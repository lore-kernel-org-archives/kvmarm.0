From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v5 2/8] KVM: arm/arm64: Factor out functionality to get
 vgic mmio requester_vcpu
Date: Fri, 1 Dec 2017 18:04:32 +0000
Message-ID: <aab23eee-aa3b-9349-6e78-473beeb46969@arm.com>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120191649.17290-3-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 20/11/17 19:16, Christoffer Dall wrote:
> We are about to distinguish between userspace accesses and mmio traps
> for a number of the mmio handlers.  When the requester vcpu is NULL, it
> mens we are handling a userspace acccess.
> 
> Factor out the functionality to get the request vcpu into its own
> function, mostly so we have a common place to document the semantics of
> the return value.
> 
> Also take the chance to move the functionality outside of holding a
> spinlock and instead explicitly disable and enable preemption.  This
> supports PREEMPT_RT kernels as well.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index deb51ee16a3d..6113cf850f47 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -122,6 +122,26 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +/*
> + * This function will return the VCPU that performed the MMIO access and
> + * trapped from twithin the VM, and will return NULL if this is a userspace
> + * access.
> + *
> + * We can disable preemption locally around accessing the per-CPU variable
> + * because even if the current thread is migrated to another CPU, reading the
> + * per-CPU value later will give us the same value as we update the per-CPU
> + * variable in the preempt notifier handlers.

This comment left me scratching my head a bit. Maybe you could change it
to point out that ... it's safe to *enable* preemption after the call
again, because of said reasons? Because disabling preemption before
accessing a per-CPU variable is not really an issue.

Apart from that it's fine.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> + */
> +static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	preempt_disable();
> +	vcpu = kvm_arm_get_running_vcpu();
> +	preempt_enable();
> +	return vcpu;
> +}
> +
>  void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
> @@ -184,24 +204,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				    bool new_active_state)
>  {
> -	struct kvm_vcpu *requester_vcpu;
>  	unsigned long flags;
> -	spin_lock_irqsave(&irq->irq_lock, flags);
> +	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
>  
> -	/*
> -	 * The vcpu parameter here can mean multiple things depending on how
> -	 * this function is called; when handling a trap from the kernel it
> -	 * depends on the GIC version, and these functions are also called as
> -	 * part of save/restore from userspace.
> -	 *
> -	 * Therefore, we have to figure out the requester in a reliable way.
> -	 *
> -	 * When accessing VGIC state from user space, the requester_vcpu is
> -	 * NULL, which is fine, because we guarantee that no VCPUs are running
> -	 * when accessing VGIC state from user space so irq->vcpu->cpu is
> -	 * always -1.
> -	 */
> -	requester_vcpu = kvm_arm_get_running_vcpu();
> +	spin_lock_irqsave(&irq->irq_lock, flags);
>  
>  	/*
>  	 * If this virtual IRQ was written into a list register, we
> @@ -213,6 +219,11 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
>  	 * so we release and re-acquire the spin_lock to let the other thread
>  	 * sync back the IRQ.
> +	 *
> +	 * When accessing VGIC state from user space, requester_vcpu is
> +	 * NULL, which is fine, because we guarantee that no VCPUs are running
> +	 * when accessing VGIC state from user space so irq->vcpu->cpu is
> +	 * always -1.
>  	 */
>  	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
>  	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
> 
