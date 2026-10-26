Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015412;
	b=NtpJsq13gsMipwV8eeTXvcVGeVTb0eLjI3CbqcPuGKj5IGwNVwxHRvZG8trMS0dvd08R
	 E+ZXGErJTl+fMByGhjYhnLuORD/BD6xrLtqeeJHulRNfzCSkhuRYFRmGvzV8Q3nVbnI0h
	 0ZQFqrpw6a6JoQkMDga7wZkvyAPRwsp5a2Vm2EI7fe76PReZ7B/gmBZTqIeYAI7DoSsom
	 t9qGwEYoATTz9AGQV7lWfxF3yAdMLPsyiVX2bumSPIZ0nk3ZHZnQ5yUjG09GRERQKf21N
	 PpqsZPRhiJczi43EFUKaPztzxfVO6aEq+JfCkwwSyT/YGt8mzt7SZBVcN6CgMW5Pi0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015412;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
	b=NxwEThNFtqWgJUg2z9H4CjeDPb6moXPMyiCfk2XPj5R2toLLU7DnYGhPkKv0KJ/ZYSdo
	 Vy5N9JNqx/Yx2JFpMC/sP+z/T4KTfun4CdZuF536pIXxU/+eP+FBIVteAuqk/gTqOLOYr
	 WzvnUgdVdT13reGT1xUh1mtP0JVoywumw7Fq030FgaeJjv1aeVglau/S+cFCdOgFd2D8L
	 8Y7ew1HVAO8KoC9sf2VqrM2X5mIUnx8BeljjJDZP9u0jgsRCYoBHcWYf9cDSAHx2T3hyc
	 dnLP3L5gYb5qZgqduBaTHlS8yKeKyXa0QaRYPNFsHZCIVHohnmB5Ko0upcQhsup3qVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LFDzEVHe;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB3C606A320
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 11:50:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DB3C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LFDzEVHe
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1c285faebso3084475a12.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 04:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793015411; x=1793620211; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
        b=LFDzEVHeeuCS/We6gsnIuA4zZMXx4E42KhKiK83xTdcXsijEAKWh+xifYmCwt/h6YJ
         TL8/xnunQLsOjNDZCnY0WT3Z/DNZup5a+i/iVH0jmONPMoxrFx0GrHdIG5v2g2jhUshs
         FtJquLHHc0PCln6b01gNc2By3Zr4TO0iAYNHV4T7Z2DomFeW0XF5t3+Xi1Rjh9u2usnV
         yXHE6kpEZcWW9z2CKpAh3VRoq7BYFbyjEeEmG1XO550ZEBQSiL3Bz2IOpCjzxo4OsC0D
         JATfEDsZVojET2GroyFhiiTeT9lR9RAgNCHDoV5QeZKeb07AennkFS03ryo0ClzcOYbN
         crUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793015411; x=1793620211;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
        b=dKCtaFEVpA0/eDSpq7Zqh8AvvOvp7HGBtecNfuHOH79vgkOk70tQuOJJXY9xiJ/qDU
         5dG8FmQUU9IHKU3XbzcqZmQX/kxNcnDhC9XA3Idfu4uRBXIOYzkAHtcw36BlDAYMfnbf
         C8QieN3+jWSNFtra7nSIHK6k1bCRy1SuFr6GEQAuKgI9PfznB2syS+9z1ST0cNbSBGTn
         AdxQCoKurrzMte5Q7BgDkAhvA4YMiEZ39lhpomTuJe5mYjjHUaI48AauWKZdSzP7bDeR
         u4re+/S3eqLk/2KyEt8lhw+DQXYG6gLeiOMAiVhvuETH6wDphCVj6beWmoGVmWpSKPWa
         6RAQ==
X-Forwarded-Encrypted: i=1; AKwUvBywdsfOkB7yZxeBhjBOw1BFu+ifBZpZaQcnoQywvkrgVfhakb5Ft9lEgH0g4WF7xIBWHdrTBgc=@lists.linux.dev
X-Gm-Message-State: AFq9FYKrI0M85mCvFDyrGIUgkO843xkjAgVR114r2UdcXDA+LYqKZnyo
	c9rgQ11s9vChbbaK9raGLG/ZPDVHX3AcUncKyIwzrDfIA+HEdAjrxIW5I/j9H0OKuIxiO7ml3ND
	gZSKgoPt6CchV7EPdDw==
