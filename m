From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3 05/10] VFIO: platform: add vfio_platform_is_active
Date: Wed, 12 Aug 2015 12:56:45 -0600
Message-ID: <1439405805.4023.529.camel@redhat.com>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
 <1439212864-12954-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 254765AD55
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 14:43:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CVGYt8eJXZGz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 14:43:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67C435AD54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 14:43:40 -0400 (EDT)
In-Reply-To: <1439212864-12954-6-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2015-08-10 at 15:20 +0200, Eric Auger wrote:
> This function returns whether the IRQ is active at irqchip level or
> VFIO masked. If either is true, it is considered the IRQ is active.
> Currently there is no way to differentiate userspace masked IRQ from
> automasked IRQ. There might be false detection of activity. However
> it is currently acceptable to have false detection.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> ---
>  drivers/vfio/platform/vfio_platform_irq.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index a285384..efaee58 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -205,6 +205,23 @@ static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
>  	return 0;
>  }
>  
> +static int vfio_platform_is_active(struct vfio_platform_irq *irq)

vfio_platform_irq_is_active()?

> +{
> +	unsigned long flags;
> +	bool active, masked, outstanding;
> +	int ret;
> +
> +	spin_lock_irqsave(&irq->lock, flags);
> +
> +	ret = irq_get_irqchip_state(irq->hwirq, IRQCHIP_STATE_ACTIVE, &active);
> +	BUG_ON(ret);

Why can't we propagate this error to the caller and let them decide?

> +	masked = irq->masked;
> +	outstanding = active || masked;
> +
> +	spin_unlock_irqrestore(&irq->lock, flags);
> +	return outstanding;
> +}
> +
>  static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
>  {
>  }
