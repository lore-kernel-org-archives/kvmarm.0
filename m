Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD87C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:59:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5583D23750
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="e8IH0pn/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5583D23750
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCCD4B407;
	Mon, 29 Jun 2020 05:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uOwTZk3Or3eG; Mon, 29 Jun 2020 05:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2834B3C4;
	Mon, 29 Jun 2020 05:59:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B003A4B3C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:59:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TaM8HpOrY6Dy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 05:59:13 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C22F44B2EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:59:13 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id f18so15502124wml.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 02:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2wnuxV1/0RtqHtih7OtirJJwd77FbkJ2KcVF0Sn7hBg=;
 b=e8IH0pn/laHG8tTi96t9eazClTzNMEVkmq6++6vrhFP5k1O+Bh4laBlFhJo3bWs6v0
 usHqYNEF6AeV9L2/A8B6jGFjEypX1fjJmPPatJbh2j5HIGeuXjZJJoHffgStc7+1UAP3
 tD8OPVZ4QwhHp30zwTvz0IZFEt83aOPbe1CdmrIKD5QwOyJkCzzV2PXwDll04+LZyzJw
 SyfZOczrc4VSNJQ+ZxK5UnZCIn3rblI/1HZwVUDavSBIPvrQjrGPlpuwFRuqVAwZxGop
 l3UniM37wfbxa6iGjRqt94jBUnAnbyIKLhOiTnwCaErZoXb8OtdRYMn1uZnYsKjV7iBq
 hp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2wnuxV1/0RtqHtih7OtirJJwd77FbkJ2KcVF0Sn7hBg=;
 b=ObuNN61pwArM6xqvIIf63l1eBinc/N6XEEbV7LmmlDNTT1GtEM9T1CGhPRqPQ6TCm9
 2c3LvbW3jf4q5os8uXJmdgolBjljwwh486FrMHQ3ZpDrqjEiXYmHygl3h4uu4iM7Tmh4
 7ugXQ/7z0X08Exk5LLTqbCbzXCzrPL6UsdM1IsYI7zksQ2tx8kyJ3mdppyT405eZazNG
 jrCbvXh05qE16mpEj3zQd6k1VMqaBs55EeWutoGspRiu82bFon3+jNndEfQQM0Q63Fn8
 8jg+Uxu38VZhe5wDl9YZPt0NgkHo0hXgh88aNMXE++k/EvsipJwHiFGHXi3TmHncvFvj
 jYKA==
X-Gm-Message-State: AOAM531QcOJ5RSSnTdTMZMq7ZHA2cVyHFATA4BI14XU3RQ9JNictE8i4
 V2+84vZuylcw5SJJxZmCNWylQA==
X-Google-Smtp-Source: ABdhPJyIjZBajpd/w+yqchc40D6JyaMj6HiDMg5KW2HrRC2+6JwZyqm/6EgiNddlKuAwmHb38fY3XA==
X-Received: by 2002:a05:600c:4109:: with SMTP id
 j9mr15343680wmi.157.1593424752543; 
 Mon, 29 Jun 2020 02:59:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id x1sm21874197wrp.10.2020.06.29.02.59.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 Jun 2020 02:59:12 -0700 (PDT)
Date: Mon, 29 Jun 2020 10:59:07 +0100
From: Andrew Scull <ascull@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
Message-ID: <20200629095907.GB3282863@google.com>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200629091841.88198-3-gshan@redhat.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jun 29, 2020 at 07:18:41PM +1000, Gavin Shan wrote:
> There are a set of inline functions defined in kvm_emulate.h. Those
> functions reads ESR from vCPU fault information struct and then operate
> on it. So it's tied with vCPU fault information and vCPU struct. It
> limits their usage scope.
> 
> This detaches these functions from the vCPU struct by introducing an
> other set of inline functions in esr.h to manupulate the specified
> ESR value. With it, the inline functions defined in kvm_emulate.h
> can call these inline functions (in esr.h) instead. This shouldn't
> cause any functional changes.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/esr.h         | 32 +++++++++++++++++++++
>  arch/arm64/include/asm/kvm_emulate.h | 43 ++++++++++++----------------
>  2 files changed, 51 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 035003acfa87..950204c5fbe1 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -326,6 +326,38 @@ static inline bool esr_is_data_abort(u32 esr)
>  	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
>  }
>  
> +#define ESR_DECLARE_CHECK_FUNC(name, field)	\
> +static inline bool esr_is_##name(u32 esr)	\
> +{						\
> +	return !!(esr & (field));		\
> +}
> +#define ESR_DECLARE_GET_FUNC(name, mask, shift)	\
> +static inline u32 esr_get_##name(u32 esr)	\
> +{						\
> +	return ((esr & (mask)) >> (shift));	\
> +}

Should these be named DEFINE rather than DECLARE given it also includes
the function definition?

