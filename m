Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A18C4CED0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9F8A217F4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9F8A217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D8294A68A;
	Mon, 23 Sep 2019 14:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gmk8j838gmLj; Mon, 23 Sep 2019 14:28:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 696194A64B;
	Mon, 23 Sep 2019 14:28:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D69C44A682
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tOoWy7ITWqP8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:28:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D85A44A685
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A30B528AC;
 Mon, 23 Sep 2019 11:28:14 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F225A3F694;
 Mon, 23 Sep 2019 11:28:11 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 29/35] irqchip/gic-v4.1: Add VSGI allocation/teardown
Date: Mon, 23 Sep 2019 19:26:00 +0100
Message-Id: <20190923182606.32100-30-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

Allocate per-VPE SGIs when initializing the GIC-specific part of the
VPE data structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v4.c       | 68 +++++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-v4.h |  2 +
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 60b51d6683aa..a29a063861bc 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -92,6 +92,47 @@ static bool has_v4_1(void)
 	return !!sgi_domain_ops;
 }
 
+static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
+{
+	char *name;
+	int sgi_base;
+
+	if (!has_v4_1())
+		return 0;
+
+	name = kasprintf(GFP_KERNEL, "GICv4-sgi-%d", task_pid_nr(current));
+	if (!name)
+		goto err;
+
+	vpe->fwnode = irq_domain_alloc_named_id_fwnode(name, idx);
+	if (!vpe->fwnode)
+		goto err;
+
+	kfree(name);
+	name = NULL;
+
+	vpe->sgi_domain = irq_domain_create_linear(vpe->fwnode, 16,
+						   sgi_domain_ops, vpe);
+	if (!vpe->sgi_domain)
+		goto err;
+
+	sgi_base = __irq_domain_alloc_irqs(vpe->sgi_domain, -1, 16,
+					       NUMA_NO_NODE, vpe,
+					       false, NULL);
+	if (sgi_base <= 0)
+		goto err;
+
+	return 0;
+
+err:
+	if (vpe->sgi_domain)
+		irq_domain_remove(vpe->sgi_domain);
+	if (vpe->fwnode)
+		irq_domain_free_fwnode(vpe->fwnode);
+	kfree(name);
+	return -ENOMEM;
+}
+
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
 	int vpe_base_irq, i;
@@ -118,8 +159,13 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 	if (vpe_base_irq <= 0)
 		goto err;
 
-	for (i = 0; i < vm->nr_vpes; i++)
+	for (i = 0; i < vm->nr_vpes; i++) {
+		int ret;
 		vm->vpes[i]->irq = vpe_base_irq + i;
+		ret = its_alloc_vcpu_sgis(vm->vpes[i], i);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 
@@ -132,8 +178,28 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 	return -ENOMEM;
 }
 
+static void its_free_sgi_irqs(struct its_vm *vm)
+{
+	int i;
+
+	if (!has_v4_1())
+		return;
+
+	for (i = 0; i < vm->nr_vpes; i++) {
+		unsigned int irq = irq_find_mapping(vm->vpes[i]->sgi_domain, 0);
+
+		if (WARN_ON(!irq))
+			continue;
+
+		irq_domain_free_irqs(irq, 16);
+		irq_domain_remove(vm->vpes[i]->sgi_domain);
+		irq_domain_free_fwnode(vm->vpes[i]->fwnode);
+	}
+}
+
 void its_free_vcpu_irqs(struct its_vm *vm)
 {
+	its_free_sgi_irqs(vm);
 	irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
 	irq_domain_remove(vm->domain);
 	irq_domain_free_fwnode(vm->fwnode);
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 084890a5c2bf..5578cbe7430b 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -47,6 +47,8 @@ struct its_vpe {
 		};
 		/* GICv4.1 implementations */
 		struct {
+			struct fwnode_handle	*fwnode;
+			struct irq_domain	*sgi_domain;
 			struct {
 				u8	priority;
 				bool	enabled;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
