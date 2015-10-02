From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 8/8] arm/arm64: KVM: Support edge-triggered forwarded
 interrupts
Date: Fri, 2 Oct 2015 18:18:03 +0100
Message-ID: <560EBC4B.3050706@arm.com>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-9-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06467410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 13:15:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YCXZ+33C9aez for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 13:15:17 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 987F0410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 13:15:17 -0400 (EDT)
In-Reply-To: <1443538145-11990-9-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/09/15 15:49, Christoffer Dall wrote:
> We mark edge-triggered interrupts with the HW bit set as queued to
> prevent the VGIC code from injecting LRs with both the Active and
> Pending bits set at the same time while also setting the HW bit,
> because the hardware does not support this.
> 
> However, this means that we must also clear the queued flag when we sync
> back a LR where the state on the physical distributor went from active
> to inactive because the guest deactivated the interrupt.  At this point
> we must also check if the interrupt is pending on the distributor, and
> tell the VGIC to queue it again if it is.
> 
> Since these actions on the sync path are extremely close to those for
> level-triggered interrupts, rename process_level_irq to
> process_queued_irq, allowing it to cater for both cases.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>


> ---
>  virt/kvm/arm/vgic.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 53548f1..f3e76e5 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1322,13 +1322,10 @@ epilog:
>  	}
>  }
>  
> -static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> +static int process_queued_irq(struct kvm_vcpu *vcpu,
> +				   int lr, struct vgic_lr vlr)
>  {
> -	int level_pending = 0;
> -
> -	vlr.state = 0;
> -	vlr.hwirq = 0;
> -	vgic_set_lr(vcpu, lr, vlr);
> +	int pending = 0;

As I mentioned in my reply to 3/8 already: shouldn't this be "bool"?

>  
>  	/*
>  	 * If the IRQ was EOIed (called from vgic_process_maintenance) or it
> @@ -1344,26 +1341,35 @@ static int process_level_irq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  	vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
>  
>  	/*
> -	 * Tell the gic to start sampling the line of this interrupt again.
> +	 * Tell the gic to start sampling this interrupt again.
>  	 */
>  	vgic_irq_clear_queued(vcpu, vlr.irq);
>  
>  	/* Any additional pending interrupt? */
> -	if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
> -		vgic_cpu_irq_set(vcpu, vlr.irq);
> -		level_pending = 1;
> +	if (vgic_irq_is_edge(vcpu, vlr.irq)) {
> +		BUG_ON(!(vlr.state & LR_HW));

Is that really needed here? I don't see how this function would fail if
called on a non-mapped IRQ. Also the two current callers would always
fulfil this requirement:
- vgic_process_maintenance() already has a WARN_ON(vgic_irq_is_edge)
- vgic_sync_irq() returns early if it's not a mapped IRQ

Removing this would also allow to pass "int irq" instead of "struct
vgic_lr vlr".

Just an idea, though and not a show-stopper.

Other than that it looks good to me.

Cheers,
Andre.

> +		pending = vgic_dist_irq_is_pending(vcpu, vlr.irq);
>  	} else {
> -		vgic_dist_irq_clear_pending(vcpu, vlr.irq);
> -		vgic_cpu_irq_clear(vcpu, vlr.irq);
> +		if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
> +			vgic_cpu_irq_set(vcpu, vlr.irq);
> +			pending = 1;
> +		} else {
> +			vgic_dist_irq_clear_pending(vcpu, vlr.irq);
> +			vgic_cpu_irq_clear(vcpu, vlr.irq);
> +		}
>  	}
>  
>  	/*
>  	 * Despite being EOIed, the LR may not have
>  	 * been marked as empty.
>  	 */
> +	vlr.state = 0;
> +	vlr.hwirq = 0;
> +	vgic_set_lr(vcpu, lr, vlr);
> +
>  	vgic_sync_lr_elrsr(vcpu, lr, vlr);
>  
> -	return level_pending;
> +	return pending;
>  }
>  
>  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> @@ -1400,7 +1406,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  					     vlr.irq - VGIC_NR_PRIVATE_IRQS);
>  
>  			spin_lock(&dist->lock);
> -			level_pending |= process_level_irq(vcpu, lr, vlr);
> +			level_pending |= process_queued_irq(vcpu, lr, vlr);
>  			spin_unlock(&dist->lock);
>  		}
>  	}
> @@ -1422,7 +1428,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  /*
>   * Save the physical active state, and reset it to inactive.
>   *
> - * Return true if there's a pending level triggered interrupt line to queue.
> + * Return true if there's a pending forwarded interrupt to queue.
>   */
>  static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  {
> @@ -1458,10 +1464,8 @@ static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  		return false;
>  	}
>  
> -	/* Mapped edge-triggered interrupts not yet supported. */
> -	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
>  	spin_lock(&dist->lock);
> -	level_pending = process_level_irq(vcpu, lr, vlr);
> +	level_pending = process_queued_irq(vcpu, lr, vlr);
>  	spin_unlock(&dist->lock);
>  	return level_pending;
>  }
> 
