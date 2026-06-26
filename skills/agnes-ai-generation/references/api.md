# Agnes AI API Reference

Base host: `https://apihub.agnes-ai.com`

Authentication: `Authorization: Bearer YOUR_API_KEY`

Content type: `application/json`

## Text

Endpoint: `POST /v1/chat/completions`

Model: `agnes-2.0-flash`

Required:

- `model`: fixed as `agnes-2.0-flash`
- `messages`: OpenAI-compatible chat messages

Optional:

- `temperature`: number
- `top_p`: number
- `max_tokens`: number
- `stream`: boolean
- `tools`: array
- `tool_choice`: string or object

Response is OpenAI-compatible and includes `choices[].message.content` and `usage`.

## Image

Endpoint: `POST /v1/images/generations`

Model: `agnes-image-2.1-flash`

Required:

- `model`: fixed as `agnes-image-2.1-flash`
- `prompt`: text instruction for image generation or editing

Optional:

- `size`: output size such as `1024x768`
- `extra_body.image`: array of input image URLs for image-to-image
- `extra_body.response_format`: use `url` for image URLs

Prompt structure:

`[Subject] + [Scene / Environment] + [Style] + [Lighting] + [Composition] + [Quality Requirements]`

For image-to-image, state what should change and what must remain unchanged.

For non-English user prompts, translate to English before sending the request. Preserve visual specifics and constraints.

## Video

Create task endpoint: `POST /v1/videos`

Retrieve result (recommended): `GET /agnesapi?video_id=<VIDEO_ID>`

Retrieve result (legacy): `GET /v1/videos/{task_id}`

Model: `agnes-video-v2.0`

The video API is asynchronous. Create a task, then retrieve or poll results.

**IMPORTANT**: The create response includes both `task_id` and `video_id`. Use `video_id` with the recommended endpoint for querying. The legacy `task_id` endpoint is still supported but not recommended for new usage.

Create response shape:
```json
{
  "id": "task_YOUR_TASK_ID",
  "task_id": "task_YOUR_TASK_ID",
  "video_id": "video_YOUR_VIDEO_ID",
  "object": "video",
  "model": "agnes-video-v2.0",
  "status": "queued",
  "progress": 0,
  "created_at": 1780457477,
  "seconds": "10.0",
  "size": "1280x768"
}
```

Use English prompts for video generation whenever possible. If the user prompt is not English, translate it to English first, preserving subject, action, scene, camera movement, lighting, style, and constraints.

Required:

- `model`: fixed as `agnes-video-v2.0`
- `prompt`: text description of the video

Optional:

- `image`: input image URL (string) for image-to-video, or omit for text-to-video
- `mode`: generation mode such as `ti2vid` or `keyframes`
- `height`: integer, default `768`
- `width`: integer, default `1152`
- `num_frames`: integer, must be `<= 441` and satisfy `8n + 1` (e.g. 81, 121, 241, 441)
- `num_inference_steps`: integer
- `seed`: integer
- `frame_rate`: number, supported range `1-60`
- `negative_prompt`: string
- `extra_body.image`: array of image URLs for multi-image video or keyframe mode
- `extra_body.mode`: set to `keyframes` for keyframe animation

Common status values:

- `queued`
- `in_progress`
- `completed`
- `failed`

The completed response includes a `video_url` field with the generated video URL when `status` is `completed`. Additional fields: `size`, `seconds`.

Video duration formula: `seconds = num_frames / frame_rate`

Recommended video defaults:

- Standard: `width=1152`, `height=768`, `num_frames=121`, `frame_rate=24`
- Short smoke test: `num_frames=81`, `frame_rate=24`
- Longer video: `num_frames=241`, `frame_rate=24`
- Maximum length: `num_frames=441`, `frame_rate=24`
- Reproducibility: set `seed`
- Keyframe animation: set `extra_body.mode` to `keyframes`

## Error Codes

- `400`: invalid request
- `401`: unauthorized; check API key
- `404`: task not found
- `500`: server error
- `503`: service busy; retry later
