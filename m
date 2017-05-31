From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 04/10] VFIO: pci: Add automasked field to vfio_pci_irq_ctx
Date: Wed, 31 May 2017 12:21:10 -0600
Message-ID: <20170531122110.1d35d6d4@w520.home>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA8D140C4B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 14:17:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2RPOVcJRMC9K for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 May 2017 14:17:36 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C01F940C4A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 14:17:36 -0400 (EDT)
In-Reply-To: <1495656803-28011-5-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 24 May 2017 22:13:17 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> For direct EOI modality we will need to differentiate a userspace
> masking from the IRQ handler auto-masking.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c   | 15 +++++++++------
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1c46045..d4d377b 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -52,7 +52,7 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
>  	if (unlikely(!is_intx(vdev))) {
>  		if (vdev->pci_2_3)
>  			pci_intx(pdev, 0);
> -	} else if (!vdev->ctx[0].masked) {
> +	} else if (!vdev->ctx[0].masked && !vdev->ctx[0].automasked) {
>  		/*
>  		 * Can't use check_and_mask here because we always want to
>  		 * mask, not just when something is pending.
> @@ -90,7 +90,8 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
>  	if (unlikely(!is_intx(vdev))) {
>  		if (vdev->pci_2_3)
>  			pci_intx(pdev, 1);
> -	} else if (vdev->ctx[0].masked && !vdev->virq_disabled) {
> +	} else if ((vdev->ctx[0].masked || vdev->ctx[0].automasked) &&
> +			!vdev->virq_disabled) {
>  		/*
>  		 * A pending interrupt here would immediately trigger,
>  		 * but we can avoid that overhead by just re-sending
> @@ -103,6 +104,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
>  			enable_irq(pdev->irq);
>  
>  		vdev->ctx[0].masked = (ret > 0);
> +		vdev->ctx[0].automasked = (ret > 0);
>  	}

This looks suspicious, if we leave this function with the interrupt
masked, isn't it due to an automask, not a usermask?

>  
>  	spin_unlock_irqrestore(&vdev->irqlock, flags);
> @@ -126,11 +128,12 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>  
>  	if (!vdev->pci_2_3) {
>  		disable_irq_nosync(vdev->pdev->irq);
> -		vdev->ctx[0].masked = true;
> +		vdev->ctx[0].automasked = true;
>  		ret = IRQ_HANDLED;
> -	} else if (!vdev->ctx[0].masked &&  /* may be shared */
> -		   pci_check_and_mask_intx(vdev->pdev)) {
> -		vdev->ctx[0].masked = true;
> +	} else if (!vdev->ctx[0].masked && !vdev->ctx[0].automasked &&
> +			pci_check_and_mask_intx(vdev->pdev)) {
> +		 /* shared INTx */
> +		vdev->ctx[0].automasked = true;
>  		ret = IRQ_HANDLED;
>  	}
>  
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index f561ac1..f7f1101 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -35,6 +35,7 @@ struct vfio_pci_irq_ctx {
>  	struct virqfd		*mask;
>  	char			*name;
>  	bool			masked;
> +	bool			automasked;
>  	struct irq_bypass_producer	producer;
>  };
>  
