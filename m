Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCC9C4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 16:17:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5793F21D56
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 16:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5793F21D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B93F4A715;
	Thu, 26 Sep 2019 12:17:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E--DzLR0VauT; Thu, 26 Sep 2019 12:17:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A157B4A719;
	Thu, 26 Sep 2019 12:17:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F6E4A715
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 12:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3t4dA5Qo2O7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 12:17:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A9B4A714
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 12:17:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E1AD28;
 Thu, 26 Sep 2019 09:17:32 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 A02A13F534; Thu, 26 Sep 2019 09:17:31 -0700 (PDT)
Subject: Re: [PATCH 03/35] irqchip/gic-v3-its: Allow LPI invalidation via the
 DirectLPI interface
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-4-maz@kernel.org>
 <92ff82ca-ebcb-8f5f-5063-313f65bbc5e3@huawei.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <22202880-9a99-f0d9-4737-6112d60b30a6@kernel.org>
Date: Thu, 26 Sep 2019 17:17:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <92ff82ca-ebcb-8f5f-5063-313f65bbc5e3@huawei.com>
Content-Language: en-US
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

On 26/09/2019 15:57, Zenghui Yu wrote:
> Hi Marc,
> 
> I get one kernel panic with this patch on D05.

Can you please try this (completely untested for now) on top of the 
whole series? I'll otherwise give it a go next week.

Thanks,

	M.

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bc55327406b7..9d24236d1257 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3461,15 +3461,16 @@ static void its_vpe_send_cmd(struct its_vpe *vpe,
 
 static void its_vpe_send_inv(struct irq_data *d)
 {
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+
 	if (gic_rdists->has_direct_lpi) {
-		/*
-		 * Don't mess about. Generating the invalidation is easily
-		 * done by using the parent irq_data, just like below.
-		 */
-		direct_lpi_inv(d->parent_data);
-	} else {
-		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+		void __iomem *rdbase;
 
+		/* Target the redistributor this VPE is currently known on */
+		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
+		wait_for_syncr(rdbase);
+	} else {
 		its_vpe_send_cmd(vpe, its_send_inv);
 	}
 }

-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
