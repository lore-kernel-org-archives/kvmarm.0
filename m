Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B05AC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 14:07:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 978C6613AA
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 14:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 978C6613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FDE4B993;
	Fri, 14 May 2021 10:06:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OyW-yoo5P+Bf; Fri, 14 May 2021 10:06:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8878E4B97A;
	Fri, 14 May 2021 10:06:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ECB04B97A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 10:06:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1e9yzTvwRXaP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 10:06:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73EE74B5A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 10:06:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2BE51763;
 Fri, 14 May 2021 07:06:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 830DD3F718;
 Fri, 14 May 2021 07:06:52 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: arm64: Move __adjust_pc out of line
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20210514104042.1929168-1-maz@kernel.org>
 <20210514104042.1929168-2-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d05de0f0-5914-46bc-21d1-dd186284142c@arm.com>
Date: Fri, 14 May 2021 15:07:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210514104042.1929168-2-maz@kernel.org>
Content-Language: en-US
Cc: stable@vger.kernel.org, kernel-team@android.com
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

Hi Marc,

On 5/14/21 11:40 AM, Marc Zyngier wrote:
> In order to make it easy to call __adjust_pc() from the EL1 code
> (in the case of nVHE), rename it to __kvm_adjust_pc() and move
> it out of line.
>
> No expected functional change.

Looks good to me. Ran the kvm-unit-tests test selftest-vectors-kernel, which goes
out of its way to trigger an undefined exception, compiled for arm and arm64,
under VHE, nVHE and protected modes on an odroid-c4, everything worked as expected:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # 5.11
> ---
>  arch/arm64/include/asm/kvm_asm.h           |  2 ++
>  arch/arm64/kvm/hyp/exception.c             | 18 +++++++++++++++++-
>  arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ------------------
>  arch/arm64/kvm/hyp/nvhe/switch.c           |  3 +--
>  arch/arm64/kvm/hyp/vhe/switch.c            |  3 +--
>  5 files changed, 21 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index cf8df032b9c3..d5b11037401d 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -201,6 +201,8 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
> +extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
> +
>  extern u64 __vgic_v3_get_gic_config(void);
>  extern u64 __vgic_v3_read_vmcr(void);
>  extern void __vgic_v3_write_vmcr(u32 vmcr);
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 73629094f903..0812a496725f 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -296,7 +296,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  	*vcpu_pc(vcpu) = vect_offset;
>  }
>  
> -void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_el1_is_32bit(vcpu)) {
>  		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> @@ -329,3 +329,19 @@ void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  }
> +
> +/*
> + * Adjust the guest PC on entry, depending on flags provided by EL1
> + * for the purpose of emulation (MMIO, sysreg) or exception injection.
> + */
> +void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
> +		kvm_inject_exception(vcpu);
> +		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
> +				      KVM_ARM64_EXCEPT_MASK);
> +	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
> +		kvm_skip_instr(vcpu);
> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
> +	}
> +}
> diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> index 61716359035d..4fdfeabefeb4 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> @@ -13,8 +13,6 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
>  
> -void kvm_inject_exception(struct kvm_vcpu *vcpu);
> -
>  static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> @@ -43,22 +41,6 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
>  	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
>  }
>  
> -/*
> - * Adjust the guest PC on entry, depending on flags provided by EL1
> - * for the purpose of emulation (MMIO, sysreg) or exception injection.
> - */
> -static inline void __adjust_pc(struct kvm_vcpu *vcpu)
> -{
> -	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
> -		kvm_inject_exception(vcpu);
> -		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
> -				      KVM_ARM64_EXCEPT_MASK);
> -	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
> -		kvm_skip_instr(vcpu);
> -		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
> -	}
> -}
> -
>  /*
>   * Skip an instruction while host sysregs are live.
>   * Assumes host is always 64-bit.
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index e9f6ea704d07..f7af9688c1f7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -4,7 +4,6 @@
>   * Author: Marc Zyngier <marc.zyngier@arm.com>
>   */
>  
> -#include <hyp/adjust_pc.h>
>  #include <hyp/switch.h>
>  #include <hyp/sysreg-sr.h>
>  
> @@ -201,7 +200,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	__debug_save_host_buffers_nvhe(vcpu);
>  
> -	__adjust_pc(vcpu);
> +	__kvm_adjust_pc(vcpu);
>  
>  	/*
>  	 * We must restore the 32-bit state before the sysregs, thanks
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 7b8f7db5c1ed..b3229924d243 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -4,7 +4,6 @@
>   * Author: Marc Zyngier <marc.zyngier@arm.com>
>   */
>  
> -#include <hyp/adjust_pc.h>
>  #include <hyp/switch.h>
>  
>  #include <linux/arm-smccc.h>
> @@ -132,7 +131,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	__load_guest_stage2(vcpu->arch.hw_mmu);
>  	__activate_traps(vcpu);
>  
> -	__adjust_pc(vcpu);
> +	__kvm_adjust_pc(vcpu);
>  
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
