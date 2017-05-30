From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 01/10] vfio: platform: Add automasked field to
 vfio_platform_irq
Date: Tue, 30 May 2017 14:45:54 +0200
Message-ID: <3bc73d5c-4830-3bf5-ae59-d88ebdab8c27@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-2-git-send-email-eric.auger@redhat.com>
 <87fufslsmm.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87fufslsmm.fsf@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, pbonzini@redhat.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 25/05/2017 20:05, Marc Zyngier wrote:
> Hi Eric,
> 
> On Wed, May 24 2017 at 10:13:14 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>> For direct EOI modality we will need to differentiate a userspace
>> masking from the IRQ handler auto-masking.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c     | 10 ++++++----
>>  drivers/vfio/platform/vfio_platform_private.h |  1 +
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 46d4750..831f0b0 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -29,7 +29,7 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
>>  
>>  	spin_lock_irqsave(&irq_ctx->lock, flags);
>>  
>> -	if (!irq_ctx->masked) {
>> +	if (!irq_ctx->masked && !irq_ctx->automasked) {
> 
> Could you please expand a bit on what this automasked variable covers?
> It'd be good to document how masked and automasked differ in behaviour.

Yes sure. So automasked is set by the physical IRQ handler only, for
level sensitive IRQ (AUTOMASKED interrupts). masked is set through the
userspace API (VFIO_DEVICE_SET_IRQS and ACTION_MASK) when masking the
IRQ. VFIO ACTION_UNMASK resets both.
> 
> Also, it may be worth having a helper (is_masked?) to abstract both
> cases.

Sure

Eric
> 
>>  		disable_irq_nosync(irq_ctx->hwirq);
>>  		irq_ctx->masked = true;
>>  	}
>> @@ -89,9 +89,10 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
>>  
>>  	spin_lock_irqsave(&irq_ctx->lock, flags);
>>  
>> -	if (irq_ctx->masked) {
>> +	if (irq_ctx->masked || irq_ctx->automasked) {
>>  		enable_irq(irq_ctx->hwirq);
>>  		irq_ctx->masked = false;
>> +		irq_ctx->automasked = false;
>>  	}
>>  
>>  	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> @@ -152,12 +153,12 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>>  
>>  	spin_lock_irqsave(&irq_ctx->lock, flags);
>>  
>> -	if (!irq_ctx->masked) {
>> +	if (!irq_ctx->masked && !irq_ctx->automasked) {
>>  		ret = IRQ_HANDLED;
>>  
>>  		/* automask maskable interrupts */
>>  		disable_irq_nosync(irq_ctx->hwirq);
>> -		irq_ctx->masked = true;
>> +		irq_ctx->automasked = true;
>>  	}
>>  
>>  	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> @@ -315,6 +316,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>  		vdev->irqs[i].count = 1;
>>  		vdev->irqs[i].hwirq = hwirq;
>>  		vdev->irqs[i].masked = false;
>> +		vdev->irqs[i].automasked = false;
>>  	}
>>  
>>  	vdev->num_irqs = cnt;
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 85ffe5d..8a3cfa9 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -34,6 +34,7 @@ struct vfio_platform_irq {
>>  	char			*name;
>>  	struct eventfd_ctx	*trigger;
>>  	bool			masked;
>> +	bool			automasked;
>>  	spinlock_t		lock;
>>  	struct virqfd		*unmask;
>>  	struct virqfd		*mask;
> 
> Thanks,
> 
> 	M.
> 
