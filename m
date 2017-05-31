From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 01/10] vfio: platform: Add automasked field to
 vfio_platform_irq
Date: Wed, 31 May 2017 11:41:45 -0600
Message-ID: <20170531114145.769097e5@w520.home>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-2-git-send-email-eric.auger@redhat.com>
 <87fufslsmm.fsf@arm.com>
 <3bc73d5c-4830-3bf5-ae59-d88ebdab8c27@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01BDB40296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 13:38:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVn7i8mC+KMk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 May 2017 13:38:03 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C755A40187
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 13:38:03 -0400 (EDT)
In-Reply-To: <3bc73d5c-4830-3bf5-ae59-d88ebdab8c27@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 30 May 2017 14:45:54 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Marc,
> 
> On 25/05/2017 20:05, Marc Zyngier wrote:
> > Hi Eric,
> > 
> > On Wed, May 24 2017 at 10:13:14 pm BST, Eric Auger <eric.auger@redhat.com> wrote:  
> >> For direct EOI modality we will need to differentiate a userspace
> >> masking from the IRQ handler auto-masking.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  drivers/vfio/platform/vfio_platform_irq.c     | 10 ++++++----
> >>  drivers/vfio/platform/vfio_platform_private.h |  1 +
> >>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> >> index 46d4750..831f0b0 100644
> >> --- a/drivers/vfio/platform/vfio_platform_irq.c
> >> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> >> @@ -29,7 +29,7 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
> >>  
> >>  	spin_lock_irqsave(&irq_ctx->lock, flags);
> >>  
> >> -	if (!irq_ctx->masked) {
> >> +	if (!irq_ctx->masked && !irq_ctx->automasked) {  
> > 
> > Could you please expand a bit on what this automasked variable covers?
> > It'd be good to document how masked and automasked differ in behaviour.  
> 
> Yes sure. So automasked is set by the physical IRQ handler only, for
> level sensitive IRQ (AUTOMASKED interrupts). masked is set through the
> userspace API (VFIO_DEVICE_SET_IRQS and ACTION_MASK) when masking the
> IRQ. VFIO ACTION_UNMASK resets both.

This would make more sense if you at the same time renamed 'masked' to
'usermasked'.  Thanks,

Alex

> > 
> > Also, it may be worth having a helper (is_masked?) to abstract both
> > cases.  
> 
> Sure
> 
> Eric
> >   
> >>  		disable_irq_nosync(irq_ctx->hwirq);
> >>  		irq_ctx->masked = true;
> >>  	}
> >> @@ -89,9 +89,10 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
> >>  
> >>  	spin_lock_irqsave(&irq_ctx->lock, flags);
> >>  
> >> -	if (irq_ctx->masked) {
> >> +	if (irq_ctx->masked || irq_ctx->automasked) {
> >>  		enable_irq(irq_ctx->hwirq);
> >>  		irq_ctx->masked = false;
> >> +		irq_ctx->automasked = false;
> >>  	}
> >>  
> >>  	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> >> @@ -152,12 +153,12 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
> >>  
> >>  	spin_lock_irqsave(&irq_ctx->lock, flags);
> >>  
> >> -	if (!irq_ctx->masked) {
> >> +	if (!irq_ctx->masked && !irq_ctx->automasked) {
> >>  		ret = IRQ_HANDLED;
> >>  
> >>  		/* automask maskable interrupts */
> >>  		disable_irq_nosync(irq_ctx->hwirq);
> >> -		irq_ctx->masked = true;
> >> +		irq_ctx->automasked = true;
> >>  	}
> >>  
> >>  	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> >> @@ -315,6 +316,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
> >>  		vdev->irqs[i].count = 1;
> >>  		vdev->irqs[i].hwirq = hwirq;
> >>  		vdev->irqs[i].masked = false;
> >> +		vdev->irqs[i].automasked = false;
> >>  	}
> >>  
> >>  	vdev->num_irqs = cnt;
> >> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> >> index 85ffe5d..8a3cfa9 100644
> >> --- a/drivers/vfio/platform/vfio_platform_private.h
> >> +++ b/drivers/vfio/platform/vfio_platform_private.h
> >> @@ -34,6 +34,7 @@ struct vfio_platform_irq {
> >>  	char			*name;
> >>  	struct eventfd_ctx	*trigger;
> >>  	bool			masked;
> >> +	bool			automasked;
> >>  	spinlock_t		lock;
> >>  	struct virqfd		*unmask;
> >>  	struct virqfd		*mask;  
> > 
> > Thanks,
> > 
> > 	M.
> >   
