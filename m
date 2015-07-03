From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC 09/17] bypass: IRQ bypass manager proto by Alex
Date: Fri, 3 Jul 2015 02:16:01 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025E6C0E@SHSMSX104.ccr.corp.intel.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-10-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B5957852
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 22:07:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2UJyxn8-KmUY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 22:07:24 -0400 (EDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8951657844
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 22:07:24 -0400 (EDT)
In-Reply-To: <1435843047-6327-10-git-send-email-eric.auger@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "Wu, Feng" <feng.wu@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@linaro.org]
> Sent: Thursday, July 02, 2015 9:17 PM
> To: eric.auger@st.com; eric.auger@linaro.org;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; pbonzini@redhat.com; avi.kivity@gmail.com;
> mtosatti@redhat.com; Wu, Feng; joro@8bytes.org;
> b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> Subject: [RFC 09/17] bypass: IRQ bypass manager proto by Alex
> 
> From: Alex Williamson <alex.williamson@redhat.com>
> 
> There are plenty of details to be filled in, but I think the basics
> looks something like the code below.  The IRQ bypass manager just
> defines a pair of structures, one for interrupt producers and one for
> interrupt consumers.  I'm certain that we'll need more callbacks than
> I've defined below, but figuring out what those should be for the best
> abstraction is the hardest part of this idea.  The manager provides both
> registration and de-registration interfaces for both types of objects
> and keeps lists for each, protected by a lock.  The manager doesn't even
> really need to know what the match token is, but I assume for our
> purposes it will be an eventfd_ctx.
> 
> On the vfio side, the producer struct would be embedded in the
> vfio_pci_irq_ctx struct.  KVM would probably embed the consumer struct
> in _irqfd.  As I've coded below, the IRQ bypass manager calls the
> consumer callbacks, so the producer struct would need fields or
> callbacks to provide the consumer the info it needs.  AIUI the Posted
> Interrupt model, VFIO only needs to provide data to the consumer.  For
> IRQ Forwarding, I think the producer needs to be informed when bypass is
> active to model the incoming interrupt as edge vs level.
> 
> I've prototyped the base IRQ bypass manager here as static, but I don't
> see any reason it couldn't be a module that's loaded by dependency when
> either vfio-pci or kvm-intel is loaded (or other producer/consumer
> objects).
> 
> Is this a reasonable starting point to craft the additional fields and
> callbacks and interaction of who calls who that we need to support
> Posted Interrupts and IRQ Forwarding?  Is the AMD version of this still
> alive?  Thanks,
> 
> Alex

In fact, I also implement a RFC patch for this new framework. I am
thinking, can we discuss all the requirements for irq forwarding and
posted interrupts, and make it a separate patchset as a general
layer? Then we can continue to push arch specific stuff, it is more
clear and easy.

Thanks,
Feng

