Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1411C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 646AE2065F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 646AE2065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5504B2A0;
	Wed, 22 Jul 2020 12:24:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vtXy7watoJIH; Wed, 22 Jul 2020 12:24:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC244B2AF;
	Wed, 22 Jul 2020 12:24:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35ECF4B297
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+8mWCUiJ6Wv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:24:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E490A4B294
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98DC931B;
 Wed, 22 Jul 2020 09:24:26 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA49A3F66E;
 Wed, 22 Jul 2020 09:24:25 -0700 (PDT)
Date: Wed, 22 Jul 2020 17:24:23 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates
 to the host
Message-ID: <20200722162423.GO30452@arm.com>
References: <20200713210505.2959828-1-ascull@google.com>
 <20200713210505.2959828-2-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713210505.2959828-2-ascull@google.com>
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

On Mon, Jul 13, 2020 at 10:05:02PM +0100, Andrew Scull wrote:
> Move the clearing of KVM_ARM64_DEBUG_DIRTY from being one of the last
> things hyp does before exiting to the host to being one of the first
> things the host does after hyp exits.
> 
> This means the host always manages the state of the bit and hyp simply
> respects that in the context switch.
> 
> No functional change.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>

Seems reasonable, though we have to map the vcpu arch flags into hyp
anyway.  For FPSIMD we do maintain these flags from hyp, in order to
void mapping in host-specific stuff (the thread flags).

So maybe this change isn't that useful?

I don't have a strong opinion though.  If this change fits in better
with the broader KVM work you're doing, I don't see a problem with it.

So, FWIW:

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h         | 2 +-
>  arch/arm64/kvm/debug.c                    | 2 ++
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 2 --
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e1a32c0707bb..b06f24b5f443 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -404,7 +404,7 @@ struct kvm_vcpu_arch {
>  })
>  
>  /* vcpu_arch flags field values: */
> -#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
> +#define KVM_ARM64_DEBUG_DIRTY		(1 << 0) /* vcpu is using debug */
>  #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
>  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
>  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 7a7e425616b5..e9932618a362 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -209,6 +209,8 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
>  	trace_kvm_arm_clear_debug(vcpu->guest_debug);
>  
> +	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
> +
>  	if (vcpu->guest_debug) {
>  		restore_guest_debug_regs(vcpu);
>  
> diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> index 0297dc63988c..50ca5d048017 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> @@ -161,8 +161,6 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
>  
>  	__debug_save_state(guest_dbg, guest_ctxt);
>  	__debug_restore_state(host_dbg, host_ctxt);
> -
> -	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
>  }
>  
>  #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
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