X-Received: from edrd16.prod.google.com ([2002:aa7:d690:0:b0:6b3:8448:41c6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:249e:b0:6b1:c7d9:b622 with SMTP id 4fb4d7f45d1cf-6b442fffef3mr7891637a12.26.1793015410774;
 Mon, 26 Oct 2026 04:50:10 -0700 (PDT)
Date: Mon, 26 Oct 2026 11:50:10 +0000
In-Reply-To: <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
Message-ID: <9huzzew0el59.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

David Matlack <dmatlack@google.com> writes:

> On Wed, Oct 21, 2026 at 4:55=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
>>
>> On 2026-10-21 03:25 PM, Tarun Sahu wrote:
>> > LUO and its file handlers validate handed-over state with monolithic
>> > compatibility strings ("luo-v5", "memfd-v2"). Any change to a serializ=
ed
>> > structure, even an optional additive one, must bump the string, which
>> > breaks live update between adjacent kernels. Replace the string in
>> > struct luo_ser with a feature header, so that the target kernel can
>> > accept or reject the source kernel state per feature.
>> >
>> > struct luo_feature_hdr is a fixed 128-byte header: the serialized
>> > structure size from the source kernel followed by 15 chained u64 featu=
re
>> > flags entries. The fixed size keeps payload field offsets identical in
>> > every kernel, regardless of how many flags entries a source kernel use=
s.
>> >
>> > Each feature has a 2-bit pair (req, active) state (enum luo_feat_state=
:
>> > LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entr=
y
>> > holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (=
465
>> > features in total). Each subsystem defines its feature states as a
>> > static const u8 array indexed by its feature enum, which
>> > luo_feature_hdr_init() packs into 64-bit flags entries with
>> > LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header f=
rom
>> > the source kernel against its own feature array via
>> > luo_feature_hdr_validate() according to the per-feature (req, active)
>> > truth table:
>> >
>> >   Source Target Action
>> >   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without act=
ive)
>> >   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>> >   (0,0)  (0,0)  Accept: feature absent
>> >   (0,0)  (0,1)  Accept: feature absent
>> >   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>> >   (0,1)  (0,0)  Accept: ignore payload data
>> >   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>> >   (x,1)  (x,1)  Accept: use payload data
>>
>> I think we have different definitions of "required".
>>
>> In the PCI series [1], required and optional flags describe the _data_
>> the previous kernel handed over, not the kernel itself. A required bit
>> means "this preserved state depends on feature X; a kernel that does
>> not understand X must not take it over". An optional bit means "the
>> data for X is here, but you can safely ignore it". The source kernel
>> only sets a bit when the preserved state actually uses the feature.
>>
>> It's up to the FLB/FH retrieve how to handle the scenario where a
>> required bit is set that the target kernel does not understand. For the
>> PCI FLB we panic since failing to adopt the PCI state could lead to
>> memory corruption as preserved devices can be doing DMA.
>>
>> The target kernel never requires anything from the source. If a
>> feature is absent, the target kernel must handle that, e.g. by
>> falling back to default behavior. If it can't, that is a compatibility
>> break and should be handled by the compatible string.
>>
>> In this patch each kernel has a single static feature array that is used
>> both to generate the header and to validate the incoming header.  So if
>> kernel N marks a new feature X as required (so that older kernels reject
>> data they cannot understand), then kernel N will also reject every
>> kernel that does not have X, because of the (0,0) -> (1,1) row in the
>> truth table. That breaks forward updates from N-1 to N, and rollbacks
>> from N to N-1 even when **nothing being preserved uses X**. Therefore,
>> every new required feature becomes a compatible string bump.
>>

Right, Required bit should be source kernel payload property to tell
target kernel that the payload must be handled to correctly deserialize
the data. It should be source kernel (userspace) responsiblity to make
sure it understand the target kernel before doing liveupdate.

Saying this, During deserialization, target kernel's required bit is not
necessary. So I propose the following truth table.

Source hdr  Target supported[i]  Action
----------  -------------------  ----------------------------------
00          0 or 1               Accept: feature absent in payload
01          0                    Accept: ignore the feature data
01          1                    Accept: use the feature data
11          0                    Reject: -EOPNOTSUPP
11          1                    Accept: use the feature data
10          0 or 1               Reject: -EINVAL (invalid encoding)

Where Supported bit is extra bit information used by target kernel to
deserialize the data. Which is static information of target kernel and
will never be used in serialization payload.

Like,

static bool memfd_feat_supported[MEMFD_NR_FEATUERS]{
       [MEMFD_CORE_FEATURE] =3D true
}

This makes every kernel 3 bit information.

required+active: used by source kernel and embedded in serialized hdr
supported: used by target kernel to deserialize the data if it supports.

~Tarun



>> I would drop the target-side required state entirely and let the source
>> kernel decide which flags to set for each Live Update based on what is
>> _actually_ preserved. Accessing a field added after the original struct
>> then always requires checking its flag.
>>
>> At the end of the day it is up to userspace to never start using a
>> required feature while they can still rollback to a kernel that does not
>> support it. Cloud Providers know how to do this since Live Migration has
>> the same problem. This also means we must be very careful when adding
>> new required features, as they need some way for userspace to explicitly
>> opt-into them. I do _not_ think we should try to have some generic LUO
>> opt-in for required features. That is up to the File Handlers and FLBs,
>> as they have their own uAPI.
>>
>> [1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@=
google.com/
>
> Oh and please see the follow-up PCI series to preserve BARs and bridge
> windows for some examples of using optional_flags to extend struct
> pci_ser with additional data without breaking backwards compatibility.
> e.g. https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@=
google.com/
>
> I don't yet have a use-case for a required_flag.




