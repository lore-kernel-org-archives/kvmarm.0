From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
Date: Thu, 2 Jul 2015 15:42:07 +0200
Message-ID: <55953FAF.2060401@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 359FE57750
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:30:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zQQmwI1X+MOQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:30:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A37A5774A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:30:57 -0400 (EDT)
In-Reply-To: <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/07/2015 15:17, Eric Auger wrote:
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
> @@ -429,7 +431,21 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	 */
>  	fdput(f);
>  
> -	/* irq_bypass_register_consumer(); */
> +	irqfd->cons = kzalloc(sizeof(struct irq_bypass_consumer),
> +			      GFP_KERNEL);

Apart from the struct embedding technique I suggested in patch 12, this
looks very reasonable.  Thanks!

Paolo

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
> @@ -530,8 +546,6 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  	struct _irqfd *irqfd, *tmp;
>  	struct eventfd_ctx *eventfd;
>  
> -	/* irq_bypass_unregister_consumer() */
> -
>  	eventfd = eventfd_ctx_fdget(args->fd);
>  	if (IS_ERR(eventfd))
>  		return PTR_ERR(eventfd);
> @@ -550,6 +564,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  			irqfd->irq_entry.type = 0;
>  			write_seqcount_end(&irqfd->irq_entry_sc);
>  			irqfd_deactivate(irqfd);
> +			irq_bypass_unregister_consumer(irqfd->cons);
> +			kfree(irqfd->cons);
>  		}
>  	}
>  
> 
