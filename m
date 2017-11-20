From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: VGIC: extend !vgic_is_initialized guard
Date: Mon, 20 Nov 2017 10:12:34 +0100
Message-ID: <12a709ab-ce5f-5fd0-02d7-7b1456a1f061@redhat.com>
References: <20171117175821.23250-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB0C49D19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 04:10:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+dpMFFJmRNH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Nov 2017 04:10:09 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA0ED49D15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 04:10:09 -0500 (EST)
In-Reply-To: <20171117175821.23250-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 17/11/2017 18:58, Andre Przywara wrote:
> Commit f39d16cbabf9 ("KVM: arm/arm64: Guard kvm_vgic_map_is_active against
> !vgic_initialized") introduced a check whether the VGIC has been
> initialized before accessing the spinlock and the VGIC data structure.
> However the vgic_get_irq() call in the variable declaration sneaked
> through the net, so lets make sure that this also gets called only after
> we actually allocated the arrays this function accesses.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
actually it does not directly apply on kvmarm/next. There is a small
conflict with 47bbd31  KVM: arm/arm64: vgic: restructure
kvm_vgic_(un)map_phys_irq I think.

Cheers

Eric
> ---
>  virt/kvm/arm/vgic/vgic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e54ef2fdf73d..967983a33ab2 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -786,13 +786,14 @@ void vgic_kick_vcpus(struct kvm *kvm)
>  
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  {
> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +	struct vgic_irq *irq;
>  	bool map_is_active;
>  	unsigned long flags;
>  
>  	if (!vgic_initialized(vcpu->kvm))
>  		return false;
>  
> +	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>  	spin_lock_irqsave(&irq->irq_lock, flags);
>  	map_is_active = irq->hw && irq->active;
>  	spin_unlock_irqrestore(&irq->irq_lock, flags);
> 
