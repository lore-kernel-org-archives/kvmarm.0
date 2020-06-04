Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B81C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 15:04:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8A11207D8
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 15:04:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8A11207D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5004B3B5;
	Thu,  4 Jun 2020 11:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cu+efLHmVXRt; Thu,  4 Jun 2020 11:04:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE2774B3B9;
	Thu,  4 Jun 2020 11:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0DE4B34E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:04:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vRAxC9xxV8Np for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 11:04:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 357564B325
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:04:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A52571FB;
 Thu,  4 Jun 2020 08:04:41 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.9.165])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BA053F305;
 Thu,  4 Jun 2020 08:04:38 -0700 (PDT)
Date: Thu, 4 Jun 2020 16:04:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Save the host's PtrAuth keys in
 non-preemptible context
Message-ID: <20200604150436.GC75320@C02TD0UTHF1T.local>
References: <20200604133354.1279412-1-maz@kernel.org>
 <20200604133354.1279412-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200604133354.1279412-2-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jun 04, 2020 at 02:33:52PM +0100, Marc Zyngier wrote:
> When using the PtrAuth feature in a guest, we need to save the host's
> keys before allowing the guest to program them. For that, we dump
> them in a per-CPU data structure (the so called host context).
> 
> But both call sites that do this are in preemptible context,
> which may end up in disaster should the vcpu thread get preempted
> before reentering the guest.

Yuck!

> Instead, save the keys eagerly on each vcpu_load(). This has an
> increased overhead, but is at least safe.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This looks sound to me given kvm_arch_vcpu_load() is surrounded with
get_cpu() .. put_cpu() and gets called when the thread is preempted.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
>  arch/arm64/include/asm/kvm_emulate.h |  6 ------
>  arch/arm64/kvm/arm.c                 | 18 +++++++++++++++++-
>  arch/arm64/kvm/handle_exit.c         | 19 ++-----------------
>  3 files changed, 19 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index a30b4eec7cb4..977843e4d5fb 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -112,12 +112,6 @@ static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
>  }
>  
> -static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
> -{
> -	if (vcpu_has_ptrauth(vcpu))
> -		vcpu_ptrauth_disable(vcpu);
> -}
> -
>  static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.vsesr_el2;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d6988401c22a..152049c5055d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -337,6 +337,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  	preempt_enable();
>  }
>  
> +#define __ptrauth_save_key(regs, key)						\
> +({										\
> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	int *last_ran;
> @@ -370,7 +376,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	else
>  		vcpu_set_wfx_traps(vcpu);
>  
> -	vcpu_ptrauth_setup_lazy(vcpu);
> +	if (vcpu_has_ptrauth(vcpu)) {
> +		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
> +
> +		__ptrauth_save_key(ctxt->sys_regs, APIA);
> +		__ptrauth_save_key(ctxt->sys_regs, APIB);
> +		__ptrauth_save_key(ctxt->sys_regs, APDA);
> +		__ptrauth_save_key(ctxt->sys_regs, APDB);
> +		__ptrauth_save_key(ctxt->sys_regs, APGA);
> +
> +		vcpu_ptrauth_disable(vcpu);
> +	}
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index eb194696ef62..065251efa2e6 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -162,31 +162,16 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> -#define __ptrauth_save_key(regs, key)						\
> -({										\
> -	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> -	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> -})
> -
>  /*
>   * Handle the guest trying to use a ptrauth instruction, or trying to access a
>   * ptrauth register.
>   */
>  void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpu_context *ctxt;
> -
> -	if (vcpu_has_ptrauth(vcpu)) {
> +	if (vcpu_has_ptrauth(vcpu))
>  		vcpu_ptrauth_enable(vcpu);
> -		ctxt = vcpu->arch.host_cpu_context;
> -		__ptrauth_save_key(ctxt->sys_regs, APIA);
> -		__ptrauth_save_key(ctxt->sys_regs, APIB);
> -		__ptrauth_save_key(ctxt->sys_regs, APDA);
> -		__ptrauth_save_key(ctxt->sys_regs, APDB);
> -		__ptrauth_save_key(ctxt->sys_regs, APGA);
> -	} else {
> +	else
>  		kvm_inject_undefined(vcpu);
> -	}
>  }
>  
>  /*
> -- 
> 2.26.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
