From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 01/52] genirq: Let irq_set_vcpu_affinity() iterate over
 hierarchy
Date: Wed, 28 Jun 2017 16:03:20 +0100
Message-ID: <20170628150411.15846-2-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BC440D44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PrZlhBM+Wp7Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1986740187
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:30 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

When assigning an interrupt to a vcpu, it is not unlikely that
the level of the hierarchy implementing irq_set_vcpu_affinity
is not the top level (think a generic MSI domain on top of a
virtualization aware interrupt controller).

In such a case, let's iterate over the hierarchy until we find
an irqchip implementing it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 kernel/irq/manage.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 425170d4439b..804fb94e86e6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -431,8 +431,18 @@ int irq_set_vcpu_affinity(unsigned int irq, void *vcpu_info)
 		return -EINVAL;
 
 	data = irq_desc_get_irq_data(desc);
-	chip = irq_data_get_irq_chip(data);
-	if (chip && chip->irq_set_vcpu_affinity)
+	do {
+		chip = irq_data_get_irq_chip(data);
+		if (chip && chip->irq_set_vcpu_affinity)
+			break;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		data = data->parent_data;
+#else
+		data = NULL;
+#endif
+	} while (data);
+
+	if (data)
 		ret = chip->irq_set_vcpu_affinity(data, vcpu_info);
 	irq_put_desc_unlock(desc, flags);
 
-- 
2.11.0