> +
> +ESR_DECLARE_CHECK_FUNC(il_32bit,   ESR_ELx_IL);
> +ESR_DECLARE_CHECK_FUNC(condition,  ESR_ELx_CV);
> +ESR_DECLARE_CHECK_FUNC(dabt_valid, ESR_ELx_ISV);
> +ESR_DECLARE_CHECK_FUNC(dabt_sse,   ESR_ELx_SSE);
> +ESR_DECLARE_CHECK_FUNC(dabt_sf,    ESR_ELx_SF);
> +ESR_DECLARE_CHECK_FUNC(dabt_s1ptw, ESR_ELx_S1PTW);
> +ESR_DECLARE_CHECK_FUNC(dabt_write, ESR_ELx_WNR);
> +ESR_DECLARE_CHECK_FUNC(dabt_cm,    ESR_ELx_CM);
> +
> +ESR_DECLARE_GET_FUNC(class,        ESR_ELx_EC_MASK,      ESR_ELx_EC_SHIFT);
> +ESR_DECLARE_GET_FUNC(fault,        ESR_ELx_FSC,          0);
> +ESR_DECLARE_GET_FUNC(fault_type,   ESR_ELx_FSC_TYPE,     0);
> +ESR_DECLARE_GET_FUNC(condition,    ESR_ELx_COND_MASK,    ESR_ELx_COND_SHIFT);
> +ESR_DECLARE_GET_FUNC(hvc_imm,      ESR_ELx_xVC_IMM_MASK, 0);
> +ESR_DECLARE_GET_FUNC(dabt_iss_nisv_sanitized,
> +		     (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC), 0);
> +ESR_DECLARE_GET_FUNC(dabt_rd,      ESR_ELx_SRT_MASK,     ESR_ELx_SRT_SHIFT);
> +ESR_DECLARE_GET_FUNC(dabt_as,      ESR_ELx_SAS,          ESR_ELx_SAS_SHIFT);
> +ESR_DECLARE_GET_FUNC(sys_rt,       ESR_ELx_SYS64_ISS_RT_MASK,
> +				   ESR_ELx_SYS64_ISS_RT_SHIFT);
> +
>  const char *esr_get_class_string(u32 esr);
>  #endif /* __ASSEMBLY */
>  
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c9ba0df47f7d..9337d90c517f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -266,12 +266,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>  
>  static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>  {
> -	u32 esr = kvm_vcpu_get_esr(vcpu);
> -
> -	if (esr & ESR_ELx_CV)
> -		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
> -
> -	return -1;
> +	return esr_is_condition(kvm_vcpu_get_esr(vcpu)) ?
> +	       esr_get_condition(kvm_vcpu_get_esr(vcpu)) : -1;
>  }
>  
>  static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
> @@ -291,79 +287,79 @@ static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
>  
>  static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
> +	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
>  }

It feels a little strange that in the raw esr case it uses macro magic
but in the vcpu cases here it writes everything out in full. Was there a
reason that I'm missing or is there a chance to apply a consistent
approach?

I'm not sure of the style preferences, but if it goes the macro path,
the esr field definitions could be reused with something x-macro like to
get the kvm_emulate.h and esr.h functions generated from a singe list of
the esr fields.

>  static __always_inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_ISV);
> +	return esr_is_dabt_valid(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_esr(vcpu) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
> +	return esr_get_dabt_iss_nisv_sanitized(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SSE);
> +	return esr_is_dabt_sse(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SF);
> +	return esr_is_dabt_sf(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
>  {
> -	return (kvm_vcpu_get_esr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> +	return esr_get_dabt_rd(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
> +	return esr_is_dabt_s1ptw(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR) ||
> -		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
> +	return esr_is_dabt_write(kvm_vcpu_get_esr(vcpu)) ||
> +	       esr_is_dabt_s1ptw(kvm_vcpu_get_esr(vcpu)); /* AF/DBM update */
>  }
>  
>  static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
> +	return esr_is_dabt_cm(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
>  {
> -	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> +	return 1 << esr_get_dabt_as(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  /* This one is not specific to Data Abort */
>  static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
>  {
> -	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
> +	return esr_is_il_32bit(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
>  {
> -	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
> +	return esr_get_class(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
> +	return esr_get_class(kvm_vcpu_get_esr(vcpu)) == ESR_ELx_EC_IABT_LOW;
>  }
>  
>  static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
> +	return esr_get_fault(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
> +	return esr_get_fault_type(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
> @@ -387,8 +383,7 @@ static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
>  
>  static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>  {
> -	u32 esr = kvm_vcpu_get_esr(vcpu);
> -	return ESR_ELx_SYS64_ISS_RT(esr);
> +	return esr_get_sys_rt(kvm_vcpu_get_esr(vcpu));
>  }
>  
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> -- 
> 2.23.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
