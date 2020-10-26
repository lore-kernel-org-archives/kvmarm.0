Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD59C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:30:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A4D121655
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A4D121655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09DE94B47B;
	Mon, 26 Oct 2020 10:30:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k10reK+xl7kU; Mon, 26 Oct 2020 10:30:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E454B460;
	Mon, 26 Oct 2020 10:30:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B05414B45D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:30:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gsQG26HAl3no for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:30:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091324B452
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:30:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4C5630E;
 Mon, 26 Oct 2020 07:30:23 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334E93F68F;
 Mon, 26 Oct 2020 07:30:22 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:30:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 09/11] KVM: arm64: Remove SPSR manipulation primitives
Message-ID: <20201026143019.GK12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-10-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-10-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On Mon, Oct 26, 2020 at 01:34:48PM +0000, Marc Zyngier wrote:
> The SPR setting code is now completely unused, including that dealing
> with banked AArch32 SPSRs. Cleanup time.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 26 --------
>  arch/arm64/kvm/regmap.c              | 96 ----------------------------
>  2 files changed, 122 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 736a342dadf7..5d957d0e7b69 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -34,8 +34,6 @@ enum exception_type {
>  };
>  
>  unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
> -unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
> -void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
>  
>  bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
>  void kvm_skip_instr32(struct kvm_vcpu *vcpu);
> @@ -180,30 +178,6 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>  }
>  
> -static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
> -{
> -	if (vcpu_mode_is_32bit(vcpu))
> -		return vcpu_read_spsr32(vcpu);
> -
> -	if (vcpu->arch.sysregs_loaded_on_cpu)
> -		return read_sysreg_el1(SYS_SPSR);
> -	else
> -		return __vcpu_sys_reg(vcpu, SPSR_EL1);
> -}
> -
> -static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
> -{
> -	if (vcpu_mode_is_32bit(vcpu)) {
> -		vcpu_write_spsr32(vcpu, v);
> -		return;
> -	}
> -
> -	if (vcpu->arch.sysregs_loaded_on_cpu)
> -		write_sysreg_el1(v, SYS_SPSR);
> -	else
> -		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
> -}
> -
>  /*
>   * The layout of SPSR for an AArch32 state is different when observed from an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
> diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
> index accc1d5fba61..ae7e290bb017 100644
> --- a/arch/arm64/kvm/regmap.c
> +++ b/arch/arm64/kvm/regmap.c
> @@ -126,99 +126,3 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
>  
>  	return reg_array + vcpu_reg_offsets[mode][reg_num];
>  }
> -
> -/*
> - * Return the SPSR for the current mode of the virtual CPU.
> - */
> -static int vcpu_spsr32_mode(const struct kvm_vcpu *vcpu)
> -{
> -	unsigned long mode = *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;
> -	switch (mode) {
> -	case PSR_AA32_MODE_SVC: return KVM_SPSR_SVC;
> -	case PSR_AA32_MODE_ABT: return KVM_SPSR_ABT;
> -	case PSR_AA32_MODE_UND: return KVM_SPSR_UND;
> -	case PSR_AA32_MODE_IRQ: return KVM_SPSR_IRQ;
> -	case PSR_AA32_MODE_FIQ: return KVM_SPSR_FIQ;
> -	default: BUG();
> -	}
> -}
> -
> -unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
> -{
> -	int spsr_idx = vcpu_spsr32_mode(vcpu);
> -
> -	if (!vcpu->arch.sysregs_loaded_on_cpu) {
> -		switch (spsr_idx) {
> -		case KVM_SPSR_SVC:
> -			return __vcpu_sys_reg(vcpu, SPSR_EL1);
> -		case KVM_SPSR_ABT:
> -			return vcpu->arch.ctxt.spsr_abt;
> -		case KVM_SPSR_UND:
> -			return vcpu->arch.ctxt.spsr_und;
> -		case KVM_SPSR_IRQ:
> -			return vcpu->arch.ctxt.spsr_irq;
> -		case KVM_SPSR_FIQ:
> -			return vcpu->arch.ctxt.spsr_fiq;
> -		}
> -	}
> -
> -	switch (spsr_idx) {
> -	case KVM_SPSR_SVC:
> -		return read_sysreg_el1(SYS_SPSR);
> -	case KVM_SPSR_ABT:
> -		return read_sysreg(spsr_abt);
> -	case KVM_SPSR_UND:
> -		return read_sysreg(spsr_und);
> -	case KVM_SPSR_IRQ:
> -		return read_sysreg(spsr_irq);
> -	case KVM_SPSR_FIQ:
> -		return read_sysreg(spsr_fiq);
> -	default:
> -		BUG();
> -	}
> -}
> -
> -void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
> -{
> -	int spsr_idx = vcpu_spsr32_mode(vcpu);
> -
> -	if (!vcpu->arch.sysregs_loaded_on_cpu) {
> -		switch (spsr_idx) {
> -		case KVM_SPSR_SVC:
> -			__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
> -			break;
> -		case KVM_SPSR_ABT:
> -			vcpu->arch.ctxt.spsr_abt = v;
> -			break;
> -		case KVM_SPSR_UND:
> -			vcpu->arch.ctxt.spsr_und = v;
> -			break;
> -		case KVM_SPSR_IRQ:
> -			vcpu->arch.ctxt.spsr_irq = v;
> -			break;
> -		case KVM_SPSR_FIQ:
> -			vcpu->arch.ctxt.spsr_fiq = v;
> -			break;
> -		}
> -
> -		return;
> -	}
> -
> -	switch (spsr_idx) {
> -	case KVM_SPSR_SVC:
> -		write_sysreg_el1(v, SYS_SPSR);
> -		break;
> -	case KVM_SPSR_ABT:
> -		write_sysreg(v, spsr_abt);
> -		break;
> -	case KVM_SPSR_UND:
> -		write_sysreg(v, spsr_und);
> -		break;
> -	case KVM_SPSR_IRQ:
> -		write_sysreg(v, spsr_irq);
> -		break;
> -	case KVM_SPSR_FIQ:
> -		write_sysreg(v, spsr_fiq);
> -		break;
> -	}
> -}
> -- 
> 2.28.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
