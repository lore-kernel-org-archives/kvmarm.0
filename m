From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 17/33] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Mon, 13 Feb 2017 11:37:03 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131135220.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C0740BE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:36:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nyFIV2LWWw6c for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:36:26 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B1FD40BE4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:36:26 -0500 (EST)
In-Reply-To: <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
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
> +static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_info *info = vcpu_info;
> +	u32 event = its_get_event_id(d);
> +
> +	/* Need a v4 ITS */
> +	if (!its_dev->its->is_v4 || !info)
> +		return -EINVAL;
> +
> +	switch (info->cmd_type) {
> +	case MAP_VLPI:
> +	{

Looking at the later patches which add functionality here, I'd rather avoid
these massive case { } blocks and stick the functionality into seperate
helper functions.

Thanks,

	tglx
