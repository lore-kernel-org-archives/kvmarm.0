From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
Date: Mon, 6 Jul 2015 07:55:35 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025EB7C5@SHSMSX104.ccr.corp.intel.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "Wu, Feng" <feng.wu@intel.com>
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
> Subject: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
> 
> This patch adds the registration/unregistration of an
> irq_bypass_consumer on irqfd assignment/deassignment.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  virt/kvm/eventfd.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index f3da161..425a47b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -34,6 +34,7 @@
>  #include <linux/srcu.h>
>  #include <linux/slab.h>
>  #include <linux/seqlock.h>
> +#include <linux/irqbypass.h>
>  #include <trace/events/kvm.h>
> 
>  #include <kvm/iodev.h>
> @@ -93,6 +94,7 @@ struct _irqfd {
>  	struct list_head list;
>  	poll_table pt;
>  	struct work_struct shutdown;
> +	struct irq_bypass_consumer *cons;
>  };
> 
>  static struct workqueue_struct *irqfd_cleanup_wq;
> @@ -429,7 +431,21 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd
> *args)
>  	 */
>  	fdput(f);
> 
> -	/* irq_bypass_register_consumer(); */
> +	irqfd->cons = kzalloc(sizeof(struct irq_bypass_consumer),
> +			      GFP_KERNEL);
> +	if (!irqfd->cons) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +	irqfd->cons->token = (void *)irqfd->eventfd;
> +	irqfd->cons->gsi = irqfd->gsi;
> +	irqfd->cons->kvm = kvm;
> +	irqfd->cons->add_producer = kvm_arch_add_producer;
> +	irqfd->cons->del_producer = kvm_arch_del_producer;
> +	irqfd->cons->stop_consumer = kvm_arch_stop_consumer;
> +	irqfd->cons->resume_consumer = kvm_arch_resume_consumer;
> +	ret = irq_bypass_register_consumer(irqfd->cons);
> +	WARN_ON(ret);
> 
>  	return 0;
> 
> @@ -530,8 +546,6 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd
> *args)
>  	struct _irqfd *irqfd, *tmp;
>  	struct eventfd_ctx *eventfd;
> 
> -	/* irq_bypass_unregister_consumer() */
> -
>  	eventfd = eventfd_ctx_fdget(args->fd);
>  	if (IS_ERR(eventfd))
>  		return PTR_ERR(eventfd);
> @@ -550,6 +564,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd
> *args)
>  			irqfd->irq_entry.type = 0;
>  			write_seqcount_end(&irqfd->irq_entry_sc);
>  			irqfd_deactivate(irqfd);
> +			irq_bypass_unregister_consumer(irqfd->cons);
> +			kfree(irqfd->cons);

There may be an issue here. 'irqfd' is freed in irqfd_deactivate() --> ... --.>irqfd_shutdown(),
and irqfd_deactivate() can be called in the other two places below:
	- irqfd_wakeup()
	- kvm_irqfd_release()
I think we also need to call irq_bypass_unregister_consumer() there, right?

Thanks,
Feng


>  		}
>  	}
> 
> --
> 1.9.1
