From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 09/10] KVM: arm/arm64: use vcpu requests for irq
 injection
Date: Sat, 6 May 2017 20:51:00 +0200
Message-ID: <20170506185100.GF5923@cbox>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-10-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503160635.21669-10-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Wed, May 03, 2017 at 06:06:34PM +0200, Andrew Jones wrote:
> Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
> kick meant to trigger the interrupt injection could be sent while
> the VCPU is outside guest mode, which means no IPI is sent, and
> after it has called kvm_vgic_flush_hwstate(), meaning it won't see
> the updated GIC state until its next exit some time later for some
> other reason.  The receiving VCPU only needs to check this request
> in VCPU RUN to handle it.  By checking it, if it's pending, a
> memory barrier will be issued that ensures all state is visible.
> We still create a vcpu_req_irq_pending() function (which is a nop),
> though, in order to allow us to use the standard request checking
> pattern.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  1 +
>  arch/arm/kvm/arm.c                | 12 ++++++++++++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  virt/kvm/arm/arch_timer.c         |  1 +
>  virt/kvm/arm/vgic/vgic.c          |  9 +++++++--
>  5 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 41669578b3df..7bf90aaf2e87 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -47,6 +47,7 @@
>  
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
> +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>  
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d62e99885434..330064475914 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -581,6 +581,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>  				       (!vcpu->arch.pause)));
>  }
>  
> +static void vcpu_req_irq_pending(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Nothing to do here. kvm_check_request() already issued a memory
> +	 * barrier that pairs with kvm_make_request(), so all hardware state
> +	 * we need to flush should now be visible.
> +	 */
> +}
> +
>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.target >= 0;
> @@ -634,6 +643,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (kvm_request_pending(vcpu)) {
>  			if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
>  				vcpu_req_sleep(vcpu);
> +			if (kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu))
> +				vcpu_req_irq_pending(vcpu);
>  		}
>  
>  		/*
> @@ -777,6 +788,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>  	 * trigger a world-switch round on the running physical CPU to set the
>  	 * virtual IRQ/FIQ fields in the HCR appropriately.
>  	 */
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  	kvm_vcpu_kick(vcpu);
>  
>  	return 0;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 04c0f9d37386..2c33fef945fe 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -44,6 +44,7 @@
>  
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
> +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 5976609ef27c..469b43315c0a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -95,6 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	 * If the vcpu is blocked we want to wake it up so that it will see
>  	 * the timer has expired when entering the guest.
>  	 */
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  	kvm_vcpu_kick(vcpu);

So I think we just call kvm_vcpu_kick() because it calls
kvm_vcpu_wake_up().  If we have this timer work happening, it means that
the VCPU is blocked, and there won't be a race with executing in the run
loop, right?

So maybe we should just change this kvm_vcpu_kick() to a direct call to
kvm_vcpu_wake_up() to avoid having a request-less kick.

Note that your change will still work, I just think it's unnecessary.

Thanks,
-Christoffer

>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 3d0979c30721..bdd4b3a953b5 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -283,8 +283,10 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
>  		 * won't see this one until it exits for some other
>  		 * reason.
>  		 */
> -		if (vcpu)
> +		if (vcpu) {
> +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  			kvm_vcpu_kick(vcpu);
> +		}
>  		return false;
>  	}
>  
> @@ -330,6 +332,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
>  	spin_unlock(&irq->irq_lock);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  	kvm_vcpu_kick(vcpu);
>  
>  	return true;
> @@ -719,8 +722,10 @@ void vgic_kick_vcpus(struct kvm *kvm)
>  	 * a good kick...
>  	 */
>  	kvm_for_each_vcpu(c, vcpu, kvm) {
> -		if (kvm_vgic_vcpu_pending_irq(vcpu))
> +		if (kvm_vgic_vcpu_pending_irq(vcpu)) {
> +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  			kvm_vcpu_kick(vcpu);
> +		}
>  	}
>  }
>  
> -- 
> 2.9.3
> 
