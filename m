Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B95FC388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 10:55:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E864422282
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 10:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E864422282
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B62C4B53E;
	Tue, 27 Oct 2020 06:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TJq-xFiyYXPk; Tue, 27 Oct 2020 06:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB604B513;
	Tue, 27 Oct 2020 06:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99DEC4B4A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 06:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mwP7QptMbvOt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 06:55:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E8F4B2E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 06:55:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5CCC30E;
 Tue, 27 Oct 2020 03:55:40 -0700 (PDT)
Received: from [10.57.18.142] (unknown [10.57.18.142])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E91A53F66E;
 Tue, 27 Oct 2020 03:55:38 -0700 (PDT)
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to
 HYP
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <a2b942e5-651b-4733-4332-98b33fc6689b@arm.com>
Date: Tue, 27 Oct 2020 10:55:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-4-maz@kernel.org>
Content-Language: en-GB
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 10/26/20 1:34 PM, Marc Zyngier wrote:
> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
> to increment PC post emulation is now signalled via a flag in the
> vcpu structure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_emulate.h       | 27 +----------
>   arch/arm64/include/asm/kvm_host.h          |  1 +
>   arch/arm64/kvm/handle_exit.c               |  6 +--
>   arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 56 ++++++++++++++++++++++
>   arch/arm64/kvm/hyp/include/hyp/switch.h    |  2 +
>   arch/arm64/kvm/hyp/nvhe/switch.c           |  3 ++
>   arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  2 +
>   arch/arm64/kvm/hyp/vgic-v3-sr.c            |  2 +
>   arch/arm64/kvm/hyp/vhe/switch.c            |  3 ++
>   arch/arm64/kvm/mmio.c                      |  2 +-
>   arch/arm64/kvm/mmu.c                       |  2 +-
>   arch/arm64/kvm/sys_regs.c                  |  2 +-
>   12 files changed, 77 insertions(+), 31 deletions(-)
>   create mode 100644 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 0864f425547d..6d2b5d1aa7b3 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -472,32 +472,9 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>   	return data;		/* Leave LE untouched */
>   }
>   
> -static __always_inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
> +static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu_mode_is_32bit(vcpu)) {
> -		kvm_skip_instr32(vcpu);
> -	} else {
> -		*vcpu_pc(vcpu) += 4;
> -		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
> -	}
> -
> -	/* advance the singlestep state machine */
> -	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> -}
> -
> -/*
> - * Skip an instruction which has been emulated at hyp while most guest sysregs
> - * are live.
> - */
> -static __always_inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
> -{
> -	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> -	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
> -
> -	kvm_skip_instr(vcpu);
> -
> -	write_sysreg_el2(vcpu_gp_regs(vcpu)->pstate, SYS_SPSR);
> -	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> +	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
>   }
>   
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0aecbab6a7fb..9a75de3ad8da 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -406,6 +406,7 @@ struct kvm_vcpu_arch {
>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
>   #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
> +#define KVM_ARM64_INCREMENT_PC		(1 << 8) /* Increment PC */
>   
>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 30bf8e22df54..d4e00a864ee6 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -61,7 +61,7 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>   	 * otherwise return to the same address...
>   	 */
>   	vcpu_set_reg(vcpu, 0, ~0UL);
> -	kvm_skip_instr(vcpu);
> +	kvm_incr_pc(vcpu);
>   	return 1;
>   }
>   
> @@ -100,7 +100,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>   		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   	}
>   
> -	kvm_skip_instr(vcpu);
> +	kvm_incr_pc(vcpu);
>   
>   	return 1;
>   }
> @@ -221,7 +221,7 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
>   	 * that fail their condition code check"
>   	 */
>   	if (!kvm_condition_valid(vcpu)) {
> -		kvm_skip_instr(vcpu);
> +		kvm_incr_pc(vcpu);
>   		handled = 1;
>   	} else {
>   		exit_handle_fn exit_handler;
> diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> new file mode 100644
> index 000000000000..4ecaf5cb2633
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Guest PC manipulation helpers
> + *
> + * Copyright (C) 2012,2013 - ARM Ltd
> + * Copyright (C) 2020 - Google LLC
> + * Author: Marc Zyngier <maz@kernel.org>
> + */
> +
> +#ifndef __ARM64_KVM_HYP_ADJUST_PC_H__
> +#define __ARM64_KVM_HYP_ADJUST_PC_H__
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_host.h>
> +
> +static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_mode_is_32bit(vcpu)) {
> +		kvm_skip_instr32(vcpu);
> +	} else {
> +		*vcpu_pc(vcpu) += 4;
> +		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
> +	}
> +
> +	/* advance the singlestep state machine */
> +	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> +}
> +
> +/*
> + * Skip an instruction which has been emulated at hyp while most guest sysregs
> + * are live.
> + */
> +static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
> +{
> +	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> +	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
> +
> +	__kvm_skip_instr(vcpu);

Did you mean kvm_skip_instr() instead ?

Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
