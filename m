Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4382C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 11:00:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7359823A03
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 11:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7359823A03
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB414B3E9;
	Mon, 29 Jun 2020 07:00:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OXdhefW4XrL5; Mon, 29 Jun 2020 07:00:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3384B3EC;
	Mon, 29 Jun 2020 07:00:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDE24B3C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 07:00:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wyuz9qAXcKSM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 07:00:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91EF04B1A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 07:00:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 374B613D5;
 Mon, 29 Jun 2020 04:00:20 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.20.135])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C11893F73C;
 Mon, 29 Jun 2020 04:00:18 -0700 (PDT)
Date: Mon, 29 Jun 2020 12:00:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
Message-ID: <20200629110016.GB59769@C02TD0UTHF1T.local>
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

TBH, I'm not sure that this patch makes much sense on its own.

We already use vcpu_get_esr(), which is the bit that'd have to change if
we didn't pass the vcpu around, and the new helpers are just consuming
the value in a sifferent way rather than a necessarily simpler way.

Further comments on that front below.

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

I'm really not keen on this, as I think it's abstracting the problem at
the wrong level, hiding information and making things harder to reason
about rather than abstracting that.

I strongly suspect the right thing to do is use FIELD_GET() in-place in
the functions below, e.g.

   !!FIELD_GET(esr, ESR_ELx_IL);

... rather than:

   esr_get_il_32bit(esr);

... as that avoids the wrapper entirely, minimizing indirection and
making the codebase simpler to navigate.

For the cases where we *really* want a helper, i'd rather write those
out explicitly, e.g.

#define esr_get_hvc_imm(esr)	FIELD_GET(esr, ESR_ELx_xVC_IMM_MASK)

... but I'm not sure if we really need those given these are mostly used
*once* below.

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

Do we really need to change the structure of this code? I thought this
was purely about decooupling helpers from the vcpu struct. This could
have stayed as:

static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
{
	u32 esr = kvm_vcpu_get_esr(vcpu);

	if (esr_is_condition(esr))
		return esr_get_condition(esr);
	
	return -1;
}

... or:

static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
{
	u32 esr = kvm_vcpu_get_esr(vcpu);

	if (FEILD_GET(esr, ESR_ELx_CV))
		return FIELD_GET(esr, ESR_ELx_COND_MASK);
	
	return -1;
}

Thanks,
Mark.

>  
>  static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
> @@ -291,79 +287,79 @@ static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
>  
>  static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
> +	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
>  }
>  
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
