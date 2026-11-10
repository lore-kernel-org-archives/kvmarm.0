Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334424;
	b=yhFqeJCCLrXPKbGPBkkVvhgCfkPHTwpTVShMj0ee6Yu/Hnry+Qjvb63Crlks8Y3UqBfq
	 rjMw8jKE/MfoCOAdr4rXJYmYFnu4phlfHJu9IRjyPm41UqYfc57KxzlEhui6GXAm/RsgZ
	 uYZF2l12CEt7Hk9Ias8Iye71KxxlJS2CsZhxJ4oUGS56MgCCkfXowi2CHf9zvMNkC1U9S
	 0eiLGb/caF7GkfWi3+wcZk1aCje9bEvPRVN10zStTWriN91C38oNfXTUCP/3eAm6TsYns
	 XbTzyIEuid03Lvv3Mi9sCLNgGWD7DI3WBwZnaRh448J9LI/cgbYR6MmQ1Gm7MSPi6Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334424;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
	b=FL9rLmBdrCi9/k/7mASxGYb2A/rNZ6XcCiUCWfwXgffxOYD2Z0UaY+BrHRdxJ2mRnbqD
	 CDrC1RRKxQNV7TmZw3ONHuqY6nEtazS4AvddaRxPMEeTcFGs75DkCfKmyFDIu4mrwMdxt
	 IRNtE3YOH3leiePYO/z44TVeKeaEL/B6Ud3Se9SshRQPZTyjdZJ+V5UztSElSxb2Sd+V0
	 LtYKH0S81eJ6ve+4WucZrB1yebx7bBRAUW5KKDY0BRbJaaxmLXEHopwU6t4JL+s49iM8s
	 vi8Gr+XyLDK1rR+7iGSoxpk/4p5+4tkDYh2KH8Gv22MQyqAclgKUh6RrjA5MBzzKH8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZSi7eVgq;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B2606A332
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 18:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 436B2606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZSi7eVgq
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c50547b4992so81371066b.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 10:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794334421; x=1794939221; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
        b=ZSi7eVgqWek1myx8HA3VrU2c4XdLNYJYWkcHAM/XaPHA0dIU2kjTGbIALhjjXmhkD4
         unahkkAGIpfkKQ+mKn9IDJkTvbuwIWKnuoD6H+MWAwn4XK8Uzh6R5aXWgtJbmeT/uGcK
         KNjf3ZHK24DaWm8JzBy+J8plWmFx3jbZZdC+whLUaHtVlpEDQaDwRjHXTZNQRfQnaPit
         lmTPuk2T6XqrfsAApeXIPfVdbK5p++KxX818XFWltad4N8lEXcMsemeU9ZsM/ufqHZes
         Ancl29MH8ryVVpcfMD3ASX8otLTLBM8Zz+4/7TgoxNaMYWrjcdG7pw6MQs7QUXpAH3wv
         PUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794334421; x=1794939221;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
        b=YraZnCwjSVJ4+LDDkE3XaGVltip5tbtuNDwStesK+pOaXKqIA+q8xM2mYSinvNHc5F
         ND+BA535L9uTYuMV3yRl2/UeEIi7zYXrTzi/A4K1l3FDtsDD8cgZrSYDZOcc77O35lsH
         pzzUjw5RpIPuxYFjcuYLmWIHq7PprRCUye95GnsPoFZ32fyYsXuuhiRZvX07Ps39OwIA
         3LYFHTd+JNKX21Q/+JTEHcjMmye25NaVLI4GoTfYNOHEeU0qvpBJqlPutFp/ST/W6Gsj
         vGmInp5dQPtHIcGInqeUOzFrKr/jv9Lw2Xe2tgFalBKTLEQU0vmUA+bWAb8QCTwTCLNT
         3Jjw==
X-Forwarded-Encrypted: i=1; AL+hErFHDJOaXEitDFdNf1nq0buvNBpB4tnv3ksnFcQOOzn9/9DK/blnwM3nqkDc+OWiIe4IoVXSIk4=@lists.linux.dev
X-Gm-Message-State: APuU4Z868NQhT9ckHxAJOen8V4KABw24EpRuY+qMUqznTttGxmpo6l8z
	vDLsQ7eFAoyGKwUHaiQcj6b9gHUzX4n7B6Wy+ejuGXeDOVRK9r1tRC5Nh7mZxMX4S8iiJuTPcon
	aqGh6eroElIn3dzGMwg==
