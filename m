From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 12/26] KVM: arm/arm64: GICv4: Unmap VLPI when freeing
 an LPI
Date: Tue, 7 Nov 2017 21:28:55 +0100
Message-ID: <052a6676-c15a-6d91-da1e-660312c29f1b@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4466549D20
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:27:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qMqffUrRCSP0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 15:27:07 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59DA249D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:27:07 -0500 (EST)
In-Reply-To: <20171027142855.21584-13-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/10/2017 16:28, Marc Zyngier wrote:
> When freeing an LPI (on a DISCARD command, for example), we need
> to unmap the VLPI down to the physical ITS level.
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index b2a678d131d0..c9b1c0967426 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -628,8 +628,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
>  	list_del(&ite->ite_list);
>  
>  	/* This put matches the get in vgic_add_lpi. */
> -	if (ite->irq)
> +	if (ite->irq) {
> +		if (ite->irq->hw)
> +			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
> +
>  		vgic_put_irq(kvm, ite->irq);
You could have put the its_unmap_vlpi() directly in vgic_put_irq which
is meant to decr the ref/release the LPI irq.

Thanks

Eric
> +	}
>  
>  	kfree(ite);
>  }
> 
