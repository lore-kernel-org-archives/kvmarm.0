From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 24/52] irqchip/gic-v3-its: Add VPE invalidation hook
Date: Wed, 28 Jun 2017 16:03:43 +0100
Message-ID: <20170628150411.15846-25-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF8843C8D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ovnzIicPaTFc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 511F543C75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:09 -0400 (EDT)
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

When a guest issues a INVALL command targetting a collection, it must
be translated into a VINVALL for the VPE that has this collection.

This patch implements a hook that offers this functionallity to the
hypervisor.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index be8598354d5a..0eda36dc84b4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2211,6 +2211,10 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 		its_vpe_deschedule(vpe);
 		return 0;
 
+	case INVALL_VPE:
+		its_send_vinvall(vpe);
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
-- 
2.11.0
