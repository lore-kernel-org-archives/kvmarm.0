From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/9] KVM: arm/arm64: use a vcpu request on irq
 injection
Date: Tue, 4 Apr 2017 20:51:35 +0200
Message-ID: <91d64993-0261-52ec-4d06-8aac4425ddd7@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-7-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170331160658.4331-7-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 31/03/2017 18:06, Andrew Jones wrote:
> Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
> kick meant to trigger the interrupt injection could be sent while
> the VCPU is outside guest mode, which means no IPI is sent, and
> after it has called kvm_vgic_flush_hwstate(), meaning it won't see
> the updated GIC state until its next exit some time later for some
> other reason.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  1 +
>  arch/arm/kvm/arm.c                |  1 +
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  virt/kvm/arm/arch_timer.c         |  1 +
>  virt/kvm/arm/vgic/vgic.c          | 12 ++++++++++--
>  5 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index afed5d44634d..0b8a6d6b3cb3 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -47,6 +47,7 @@
>  
>  #define KVM_REQ_PAUSE		8
>  #define KVM_REQ_POWER_OFF	9
> +#define KVM_REQ_IRQ_PENDING	10
>  
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 7ed39060b1cf..a106feccf314 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -768,6 +768,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>  	 * trigger a world-switch round on the running physical CPU to set the
>  	 * virtual IRQ/FIQ fields in the HCR appropriately.
>  	 */
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  	kvm_vcpu_kick(vcpu);
>  
>  	return 0;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e78895f675d0..7057512b3474 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -44,6 +44,7 @@
>  
>  #define KVM_REQ_PAUSE		8
>  #define KVM_REQ_POWER_OFF	9
> +#define KVM_REQ_IRQ_PENDING	10
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 35d7100e0815..3c48abbf951b 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -95,6 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	 * If the vcpu is blocked we want to wake it up so that it will see
>  	 * the timer has expired when entering the guest.
>  	 */
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 654dfd40e449..31fb89057f0c 100644
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
> @@ -654,6 +657,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  	vgic_flush_lr_state(vcpu);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +
> +	/* The GIC is now ready to deliver the IRQ. */
> +	clear_bit(KVM_REQ_IRQ_PENDING, &vcpu->requests);
>  }
>  
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> @@ -691,8 +697,10 @@ void vgic_kick_vcpus(struct kvm *kvm)
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
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
