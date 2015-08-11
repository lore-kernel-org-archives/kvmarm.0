From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 4/6] irqchip: GIC: Use chip_data instead of handler_data
 for cascaded interrupts
Date: Tue, 11 Aug 2015 11:45:18 +0200
Message-ID: <55C9C42E.8070602@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 469215A8A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:32:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qi+-+Tsz5pNX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 05:32:57 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5947A5A89E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:32:57 -0400 (EDT)
Received: by wibhh20 with SMTP id hh20so187032725wib.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 02:46:00 -0700 (PDT)
In-Reply-To: <1436447951-22357-5-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 07/09/2015 03:19 PM, Marc Zyngier wrote:
> When used as a primary interrupt controller, the GIC driver uses
> irq_data->chip_data to extract controller-specific information.
> 
> When used as a secondary interrupt controller, it uses handler_data
> instead. As this difference is relatively pointless and only creates
> confusion, change the secondary path to match what the rest of the
> driver does.
not really related to this series' topic, is it?

Eric
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index e264675..3c7f3a4 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -298,7 +298,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  
>  static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>  {
> -	struct gic_chip_data *chip_data = irq_get_handler_data(irq);
> +	struct gic_chip_data *chip_data = irq_get_chip_data(irq);
>  	struct irq_chip *chip = irq_get_chip(irq);
>  	unsigned int cascade_irq, gic_irq;
>  	unsigned long status;
> @@ -341,7 +341,7 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>  {
>  	if (gic_nr >= MAX_GIC_NR)
>  		BUG();
> -	if (irq_set_handler_data(irq, &gic_data[gic_nr]) != 0)
> +	if (irq_set_chip_data(irq, &gic_data[gic_nr]) != 0)
>  		BUG();
>  	irq_set_chained_handler(irq, gic_handle_cascade_irq);
>  }
> 
