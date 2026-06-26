# Agnes Q&A Notes

- Free users have RPM 20. The limit is counted independently per model.
- Video duration can be adjusted by changing frame rate.
- Thinking mode:
  - OpenAI style: add `chat_template_kwargs: { "enable_thinking": true }`.
  - Anthropic style: add `thinking: { "type": "enabled", "budget_tokens": 2048 }`.
- Free and paid membership differ mainly by RPM quota; paid subscription is useful when RPM is insufficient.
- Agnes-2.0-Flash context:
  - Input: 256K.
  - Output: 64K.
  - Expected upgrade to 1M around 2026-06-08.
- Agnes-2.0-Flash supports image and video understanding.
- Image-to-image supports input images by URL and base64.
- Generated images and videos have no watermark.
