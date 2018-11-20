From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm/arm64: vgic: Do not cond_resched_lock()
 with IRQs disabled
Date: Tue, 20 Nov 2018 15:18:32 +0100
Message-ID: <20181120141832.GA11162@e113682-lin.lund.arm.com>
References: <1542647279-46609-1-git-send-email-julien.thierry@arm.com>
 <1542647279-46609-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1542647279-46609-2-git-send-email-julien.thierry@arm.com>
Sender: stable-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 19, 2018 at 05:07:56PM +0000, Julien Thierry wrote:
> To change the active state of an MMIO, halt is requested for all vcpus of
> the affected guest before modifying the IRQ state. This is done by calling
> cond_resched_lock() in vgic_mmio_change_active(). However interrupts are
> disabled at this point and running a vcpu cannot get rescheduled.

"running a vcpu cannot get rescheduled" ?

> 
> Solve this by waiting for all vcpus to be halted after emmiting the halt
> request.
> 
> Fixes commit 6c1b7521f4a07cc63bbe2dfe290efed47cdb780a ("KVM: arm/arm64:
> Factor out functionality to get vgic mmio requester_vcpu")
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: stable@vger.kernel.org
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index f56ff1c..eefd877 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -313,27 +313,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> 
>  	spin_lock_irqsave(&irq->irq_lock, flags);
> 
> -	/*
> -	 * If this virtual IRQ was written into a list register, we
> -	 * have to make sure the CPU that runs the VCPU thread has
> -	 * synced back the LR state to the struct vgic_irq.
> -	 *
> -	 * As long as the conditions below are true, we know the VCPU thread
> -	 * may be on its way back from the guest (we kicked the VCPU thread in
> -	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
> -	 * so we release and re-acquire the spin_lock to let the other thread
> -	 * sync back the IRQ.
> -	 *
> -	 * When accessing VGIC state from user space, requester_vcpu is
> -	 * NULL, which is fine, because we guarantee that no VCPUs are running
> -	 * when accessing VGIC state from user space so irq->vcpu->cpu is
> -	 * always -1.
> -	 */
> -	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> -	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
> -	       irq->vcpu->cpu != -1) /* VCPU thread is running */
> -		cond_resched_lock(&irq->irq_lock);
> -
>  	if (irq->hw) {
>  		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
>  	} else {
> @@ -368,8 +347,18 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>   */
>  static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
>  {
> -	if (intid > VGIC_NR_PRIVATE_IRQS)
> +	if (intid > VGIC_NR_PRIVATE_IRQS) {
> +		struct kvm_vcpu *tmp;
> +		int i;
> +
>  		kvm_arm_halt_guest(vcpu->kvm);
> +
> +		/* Wait for each vcpu to be halted */
> +		kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +			while (tmp->cpu != -1)
> +				cond_resched();

We used to have something like this which Andre then found out it could
deadlock the system, because the VCPU making this request wouldn't have
called kvm_arch_vcpu_put, and its cpu value would still have a value.

That's why we have the vcpu && vcpu != requester check.


Thanks,

    Christoffer
