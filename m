Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9BAC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 17:00:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6344B2065D
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 17:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6344B2065D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A014B12E;
	Tue,  7 Jul 2020 13:00:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SpU0e5GvGt8U; Tue,  7 Jul 2020 13:00:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4C24B0FE;
	Tue,  7 Jul 2020 13:00:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8509F4B0F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 13:00:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LOXjIPWhLQsT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 13:00:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C7B4B0BC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 13:00:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C4341FB;
 Tue,  7 Jul 2020 10:00:01 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC5523F68F;
 Tue,  7 Jul 2020 10:00:00 -0700 (PDT)
Date: Tue, 7 Jul 2020 17:59:58 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH] arm64: kvm: Remove redundant KVM_ARM64_FP_HOST flag
Message-ID: <20200707165958.GL10992@arm.com>
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

In general there's another case

	(d) loaded with some unrelated user task's state

I have a vague memory that the hyp trap code is supposed to save state
back to whatever task it belonged to -- but functions like
kvm_arch_vcpu_run_map_fp() make me suspicious that if this can happen,
it doesn't work correctly.

Since you're digging anyway, I'll answer in the form of a question:
when we reach __hyp_handle_fpsimd(), can the state in the FPSIMD/SVE
regs be unsaved data belonging to another task?  I'd hope not, because
fpsimd_thread_switch() should have saved any dirty regs when scheduling
that other thread out.

If the regs can't be owned by another task, then there may be some scope
for simplifying the code along the lines you suggest...

(See also below)

> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
> This is the result of trying to get my head around the FPSIMD handling.
> If I've misunderstood something I'll be very happy to have it explained
> to me :)

Er, me too.  It's a while since I worked on this ;)

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

I'm wondering whether the original code is buggy here.

If the FPSIMD/SVE regs contain some other task's data, we'd overwrite
current's regs with that data when running __hyp_handle_fpsimd().

Maybe we should have been checking TIF_FOREIGN_FPSTATE here.  If the
issue can happen, your version may fix it.

If we wanted to keep the separate flag (see below for some rationale),
it might make sense to do:

  	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
  			      KVM_ARM64_HOST_SVE_IN_USE |
  			      KVM_ARM64_HOST_SVE_ENABLED |
			      KVM_ARM64_FP_HOST);
	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
		vcpu->arch.flags |= KVM_ARM64_FP_HOST;

[...]

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

Without this, there is no record that we did anything.  Are you sure we
can't save junk data into the host context the next time we take this
trap?  Will we re-enable the trap unnecessarily?


I think previously I was trying to avoid things like
test_and_clear_thread_flag() here because there were limitations on what
we could call from the hyp code.  Maybe that's not such an issue now.

I'm slightly uneasy about setting TIF_FOREIGN_FPSTATE from the hyp
switch code however.  The order in which this flag is touched with
respect to other metadata is important in preemptible code, so I
preferred to avoid bare writing of this thread flag: rather it should
be set and cleared through the fpsimd_bind_*() and fpsimd_flush_*()
functions if at all possible, but these didn't seem suitable for calling
from hyp at the time.

In the hyp code we are of course not preemptible, so we would probably
get away with a bare set_thread_flag() in practice.

Overall, it felt a bit cleaner to have separate metdata for the hyp
code, and sync it with the host's metadata in clearly defined places
(the functions in arch/arm64/kvm/fpsimd.c).  KVM_ARM64_FP_HOST plays
that role for the hyp code at present.

That doesn't mean I wouldn't welcome a simplification, though!

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
