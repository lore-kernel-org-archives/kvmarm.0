Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286933;
	b=rTstDnf2vCNzBqweTv6g1VR2KpNRiIPi95a9bd3KW2En77+n/jQFKj7kRBPrAJGeuCNB
	 W2FIyYVHfVdnTCLMELG2Ds52H2RI2WVAEuZbh1XDTQ9l1M5tgDhHty68untIqpYrAfCrh
	 o+yMgJ1pwSaz8Hc+8r06aiwxJq/CgveA7qCM1Yl8ayctCAOmqUJ9R99MFtyPpE/iRo9j3
	 fHiaX3hsYTos4sd+kWvFXWP11Wqqn3XEmHWIb0RZhPGy3GGOtZ3HobSKdwJUtpW/e+rcB
	 CPXU7zwMEEDJjCU7UwXVRcWH+cSozMdfXrJ+u5KNsPLLnlhwTG3QuOsqcWOKMjAFn8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
	b=ByjXNeuMrD0mFJmUjjOETYCpXrycjFC+sdaHGKDUJDTMnjff8Xx+l6KNM8wmBQn+HO75
	 +gNH7iFqgkt5N76v49sTv5bAGDLSW+9p6Ch9E5xjONM2sN2aTkBWllG/yHpGazSilntUZ
	 qJDB36TadC/9fBkdy4QsOlxiBD0pv5lFpdhP0nJ15A3IlbFkrZkFMpTBDIHvO3dpaRbB8
	 eHBXKOKlB8hxP8VFQMPpk5Vt+9tmA76EOgSKzp+9uj/Sh7nLHvqlNI3zl7b6w3n1Nc3C8
	 B7PvtPRoII7atGUzlOWCXVvtRMt99gk9qac6dwoh1ujiT1bury5xZtpk9xtyCVGrGgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KtlPUsOD;
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4088D60A383E
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4088D60A383E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KtlPUsOD
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b586d1266dso1491644a12.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286931; x=1794891731; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
        b=KtlPUsOD9jmV3b0Xu43yJSVDneUSyX+Kb3eKR9P1ZEU43gIf9dcLZsK6h8DLOqo3Q+
         xF2PZcSmdQV9rrwb8z9kVQS7lmbo9dGUrOIQkuL2Ozx6JnpIz9B+IiJzXR9sCs0pc/n+
         ZAmH8YxF86FLix9wbZ0/yBpn82Bk/ItnRmICuvg2z/xtw7WfesQSUE9SKwFbpZk1a+xD
         oOBuKJ+ZO2VgIKY6Subh819qo9NivuQW2zjf7fJY0c7UIHEEDDFk7azhVEFWQ3EKg8bi
         +EmbFtmZtlWRjotg+DGlrlvC8jHfIl8SQZTZdbo4MzqiO7ieKZL9jS7Km6G8v3UNg6LU
         NmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286931; x=1794891731;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
        b=vxh7OdUHuz2mmjwrfVTQIUV52BPwlcISu62NWHtwW7u7SWf8GOlpzNdo9nw9sJ12Sv
         kGzO6dO7gVkwAP2NZpyqzuufM4j+nizjLibcI+01RcQDKy8Z69afws2yduvfNKJVVyl5
         JP+m1b0NoeqfPg9l1ewCuUJPF5pubYIYvF4zqy9TRJyMxumzk2ERfbBoiXS0vraCRGiW
         GqcQpHX+LgdsjXr4I7VrrJf2VSl3oEI/bvRkWXUmXP+M95dXAdr4gDukzGZKDBU7o9Cp
         /6zDZXZXpXup2Hme2JD3D6sn/pSyx+FdiORDQUCEizjvpn/vWMli6ZKN/qNlpiEO/mNy
         G/ew==
X-Gm-Message-State: APuU4Z/1c25TmBJatTgRxWEnPGiFj7Qbn0LipJRGCCxau2cDD5ncRrXq
	OYT5slmMYB24XN1dY53xYhKYa/pe6u7y+FUESLwtQQ6M1G9wAZJ0cAqgzcZt46rhunGwxzmEUL1
	QbMa78tNAFMjGokr+VA==
