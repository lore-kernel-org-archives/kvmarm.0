Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286D61A6806
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780275040; cv=none; b=DsiRreg8e3bb1CzXyQ6rpIJsQD+ZQMHHMI+sE/pzoDYYmN76BZRfisn1Lr6qmgEgQrnOL/rWq+Q5Pu1usbAxq4U9E9gj5atDjIAk7mYAianU//EZlxuXjUJJSIl3TVSaQAJW6eYeUwPBw8+idtHWbM5b+2ThVmZC+sCXWBpd0iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780275040; c=relaxed/simple;
	bh=NkgDjfStwAVwsufE6vFbU/T9ELXHoUZnhbLlqe0wf2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxjpqN7HR5B7Y32xBbVulpTW9eyfb4YtKTzKYprsPYLU2tZHPNY6FyQ2DlUgQJmccMHnBX0md+E2tdEZHMBlXiqAjJOcsWeVPmu4lNsw3Sm1U7frVEE/RGUzFfzNHpi/Xgt/pvnqc4P38qwDcLla5WwkyMvLo9cB2MwzxbZSJYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrndjjPq; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrndjjPq"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36b903567fdso3254808a91.1
        for <kvmarm@lists.linux.dev>; Sun, 31 May 2026 17:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780275038; x=1780879838; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cg6Y3xqfBKjzaemeU2L9Q5dBdOV9FXfEg49CMyYPN/s=;
        b=DrndjjPqDt2q6tVbxW8y6pvDPMvUvJ8HDml5oRyPTTVyhHeg3z0w8K1/RVhLWZgOpd
         c6SE707muZiiOiG2W6kdO4wtoyhKluMj74IMc640ZB7d+X3Iv/Zyhkcwok4LYP2j4yJX
         VjQFx93y8l2ow0UP85IlU3XFdQUeF7I2MtHjxwJiObtTWN2BDKl9yMyX/AaWBIKXIqOV
         2y12Y55UniBHTHtwpPqAaud78BoT+XzdBOR/dcZzdDaqR/2C1MeCLaz3929NQOwAgX3V
         Hxbh849eK+I/07H97Ip+lumjsss8datpU4T9tHYFtRRrJF6sVWRWCqoXJ8ju4tvBUBEj
         bdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780275038; x=1780879838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg6Y3xqfBKjzaemeU2L9Q5dBdOV9FXfEg49CMyYPN/s=;
        b=a3MipwAIJgK74quaqzeZ0vTuGMDcJEq9Hul2h3iHxiKb/EHRX3UNh5onn7wrOdj6nn
         kFXvuTVnzjpcfn2/FZ4hyn0zGdEN/EjHdsxs+iynYYtL34s2XRqTGsG6RiNcJYGDtH60
         U9l5rrfm4qr73Ku2si3ibTpdB7GJtowQaZPB1rYMP3mlx3bAY3FHmBKzNJCCdQz6bfZA
         vEYeE96wP20w9tISdpeTL1aMGVtIq/+25B9cQgqJpjOLfA/w5A0ZNLas/eh/XdJ3l9aO
         qEFKVD9RTKiXMg6Idaj902xzlvR5u/jr+yyIG4yenSf1+acCuUx0kKi1kV7eOPJOk+Mn
         g3pA==
X-Forwarded-Encrypted: i=1; AFNElJ+/s0hi06vVWSKgzRN3r94lgm/sMzqFkXkcUn2GxXURt0QEntREXluZqzUnir1rHKz5yzA6v9w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5tjNTQTV58u6zaeaAsuFaw/dA8oI5/sdnyZ6clYd/e9Z1uyX9
	Jfn4kd2Ab7EIW3TSAKayLgfYfMCcni63zp2AdmBF1HuP8c+MT8bnmGN/
X-Gm-Gg: Acq92OEwhM74kF+ifbFFAxam6SDoIoinnLqT+nEM8ETUzu+IyyiigEqPHKaelXrS8gu
	kY6KXaqUL6JOXcnvVkUgLLaZst54s+kGgTxK0bW60pHNec24ik+cLTrtqpHJ2yCnZ0l8xJaUWoV
	tfW9LoDmsY+AHX3AM85/9jSoed/WC5rhJUWIk+fQwOEsqY+Ry88JZgXOtxBC0mZXO/CCfOJsK81
	IFdwFANJKwwNkhc64XMaNDYScDl7WvsRTIm8l1NB+T9JxeWE6UJ9h/rYVRQs6X2S8hcjfBZPuc0
	HY1+Op4lniZ875LJHRl8kz2ajLjceqYg9Fav3Q8kMzYqzI8VsHYTfwR3cI/E8BYLMlfRUfpTPcG
	CCx6Fs5EXkPAggzyzF6eIb3j3hKHj5cxdRILXTEh2+OGCzFV9YHDn9FWBrpasYpwzCMJOTghM3C
	GaX+uIdh9Ac7O3PQHDHZRnclyoBdJ1wbHVpw==