X-Received: from ejbfi14.prod.google.com ([2002:a17:906:da0e:b0:c50:4ab9:995a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:da16:b0:c3f:dce3:20c5 with SMTP id a640c23a62f3a-c50495d5a60mr286796366b.44.1794334421346;
 Tue, 10 Nov 2026 10:13:41 -0800 (PST)
Date: Tue, 10 Nov 2026 18:13:40 +0000
In-Reply-To: <179432205559.2329176.3035981527541971699.b4-review@b4>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-6-tarunsahu@google.com>
 <179432205559.2329176.3035981527541971699.b4-review@b4>
Message-ID: <9huz8q30tuzv.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>> Serialized structures in KHO and Live Update Orchestrator currently rely
>> on whole-structure compatibility strings or monolithic version fields to
>> validate handed-over state across kexec. Any change to a serialized
>> structure, even an optional additive field, requires bumping the
>> compatibility string or version number and breaks live update between
>> adjacent kernels.
>> 
>> Introduce a generic feature header (struct kho_ser_hdr) for serialized
>> binary structures in include/linux/kho/abi/feature.h. Each subsystem
>> groups the fields of its serialized structure under feature indices,
>> starting with index 0 for base fields. When a subsystem adds a new
>> capability, it appends new fields to the end of its payload structure
>> under a new feature index. Retired fields are kept in place so existing
>> field offsets never shift; if the type or format of a field needs to
>> change, the existing field and feature are kept intact until retired and
>> a new feature index with an appended field of the new type is added.
>> Only when a change requires a complete break in the serialized layout or
>> semantics that feature flags cannot handle, a new handler or format can
>> be introduced with an incremented version number.
>> 
>> Each feature belongs to either a required feature space or an optional
>> feature space. Both spaces are numbered independently starting from 0.
>> In the serialized header, required features occupy the first nr_required
>> bits, followed immediately by nr_optional bits for optional features:
>> 
>>   struct kho_ser_hdr {
>>           __u32 size;
>>           __u16 nr_required;
>>           __u16 nr_optional;
>>           __aligned_u64 flags[];
>>   };
>> 
>> A set bit indicates that the feature is present in the payload. The
>> truth table for deserialization:
>> 
>>   Source bit       Target            Action
>>   Not set          -                 Accept: feature absent
>>   Optional set     unknown or known  Accept: ignore or use the data
>>   Required set     known             Accept: use the feature data
>>   Required set     unknown           Reject: -EOPNOTSUPP
>> 
>> During deserialization, the target kernel only validates required
>> features: if the source set any required feature bit at or beyond the
>> known required feature count of the target kernel, validation fails with
>> -EOPNOTSUPP. Optional features are never rejected; the target kernel
>> simply checks whether known optional features are present before reading
>> their data.
>> 
>> No subsystem defines feature flags yet. Every converted structure is
>> registered with 0 required and 0 optional features, producing a compact
>> 8-byte header with no flags entries. Feature enums can be added later as
>> needed, once the first additive feature is introduced for a particular
>> serialized structure. With nr_required set to 0, kho_ser_validate()
>> rejects any incoming required feature bit while ignoring optional bits,
>> allowing future kernels with additive features to evolve smoothly in
>> both directions.
>> 
>> Each subsystem registers its serialized structure with:
>> 
>>         DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)
>> 
>> This establishes compile-time assertions and provides type-checked
>> helpers: kho_ser_size() for total allocation size, kho_ser_init() to
>> initialize the header, kho_ser_payload() to access the typed payload at
>> its dynamic offset, and kho_ser_validate() to validate required features
>> during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
>> kho_ser_hdr pointer while verifying at compile time that name was
>> registered with DECLARE_KHO_SER(), allowing callers to document which
>> structure a feature header pointer represents.
>> 
>> An example demonstrating how a hypothetical structure defines its
>> features:
>> 
>>   enum foo_ser_required {
>>           FOO_SER_REQ_BAR,
>>           __FOO_SER_NR_REQUIRED,
>>   };
>> 
>>   enum foo_ser_optional {
>>           FOO_SER_OPT_BAZ,
>>           __FOO_SER_NR_OPTIONAL,
>>   };
>> 
>>   struct foo_ser {
>>           __u64 base;     /* base fields, always present */
>>           __u64 bar;      /* FOO_SER_REQ_BAR */
>>           __u64 baz;      /* FOO_SER_OPT_BAZ */
>>   };
>> 
>>   DECLARE_KHO_SER(foo_ser, 24,
>>                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
>> 
>>   /* Serialize */
>>   kho_ser_init(fhdr, foo_ser);
>>   ser = kho_ser_payload(fhdr, foo_ser);
>>   ser->bar = ...;
>>   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
>>   ser->baz = ...;
>>   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
>> 
>>   /* Restore */
>>   err = kho_ser_validate(fhdr, foo_ser);
>>   ser = kho_ser_payload(fhdr, foo_ser);
>>   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
>>           use ser->bar;
>>   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
>>           use ser->baz;
>> 
>> Required and optional features each have their own enum, numbered
>> independently from 0. New features are only appended at the end of their
>> enum, never reordered or reused. The last entry of each enum (e.g.
>> __FOO_SER_NR_REQUIRED) is the feature count passed to DECLARE_KHO_SER and
>> stays last. The fields of a new feature are appended at the end of the
>> payload. A reader accesses the fields of a feature only when its bit is set
>> in the incoming header (kho_ser_has_required() or kho_ser_has_optional()),
>> because an older source kernel does not serialize them. Use required for
>> data the target must understand to restore correctly, and optional for
>> data it can safely ignore. Variable length data that follows the payload,
>> such as an array of entries, starts at fhdr->size, the size recorded by the
>> source kernel, so it stays correct when a later feature appends fields to
>> the payload. Document that serialization helpers describe this kernel's
>> layout while deserialization helpers follow the incoming header.
>> 
>> Suggested-by: David Matlack <dmatlack@google.com>
>> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
>> new file mode 100644
>> index 000000000000..55ff1b9e9b73
>> --- /dev/null
>> +++ b/include/linux/kho/abi/feature.h
>> @@ -0,0 +1,372 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/**
>> + * DOC: KHO Serialization Feature Header ABI
>> + *
>> + * Generic feature header for serialized binary data structures preserved
>> + * across kexec via KHO or Live Update Orchestrator (LUO).
>
> via KHO or LUO.
>

Oops! it is wrong. It should only be via KHO.

>> + *
>> + * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
>> + * containing the total structure size (size, including header, flags, and
>> + * payload) in bytes, the number of required features (nr_required), and the
>> + * number of optional features (nr_optional). Following the header is a
>> + * flexible array of 64-bit flags entries (flags[]) containing one bit per
>> + * feature.
>> + *
>> + * Feature bits:
>> + *   - Required feature N is at bit N of flags[].
>> + *   - Optional feature N is at bit (nr_required + N) of flags[].
>> + *   - The number of __u64 entries in flags[] is
>> + *     DIV_ROUND_UP(nr_required + nr_optional, 64).
>> + *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
>> + *     and the header is exactly 8 bytes.
>
> The above is not needed in the documentation.

Sure, I will update all of the above (feature.h) with:

"A feature header precedes each serialized structure that outgoing
kernel store along with ser data and incoming kernel use to understand
and decode the preserved data."

A feature header holds the details about required and optional feature
in the serialized data stored as a bit for each features.
>
>> + *
>> + * A set bit indicates that the feature is present in the payload.
>> + *
>> + * Deserialization truth table:
>> + *
>> + *   Source bit       Target            Action
>> + *   ----------       ------            ------
>> + *   Not set          -                 Accept: feature absent
>> + *   Optional set     unknown or known  Accept: ignore or use the data
>> + *   Required set     known             Accept: use the feature data
>> + *   Required set     unknown           Reject: -EOPNOTSUPP
>> + *
>> + * Validation trusts the incoming header: only set required feature bits at or
>> + * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
>> + * Optional feature bits are never validated.
>> + *
>
> We can shorten the comment below (and commit message as well); there is 
> no need to include sample code showing how the header is implemented in 
> the doc comment. Too much stuff that is not really useful to the reader.
>

Okay, I will remove about function related details below.

About feature flags, I added this because at this point none of the
serialized structure use the feature flags, I intended to explain how they can
define new feature and use them.

I have updated the below, let me know if that looks good.

>> + * Defining features:
>> + *
>> + * A serialized structure defines its features using enums and registers with
>> + * DECLARE_KHO_SER():: AN Example to introduce a new feature:
>> + *
>> + *   enum foo_ser_required {
>> + *           FOO_SER_REQ_BAR,
>> + *           __FOO_SER_NR_REQUIRED,
>> + *   };
>> + *
>> + *   enum foo_ser_optional {
>> + *           FOO_SER_OPT_BAZ,
>> + *           __FOO_SER_NR_OPTIONAL,
>> + *   };
>> + *
>> + *   struct foo_ser {
>> + *           __u64 base;     // base fields, always present
>> + *           __u64 bar;      // FOO_SER_REQ_BAR
>> + *           __u64 baz;      // FOO_SER_OPT_BAZ
>> + *   };
>> + *
>> + *   DECLARE_KHO_SER(foo_ser, 24,
>> + *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
>> + *
>> + *
>> + * Rules:
>> + *   - The fields of a new feature are appended at the end of the
>> +       serialized structure to keep the offset of older fields same.
>> + *   - Use required for data the target must understand to restore
>> + *     correctly, and optional for data it can safely ignore.
>> + *
>> + */
>> +

=======END OF DOC=================

>> +#ifndef _LINUX_KHO_ABI_FEATURE_H
>> +#define _LINUX_KHO_ABI_FEATURE_H
>> +
>> +#include <linux/build_bug.h>
>> +#include <linux/err.h>
>> +#include <linux/errno.h>
>> +#include <linux/math.h>
>> +#include <linux/string.h>
>> +#include <linux/types.h>
>> +
>> +/**
>> + * struct kho_ser_hdr - Header for serialized data structures in KHO.
>> + * @size:        Total size in bytes (header + flags + payload).
>> + * @nr_required: Number of required features known to the source kernel.
>> + * @nr_optional: Number of optional features known to the source kernel.
>> + * @flags:       Bitmask of present features (required, then optional).
>> + */
>
> Let's avoid tab-aligning the new doc comment. Apparently, that is not 
> ideal because it makes future maintenance harder; each line must be 
> re-aligned whenever longer fields are added.
>

Got it. I will update it.

>> +struct kho_ser_hdr {
>> +	__u32 size;
>> +	__u16 nr_required;
>> +	__u16 nr_optional;
>> +	__aligned_u64 flags[];
>> +};
>> +
>
> Please use u32/u16/u64, this is not uapi.
>
Got it. I will update it.

>> +static_assert(sizeof(struct kho_ser_hdr) == 8);
>> +static_assert(__alignof__(struct kho_ser_hdr) == 8);
>> +
>> +#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
>> +	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)
>> +
>> +/**
>> + * kho_ser_hdr_size - Calculate header size in bytes including flags.
>> + * @fhdr: Pointer to the serialization header.
>> + *
>> + * Return: Size of the header and flags array in bytes.
>> + */
>> +static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
>> +{
>> +	return sizeof(*fhdr) + sizeof(__u64) *
>> +		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
>> +}
>> +
>> +/**
>> + * kho_ser_set_required - Mark a required feature present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to set.
>> + */
>> +static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_required)
>> +		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);
>> +}
>> +
>> +/**
>> + * kho_ser_clear_required - Clear a required feature in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to clear.
>> + */
>> +static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_required)
>> +		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
>> +}
>> +
>> +/**
>> + * kho_ser_set_optional - Mark an optional feature present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to set.
>> + */
>> +static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_optional) {
>> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
>> +
>> +		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
>> +	}
>> +}
>> +
>> +/**
>> + * kho_ser_clear_optional - Clear an optional feature in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to clear.
>> + */
>> +static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_optional) {
>> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
>> +
>> +		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
>> +	}
>> +}
>> +
>> +/**
>> + * kho_ser_has_required - Check if a required feature is present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to check.
>> + *
>> + * Return: True if the feature is present, false otherwise or if the index
>> + *         exceeds the header's known required feature count.
>> + */
>> +static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
>> +					unsigned int feat)
>> +{
>> +	if (feat >= fhdr->nr_required)
>> +		return false;
>> +	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
>> +}
>> +
>> +/**
>> + * kho_ser_has_optional - Check if an optional feature is present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to check.
>> + *
>> + * Return: True if the feature is present, false otherwise or if the index
>> + *         exceeds the header's known optional feature count.
>> + */
>> +static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
>> +					unsigned int feat)
>> +{
>> +	unsigned int bit;
>> +
>> +	if (feat >= fhdr->nr_optional)
>> +		return false;
>> +	bit = (unsigned int)fhdr->nr_required + feat;
>> +	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
>> +}
>> +
>> +/**
>> + * __kho_ser_init - Initialize a serialization header and flags.
>> + * @fhdr:          Pointer to the memory for the serialization header.
>> + * @payload_size: Size of the payload structure in bytes.
>> + * @nr_required:  Number of required features known by the caller.
>> + * @nr_optional:  Number of optional features known by the caller.
>> + */
>> +static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
>> +				  __u16 nr_required, __u16 nr_optional)
>> +{
>> +	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);
>> +
>> +	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
>> +	fhdr->nr_required = nr_required;
>> +	fhdr->nr_optional = nr_optional;
>> +	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
>> +}
>> +
>> +/**
>> + * __kho_ser_payload - Return pointer to the payload following the header.
>> + * @fhdr: Pointer to the serialization header.
>> + *
>> + * Return: Pointer to payload memory immediately after the flags array.
>> + */
>> +static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
>> +{
>> +	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));
>> +}
>> +
>> +/**
>> + * __kho_ser_validate - Validate an incoming header against target capabilities.
>> + * @fhdr:                Pointer to the serialization header.
>> + * @target_nr_required: Number of required features supported by the target.
>> + *
>> + * Checks that the source did not set any required feature bits that the target
>> + * kernel does not support (index >= @target_nr_required).
>> + *
>> + * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
>> + */
>> +static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
>> +				     __u16 target_nr_required)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = target_nr_required; i < fhdr->nr_required; i++) {
>> +		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))
>> +			return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
>> + * @name:         Structure tag name (e.g. luo_ser).
>> + * @payload_size: Compile-time expected size of struct @name in bytes.
>> + * @nr_required:  Total number of defined required features.
>> + * @nr_optional:  Total number of defined optional features.
>> + *
>> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
>> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
>> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
>> + */
>> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      sizeof(struct name) == (payload_size),		\
>> +		      "struct " #name " size mismatch");		\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      __alignof__(struct name) == 8,			\
>> +		      "struct " #name " must be 8-byte aligned");	\
>> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
>> +	enum {								\
>> +		__KHO_SER_SIZE_##name = (payload_size),			\
>> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
>> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
>> +	}
>> +
>> +/**
>> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
>> + *
>> + * Declares @decl with type struct kho_ser_hdr while checking at compile time
>> + * that @name was registered with DECLARE_KHO_SER(), documenting which
>> + * serialized payload structure a feature header pointer belongs to.
>> + */
>> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
>> +
>> +/**
>> + * kho_ser_size - Total size of header, flags, and payload for a structure.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_size(name)						\
>> +	(sizeof(struct kho_ser_hdr) +					\
>> +	 sizeof(__u64) * KHO_SER_NR_FLAGS(__KHO_SER_NR_REQUIRED_##name,	\
>> +					  __KHO_SER_NR_OPTIONAL_##name) +\
>> +	 __KHO_SER_SIZE_##name)
>> +
>> +/**
>> + * kho_ser_init - Initialize a serialization header for a registered structure.
>> + * @fhdr:  Pointer to allocated memory.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_init(fhdr, name)						\
>> +	__kho_ser_init((fhdr), __KHO_SER_SIZE_##name,			\
>> +		       __KHO_SER_NR_REQUIRED_##name,			\
>> +		       __KHO_SER_NR_OPTIONAL_##name)
>> +
>> +/**
>> + * kho_ser_payload - Return typed pointer to payload following the header.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + *
>> + * The first operand only fails the build when DECLARE_KHO_SER(name) is
>> + * missing.
>> + */
>> +#define kho_ser_payload(fhdr, name)					\
>> +	((void)__KHO_SER_SIZE_##name,					\
>> +	 (struct name *)__kho_ser_payload(fhdr))
>> +
>> +/**
>> + * kho_ser_validate - Validate incoming required features for a structure.
>> + * @fhdr:  Pointer to the incoming serialization header.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_validate(fhdr, name)					\
>> +	__kho_ser_validate((fhdr), __KHO_SER_NR_REQUIRED_##name)
>> +
>> +#endif /* _LINUX_KHO_ABI_FEATURE_H */
>
> Headers under include/linux/kho/abi/ are meant to describe the ABI 
> layout only, so include/linux/kho/abi/feature.h should only contain the 
> struct and declaration macros actually used by kho/abi/*.h headers:
>
> - struct kho_ser_hdr (and its static_asserts)
> - DECLARE_KHO_SER()
> - DECLARE_KHO_SER_HDR()
>
> Everything else here (KHO_SER_NR_FLAGS(), kho_ser_hdr_size(), 
> kho_ser_size(), kho_ser_init(), kho_ser_payload(), kho_ser_validate(), 
> kho_ser_{set,clear,has}_{required,optional}(), and the __kho_ser_*() 
> helpers) is kernel runtime helper code and should be moved to 
> include/linux/kexec_handover.h (which also avoids pulling string.h, 
> math.h, err.h, and errno.h into the ABI header).


Okay will update it.
~Tarun

>
> -- 
> Pasha
