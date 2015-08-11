From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 3/6] irqchip: GICv3: Skip LPI deactivation
Date: Tue, 11 Aug 2015 11:42:50 +0200
Message-ID: <55C9C39A.3060208@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31FAB5A89C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:30:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kcvZxhkJwJT5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 05:30:31 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 080F25A898
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:30:30 -0400 (EDT)
Received: by wijp15 with SMTP id p15so168626539wij.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 02:43:33 -0700 (PDT)
In-Reply-To: <1436447951-22357-4-git-send-email-marc.zyngier@arm.com>
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

On 07/09/2015 03:19 PM, Marc Zyngier wrote:
> Contrary to other GICv3 interrupts, LPIs do not have an active state
> by virtue of being edge-triggered only (they only have a pending state).
> 
> Given this, there is no point trying to deactivate them, and we can
> skip the ICC_DIR_EL1 entierely.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 49768fc..e02592b 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -295,10 +295,14 @@ static int gic_irq_get_irqchip_state(struct irq_data *d,
>  
>  static void gic_eoi_irq(struct irq_data *d)
>  {
> -	if (static_key_true(&supports_deactivate))
> +	if (static_key_true(&supports_deactivate)) {
> +		/* No need to deactivate an LPI */
> +		if (gic_irq(d) >= 8192)
In case of EOIMode == 0, we do not call EOI. I can't understand whether
it is an issue.
In 4.8.3 Properties of LPI, in 2d note it is written:

"SW must issue a write to EOI to clear the active priorities register,
hence the CPU interface still requires an active state for LPIs, even
through this is not necessary within the redistributor"

Eric
> +			return;
>  		gic_write_dir(gic_irq(d));
> -	else
> +	} else {
>  		gic_write_eoir(gic_irq(d));
> +	}
>  }
>  
>  static int gic_set_type(struct irq_data *d, unsigned int type)
> 
