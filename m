From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Fix spinlock acquisition in vgic_set_owner
Date: Fri, 1 Dec 2017 08:55:07 +0100
Message-ID: <20171201075507.GA4218@cbox>
References: <20171130170030.29827-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35BAC49D51
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 02:52:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c+K9G0zzq1gf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Dec 2017 02:52:08 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC4EC40D25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 02:52:07 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id v19so1814520wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Nov 2017 23:55:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171130170030.29827-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 30, 2017 at 05:00:30PM +0000, Marc Zyngier wrote:
> vgic_set_owner acquires the irq lock without disabling interrupts,
> resulting in a lockdep splat (an interrupt could fire and result
> in the same lock being taken if the same virtual irq is to be
> injected).
> 
> In practice, it is almost impossible to trigger this bug, but
> better safe than sorry. Convert the lock acquisition to a
> spin_lock_irqsave() and keep lockdep happy.
> 
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Applied, thanks.
-Christoffer

> ---
>  virt/kvm/arm/vgic/vgic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index b168a328a9e0..8d863e6405a5 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -492,6 +492,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
>  int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
>  {
>  	struct vgic_irq *irq;
> +	unsigned long flags;
>  	int ret = 0;
>  
>  	if (!vgic_initialized(vcpu->kvm))
> @@ -502,12 +503,12 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
>  		return -EINVAL;
>  
>  	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> -	spin_lock(&irq->irq_lock);
> +	spin_lock_irqsave(&irq->irq_lock, flags);
>  	if (irq->owner && irq->owner != owner)
>  		ret = -EEXIST;
>  	else
>  		irq->owner = owner;
> -	spin_unlock(&irq->irq_lock);
> +	spin_unlock_irqrestore(&irq->irq_lock, flags);
>  
>  	return ret;
>  }
> -- 
> 2.11.0
> 