X-Received: from edra14.prod.google.com ([2002:aa7:d90e:0:b0:6b1:af33:7d07])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:947:b0:6b1:b97b:750 with SMTP id 4fb4d7f45d1cf-6b7564fbe2fmr835079a12.16.1794286930545;
 Mon, 09 Nov 2026 21:02:10 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:48 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-6-tarunsahu@google.com>
Subject: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

Serialized structures in KHO and Live Update Orchestrator currently rely
on whole-structure compatibility strings or monolithic version fields to
validate handed-over state across kexec. Any change to a serialized
structure, even an optional additive field, requires bumping the
compatibility string or version number and breaks live update between
adjacent kernels.

Introduce a generic feature header (struct kho_ser_hdr) for serialized
binary structures in include/linux/kho/abi/feature.h. Each subsystem
groups the fields of its serialized structure under feature indices,
starting with index 0 for base fields. When a subsystem adds a new
capability, it appends new fields to the end of its payload structure
under a new feature index. Retired fields are kept in place so existing
field offsets never shift; if the type or format of a field needs to
change, the existing field and feature are kept intact until retired and
a new feature index with an appended field of the new type is added.
Only when a change requires a complete break in the serialized layout or
semantics that feature flags cannot handle, a new handler or format can
be introduced with an incremented version number.

Each feature belongs to either a required feature space or an optional
feature space. Both spaces are numbered independently starting from 0.
In the serialized header, required features occupy the first nr_required
bits, followed immediately by nr_optional bits for optional features:

  struct kho_ser_hdr {
          __u32 size;
          __u16 nr_required;
          __u16 nr_optional;
          __aligned_u64 flags[];
  };

A set bit indicates that the feature is present in the payload. The
truth table for deserialization:

  Source bit       Target            Action
  Not set          -                 Accept: feature absent
  Optional set     unknown or known  Accept: ignore or use the data
  Required set     known             Accept: use the feature data
  Required set     unknown           Reject: -EOPNOTSUPP

During deserialization, the target kernel only validates required
features: if the source set any required feature bit at or beyond the
known required feature count of the target kernel, validation fails with
-EOPNOTSUPP. Optional features are never rejected; the target kernel
simply checks whether known optional features are present before reading
their data.

No subsystem defines feature flags yet. Every converted structure is
registered with 0 required and 0 optional features, producing a compact
8-byte header with no flags entries. Feature enums can be added later as
needed, once the first additive feature is introduced for a particular
serialized structure. With nr_required set to 0, kho_ser_validate()
rejects any incoming required feature bit while ignoring optional bits,
allowing future kernels with additive features to evolve smoothly in
both directions.

Each subsystem registers its serialized structure with:

        DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)

This establishes compile-time assertions and provides type-checked
helpers: kho_ser_size() for total allocation size, kho_ser_init() to
initialize the header, kho_ser_payload() to access the typed payload at
its dynamic offset, and kho_ser_validate() to validate required features
during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
kho_ser_hdr pointer while verifying at compile time that name was
registered with DECLARE_KHO_SER(), allowing callers to document which
structure a feature header pointer represents.

An example demonstrating how a hypothetical structure defines its
features:

  enum foo_ser_required {
          FOO_SER_REQ_BAR,
          __FOO_SER_NR_REQUIRED,
  };

  enum foo_ser_optional {
          FOO_SER_OPT_BAZ,
          __FOO_SER_NR_OPTIONAL,
  };

  struct foo_ser {
          __u64 base;     /* base fields, always present */
          __u64 bar;      /* FOO_SER_REQ_BAR */
          __u64 baz;      /* FOO_SER_OPT_BAZ */
  };

  DECLARE_KHO_SER(foo_ser, 24,
                  __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);

  /* Serialize */
  kho_ser_init(fhdr, foo_ser);
  ser = kho_ser_payload(fhdr, foo_ser);
  ser->bar = ...;
  kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
  ser->baz = ...;
  kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);

  /* Restore */
  err = kho_ser_validate(fhdr, foo_ser);
  ser = kho_ser_payload(fhdr, foo_ser);
  if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
          use ser->bar;
  if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
          use ser->baz;

