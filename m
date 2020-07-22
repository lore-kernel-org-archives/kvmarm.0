Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEBBC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F28342065F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F28342065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0424B294;
	Wed, 22 Jul 2020 12:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9w+FZM-2Rpyh; Wed, 22 Jul 2020 12:23:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E964B2B0;
	Wed, 22 Jul 2020 12:23:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 545B44B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:23:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LY6DVi3GNty1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:23:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0266C4B298
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:23:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F5C531B;
 Wed, 22 Jul 2020 09:23:56 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 256623F66E;
 Wed, 22 Jul 2020 09:23:54 -0700 (PDT)
Date: Wed, 22 Jul 2020 17:23:41 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: Predicate FPSIMD vcpu flags on
 feature support
Message-ID: <20200722162340.GL30452@arm.com>
References: <20200713210505.2959828-1-ascull@google.com>
 <20200713210505.2959828-3-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713210505.2959828-3-ascull@google.com>
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

On Mon, Jul 13, 2020 at 10:05:03PM +0100, Andrew Scull wrote:
> If the system doesn't support FPSIMD features then the flags must never

Mustn't they?  Why not?  I think the flags are currently ignored in this
case, which is just as good.

I'm not disagreeing with the change here; I just want to be clear on the
rationale.

> be set. These are the same feature checks performed by hyp when handling
> an FPSIMD trap.

Nit: Try to ensure that the commit message make sense even without the
subject line: i.e., the subject line is just a one-line summary of the
commit message and should not add any new information.

(This makes life easier for users of mailers that invoke an editor on
the message body only when replying -- i.e., Mutt and probably some
others.  It also helps with understanding the state in .git/rebase-apply/
during a rebase, where the subject line and the rest of the message end
up in different places.)


Also, it's worth nothing the comment additions here, since they look
substantial and it's not clear from just looking at this patch that the
new comments are just clarifying the existing behaviour.

> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/kvm/fpsimd.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 3e081d556e81..c6b3197f6754 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -52,7 +52,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>   * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
>   * The actual loading is done by the FPSIMD access trap taken to hyp.
>   *
> - * Here, we just set the correct metadata to indicate that the FPSIMD
> + * Here, we just set the correct metadata to indicate whether the FPSIMD
>   * state in the cpu regs (if any) belongs to current on the host.
>   *
>   * TIF_SVE is backed up here, since it may get clobbered with guest state.
> @@ -63,15 +63,29 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	BUG_ON(!current->mm);
>  
>  	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> +			      KVM_ARM64_FP_HOST |
>  			      KVM_ARM64_HOST_SVE_IN_USE |
>  			      KVM_ARM64_HOST_SVE_ENABLED);
> +
> +	if (!system_supports_fpsimd())
> +		return;
> +
> +	/*
> +	 * Having just come from the user task, if any FP state is loaded it
> +	 * will be that of the task. Make a note of this but, just before
> +	 * entering the vcpu, it will be double checked that the loaded FP
> +	 * state isn't transient because things could change between now and
> +	 * then.
> +	 */

Can we avoid this word "transient"?  Just because the state isn't our
state doesn't mean it will be thrown away.

If the regs contains the state for task foo, and we exit the run loop
before taking an FP trap from the guest, then we might context switch
back to foo before re-entering userspace in the KVM thread.  In that
case the regs aren't reloaded.  Unless someone called
fpsimd_flush_cpu_state() in the meantime, the regs will be assumed still
to be correctly loaded for foo.

To be clear, TIF_FOREIGN_FPSTATE doesn't mean that the regs are garbage,
just that they don't contain the right state for current.


This may not matter that much for this code, but I don't want people to
get confused when maintaining related code...


Here, does it make sense to say something like:

--8<--

Having just come from the user task, if the FP regs contain state for
current then it is definitely host user state, not vcpu state.  Note
this here, ready for the first entry to the guest.

-->8--

>  	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
>  
> -	if (test_thread_flag(TIF_SVE))
> -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> +	if (system_supports_sve()) {
> +		if (test_thread_flag(TIF_SVE))
> +			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
>  
> -	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
> +		if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> +			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
> +	}
>  }

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
