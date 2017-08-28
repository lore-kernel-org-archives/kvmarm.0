From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 43/59] KVM: arm/arm64: GICv4: Unmap VLPI when freeing
 an LPI
Date: Mon, 28 Aug 2017 20:18:08 +0200
Message-ID: <20170828181808.GC24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-44-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F29149C34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jb9DBTG8QDQH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:03 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 503F949C19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:03 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id u26so8596468wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-44-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:21PM +0100, Marc Zyngier wrote:
> When freeing an LPI (on a DISCARD command, for example), we need
> to unmap the VLPI down to the physical ITS level.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 40aeadef33fe..79bac93d3e7d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -623,8 +623,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
>  	list_del(&ite->ite_list);
>  
>  	/* This put matches the get in vgic_add_lpi. */
> -	if (ite->irq)
> +	if (ite->irq) {
> +		if (ite->irq->hw)
> +			its_unmap_vlpi(ite->irq->host_irq);

nit: should we raise a warning on a bad return value?

Otherwise:

Acked-by: Christoffer Dall <cdall@linaro.org>

> +
>  		vgic_put_irq(kvm, ite->irq);
> +	}
>  
>  	kfree(ite);
>  }
> -- 
> 2.11.0
> 
