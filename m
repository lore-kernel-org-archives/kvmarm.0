From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 03/10] VFIO: platform: Direct EOI irq bypass for ARM/ARM64
Date: Wed, 31 May 2017 21:31:03 +0200
Message-ID: <d119739d-b448-f4b2-0118-ca1e792285b7@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-4-git-send-email-eric.auger@redhat.com>
 <20170531122048.68bd231e@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CDA440A74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 15:27:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hGEYhRtHAcQ6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 May 2017 15:27:18 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 381CF40430
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 May 2017 15:27:16 -0400 (EDT)
In-Reply-To: <20170531122048.68bd231e@w520.home>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex, Marc,

On 31/05/2017 20:20, Alex Williamson wrote:
> On Wed, 24 May 2017 22:13:16 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This patch adds the registration/unregistration of an
>> irq_bypass_producer for vfio platform device interrupts.
>>
>> Its callbacks handle the direct EOI modality on VFIO side.
>>
>> - stop/start: disable/enable the host irq
>> - add/del consumer: set the VFIO Direct EOI mode, ie. select the
>>   adapted physical IRQ handler (automasked or not automasked).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> ---
>>  drivers/vfio/platform/Kconfig                    |   5 +
>>  drivers/vfio/platform/Makefile                   |   2 +-
>>  drivers/vfio/platform/vfio_platform_irq.c        |  19 ++++
>>  drivers/vfio/platform/vfio_platform_irq_bypass.c | 114 +++++++++++++++++++++++
>>  drivers/vfio/platform/vfio_platform_private.h    |  23 +++++
>>  5 files changed, 162 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/vfio/platform/vfio_platform_irq_bypass.c
>>
>> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
>> index bb30128..33ec3d9 100644
>> --- a/drivers/vfio/platform/Kconfig
>> +++ b/drivers/vfio/platform/Kconfig
>> @@ -2,6 +2,7 @@ config VFIO_PLATFORM
>>  	tristate "VFIO support for platform devices"
>>  	depends on VFIO && EVENTFD && (ARM || ARM64)
>>  	select VFIO_VIRQFD
>> +	select IRQ_BYPASS_MANAGER
>>  	help
>>  	  Support for platform devices with VFIO. This is required to make
>>  	  use of platform devices present on the system using the VFIO
>> @@ -19,4 +20,8 @@ config VFIO_AMBA
>>  
>>  	  If you don't know what to do here, say N.
>>  
>> +config VFIO_PLATFORM_IRQ_BYPASS_DEOI
>> +	depends on VFIO_PLATFORM
>> +	def_bool y
>> +
>>  source "drivers/vfio/platform/reset/Kconfig"
>> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
>> index 41a6224..324f3e7 100644
>> --- a/drivers/vfio/platform/Makefile
>> +++ b/drivers/vfio/platform/Makefile
>> @@ -1,4 +1,4 @@
>> -vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
>> +vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o vfio_platform_irq_bypass.o
>>  vfio-platform-y := vfio_platform.o
>>  
>>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 2f82459..5b70c8e 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/types.h>
>>  #include <linux/vfio.h>
>>  #include <linux/irq.h>
>> +#include <linux/irqbypass.h>
>>  
>>  #include "vfio_platform_private.h"
>>  
>> @@ -186,6 +187,19 @@ static irqreturn_t vfio_wrapper_handler(int irq, void *dev_id)
>>  	return ret;
>>  }
>>  
>> +/* must be called with irq_ctx->lock held */
>> +int vfio_platform_set_deoi(struct vfio_platform_irq *irq_ctx, bool deoi)
>> +{
>> +	irq_ctx->deoi = deoi;
>> +
>> +	if (!deoi && (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED))
>> +		irq_ctx->handler = vfio_automasked_irq_handler;
>> +	else
>> +		irq_ctx->handler = vfio_irq_handler;
>> +
>> +	return 0;
>> +}
>> +
>>  static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>>  			    int fd, irq_handler_t handler)
>>  {
>> @@ -196,6 +210,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>>  	if (irq->trigger) {
>>  		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
>>  		free_irq(irq->hwirq, irq);
>> +		irq_bypass_unregister_producer(&irq->producer);
>>  		kfree(irq->name);
>>  		eventfd_ctx_put(irq->trigger);
>>  		irq->trigger = NULL;
>> @@ -227,6 +242,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>>  		return ret;
>>  	}
>>  
>> +	if (vfio_platform_has_deoi())
>> +		vfio_platform_register_deoi_producer(vdev, irq,
>> +						     trigger, irq->hwirq);
>> +
>>  	if (!irq->masked)
>>  		enable_irq(irq->hwirq);
>>  
>> diff --git a/drivers/vfio/platform/vfio_platform_irq_bypass.c b/drivers/vfio/platform/vfio_platform_irq_bypass.c
>> new file mode 100644
>> index 0000000..436902c
>> --- /dev/null
>> +++ b/drivers/vfio/platform/vfio_platform_irq_bypass.c
>> @@ -0,0 +1,114 @@
>> +/*
>> + * VFIO platform device irqbypass callback implementation for DEOI
>> + *
>> + * Copyright (C) 2017 Red Hat, Inc.  All rights reserved.
>> + * Author: Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License, version 2, as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/device.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqbypass.h>
>> +#include "vfio_platform_private.h"
>> +
>> +#ifdef CONFIG_VFIO_PLATFORM_IRQ_BYPASS_DEOI
>> +
>> +static void irq_bypass_deoi_start(struct irq_bypass_producer *prod)
>> +{
>> +	enable_irq(prod->irq);
>> +}
>> +
>> +static void irq_bypass_deoi_stop(struct irq_bypass_producer *prod)
>> +{
>> +	disable_irq(prod->irq);
>> +}
>> +
>> +/**
>> + * irq_bypass_deoi_add_consumer - turns irq direct EOI on
>> + *
>> + * The linux irq is disabled when the function is called.
>> + * The operation succeeds only if the irq is not active at irqchip level
>> + * and the irq is not automasked at VFIO level, meaning the IRQ is under
>> + * injection into the guest.
>> + */
>> +static int irq_bypass_deoi_add_consumer(struct irq_bypass_producer *prod,
>> +					struct irq_bypass_consumer *cons)
>> +{
>> +	struct vfio_platform_irq *irq_ctx =
>> +		container_of(prod, struct vfio_platform_irq, producer);
>> +	unsigned long flags;
>> +	bool active;
>> +	int ret;
>> +
>> +	spin_lock_irqsave(&irq_ctx->lock, flags);
>> +
>> +	ret = irq_get_irqchip_state(irq_ctx->hwirq, IRQCHIP_STATE_ACTIVE,
>> +				    &active);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (active || irq_ctx->automasked) {
>> +		ret = -EAGAIN;
>> +		goto out;
>> +	}
>> +
>> +	if (!(irq_get_trigger_type(irq_ctx->hwirq) & IRQ_TYPE_LEVEL_MASK))
>> +		goto out;
> 
> Not sure why this wouldn't return -EINVAL;
At the moment direct EOI is also set up for edge sensitive IRQs. This
means the deactivation of the IRQ will happen later through guest
virtual interrupt deactivation but somehow isn't it more accurate wrt
the passthrough? Marc, what is your opinion? GIC spec does not seem to
restrict this mode to level sensitive interrupts or am I mistajen?

Thanks

Eric
> 
>> +
>> +	ret = vfio_platform_set_deoi(irq_ctx, true);
>> +out:
>> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> +	return ret;
>> +}
>> +
>> +static void irq_bypass_deoi_del_consumer(struct irq_bypass_producer *prod,
>> +					 struct irq_bypass_consumer *cons)
>> +{
>> +	struct vfio_platform_irq *irq_ctx =
>> +		container_of(prod, struct vfio_platform_irq, producer);
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&irq_ctx->lock, flags);
>> +	if (irq_get_trigger_type(irq_ctx->hwirq) & IRQ_TYPE_LEVEL_MASK)
>> +		vfio_platform_set_deoi(irq_ctx, false);
>> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> +}
>> +
>> +bool vfio_platform_has_deoi(void)
>> +{
>> +	return true;
>> +}
>> +
>> +void vfio_platform_register_deoi_producer(struct vfio_platform_device *vdev,
>> +					  struct vfio_platform_irq *irq,
>> +					  struct eventfd_ctx *trigger,
>> +					  unsigned int host_irq)
>> +{
>> +	struct irq_bypass_producer *prod = &irq->producer;
>> +	int ret;
>> +
>> +	prod->token =		trigger;
>> +	prod->irq =		host_irq;
>> +	prod->add_consumer =	irq_bypass_deoi_add_consumer;
>> +	prod->del_consumer =	irq_bypass_deoi_del_consumer;
>> +	prod->stop =		irq_bypass_deoi_stop;
>> +	prod->start =		irq_bypass_deoi_start;
>> +
>> +	ret = irq_bypass_register_producer(prod);
>> +	if (unlikely(ret))
>> +		dev_info(vdev->device,
>> +			 "irq bypass producer (token %p) registration fails: %d\n",
>> +			 prod->token, ret);
>> +}
>> +
>> +#endif
>> +
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index b80a380..bfa2675 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -17,6 +17,7 @@
>>  
>>  #include <linux/types.h>
>>  #include <linux/interrupt.h>
>> +#include <linux/irqbypass.h>
>>  
>>  #define VFIO_PLATFORM_OFFSET_SHIFT   40
>>  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
>> @@ -40,6 +41,7 @@ struct vfio_platform_irq {
>>  	struct virqfd		*mask;
>>  	bool			deoi;
>>  	irqreturn_t		(*handler)(int irq, void *dev_id);
>> +	struct irq_bypass_producer producer;
>>  };
>>  
>>  struct vfio_platform_region {
>> @@ -102,9 +104,30 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>  					unsigned start, unsigned count,
>>  					void *data);
>>  
>> +extern int vfio_platform_set_deoi(struct vfio_platform_irq *irq_ctx, bool deoi);
>> +
>>  extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
>>  extern void vfio_platform_unregister_reset(const char *compat,
>>  					   vfio_platform_reset_fn_t fn);
>> +
>> +#ifdef CONFIG_VFIO_PLATFORM_IRQ_BYPASS_DEOI
>> +bool vfio_platform_has_deoi(void);
>> +void vfio_platform_register_deoi_producer(struct vfio_platform_device *vdev,
>> +					  struct vfio_platform_irq *irq,
>> +					  struct eventfd_ctx *trigger,
>> +					  unsigned int host_irq);
>> +#else
>> +static inline bool vfio_platform_has_deoi(void)
>> +{
>> +	return false;
>> +}
>> +static inline
>> +void vfio_platform_register_deoi_producer(struct vfio_platform_device *vdev,
>> +					  struct vfio_platform_irq *irq,
>> +					  struct eventfd_ctx *trigger,
>> +					  unsigned int host_irq) {}
>> +#endif
>> +
>>  #define vfio_platform_register_reset(__compat, __reset)		\
>>  static struct vfio_platform_reset_node __reset ## _node = {	\
>>  	.owner = THIS_MODULE,					\
> 
