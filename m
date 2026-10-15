Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29140530E18
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792076860; cv=none; b=WVlq1MUvUWnmkiQUkv13Y/+gI0DrWF4HJIvYZVvAuU77i/0B8VA7ii6VL7YKTvKCqL+MTstUqYVCpKe20s7uK4On5/usx2+OAaxAF+CSnyV61E9lYia96mjdMNur8vFgwphBXLSGz6qDLb0GGMNYc7F0lZfT5tUbjWG+rV+gWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792076860; c=relaxed/simple;
	bh=fDf2TZGggSk/cJ95OW/A1pc9n9A1t6tXqujXvNReYYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iEMcGVSdqo7O5blTAmr62Mvca0ShDa/f806dzIMG1Rf50pTEpf8k+M9pulo1WpnHkfgPUXg7PoUGC4Vg9wDFSQlNPFJy0xBrhLAe5jpDn44SmVOjR2TqhrA14hOmaj7CH8PcHIYHD0wOYJ7AcMsikhDkvASsY4SxfwssxSptCrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJ+oSXQ2; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJ+oSXQ2"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c40285df2a0so5700766b.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792076856; x=1792681656; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IC5Ct3FOhi968am1MRf06lj4teeqkFZmOqPC0DoSw2E=;
        b=fJ+oSXQ2+yZcN69fp6O78+yppt6DxZzI7Dl4YGk7Xu/cpAnUa6PoF/qqPqHeijvXsR
         azpJuIMSQB3bYht2JHEP4q7tU7wwdO1LWLLgilRcmIM72VARffvBUmXi5usGDM8IG02u
         xKzQscFFdLkokaLofnqQE/YSdSuPS48R8lwlFjE74K9X0/TfxwYcN2xFeCK6hRFtZ82K
         23Kb/W1ry568pN3X8nhsZDw+V08blpSIN/JoP3+U4fI2feBo8vBL71bho+4AyuAE1yo6
         t2ucOkGRkzTOSs3Eamq7KZQaEFRXtM8EkdoK/Pka4ST8lUOMSl/gKByX4fUPLNHYqeg3
         9bDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792076856; x=1792681656;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IC5Ct3FOhi968am1MRf06lj4teeqkFZmOqPC0DoSw2E=;
        b=RlPBubvbXXuqFSwE7Wqk8t0m4IU929H17+Y6k+oLvKH02/eeWaUTWmC0LwuKZmu2AU
         7x4Oop+8keT7O7noyDxUlNVz0hobApqxdG0sedFzwaYuhD2OkrowaqG9asde4mpWJ3v0
         3arDpgZQ5Kpt86Yp+qteCYldvztCPtgn5j+VDJYYPJtaTemZL+r2osYdzdEKD0t8G8lm
         p5P3qs08fIMf8hZhGvcbP4S0S97YKeTyWHCt5JsB0tbrZ8u9liOEbBQEfbjbScmQ4F6E
         ajxlfXY+q6l1KiH9LdX95iwowMxpimOqaHJdsqs2lVt5XaEM2+kWVnS4XilekPxORjxu
         yZww==
X-Forwarded-Encrypted: i=1; AKwUvBxwHcyoZKldkIBZAUOj1L1t/+FvRJLAGs/7OAlBFcIW3RCc9wLH2oiVWa4jJJc7kRv3Pgw4D80=@lists.linux.dev
X-Gm-Message-State: AFq9FYL4cgiy8kO4jl2Rya3g29U7mbtd1nCm3/p/eJ34AfJKNOE5MKhT
	OIJ6kzPd17hSly9BdimmFWo2soWNFSuRZzcClKNf51At4fgmhXKWKP5fo/p5R4UOkYTQk9uapjB
	n+8MoWrkTKwfPIJh3CA==
