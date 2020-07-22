Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08689C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C8B02065F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C8B02065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBC94B294;
	Wed, 22 Jul 2020 12:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MCaumexnOsE2; Wed, 22 Jul 2020 12:24:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AB64B2AE;
	Wed, 22 Jul 2020 12:24:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F2D4B294
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id khTFeV4DrT7A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:24:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA654B296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1797431B;
 Wed, 22 Jul 2020 09:24:12 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 609BD3F66E;
 Wed, 22 Jul 2020 09:24:11 -0700 (PDT)
Date: Wed, 22 Jul 2020 17:24:08 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Leave vcpu FPSIMD synchronization in
 host
Message-ID: <20200722162407.GM30452@arm.com>
References: <20200713210505.2959828-1-ascull@google.com>
 <20200713210505.2959828-4-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713210505.2959828-4-ascull@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 13, 2020 at 10:05:04PM +0100, Andrew Scull wrote:

vv Nit: Message body doesn't say what changed _or_ why.  See comments on
patch 2.

> The task state can be checked by the host and the vcpu flags updated
> before calling into hyp. Hyp simply acts on the state provided to it by
> the host and updates it when switching to the vcpu state.

It would be useful here to explain the renaming of
kvm_arch_vcpu_ctxsync_fp().

> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  3 ++-
>  arch/arm64/kvm/arm.c                    |  4 +++-
>  arch/arm64/kvm/fpsimd.c                 | 19 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 -------------------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +--
>  arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
>  6 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b06f24b5f443..1a062d44b395 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -616,7 +616,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> -void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_sync_fp_before_run(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_sync_fp_after_run(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 98f05bdac3c1..c91b0a66bf20 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -682,6 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  		local_irq_disable();
>  
> +		kvm_arch_vcpu_sync_fp_before_run(vcpu);
> +
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		/*
> @@ -769,7 +771,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (static_branch_unlikely(&userspace_irqchip_in_use))
>  			kvm_timer_sync_user(vcpu);
>  
> -		kvm_arch_vcpu_ctxsync_fp(vcpu);
> +		kvm_arch_vcpu_sync_fp_after_run(vcpu);
>  
>  		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index c6b3197f6754..2779cc11f3dd 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -88,13 +88,30 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +void kvm_arch_vcpu_sync_fp_before_run(struct kvm_vcpu *vcpu)
> +{
> +	WARN_ON_ONCE(!irqs_disabled());
> +
> +	if (!system_supports_fpsimd())
> +		return;
> +
> +	/*
> +	 * If the CPU's FP state is transient, there is no need to save the

See comments on patch 2 regarding "transient".

Beyond not needing to save the state, we must not even attempt to do so.

> +	 * current state. Without further information, it must also be assumed
> +	 * that the vcpu's state is not loaded.
> +	 */
> +	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> +		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> +				      KVM_ARM64_FP_HOST);
> +}
> +
>  /*
>   * If the guest FPSIMD state was loaded, update the host's context
>   * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
>   * so that they will be written back if the kernel clobbers them due to
>   * kernel-mode NEON before re-entry into the guest.
>   */
> -void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> +void kvm_arch_vcpu_sync_fp_after_run(struct kvm_vcpu *vcpu)
>  {
>  	WARN_ON_ONCE(!irqs_disabled());
>  
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 0511af14dc81..65cde758abad 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -25,28 +25,9 @@
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/processor.h>
> -#include <asm/thread_info.h>
>  
>  extern const char __hyp_panic_string[];
>  
> -/* Check whether the FP regs were dirtied while in the host-side run loop: */
> -static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * When the system doesn't support FP/SIMD, we cannot rely on
> -	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
> -	 * abort on the very first access to FP and thus we should never
> -	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
> -	 * trap the accesses.
> -	 */
> -	if (!system_supports_fpsimd() ||
> -	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
> -		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> -				      KVM_ARM64_FP_HOST);
> -
> -	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
> -}
> -
>  /* Save the 32-bit only FPSIMD system register state */
>  static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 341be2f2f312..3b7306003917 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -25,7 +25,6 @@
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/processor.h>
> -#include <asm/thread_info.h>
>  
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
> @@ -36,7 +35,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
> -	if (!update_fp_enabled(vcpu)) {
> +	if (!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED)) {
>  		val |= CPTR_EL2_TFP;
>  		__activate_traps_fpsimd32(vcpu);
>  	}
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index c52d714e0d75..0c08c9123ce5 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -24,7 +24,6 @@
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/processor.h>
> -#include <asm/thread_info.h>
>  
>  const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>  
> @@ -49,7 +48,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  
>  	val |= CPTR_EL2_TAM;
>  
> -	if (update_fp_enabled(vcpu)) {
> +	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
>  		if (vcpu_has_sve(vcpu))
>  			val |= CPACR_EL1_ZEN;

Looks reasonable otherwise.

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
