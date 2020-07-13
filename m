Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A90BC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 15:40:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB71D20771
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 15:40:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB71D20771
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174E94B260;
	Mon, 13 Jul 2020 11:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YvDSm5aUKw5V; Mon, 13 Jul 2020 11:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8DEC4B26F;
	Mon, 13 Jul 2020 11:40:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D40AB4B226
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 11:40:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fQHvxgkLBvuA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 11:40:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10DDC4B1F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 11:40:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45AA41FB;
 Mon, 13 Jul 2020 08:40:05 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F55B3F7BB;
 Mon, 13 Jul 2020 08:40:04 -0700 (PDT)
Date: Mon, 13 Jul 2020 16:40:02 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH] arm64: kvm: Remove redundant KVM_ARM64_FP_HOST flag
Message-ID: <20200713154002.GR10992@arm.com>
References: <20200707145713.287710-1-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200707145713.287710-1-ascull@google.com>
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

On Tue, Jul 07, 2020 at 03:57:13PM +0100, Andrew Scull wrote:
> The FPSIMD registers can be in one of three states:
>  (a) loaded with the user task's state
>  (b) loaded with the vcpu's state
>  (c) dirty with transient state
> 
> KVM_ARM64_FP_HOST identifies the case (a). When loading the vcpu state,
> this is used to decide whether to save the current FPSIMD registers to
> the user task.
> 
> However, at the point of loading the vcpu's FPSIMD state, it is known
> that we are not in state (b). States (a) and (c) can be distinguished by
> by checking the TIF_FOREIGN_FPSTATE bit, as was previously being done to
> prepare the KVM_ARM64_FP_HOST flag but without the need for mirroring
> the state.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>

Is your new series [1] intended to replace this, or do I need to look at
both series now?

Cheers
---Dave

[1] Manage vcpu flags from the host
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-July/041531.html

> ---
> This is the result of trying to get my head around the FPSIMD handling.
> If I've misunderstood something I'll be very happy to have it explained
> to me :)
> ---
>  arch/arm64/include/asm/kvm_host.h       | 11 +++++----
>  arch/arm64/kvm/fpsimd.c                 |  1 -
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 30 +++++++++++++++++--------
>  3 files changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e0920df1d0c1..d3652745282d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -370,12 +370,11 @@ struct kvm_vcpu_arch {
>  /* vcpu_arch flags field values: */
>  #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
>  #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
> -#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
> -#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
> -#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> -#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> -#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> -#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
> +#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 2) /* backup for host TIF_SVE */
> +#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 3) /* SVE enabled for EL0 */
> +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 4) /* SVE exposed to guest */
> +#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 5) /* SVE config completed */
> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 6) /* PTRAUTH exposed to guest */
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index e329a36b2bee..4e9afeb31989 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -65,7 +65,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
>  			      KVM_ARM64_HOST_SVE_IN_USE |
>  			      KVM_ARM64_HOST_SVE_ENABLED);
> -	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
>  
>  	if (test_thread_flag(TIF_SVE))
>  		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8f622688fa64..beadf17f12a6 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -33,16 +33,24 @@ extern const char __hyp_panic_string[];
>  static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
>  {
>  	/*
> -	 * When the system doesn't support FP/SIMD, we cannot rely on
> -	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
> -	 * abort on the very first access to FP and thus we should never
> -	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
> +	 * When entering the vcpu during a KVM_VCPU_RUN call before the vcpu
> +	 * has used FPSIMD, FPSIMD is disabled for the vcpu and will trap when
> +	 * it is first used. The FPSIMD state currently bound to the cpu is
> +	 * that of the user task.
> +	 *
> +	 * After the vcpu has used FPSIMD, on subsequent entries into the vcpu
> +	 * for the same KVM_VCPU_RUN call, the vcpu's FPSIMD state is bound to
> +	 * the cpu. Therefore, if _TIF_FOREIGN_FPSTATE is set, we know the
> +	 * FPSIMD registers no longer contain the vcpu's state. In this case we
> +	 * must, once again, disable FPSIMD.
> +	 *
> +	 * When the system doesn't support FPSIMD, we cannot rely on the
> +	 * _TIF_FOREIGN_FPSTATE flag. For added safety, make sure we always
>  	 * trap the accesses.
>  	 */
>  	if (!system_supports_fpsimd() ||
>  	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
> -		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> -				      KVM_ARM64_FP_HOST);
> +		vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
>  
>  	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
>  }
> @@ -245,7 +253,13 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  
>  	isb();
>  
> -	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
> +	/*
> +	 * The trap means that the vcpu's FPSIMD state is not loaded. If
> +	 * _TIF_FOREIGN_FPSTATE is set, the current state does not need to be
> +	 * saved. Otherwise, the user task's state is currently loaded and
> +	 * needs to be saved.
> +	 */
> +	if (!(vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)) {
>  		/*
>  		 * In the SVE case, VHE is assumed: it is enforced by
>  		 * Kconfig and kvm_arch_init().
> @@ -260,8 +274,6 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  		} else {
>  			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
>  		}
> -
> -		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
>  	}
>  
>  	if (sve_guest) {
> -- 
> 2.27.0.383.g050319c2ae-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
