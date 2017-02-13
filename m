From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 24/33] irqchip/gic-v3-its: Add VPE scheduling
Date: Mon, 13 Feb 2017 11:48:10 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131146250.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1B5A40C26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:47:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ofWu8+uZsbV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:47:31 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9EF940C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:47:31 -0500 (EST)
In-Reply-To: <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
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
> +static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_info *info = vcpu_info;
> +	u64 val;
> +
> +	switch (info->cmd_type) {
> +	case SCHEDULE_VPE:
> +	{
> +		void * __iomem vlpi_base = gic_data_rdist_vlpi_base();

Moving the vlpi_base line on top of the fucntion spares you lines and
brackets. No point in having the same thing twice

Thanks,

	tglx