Required and optional features each have their own enum, numbered
independently from 0. New features are only appended at the end of their
enum, never reordered or reused. The last entry of each enum (e.g.
__FOO_SER_NR_REQUIRED) is the feature count passed to DECLARE_KHO_SER and
stays last. The fields of a new feature are appended at the end of the
payload. A reader accesses the fields of a feature only when its bit is set
in the incoming header (kho_ser_has_required() or kho_ser_has_optional()),
because an older source kernel does not serialize them. Use required for
data the target must understand to restore correctly, and optional for
data it can safely ignore. Variable length data that follows the payload,
such as an array of entries, starts at fhdr->size, the size recorded by the
source kernel, so it stays correct when a later feature appends fields to
the payload. Document that serialization helpers describe this kernel's
layout while deserialization helpers follow the incoming header.

Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/feature.h | 372 ++++++++++++++++++++++++++++++++
 1 file changed, 372 insertions(+)
 create mode 100644 include/linux/kho/abi/feature.h

diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
new file mode 100644
index 000000000000..55ff1b9e9b73
--- /dev/null
+++ b/include/linux/kho/abi/feature.h
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/**
+ * DOC: KHO Serialization Feature Header ABI
+ *
+ * Generic feature header for serialized binary data structures preserved
+ * across kexec via KHO or Live Update Orchestrator (LUO).
+ *
+ * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
+ * containing the total structure size (size, including header, flags, and
+ * payload) in bytes, the number of required features (nr_required), and the
+ * number of optional features (nr_optional). Following the header is a
+ * flexible array of 64-bit flags entries (flags[]) containing one bit per
+ * feature.
+ *
+ * Feature bits:
+ *   - Required feature N is at bit N of flags[].
+ *   - Optional feature N is at bit (nr_required + N) of flags[].
+ *   - The number of __u64 entries in flags[] is
+ *     DIV_ROUND_UP(nr_required + nr_optional, 64).
+ *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
+ *     and the header is exactly 8 bytes.
+ *
+ * A set bit indicates that the feature is present in the payload.
+ *
+ * Deserialization truth table:
+ *
+ *   Source bit       Target            Action
+ *   ----------       ------            ------
+ *   Not set          -                 Accept: feature absent
+ *   Optional set     unknown or known  Accept: ignore or use the data
+ *   Required set     known             Accept: use the feature data
+ *   Required set     unknown           Reject: -EOPNOTSUPP
+ *
+ * Validation trusts the incoming header: only set required feature bits at or
+ * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
+ * Optional feature bits are never validated.
+ *
+ * Defining features:
+ *
+ * A serialized structure defines its features using enums and registers with
+ * DECLARE_KHO_SER()::
+ *
+ *   enum foo_ser_required {
+ *           FOO_SER_REQ_BAR,
+ *           __FOO_SER_NR_REQUIRED,
+ *   };
+ *
+ *   enum foo_ser_optional {
+ *           FOO_SER_OPT_BAZ,
+ *           __FOO_SER_NR_OPTIONAL,
+ *   };
+ *
+ *   struct foo_ser {
+ *           __u64 base;     // base fields, always present
+ *           __u64 bar;      // FOO_SER_REQ_BAR
+ *           __u64 baz;      // FOO_SER_OPT_BAZ
+ *   };
+ *
+ *   DECLARE_KHO_SER(foo_ser, 24,
+ *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
+ *
+ *   // Serialize
+ *   kho_ser_init(fhdr, foo_ser);
+ *   ser = kho_ser_payload(fhdr, foo_ser);
+ *   ser->bar = ...;
+ *   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
+ *   ser->baz = ...;
+ *   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
+ *
+ *   // Restore
+ *   err = kho_ser_validate(fhdr, foo_ser);
+ *   ser = kho_ser_payload(fhdr, foo_ser);
+ *   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
+ *           use ser->bar;
+ *   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
+ *           use ser->baz;
+ *
+ * Rules:
+ *   - Required and optional features each have their own enum, numbered
+ *     independently from 0.
+ *   - New features are only appended at the end of their enum, never
+ *     reordered or reused.
+ *   - The last entry of each enum (e.g. __FOO_SER_NR_REQUIRED) is the
+ *     feature count passed to DECLARE_KHO_SER and stays last.
+ *   - The fields of a new feature are appended at the end of the payload.
+ *   - A reader accesses the fields of a feature only when its bit is set in
+ *     the incoming header (kho_ser_has_required() or
+ *     kho_ser_has_optional()), because an older source kernel does not
+ *     serialize them.
+ *   - Use required for data the target must understand to restore
+ *     correctly, and optional for data it can safely ignore.
+ *   - Variable length data that follows the payload, such as an array of
+ *     entries, starts at fhdr->size, the size recorded by the source kernel,
+ *     so it stays correct when a later feature appends fields to the
+ *     payload.
+ *
+ * Writing and reading:
+ *
+ * kho_ser_size(), kho_ser_init(), kho_ser_set_required() and
+ * kho_ser_set_optional() (and the clear variants) use the values this
+ * kernel registered with DECLARE_KHO_SER(), so they describe this
+ * kernel's layout and are used when serializing.
+ *
+ * A reader of handed-over data uses only the incoming header:
+ * kho_ser_validate(), kho_ser_hdr_size(), kho_ser_payload(),
+ * kho_ser_has_required(), kho_ser_has_optional() and fhdr->size, so
+ * it follows the layout of the kernel that wrote the data. On data
+ * this kernel serialized, these give the same result.
+ *
+ * Use DECLARE_KHO_SER_HDR(name, *fhdr) (or const
+ * DECLARE_KHO_SER_HDR(name, *fhdr)) to document which registered
+ * structure a feature header pointer belongs to while verifying at
+ * compile time that the structure is registered with DECLARE_KHO_SER().
+ */
+
+#ifndef _LINUX_KHO_ABI_FEATURE_H
+#define _LINUX_KHO_ABI_FEATURE_H
+
+#include <linux/build_bug.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/math.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+/**
+ * struct kho_ser_hdr - Header for serialized data structures in KHO.
+ * @size:        Total size in bytes (header + flags + payload).
+ * @nr_required: Number of required features known to the source kernel.
+ * @nr_optional: Number of optional features known to the source kernel.
+ * @flags:       Bitmask of present features (required, then optional).
+ */
+struct kho_ser_hdr {
+	__u32 size;
+	__u16 nr_required;
+	__u16 nr_optional;
+	__aligned_u64 flags[];
+};
+
+static_assert(sizeof(struct kho_ser_hdr) == 8);
+static_assert(__alignof__(struct kho_ser_hdr) == 8);
+
+#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
+	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)
+
+/**
+ * kho_ser_hdr_size - Calculate header size in bytes including flags.
+ * @fhdr: Pointer to the serialization header.
+ *
+ * Return: Size of the header and flags array in bytes.
+ */
+static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
+{
+	return sizeof(*fhdr) + sizeof(__u64) *
+		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
+}
+
+/**
+ * kho_ser_set_required - Mark a required feature present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to set.
+ */
+static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_required)
+		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);
+}
+
+/**
+ * kho_ser_clear_required - Clear a required feature in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to clear.
+ */
+static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_required)
+		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
+}
+
+/**
+ * kho_ser_set_optional - Mark an optional feature present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to set.
+ */
+static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_optional) {
+		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
+
+		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
+	}
+}
+
+/**
+ * kho_ser_clear_optional - Clear an optional feature in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to clear.
+ */
+static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_optional) {
+		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
+
+		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
+	}
+}
+
+/**
+ * kho_ser_has_required - Check if a required feature is present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to check.
+ *
+ * Return: True if the feature is present, false otherwise or if the index
+ *         exceeds the header's known required feature count.
+ */
+static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
+					unsigned int feat)
+{
+	if (feat >= fhdr->nr_required)
+		return false;
+	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
+}
+
+/**
+ * kho_ser_has_optional - Check if an optional feature is present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to check.
+ *
+ * Return: True if the feature is present, false otherwise or if the index
+ *         exceeds the header's known optional feature count.
+ */
+static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
+					unsigned int feat)
+{
+	unsigned int bit;
+
+	if (feat >= fhdr->nr_optional)
+		return false;
+	bit = (unsigned int)fhdr->nr_required + feat;
+	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
+}
+
+/**
+ * __kho_ser_init - Initialize a serialization header and flags.
+ * @fhdr:          Pointer to the memory for the serialization header.
+ * @payload_size: Size of the payload structure in bytes.
+ * @nr_required:  Number of required features known by the caller.
+ * @nr_optional:  Number of optional features known by the caller.
+ */
+static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
+				  __u16 nr_required, __u16 nr_optional)
+{
+	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);
+
+	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
+	fhdr->nr_required = nr_required;
+	fhdr->nr_optional = nr_optional;
+	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
+}
+
+/**
+ * __kho_ser_payload - Return pointer to the payload following the header.
+ * @fhdr: Pointer to the serialization header.
+ *
+ * Return: Pointer to payload memory immediately after the flags array.
+ */
+static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
+{
+	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));
+}
+
+/**
+ * __kho_ser_validate - Validate an incoming header against target capabilities.
+ * @fhdr:                Pointer to the serialization header.
+ * @target_nr_required: Number of required features supported by the target.
+ *
+ * Checks that the source did not set any required feature bits that the target
+ * kernel does not support (index >= @target_nr_required).
+ *
+ * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
+ */
+static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
+				     __u16 target_nr_required)
+{
+	unsigned int i;
+
+	for (i = target_nr_required; i < fhdr->nr_required; i++) {
+		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/**
+ * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
+ * @name:         Structure tag name (e.g. luo_ser).
+ * @payload_size: Compile-time expected size of struct @name in bytes.
+ * @nr_required:  Total number of defined required features.
+ * @nr_optional:  Total number of defined optional features.
+ *
+ * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
+ * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
+ * 32-bit builds where u64 has 4-byte or 2-byte alignment.
+ */
+#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
+	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
+		      sizeof(struct name) == (payload_size),		\
+		      "struct " #name " size mismatch");		\
+	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
+		      __alignof__(struct name) == 8,			\
+		      "struct " #name " must be 8-byte aligned");	\
+	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
+	enum {								\
+		__KHO_SER_SIZE_##name = (payload_size),			\
+		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
+		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
+	}
+
+/**
+ * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
+ *
+ * Declares @decl with type struct kho_ser_hdr while checking at compile time
+ * that @name was registered with DECLARE_KHO_SER(), documenting which
+ * serialized payload structure a feature header pointer belongs to.
+ */
+#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
+
+/**
+ * kho_ser_size - Total size of header, flags, and payload for a structure.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_size(name)						\
+	(sizeof(struct kho_ser_hdr) +					\
+	 sizeof(__u64) * KHO_SER_NR_FLAGS(__KHO_SER_NR_REQUIRED_##name,	\
+					  __KHO_SER_NR_OPTIONAL_##name) +\
+	 __KHO_SER_SIZE_##name)
+
+/**
+ * kho_ser_init - Initialize a serialization header for a registered structure.
+ * @fhdr:  Pointer to allocated memory.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_init(fhdr, name)						\
+	__kho_ser_init((fhdr), __KHO_SER_SIZE_##name,			\
+		       __KHO_SER_NR_REQUIRED_##name,			\
+		       __KHO_SER_NR_OPTIONAL_##name)
+
+/**
+ * kho_ser_payload - Return typed pointer to payload following the header.
+ * @fhdr:  Pointer to the serialization header.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ *
+ * The first operand only fails the build when DECLARE_KHO_SER(name) is
+ * missing.
+ */
+#define kho_ser_payload(fhdr, name)					\
+	((void)__KHO_SER_SIZE_##name,					\
+	 (struct name *)__kho_ser_payload(fhdr))
+
+/**
+ * kho_ser_validate - Validate incoming required features for a structure.
+ * @fhdr:  Pointer to the incoming serialization header.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_validate(fhdr, name)					\
+	__kho_ser_validate((fhdr), __KHO_SER_NR_REQUIRED_##name)
+
+#endif /* _LINUX_KHO_ABI_FEATURE_H */
-- 
2.56.0.506.g506a7eabc5-goog

