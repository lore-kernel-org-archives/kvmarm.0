From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Mon, 6 Jul 2015 14:27:17 +0200
Message-ID: <559A7425.4050506@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/07/2015 14:11, Eric Auger wrote:
> diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
> index 5d0f92b..efadbe5 100644
> --- a/kernel/irq/bypass.c
> +++ b/kernel/irq/bypass.c
> @@ -19,6 +19,42 @@ static LIST_HEAD(producers);
>  static LIST_HEAD(consumers);
>  static DEFINE_MUTEX(lock);
>  
> +/* lock must be hold when calling connect */

If a lock must be held while callbacks are called, you have to document
that producers and consumers must _not_ call back into the IRQ bypass
manager.  (If they have to, you have to document explicitly "This
function can be called from producer and consumer callbacks" whenever
relevant).

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
