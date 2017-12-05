From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v6 2/8] KVM: arm/arm64: Factor out functionality to get
 vgic mmio requester_vcpu
Date: Tue, 5 Dec 2017 16:46:08 +0300
Message-ID: <20171205134608.msg6wvh7px273mud@yury-thinkpad>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-3-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 601B549D4F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 08:43:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NlINxvkcmgD4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Dec 2017 08:43:26 -0500 (EST)
Received: from NAM03-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam03on0045.outbound.protection.outlook.com [104.47.42.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0C8F40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 08:43:25 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171204200506.3224-3-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@kernel.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 09:05:00PM +0100, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> We are about to distinguish between userspace accesses and mmio traps
> for a number of the mmio handlers.  When the requester vcpu is NULL, it
> mens we are handling a userspace acccess.

Typo: means?

> Factor out the functionality to get the request vcpu into its own
> function, mostly so we have a common place to document the semantics of
> the return value.
> 
> Also take the chance to move the functionality outside of holding a
> spinlock and instead explicitly disable and enable preemption.  This
> supports PREEMPT_RT kernels as well.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 44 +++++++++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index deb51ee16a3d..747b0a3b4784 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -122,6 +122,27 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +/*
> + * This function will return the VCPU that performed the MMIO access and
> + * trapped from twithin the VM, and will return NULL if this is a userspace

Typo: from within?

> + * access.
> + *
> + * We can disable preemption locally around accessing the per-CPU variable,
> + * and use the resolved vcpu pointer after enabling preemption again, because
> + * even if the current thread is migrated to another CPU, reading the per-CPU
> + * value later will give us the same value as we update the per-CPU variable
> + * in the preempt notifier handlers.
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
> @@ -184,24 +205,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
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
> @@ -213,6 +220,11 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
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
> -- 
> 2.14.2
