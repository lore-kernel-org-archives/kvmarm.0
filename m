From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 1/4] KVM: arm/arm64: vgic: Do not cond_resched_lock()
 with IRQs disabled
Date: Tue, 11 Dec 2018 11:20:15 +0100
Message-ID: <20181211102015.GV30263@e113682-lin.lund.arm.com>
References: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
 <1543256807-9768-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7844E4A348
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 05:20:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mCQVz5rigFkC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 05:20:18 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6094A341
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 05:20:18 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1543256807-9768-2-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-rt-users@vger.kernel.org, marc.zyngier@arm.com, bigeasy@linutronix.de, linux-kernel@vger.kernel.org, rostedt@goodmis.org, stable@vger.kernel.org, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 26, 2018 at 06:26:44PM +0000, Julien Thierry wrote:
> To change the active state of an MMIO, halt is requested for all vcpus of
> the affected guest before modifying the IRQ state. This is done by calling
> cond_resched_lock() in vgic_mmio_change_active(). However interrupts are
> disabled at this point and we cannot reschedule a vcpu.
> 
> Solve this by waiting for all vcpus to be halted after emmiting the halt
> request.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: stable@vger.kernel.org
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 36 ++++++++++++++----------------------
>  1 file changed, 14 insertions(+), 22 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index f56ff1c..5c76a92 100644
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
> @@ -368,8 +347,21 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
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
> +			if (tmp == vcpu)
> +				continue;
> +
> +			while (tmp->cpu != -1)
> +				cond_resched();
> +		}

I'm actually thinking we don't need this loop at all after the requet
rework which causes:

 1. kvm_arm_halt_guest() to use kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP), and
 2. KVM_REQ_SLEEP uses REQ_WAIT, and
 3. REQ_WAIT requires the VCPU to respond to IPIs before returning, and
 4. a VCPU thread can only respond when it enables interrupt, and
 5. enabling interrupts when running a VCPU only happens after syncing
    the VGIC hwstate.

Does that make sense?

It would be good if someone can validate this, but if it holds this
patch just becomes a nice deletion of the logic in
vgic-mmio_change_active.


Thanks,

    Christoffer
