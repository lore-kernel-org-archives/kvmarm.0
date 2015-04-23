From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sysbus: add irq_routing_notifier
Date: Thu, 23 Apr 2015 11:33:30 +0200
Message-ID: <5538BC6A.2070307@redhat.com>
References: <1429779318-1810-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A368A4E4F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:25:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PXG3w24g79f6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 05:25:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA3524E4F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:25:26 -0400 (EDT)
In-Reply-To: <1429779318-1810-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org, agraf@suse.de
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/04/2015 10:55, Eric Auger wrote:
> Add a new irq_routing_notifier notifier and its setter. This
> notifier is called on sysbus_connect_irq. The same notifier
> is used for all interrupts.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

I'm sorry, same problem here.  The question is: why? :)

I can sort of understand why you want this, but not completely.  I also
have all sorts of questions on the code that aren't answered.  For
example, why does the notifier not get the N argument?

I also cannot understand why this is not a layering violation.  Maybe
it's not, but it's hard to say without seeing the user.

Paolo

> ---
>  hw/core/sysbus.c    | 9 +++++++++
>  include/hw/sysbus.h | 6 ++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
> index b53c351..26579f1 100644
> --- a/hw/core/sysbus.c
> +++ b/hw/core/sysbus.c
> @@ -110,6 +110,9 @@ qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n)
>  void sysbus_connect_irq(SysBusDevice *dev, int n, qemu_irq irq)
>  {
>      qdev_connect_gpio_out_named(DEVICE(dev), SYSBUS_DEVICE_GPIO_IRQ, n, irq);
> +    if (dev->irq_routing_notifier) {
> +        dev->irq_routing_notifier(dev, irq);
> +    }
>  }
>  
>  /* Check whether an MMIO region exists */
> @@ -307,6 +310,12 @@ MemoryRegion *sysbus_address_space(SysBusDevice *dev)
>      return get_system_memory();
>  }
>  
> +void sysbus_set_irq_routing_notifier(SysBusDevice *dev,
> +                                     IRQRoutingNotifier notifier)
> +{
> +    dev->irq_routing_notifier = notifier;
> +}
> +
>  static void sysbus_device_class_init(ObjectClass *klass, void *data)
>  {
>      DeviceClass *k = DEVICE_CLASS(klass);
> diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
> index d1f3f00..84166d9 100644
> --- a/include/hw/sysbus.h
> +++ b/include/hw/sysbus.h
> @@ -13,6 +13,7 @@
>  #define SYSTEM_BUS(obj) OBJECT_CHECK(BusState, (obj), TYPE_SYSTEM_BUS)
>  
>  typedef struct SysBusDevice SysBusDevice;
> +typedef void (*IRQRoutingNotifier)(SysBusDevice *dev, qemu_irq irq);
>  
>  #define TYPE_SYS_BUS_DEVICE "sys-bus-device"
>  #define SYS_BUS_DEVICE(obj) \
> @@ -55,6 +56,8 @@ struct SysBusDevice {
>      } mmio[QDEV_MAX_MMIO];
>      int num_pio;
>      pio_addr_t pio[QDEV_MAX_PIO];
> +
> +    IRQRoutingNotifier irq_routing_notifier;
>  };
>  
>  typedef int FindSysbusDeviceFunc(SysBusDevice *sbdev, void *opaque);
> @@ -100,4 +103,7 @@ static inline DeviceState *sysbus_try_create_simple(const char *name,
>      return sysbus_try_create_varargs(name, addr, irq, NULL);
>  }
>  
> +void sysbus_set_irq_routing_notifier(SysBusDevice *dev,
> +                                     IRQRoutingNotifier notifier);
> +
>  #endif /* !HW_SYSBUS_H */
> 