X-Received: by 2002:a17:90b:2586:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-36db4245eb0mr1990613a91.1.1780275038259;
        Sun, 31 May 2026 17:50:38 -0700 (PDT)
Received: from localhost ([2001:19f0:8001:1b2d:5400:5ff:fefa:a95d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdb5c91bsm5313469a91.1.2026.05.31.17.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 17:50:37 -0700 (PDT)
Date: Mon, 1 Jun 2026 08:50:22 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Tian Zheng <zhengtian10@huawei.com>, maz@kernel.org, oupton@kernel.org, 
	catalin.marinas@arm.com, corbet@lwn.net, pbonzini@redhat.com, will@kernel.org
Cc: yuzenghui@huawei.com, wangzhou1@hisilicon.com, liuyonglong@huawei.com, 
	Jonathan.Cameron@huawei.com, yezhenyu2@huawei.com, linuxarm@huawei.com, joey.gouly@arm.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	suzuki.poulose@arm.com, leo.bras@arm.com, Inochi Amaoto <inochiama@gmail.com>
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add support for FEAT_HDBSS
Message-ID: <ahzUUDAMoHtDFJD3@inochi.infowork>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
 <20260225040421.2683931-4-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225040421.2683931-4-zhengtian10@huawei.com>

On Wed, Feb 25, 2026 at 12:04:19PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Armv9.5 introduces the Hardware Dirty Bit State Structure (HDBSS) feature,
> indicated by ID_AA64MMFR1_EL1.HAFDBS == 0b0100. A CPU capability is added
> to notify the user of the feature.
> 
> Add KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl and basic framework for
> ARM64 HDBSS support. Since the HDBSS buffer size is configurable and
> cannot be determined at KVM initialization, an IOCTL interface is
> required.
> 
> Actually exposing the new capability to user space happens in a later
> patch.
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  5 +++++
>  arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>  arch/arm64/tools/cpucaps            |  1 +
>  include/uapi/linux/kvm.h            |  1 +
>  tools/include/uapi/linux/kvm.h      |  1 +
>  5 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 4de51f8d92cb..dcc2e2cad5ad 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -856,6 +856,11 @@ static inline bool system_supports_haft(void)
>  	return cpus_have_final_cap(ARM64_HAFT);
>  }
> 
> +static inline bool system_supports_hdbss(void)
> +{
> +	return cpus_have_final_cap(ARM64_HAS_HDBSS);
> +}
> +
>  static __always_inline bool system_supports_mpam(void)
>  {
>  	return alternative_has_cap_unlikely(ARM64_MPAM);
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a..348b0afffc3e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2124,6 +2124,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>  }
> 
> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
> +{
> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
> +}
> +
>  bool cpu_supports_bbml2_noabort(void)
>  {
>  	/*
> @@ -2759,6 +2764,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
>  	},
>  #endif
> +	{
> +		.desc = "Hardware Dirty state tracking structure (HDBSS)",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_HDBSS,
> +		.matches = has_vhe_hdbss,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
> +	},
>  	{
>  		.desc = "CRC32 instructions",
>  		.capability = ARM64_HAS_CRC32,
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 7261553b644b..f6ece5b85532 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -68,6 +68,7 @@ HAS_VA52
>  HAS_VIRT_HOST_EXTN
>  HAS_WFXT
>  HAS_XNX
> +HAS_HDBSS
>  HAFT
>  HW_DBM
>  KVM_HVHE


> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 65500f5db379..15ee42cdbd51 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -985,6 +985,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_SEA_TO_USER 245
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
> +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
> 
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index dddb781b0507..93e0a1e14dc7 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>  #define KVM_CAP_ARM_SEA_TO_USER 245
>  #define KVM_CAP_S390_USER_OPEREXEC 246
> +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
> 
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> --
> 2.33.0
> 

Instead of having these architecture specific capability, I wonder if
we can add a generic capability like "KVM_CAP_HW_DIRTY_STATE", so
other architecture supports similar things can reuse this capability,

For this generic thing I suggest, the getter returns the max support 
entry count (or the buffer size) it supports like the dirty ring
capability. And the setter just let the architecture set the parameters
based on the user request. 

This should do no harm to this implement, as everything still depends
on the architecture behavior, and leave room for other architecture
to reuse this.

Regards,
Inochi