X-Received: from ejbbq18.prod.google.com ([2002:a17:906:d0d2:b0:c2e:1f38:d81a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9615:b0:c24:adf4:5c73 with SMTP id a640c23a62f3a-c31a9a28825mr1772701566b.1.1792076855746;
 Thu, 15 Oct 2026 08:07:35 -0700 (PDT)
Date: Thu, 15 Oct 2026 15:07:34 +0000
In-Reply-To: <2vxzzewfgno2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260903023452.721732-2-loganodell@google.com> <2vxzzewfgno2.fsf@kernel.org>
Message-ID: <9huzqzhrhuix.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH 1/3] luo: Move to feature flags instead of
 compatibility strings
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>, Logan Odell <loganodell@google.com>
Cc: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Pratyush Yadav <pratyush@kernel.org> writes:

> Hi Logan,
>
> On Wed, Sep 02 2026, Logan Odell wrote:
>
>> Define a 128 byte header that can be used by all live update serialized
>> structures. In this header, we reserve room for 64 features with
>> supported, active, and required bits. Update the top level luo struct to
>> use this instead of compatibility strings. Previous versions of the
>> struct had smaller sizes, so add a minimum size check to avoid
>> collisions with older kernels.
>>
>> Signed-off-by: Logan Odell <loganodell@google.com>
>> ---
>>  include/linux/kho/abi/luo.h  | 74 +++++++++++++++++++++++++++++-------
>>  kernel/liveupdate/luo_core.c | 44 +++++++++++++--------
>>  2 files changed, 90 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 288076de6d4a..0a7662a0cf9a 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -13,15 +13,17 @@
>>   * kernel. The ABI is built upon the Kexec HandOver framework and registers
>>   * the central `struct luo_ser` via the KHO raw subtree API.
>>   *
>> - * This interface is a contract. Any modification to the structure fields,
>> - * compatible strings, or the layout of the `__packed` serialization
>> - * structures defined here constitutes a breaking change. Such changes require
>> - * incrementing the version number in the relevant `_COMPATIBLE` string to
>> - * prevent a new kernel from misinterpreting data from an old kernel.
>> + * This interface is a contract. To ensure the stability of moving between
>> + * kernel versions, any changes to the structures should only be additive
>> + * and should utilize the feature flags to denote the supported, active, and
>> + * required status of the feature.
>> + *
>> + * Features that are entirely optional can be added with the supported and
>> + * active flags both asserted, and the required flag cleared. Features that
>> + * require that the next kernel supports the feature should only be added as
>> + * supported to allow compatible transition kernels. At a later time, the
>> + * active and required flag should be asserted.
>>   *
>> - * Changes are allowed provided the compatibility version is incremented;
>> - * however, backward/forward compatibility is only guaranteed for kernels
>> - * supporting the same ABI version.
>>   *
>>   * KHO Structure Overview:
>>   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
>> @@ -30,7 +32,7 @@
>>   * Serialization Structures:
>>   *   - struct luo_ser:
>>   *     The central ABI structure that contains the overall state of the LUO.
>> - *     It includes the compatibility string, the liveupdate-number, and pointers
>> + *     It includes the feature flags, the liveupdate-number, and pointers
>>   *     to sessions and FLBs.
>>   *
>>   *   - struct luo_session_ser:
>> @@ -58,19 +60,65 @@
>>  #define _LINUX_KHO_ABI_LUO_H
>>  
>>  #include <linux/align.h>
>> +#include <linux/bits.h>
>>  #include <linux/kho/abi/block.h>
>>  #include <uapi/linux/liveupdate.h>
>>  
>> +/**
>> + * struct luo_feature_hdr - Feature negotiation and versioning header.
>> + * @supp:     Bitmask of features supported by the producing subsystem.
>> + * @req:      Bitmask of features required for safe deserialization by the
>> + *            receiving subsystem.
>
> I think you are mixing two things here: description of the payload and
> description of the file handler capability.
>
> The payload that is handed over via KHO should have the active and
> required bitmasks only. It doesn't need the supported bitmask, because
> it doesn't matter what the handler that produced the payload supports.
> It only matters what fields it populated and which ones are mandatory to
> understand.
>
> Similarly, the description of the file handler can't really describe
> "active". Because the capabilities are static and the active bits will
> depend on a specific file.
>
> So I reckon we should separate these two. These should be the same bits
> of course, but expressed in two ways in two different places.
>
>> + * @active:   Bitmask of features actually active/used in the serialized payload.
>> + * @reserved: Reserved for future use.
>> + *
>> + * This header can be embedded at the beginning of any serialized structure to
>> + * provide forward and backward compatibility via feature negotiation across
>> + * live update.
>> + */
>> +struct luo_feature_hdr {
>> +	u64 supp;
>> +	u64 req;
>> +	u64 active;
>> +	u64 reserved[13];
>
> How do you plan to ever use this? Say I want to extend my bitmaps so I do:
>
>     struct luo_feature_hdr {
>     	u64 supp;
>     	u64 req;
>     	u64 active;
>     	u64 supp2;
>     	u64 req2;
>     	u64 active2;
>     	u64 reserved[10];

I thinking this is too spreaded.

We can do somthing like:

struct ABI {
       u64 size;
       u64 flags;
       u64 flags2;
}

where flags is extended to flags2 if flags MSB bits is 11.

and each flags is formatted like 0b 00 01 11 00 11 10 11 11 00 00 11 ...

each pair represents 0b 1 (required) 1 (active)
Getting the details of the feature is just bit manipulation, so
proper macro definition similar to the one this patch has implemented.


~Tarun



>
> But when I go back to a kernel that doesn't know about supp2, req2,
> etc., how does it know how to interpret these? How does it know what the
> values mean?
>
> Is your goal only to be able to extend the three types of flags we have?
> If so, perhaps something like "if bit 63 is set, the flags continue to
> the next u64"? It is certainly harder for the parser, but seems to at
> least be extensible. What do you think?
>
>> +} __packed;
>> +
>> +#define LUO_FEATURE_ACTIVE(s, f)		\
>> +	do {					\
>> +		(s)->features.supp |= (u64)(f);	\
>> +		(s)->features.active |= (u64)(f);	\
>> +	} while (0)
>> +#define LUO_FEATURE_SUPPORTED(s, f)	((s)->features.supp |= (u64)(f))
>> +#define LUO_FEATURE_REQUIRED(s, f)	((s)->features.req |= (u64)(f))
>> +#define LUO_FEATURE_IS_ACTIVE(s, f)	(!!((s)->features.active & (u64)(f)))
>> +#define LUO_FEATURE_IS_SUPPORTED(s, f)	(!!((s)->features.supp & (u64)(f)))
>> +#define LUO_FEATURE_IS_REQUIRED(s, f)	(!!((s)->features.req & (u64)(f)))
>> +
>>  /*
>>   * The LUO state is registered under this KHO entry name.
>>   */
>>  #define LUO_KHO_ENTRY_NAME	"LUO"
>> -#define LUO_ABI_COMPATIBLE	"luo-v5"
>> -#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
>> +
>> +/*
>> + * Bits associated with the luo_feature_hdr values.
>> + */
>> +#define LUO_FEATURE_NUMBER    BIT_ULL(0)
>> +#define LUO_FEATURE_SESSIONS  BIT_ULL(1)
>> +#define LUO_FEATURE_FLBS      BIT_ULL(2)
>
> Nit: please give the flags full documentation on their semantics.
>
>> +
>> +#define LUO_CORE_FEATURES_SUPP		(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>> +#define LUO_CORE_FEATURES_REQ		(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>> +#define LUO_CORE_FEATURES_ACTIVE	(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>>  
>>  /**
>>   * struct luo_ser - Centralized LUO ABI header.
>> - * @compatible:     Compatibility string identifying the LUO ABI version.
>> + * @features:       Bit mask of supported and active features.
>>   * @liveupdate_num: A counter tracking the number of successful live updates.
>>   * @sessions_pa:    Physical address of the first session block header.
>>   * @flbs_pa:        Physical address of the FLB header.
>> @@ -78,7 +126,7 @@
>>   * This structure is the root of all preserved LUO state.
>>   */
>>  struct luo_ser {
>> -	char compatible[LUO_ABI_COMPAT_LEN];
>> +	struct luo_feature_hdr features;
>
> Do we still need compatible here? How will we ever do breaking changes
> if we really need to?
>
>>  	u64 liveupdate_num;
>>  	u64 sessions_pa;
>>  	u64 flbs_pa;
>> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>> index 1b2bda22902d..6add1ecc463f 100644
>> --- a/kernel/liveupdate/luo_core.c
>> +++ b/kernel/liveupdate/luo_core.c
>> @@ -107,26 +107,37 @@ static int __init luo_early_startup(void)
>>  		return 0;
>>  	}
>>  
>> -	if (len < sizeof(*luo_ser)) {
>> -		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
>> -		return -EINVAL;
>> +	luo_ser = phys_to_virt(luo_ser_phys);
>> +
>> +	if (len < sizeof(struct luo_feature_hdr)) {
>> +		pr_err("LUO state is too small (%zu < %zu)\n",
>> +		       len, sizeof(struct luo_feature_hdr));
>> +		err = -EINVAL;
>> +		goto out_free_ser;
>>  	}
>>  
>> -	luo_ser = phys_to_virt(luo_ser_phys);
>> -	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
>> -		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
>> -		return -EINVAL;
>> +	if (luo_ser->features.req & ~LUO_CORE_FEATURES_SUPP) {
>> +		pr_err("Unsupported required LUO feature (req: 0x%llx, supp: 0x%llx)\n",
>> +		       luo_ser->features.req, (u64)LUO_CORE_FEATURES_SUPP);
>> +		err = -EOPNOTSUPP;
>> +		goto out_free_ser;
>>  	}
>>  
>> -	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>> -	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>> -		luo_global.liveupdate_num);
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_NUMBER)) {
>> +		luo_global.liveupdate_num = luo_ser->liveupdate_num;
>> +		pr_info("Retrieved live update data, liveupdate number: %lld\n",
>> +			luo_global.liveupdate_num);
>> +	}
>>  
>> -	err = luo_session_setup_incoming(luo_ser->sessions_pa);
>> -	if (err)
>> -		goto out_free_ser;
>>  
>> -	luo_flb_setup_incoming(luo_ser->flbs_pa);
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_SESSIONS)) {
>> +		err = luo_session_setup_incoming(luo_ser->sessions_pa);
>> +		if (err)
>> +			goto out_free_ser;
>> +	}
>> +
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_FLBS))
>> +		luo_flb_setup_incoming(luo_ser->flbs_pa);
>>  
>>  	err = 0;
>>  
>> @@ -162,7 +173,10 @@ static int __init luo_state_setup(void)
>>  		return PTR_ERR(luo_ser);
>>  	}
>>  
>> -	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
>> +	luo_ser->features.supp = LUO_CORE_FEATURES_SUPP;
>> +	luo_ser->features.req = LUO_CORE_FEATURES_REQ;
>> +	luo_ser->features.active = LUO_CORE_FEATURES_ACTIVE;
>> +
>>  	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
>>  
>>  	luo_session_setup_outgoing(&luo_ser->sessions_pa);
>
> -- 
> Regards,
> Pratyush Yadav
