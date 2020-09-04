Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50611C2D0A8
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 13:57:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF2AA2083B
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 13:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF2AA2083B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=Huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BFC54B3D3;
	Fri,  4 Sep 2020 09:57:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9w6zrcE0GCn5; Fri,  4 Sep 2020 09:57:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D37C4B3E7;
	Fri,  4 Sep 2020 09:57:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B04294B3D3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 09:57:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y0ZEFRbGsubQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 09:57:52 -0400 (EDT)
Received: from huawei.com (lhrrgout.huawei.com [185.176.76.210])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F4424B337
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 09:57:52 -0400 (EDT)
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
 by Forcepoint Email with ESMTP id 1D9F829501C8A7DD5F64;
 Fri,  4 Sep 2020 14:57:51 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 14:57:50 +0100
Date: Fri, 4 Sep 2020 14:56:16 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/23] irqchip: Add Reduced Virtual Interrupt
 Distributor support
Message-ID: <20200904145616.00007950@Huawei.com>
In-Reply-To: <20200903152610.1078827-4-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-4-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu,  3 Sep 2020 16:25:50 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Hi Marc,

Again, only trivial stuff in here from me.

Jonathan

> ---
>  drivers/irqchip/Kconfig          |   6 +
>  drivers/irqchip/Makefile         |   1 +
>  drivers/irqchip/irq-rvid.c       | 259 +++++++++++++++++++++++++++++++
>  include/linux/irqchip/irq-rvic.h |  19 +++
>  4 files changed, 285 insertions(+)
>  create mode 100644 drivers/irqchip/irq-rvid.c
> 
...

> +static int rvid_irq_set_affinity(struct irq_data *data,
> +				 const struct cpumask *mask_val,
> +				 bool force)
> +{
> +	unsigned int old_cpu, cpu;
> +	bool masked, pending;
> +	int err = 0, ret;

Looks like err is set in all paths (might change in later patches of
course!)

> +	u64 mpidr;
> +
> +	if (force)
> +		cpu = cpumask_first(mask_val);
> +	else
> +		cpu = cpumask_any_and(mask_val, cpu_online_mask);
> +
> +	if (cpu >= nr_cpu_ids)
> +		return -EINVAL;
> +
> +	mpidr = cpu_logical_map(cpu) & MPIDR_HWID_BITMASK;
> +	old_cpu = cpumask_first(data->common->effective_affinity);
> +	if (cpu == old_cpu)
> +		return 0;
> +
> +	/* Mask on source */
> +	masked = irqd_irq_masked(data);
> +	if (!masked)
> +		irq_chip_mask_parent(data);
> +
> +	/* Switch to target */
> +	irq_data_update_effective_affinity(data, cpumask_of(cpu));
> +
> +	/* Mask on target */
> +	irq_chip_mask_parent(data);
> +
> +	/* Map the input signal to the new target */
> +	ret = rvid_map(data->hwirq, mpidr, data->parent_data->hwirq);
> +	if (ret != RVID_STATUS_SUCCESS) {
> +		err = -ENXIO;
> +		goto unmask;
> +	}
> +
> +	/* Back to the source */
> +	irq_data_update_effective_affinity(data, cpumask_of(old_cpu));
> +
> +	/* Sample pending state and clear it if necessary */
> +	err = irq_chip_get_parent_state(data, IRQCHIP_STATE_PENDING, &pending);
> +	if (err)
> +		goto unmask;
> +	if (pending)
> +		irq_chip_set_parent_state(data, IRQCHIP_STATE_PENDING, false);
> +
> +	/*
> +	 * To the target again (for good this time), propagating the
> +	 * pending bit if required.
> +	 */
> +	irq_data_update_effective_affinity(data, cpumask_of(cpu));
> +	if (pending)
> +		irq_chip_set_parent_state(data, IRQCHIP_STATE_PENDING, true);
> +unmask:
> +	/* Propagate the masking state */
> +	if (!masked)
> +		irq_chip_unmask_parent(data);
> +
> +	return err;
> +}
> +

...

> +static int rvid_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				 unsigned int nr_irqs, void *arg)
> +{
> +	struct irq_fwspec *fwspec = arg;
> +	unsigned int type = IRQ_TYPE_NONE;
> +	irq_hw_number_t hwirq;
> +	int i, ret;
> +
> +	ret = irq_domain_translate_onecell(domain, fwspec, &hwirq, &type);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		unsigned int intid = hwirq + i;
> +		unsigned int irq = virq + i;
> +
> +		/* Get the rVIC to allocate any untrusted intid */
> +		ret = irq_domain_alloc_irqs_parent(domain, irq, 1, NULL);
> +		if (WARN_ON(ret))
> +			return ret;
> +
> +		irq_domain_set_hwirq_and_chip(domain, irq, intid,
> +					      &rvid_chip, &rvid);
> +		irqd_set_affinity_on_activate(irq_get_irq_data(irq));
> +	}
> +
> +	return 0;
> +}
> +
> +static void rvid_irq_domain_free(struct irq_domain *domain, unsigned int virq,
> +				 unsigned int nr_irqs)
> +{
> +	int i;
> +
> +	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		struct irq_data *d;

Trivial but for ease of comparison with _alloc, perhaps add

                unsigned int int = virq + i;
> +
> +		d = irq_domain_get_irq_data(domain, virq + i);
> +		irq_set_handler(virq + i, NULL);
> +		irq_domain_reset_irq_data(d);
> +	}
> +}
> +


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
