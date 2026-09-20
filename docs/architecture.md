# Architecture and runtime configuration

## Runtime settings

Configure secrets through the Sites environment settings, never through the frontend or hosting manifest.

- `ADMIN_EMAILS`: comma-separated administrator email allowlist. Production is restricted to the owner-provided address.
- `RESEND_API_KEY` and `EMAIL_FROM`: Resend API key and verified sender address. Without both, messages are stored in the database as **administrator-only previews**. No email is delivered and no report is marked sent. Use test addresses when testing this mode.
- `OPENAI_API_KEY`: optional server-side explanation service key.
- `OPENAI_MODEL`: optional Responses-compatible model, default `gpt-4.1-mini`. Check account availability when enabling it.

The optional OpenAI integration uses [Responses](https://developers.openai.com/api/reference/cli/resources/responses/methods/create), `store: false`, and sends only the categorical plan, excluding identity and free-text device details. Strict-privacy assessments never call the external explanation service. An unavailable service falls back to the deterministic explanation. Live provider calls have not been tested without credentials.

## Workflow

1. An anonymous assessment receives an unguessable HttpOnly ownership cookie; every answer is validated server-side before persistence.
2. Name, email, and ISO country are attached to that assessment. An expiring six-digit challenge is stored as a hash, with persistent request and attempt limits.
3. Verification creates or reuses an email account, attaches the assessment, and issues an expiring, opaque HttpOnly session; only its hash is stored.
4. Deterministic planning and an optional explanation produce a review draft. User endpoints never return the draft.
5. The authorized admin reviews all answers, edits the draft, adds compatibility-checked products, and approves. Each edit retains a revision and review record; stale revisions are rejected.
6. Approve & Send renders an escaped HTML report. Successful provider delivery records Report Sent; missing provider configuration records Report Preview Ready. Approved reports appear in the owner's dashboard.
7. Saving a draft, rejection, or regeneration removes the released recommendation until it is approved again.

## Hardware rules and limits

Rules use workload, privacy, concurrency, context, 4-bit model-weight assumptions, illustrative KV-cache geometry, runtime overhead, image/video/training flags, automation, data storage, budget, technical ability, and existing-device reuse. They provide **planning ranges, not measured performance or live retail quotes**. Video/training plans explicitly require model-specific discovery. Large private datasets require separate storage and backup planning.

Strict privacy cannot be changed to cloud to force a lower price. Edits cannot lower the numeric safety floors, and GPU/RAM/storage text must remain consistent with those floors. Admins must validate model-specific behavior, runtime support, PSU/cooling, interfaces, power requirements, and local pricing before approving purchasing advice. Unknown device specifications never prove compatibility.

References: [Hugging Face quantization](https://huggingface.co/docs/transformers/quantization/bitsandbytes) and [vLLM cache sizing](https://docs.vllm.ai/en/latest/api/vllm/config/cache/).

## Product catalog

The catalog deliberately starts empty: no invented availability, prices, or purchase links. Admins can add RAM, SSDs, NAS storage, GPUs, mini PCs, workstations, and networking from any brand. Capacity uses GB for RAM/VRAM and TB for storage. Matches require a customer country match, in-stock status, applicable minimum capacity, and an explicit compatibility rationale. Cloud-only recommendations reject hardware matches. Retail prices are stored in minor currency units.

Funnel events cover visits through report delivery and product clicks. Purchase is reserved for a future trusted integration; there is no payment or checkout functionality.

