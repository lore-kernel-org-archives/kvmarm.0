From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3 03/10] VFIO: platform: single handler using function
 pointer
Date: Wed, 12 Aug 2015 12:56:20 -0600
Message-ID: <1439405780.4023.527.camel@redhat.com>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
 <1439212864-12954-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC225AD3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 14:43:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mKhEm0k3AEs7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 14:43:14 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C52325AD33
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 14:43:14 -0400 (EDT)
In-Reply-To: <1439212864-12954-4-git-send-email-eric.auger@linaro.org>
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
> A single handler now is registered whatever the use case: automasked
> or not. A function pointer is set according to the wished behavior
> and the handler calls this function.
> 
> The irq lock is taken/released in the root handler. eventfd_signal can
> be called in regions not allowed to sleep.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v4: creation
> ---
>  drivers/vfio/platform/vfio_platform_irq.c     | 21 +++++++++++++++------
>  drivers/vfio/platform/vfio_platform_private.h |  1 +
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 40f057a..b31b1f0 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -148,11 +148,8 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>  static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  {
>  	struct vfio_platform_irq *irq_ctx = dev_id;
> -	unsigned long flags;
>  	int ret = IRQ_NONE;
>  
> -	spin_lock_irqsave(&irq_ctx->lock, flags);
> -
>  	if (!irq_ctx->masked) {
>  		ret = IRQ_HANDLED;
>  
> @@ -161,8 +158,6 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  		irq_ctx->masked = true;
>  	}
>  
> -	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> -
>  	if (ret == IRQ_HANDLED)
>  		eventfd_signal(irq_ctx->trigger, 1);

Has this been run with lockdep to check whether this is safe to call
with spinlock_irqsave held?

>  
> @@ -178,6 +173,19 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static irqreturn_t vfio_handler(int irq, void *dev_id)
> +{
> +	struct vfio_platform_irq *irq_ctx = dev_id;
> +	unsigned long flags;
> +	irqreturn_t ret;
> +
> +	spin_lock_irqsave(&irq_ctx->lock, flags);
> +	ret = irq_ctx->handler(irq, dev_id);
> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> +
> +	return ret;
> +}
> +
>  static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
>  {
>  }
> @@ -229,9 +237,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>  	}
>  
>  	irq->trigger = trigger;
> +	irq->handler = handler;
>  
>  	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
> -	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
> +	ret = request_irq(irq->hwirq, vfio_handler, 0, irq->name, irq);
>  	if (ret) {
>  		kfree(irq->name);
>  		eventfd_ctx_put(trigger);
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 8b4f814..f848a6b 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -40,6 +40,7 @@ struct vfio_platform_irq {
>  	struct virqfd		*mask;
>  	struct irq_bypass_producer producer;
>  	bool			forwarded;
> +	irqreturn_t (*handler)(int irq, void *dev_id);
>  };
>  
>  struct vfio_platform_region {
