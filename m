From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 19/20] KVM: arm/arm64: Get rid of kvm_timer_flush_hwstate
Date: Tue, 10 Oct 2017 10:46:58 +0100
Message-ID: <871smbwd0t.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-20-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-20-cdall@linaro.org> (Christoffer Dall's
        message of "Sat, 23 Sep 2017 02:42:06 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:06 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> Now when both the vtimer and the ptimer when using both the in-kernel
> vgic emulation and a userspace IRQ chip are driven by the timer signals
> and at the vcpu load/put boundaries, instead of recomputing the timer
> state at every entry/exit to/from the guest, we can get entirely rid of
> the flush hwstate function.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  include/kvm/arm_arch_timer.h |  1 -
>  virt/kvm/arm/arch_timer.c    | 24 ------------------------
>  virt/kvm/arm/arm.c           |  1 -
>  3 files changed, 26 deletions(-)
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 8e5ed54..af29563 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -61,7 +61,6 @@ int kvm_timer_hyp_init(void);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
>  void kvm_timer_update_run(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index aa18a5d..f92459a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -302,12 +302,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> -	/*
> -	 * If userspace modified the timer registers via SET_ONE_REG before
> -	 * the vgic was initialized, we mustn't set the vtimer->irq.level value
> -	 * because the guest would never see the interrupt.  Instead wait
> -	 * until we call this function from kvm_timer_flush_hwstate.
> -	 */
>  	if (unlikely(!timer->enabled))
>  		return;
>  
> @@ -493,24 +487,6 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
>  	       ptimer->irq.level != plevel;
>  }
>  
> -/**
> - * kvm_timer_flush_hwstate - prepare timers before running the vcpu
> - * @vcpu: The vcpu pointer
> - *
> - * Check if the virtual timer has expired while we were running in the host,
> - * and inject an interrupt if that was the case, making sure the timer is
> - * masked or disabled on the host so that we keep executing.  Also schedule a
> - * software timer for the physical timer if it is enabled.
> - */
> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> -{
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> -
> -	if (unlikely(!timer->enabled))
> -		return;
> -}
> -
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 132d39a..14c50d1 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -656,7 +656,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		local_irq_disable();
>  
> -		kvm_timer_flush_hwstate(vcpu);
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		/*

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
