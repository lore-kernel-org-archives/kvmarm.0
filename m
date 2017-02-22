From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 25/55] KVM: arm/arm64: Let vcpu thread modify its own
 active state
Date: Wed, 22 Feb 2017 13:27:14 +0100
Message-ID: <20170222122714.GN26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-26-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483943091-1364-26-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:21AM -0500, Jintack Lim wrote:
> Currently, if a vcpu thread tries to change its own active state when
> the irq is already in AP list, it'll loop forever. Since the VCPU thread
> has already synced back LR state to the struct vgic_irq, let it modify
> its own state safely.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index ebe1b9f..049c570 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -192,9 +192,9 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	 * If this virtual IRQ was written into a list register, we
>  	 * have to make sure the CPU that runs the VCPU thread has
>  	 * synced back LR state to the struct vgic_irq.  We can only
> -	 * know this for sure, when either this irq is not assigned to
> +	 * know this for sure, when this irq is not assigned to
>  	 * anyone's AP list anymore, or the VCPU thread is not
> -	 * running on any CPUs.
> +	 * running on any CPUs, or current thread is the VCPU thread.
>  	 *
>  	 * In the opposite case, we know the VCPU thread may be on its
>  	 * way back from the guest and still has to sync back this
> @@ -202,6 +202,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	 * other thread sync back the IRQ.
>  	 */
>  	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> +	       irq->vcpu != vcpu && /* Current thread is not the VCPU thread */
>  	       irq->vcpu->cpu != -1) /* VCPU thread is running */
>  		cond_resched_lock(&irq->irq_lock);
>  
> -- 
> 1.9.1
> 
> 

This seems to be an independent fix, so please send it outside of this
series as an individual patch.

Thanks,
-Christoffer
