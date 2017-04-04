From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 18:04:17 +0200
Message-ID: <20170404160417.GN11752@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2C840A14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 12:02:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h0+jDRgapGIC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 12:02:03 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 289A640017
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 12:02:03 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id t189so32271228wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 09:04:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170331160658.4331-5-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 31, 2017 at 06:06:53PM +0200, Andrew Jones wrote:
> This not only ensures visibility of changes to pause by using
> atomic ops, but also plugs a small race where a vcpu could get its
> pause state enabled just after its last check before entering the
> guest. With this patch, while the vcpu will still initially enter
> the guest, it will exit immediately due to the IPI sent by the vcpu
> kick issued after making the vcpu request.
> 
> We use bitops, rather than kvm_make/check_request(), because we
> don't need the barriers they provide,

why not?

> nor do we want the side-effect
> of kvm_check_request() clearing the request. For pause, only the
> requester should do the clearing.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  5 +----
>  arch/arm/kvm/arm.c                | 45 +++++++++++++++++++++++++++------------
>  arch/arm64/include/asm/kvm_host.h |  5 +----
>  3 files changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 31ee468ce667..52c25536d254 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -45,7 +45,7 @@
>  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
>  #endif
>  
> -#define KVM_REQ_VCPU_EXIT	8
> +#define KVM_REQ_PAUSE		8
>  
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
> @@ -173,9 +173,6 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> -	 /* Don't run the guest (internal implementation need) */
> -	bool pause;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 314eb6abe1ff..f3bfbb5f3d96 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -94,6 +94,18 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
>  
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * If we return true from this function, then it means the vcpu is
> +	 * either in guest mode, or has already indicated that it's in guest
> +	 * mode. The indication is done by setting ->mode to IN_GUEST_MODE,
> +	 * and must be done before the final kvm_request_pending() read. It's
> +	 * important that the observability of that order be enforced and that
> +	 * the request receiving CPU can observe any new request before the
> +	 * requester issues a kick. Thus, the general barrier below pairs with
> +	 * the general barrier in kvm_arch_vcpu_ioctl_run() which divides the
> +	 * write to ->mode and the final request pending read.
> +	 */

I am having a hard time understanding this comment.  For example, I
don't understand the difference between 'is either in guest mode or has
already indicated it's in guest mode'.  Which case is which again, and
how are we checking for two cases below?

Also, the stuff about observability of an order is hard to follow, and
the comment assumes the reader is thinking about the specific race when
entering the guest.

I think we should focus on getting the documentation in place, refer to
the documentation from here, and be much more brief and say something
like:

	/*
	 * The memory barrier below pairs with the barrier in
	 * kvm_arch_vcpu_ioctl_run() between writes to vcpu->mode
	 * and reading vcpu->requests before entering the guest.
	 *
	 * Ensures that the VCPU thread's CPU can observe changes to
	 * vcpu->requests written prior to calling this function before
	 * it writes vcpu->mode = IN_GUEST_MODE, and correspondingly
	 * ensures that this CPU observes vcpu->mode == IN_GUEST_MODE
	 * only if the VCPU thread's CPU could observe writes to
	 * vcpu->requests from this CPU.
	 /

Is this correct?  I'm not really sure anymore?

There's also the obvious fact that we're adding this memory barrier
inside a funciton that checks if we should kick a vcpu, and there's no
documentation that says that this is always called in association with
setting a request, is there?

I finally don't undertand why this would be a requirement only on ARM?

> +	smp_mb();
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
>  
> @@ -404,7 +416,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off && !v->arch.pause);
> +		&& !v->arch.power_off
> +		&& !test_bit(KVM_REQ_PAUSE, &v->requests));
>  }
>  
>  /* Just ensure a guest exit from a particular CPU */
> @@ -535,17 +548,12 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
>  
>  void kvm_arm_halt_guest(struct kvm *kvm)
>  {
> -	int i;
> -	struct kvm_vcpu *vcpu;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		vcpu->arch.pause = true;
> -	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_PAUSE);
>  }
>  
>  void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->arch.pause = true;
> +	set_bit(KVM_REQ_PAUSE, &vcpu->requests);
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> @@ -553,7 +561,7 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	vcpu->arch.pause = false;
> +	clear_bit(KVM_REQ_PAUSE, &vcpu->requests);
>  	swake_up(wq);
>  }
>  
> @@ -571,7 +579,7 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
>  	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +		(!test_bit(KVM_REQ_PAUSE, &vcpu->requests))));
>  }
>  
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> @@ -624,7 +632,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off || vcpu->arch.pause)
> +		if (vcpu->arch.power_off || test_bit(KVM_REQ_PAUSE, &vcpu->requests))
>  			vcpu_sleep(vcpu);
>  
>  		/*
> @@ -647,8 +655,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			run->exit_reason = KVM_EXIT_INTR;
>  		}
>  
> +		/*
> +		 * Indicate we're in guest mode now, before doing a final
> +		 * check for pending vcpu requests. The general barrier
> +		 * pairs with the one in kvm_arch_vcpu_should_kick().
> +		 * Please see the comment there for more details.
> +		 */
> +		WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);
> +		smp_mb();

There are two changes here:

there's a change from a normal write to a WRITE_ONCE and there's also a
change to that adds a memory barrier.  I feel like I'd like to know if
these are tied together or two separate cleanups.  I also wonder if we
could split out more general changes from the pause thing to have a
better log of why we changed the run loop?

It looks to me like there could be a separate patch that encapsulated
the reads and writes of vcpu->mode into a function that does the
WRITE_ONCE and READ_ONCE with a nice comment.

> +
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> -			vcpu->arch.power_off || vcpu->arch.pause) {
> +			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
> +			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
>  			local_irq_enable();
>  			kvm_pmu_sync_hwstate(vcpu);
>  			kvm_timer_sync_hwstate(vcpu);
> @@ -664,11 +682,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_enter_irqoff();
> -		vcpu->mode = IN_GUEST_MODE;
>  
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
> -		vcpu->mode = OUTSIDE_GUEST_MODE;
> +		WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
>  		vcpu->stat.exits++;
>  		/*
>  		 * Back from guest
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e7705e7bb07b..6e1271a77e92 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -42,7 +42,7 @@
>  
>  #define KVM_VCPU_MAX_FEATURES 4
>  
> -#define KVM_REQ_VCPU_EXIT	8
> +#define KVM_REQ_PAUSE		8
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> @@ -256,9 +256,6 @@ struct kvm_vcpu_arch {
>  	/* vcpu power-off state */
>  	bool power_off;
>  
> -	/* Don't run the guest (internal implementation need) */
> -	bool pause;
> -
>  	/* IO related fields */
>  	struct kvm_decode mmio_decode;
>  
> -- 
> 2.9.3

Thanks,
-Christoffer