> ---
>  arch/x86/kvm/Kconfig              |   1 +
>  drivers/vfio/pci/Kconfig          |   1 +
>  drivers/vfio/pci/vfio_pci_intrs.c |   6 ++
>  include/linux/irqbypass.h         |  23 ++++++++
>  kernel/irq/Kconfig                |   3 +
>  kernel/irq/Makefile               |   1 +
>  kernel/irq/bypass.c               | 116
> ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/eventfd.c                |   4 ++
>  8 files changed, 155 insertions(+)
>  create mode 100644 include/linux/irqbypass.h
>  create mode 100644 kernel/irq/bypass.c
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d8a1d56..86d0d77 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -61,6 +61,7 @@ config KVM_INTEL
>  	depends on KVM
>  	# for perf_guest_get_msrs():
>  	depends on CPU_SUP_INTEL
> +	select IRQ_BYPASS_MANAGER
>  	---help---
>  	  Provides support for KVM on Intel processors equipped with the VT
>  	  extensions.
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 579d83b..02912f1 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -2,6 +2,7 @@ config VFIO_PCI
>  	tristate "VFIO support for PCI devices"
>  	depends on VFIO && PCI && EVENTFD
>  	select VFIO_VIRQFD
> +	select IRQ_BYPASS_MANAGER
>  	help
>  	  Support for the PCI VFIO bus driver.  This is required to make
>  	  use of PCI drivers using the VFIO framework.
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1f577b4..4e053be 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -181,6 +181,7 @@ static int vfio_intx_set_signal(struct vfio_pci_device
> *vdev, int fd)
> 
>  	if (vdev->ctx[0].trigger) {
>  		free_irq(pdev->irq, vdev);
> +		/* irq_bypass_unregister_producer(); */
>  		kfree(vdev->ctx[0].name);
>  		eventfd_ctx_put(vdev->ctx[0].trigger);
>  		vdev->ctx[0].trigger = NULL;
> @@ -214,6 +215,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device
> *vdev, int fd)
>  		return ret;
>  	}
> 
> +	/* irq_bypass_register_producer(); */
> +
>  	/*
>  	 * INTx disable will stick across the new irq setup,
>  	 * disable_irq won't.
> @@ -319,6 +322,7 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_device *vdev,
> 
>  	if (vdev->ctx[vector].trigger) {
>  		free_irq(irq, vdev->ctx[vector].trigger);
> +		/* irq_bypass_unregister_producer(); */
>  		kfree(vdev->ctx[vector].name);
>  		eventfd_ctx_put(vdev->ctx[vector].trigger);
>  		vdev->ctx[vector].trigger = NULL;
> @@ -360,6 +364,8 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_device *vdev,
>  		return ret;
>  	}
> 
> +	/* irq_bypass_register_producer(); */
> +
>  	vdev->ctx[vector].trigger = trigger;
> 
>  	return 0;
> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> new file mode 100644
> index 0000000..718508e
> --- /dev/null
> +++ b/include/linux/irqbypass.h
> @@ -0,0 +1,23 @@
> +#ifndef IRQBYPASS_H
> +#define IRQBYPASS_H
> +
> +#include <linux/list.h>
> +
> +struct irq_bypass_producer {
> +	struct list_head node;
> +	void *token;
> +	/* TBD */
> +};
> +
> +struct irq_bypass_consumer {
> +	struct list_head node;
> +	void *token;
> +	void (*add_producer)(struct irq_bypass_producer *);
> +	void (*del_producer)(struct irq_bypass_producer *);
> +};
> +
> +int irq_bypass_register_producer(struct irq_bypass_producer *);
> +void irq_bypass_unregister_producer(struct irq_bypass_producer *);
> +int irq_bypass_register_consumer(struct irq_bypass_consumer *);
> +void irq_bypass_unregister_consumer(struct irq_bypass_consumer *);
> +#endif /* IRQBYPASS_H */
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index 9a76e3b..4502cdc 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -100,4 +100,7 @@ config SPARSE_IRQ
> 
>  	  If you don't know what to do here, say N.
> 
> +config IRQ_BYPASS_MANAGER
> +	bool
> +
>  endmenu
> diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
> index d121235..a30ed77 100644
> --- a/kernel/irq/Makefile
> +++ b/kernel/irq/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_PROC_FS) += proc.o
>  obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
>  obj-$(CONFIG_PM_SLEEP) += pm.o
>  obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
> +obj-$(CONFIG_IRQ_BYPASS_MANAGER) += bypass.o
> diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
> new file mode 100644
> index 0000000..5d0f92b
> --- /dev/null
> +++ b/kernel/irq/bypass.c
> @@ -0,0 +1,116 @@
> +/*
> + * IRQ offload/bypass manager
> + *
> + * Various virtualization hardware acceleration techniques allow bypassing
> + * or offloading interrupts receieved from devices around the host kernel.
> + * Posted Interrupts on Intel VT-d systems can allow interrupts to be
> + * recieved directly by a virtual machine.  ARM IRQ Forwarding can allow
> + * level triggered device interrupts to be de-asserted directly by the VM.
> + * This manager allows interrupt producers and consumers to find each other
> + * to enable this sort of bypass.
> + */
> +
> +#include <linux/irqbypass.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +static LIST_HEAD(producers);
> +static LIST_HEAD(consumers);
> +static DEFINE_MUTEX(lock);
> +
> +int irq_bypass_register_producer(struct irq_bypass_producer *producer)
> +{
> +	struct irq_bypass_producer *tmp;
> +	struct irq_bypass_consumer *consumer;
> +	int ret = 0;
> +
> +	mutex_lock(&lock);
> +
> +	list_for_each_entry(tmp, &producers, node) {
> +		if (tmp->token == producer->token) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +	}
> +
> +	list_add(&producer->node, &producers);
> +
> +	list_for_each_entry(consumer, &consumers, node) {
> +		if (consumer->token == producer->token) {
> +			consumer->add_producer(producer);
> +			break;
> +		}
> +	}
> +unlock:
> +	mutex_unlock(&lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
> +
> +void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
> +{
> +	struct irq_bypass_consumer *consumer;
> +
> +	mutex_lock(&lock);
> +
> +	list_for_each_entry(consumer, &consumers, node) {
> +		if (consumer->token == producer->token) {
> +			consumer->del_producer(producer);
> +			break;
> +		}
> +	}
> +
> +	list_del(&producer->node);
> +
> +	mutex_unlock(&lock);
> +}
> +EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
> +
> +int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
> +{
> +	struct irq_bypass_consumer *tmp;
> +	struct irq_bypass_producer *producer;
> +	int ret = 0;
> +
> +	mutex_lock(&lock);
> +
> +	list_for_each_entry(tmp, &consumers, node) {
> +		if (tmp->token == consumer->token) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +	}
> +
> +	list_add(&consumer->node, &consumers);
> +
> +	list_for_each_entry(producer, &producers, node) {
> +		if (producer->token == consumer->token) {
> +			consumer->add_producer(producer);
> +			break;
> +		}
> +	}
> +unlock:
> +	mutex_unlock(&lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
> +
> +void irq_bypass_unregister_consumer(struct irq_bypass_consumer
> *consumer)
> +{
> +	struct irq_bypass_producer *producer;
> +
> +	mutex_lock(&lock);
> +
> +	list_for_each_entry(producer, &producers, node) {
> +		if (producer->token == consumer->token) {
> +			consumer->del_producer(producer);
> +			break;
> +		}
> +	}
> +
> +	list_del(&consumer->node);
> +
> +	mutex_unlock(&lock);
> +}
> +EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 9ff4193..f3da161 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -429,6 +429,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd
> *args)
>  	 */
>  	fdput(f);
> 
> +	/* irq_bypass_register_consumer(); */
> +
>  	return 0;
> 
>  fail:
> @@ -528,6 +530,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd
> *args)
>  	struct _irqfd *irqfd, *tmp;
>  	struct eventfd_ctx *eventfd;
> 
> +	/* irq_bypass_unregister_consumer() */
> +
>  	eventfd = eventfd_ctx_fdget(args->fd);
>  	if (IS_ERR(eventfd))
>  		return PTR_ERR(eventfd);
> --
> 1.9.1
