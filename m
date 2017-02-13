From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 05/33] irqchip/gic-v3-its: Zero command on allocation
Date: Mon, 13 Feb 2017 10:55:50 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131055200.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6F540C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 04:55:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dP+ewN3W4ieX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 04:55:12 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00E2740BE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 04:55:12 -0500 (EST)
In-Reply-To: <1484648454-21216-6-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:

> When reusing commands from the ring buffer, it would be better
> to zero them out, even if the ITS should ignore the unused
> fields.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 2ca27f6..9304dd2 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -426,6 +426,12 @@ static struct its_cmd_block *its_allocate_entry(struct its_node *its)
>  	if (its->cmd_write == (its->cmd_base + ITS_CMD_QUEUE_NR_ENTRIES))
>  		its->cmd_write = its->cmd_base;
>  
> +	/* Clear command  */
> +	cmd->raw_cmd[0] = 0;
> +	cmd->raw_cmd[1] = 0;
> +	cmd->raw_cmd[2] = 0;
> +	cmd->raw_cmd[3] = 0;

  memset ?

Thanks,

	tglx
