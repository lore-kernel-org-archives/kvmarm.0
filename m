From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Tue, 7 Jul 2015 10:58:56 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025F342B@SHSMSX104.ccr.corp.intel.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "Wu, Feng" <feng.wu@intel.com>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@linaro.org]
> Sent: Monday, July 06, 2015 8:11 PM
> To: eric.auger@st.com; eric.auger@linaro.org;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; pbonzini@redhat.com; avi.kivity@gmail.com;
> mtosatti@redhat.com; Wu, Feng; joro@8bytes.org;
> b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> Subject: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding control
> 
> - [add,del]_[consumer,producer] updated to takes both the consumer and
>   producer handles. This is requested to combine info from both,
>   typically to link the source irq owned by the producer with the gsi
>   owned by the consumer (forwarded IRQ setup).
> - new methods are added:
>   x stop/resume: Those are needed for forwarding since the state change
>     requires to entermingle actions at consumer, producer.
>   x consumer update for posted interrupts
> - On handshake, we now call connect, disconnect which features the more
>   complex sequence.
> - add irq on producer side
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v1 -> v2:
> - remove vfio_device, kvm, gsi, opaque fields included in v1 except common
> - all those in can be retrieved with container_of in callbacks
> ---
>  include/linux/irqbypass.h | 19 ++++++++++++++++---
>  kernel/irq/bypass.c       | 44
> ++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 56 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> index 718508e..8f62235 100644
> --- a/include/linux/irqbypass.h
> +++ b/include/linux/irqbypass.h
> @@ -3,17 +3,30 @@
> 
>  #include <linux/list.h>
> 
> +struct irq_bypass_consumer;
> +
>  struct irq_bypass_producer {
>  	struct list_head node;
>  	void *token;
> -	/* TBD */
> +	int irq; /* linux irq */
> +	void (*stop)(struct irq_bypass_producer *);
> +	void (*resume)(struct irq_bypass_producer *);
> +	void (*add_consumer)(struct irq_bypass_producer *,
> +			     struct irq_bypass_consumer *);
> +	void (*del_consumer)(struct irq_bypass_producer *,
> +			     struct irq_bypass_consumer *);
>  };
> 
>  struct irq_bypass_consumer {
>  	struct list_head node;
>  	void *token;

Can we add a pointer to ' struct irq_bypass_producer ', and
assign it when connecting, de-assign it when disconnecting.
since in some case, I need to update IRTE from the consumer
side, where I cannot get the related producer info (I need irq info)
without iterating it again.

Thanks,
Feng

> -	void (*add_producer)(struct irq_bypass_producer *);
> -	void (*del_producer)(struct irq_bypass_producer *);
> +	void (*stop)(struct irq_bypass_consumer *);
> +	void (*resume)(struct irq_bypass_consumer *);
> +	void (*add_producer)(struct irq_bypass_consumer *,
> +			     struct irq_bypass_producer *);
> +	void (*del_producer)(struct irq_bypass_consumer *,
> +			     struct irq_bypass_producer *);
> +	void (*update)(struct irq_bypass_consumer *);
>  };
> 
>  int irq_bypass_register_producer(struct irq_bypass_producer *);
> diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
> index 5d0f92b..efadbe5 100644
> --- a/kernel/irq/bypass.c
> +++ b/kernel/irq/bypass.c
> @@ -19,6 +19,42 @@ static LIST_HEAD(producers);
>  static LIST_HEAD(consumers);
>  static DEFINE_MUTEX(lock);
> 
> +/* lock must be hold when calling connect */
> +static void connect(struct irq_bypass_producer *prod,
> +		    struct irq_bypass_consumer *cons)
> +{
> +	if (prod->stop)
> +		prod->stop(prod);
> +	if (cons->stop)
> +		cons->stop(cons);
> +	if (prod->add_consumer)
> +		prod->add_consumer(prod, cons);
> +	if (cons->add_producer)
> +		cons->add_producer(cons, prod);
> +	if (cons->resume)
> +		cons->resume(cons);
> +	if (prod->resume)
> +		prod->resume(prod);
> +}
> +
> +/* lock must be hold when calling disconnect */
> +static void disconnect(struct irq_bypass_producer *prod,
> +		       struct irq_bypass_consumer *cons)
> +{
> +	if (prod->stop)
> +		prod->stop(prod);
> +	if (cons->stop)
> +		cons->stop(cons);
> +	if (cons->del_producer)
> +		cons->del_producer(cons, prod);
> +	if (prod->del_consumer)
> +		prod->del_consumer(prod, cons);
> +	if (cons->resume)
> +		cons->resume(cons);
> +	if (prod->resume)
> +		prod->resume(prod);
> +}
> +
>  int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>  {
>  	struct irq_bypass_producer *tmp;
> @@ -38,7 +74,7 @@ int irq_bypass_register_producer(struct
> irq_bypass_producer *producer)
> 
>  	list_for_each_entry(consumer, &consumers, node) {
>  		if (consumer->token == producer->token) {
> -			consumer->add_producer(producer);
> +			connect(producer, consumer);
>  			break;
>  		}
>  	}
> @@ -56,7 +92,7 @@ void irq_bypass_unregister_producer(struct
> irq_bypass_producer *producer)
> 
>  	list_for_each_entry(consumer, &consumers, node) {
>  		if (consumer->token == producer->token) {
> -			consumer->del_producer(producer);
> +			disconnect(producer, consumer);
>  			break;
>  		}
>  	}
> @@ -86,7 +122,7 @@ int irq_bypass_register_consumer(struct
> irq_bypass_consumer *consumer)
> 
>  	list_for_each_entry(producer, &producers, node) {
>  		if (producer->token == consumer->token) {
> -			consumer->add_producer(producer);
> +			connect(producer, consumer);
>  			break;
>  		}
>  	}
> @@ -104,7 +140,7 @@ void irq_bypass_unregister_consumer(struct
> irq_bypass_consumer *consumer)
> 
>  	list_for_each_entry(producer, &producers, node) {
>  		if (producer->token == consumer->token) {
> -			consumer->del_producer(producer);
> +			disconnect(producer, consumer);
>  			break;
>  		}
>  	}
> --
> 1.9.1
