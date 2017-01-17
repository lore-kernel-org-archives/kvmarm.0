From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 25/33] irqchip/gic-v3-its: Add VPE invalidation hook
Date: Tue, 17 Jan 2017 10:20:46 +0000
Message-ID: <1484648454-21216-26-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC4B4086A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xlfmCTkEKquF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E35840822
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:58 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

When a guest issues a INVALL command targetting a collection, it must
be translated into a VINVALL for the VPE that has this collection.

This patch implements a hook that offers this functionallity to the
hypervisor.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index f918d59..51a1930 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2090,6 +2090,12 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 		return 0;
 	}
 
+	case INVALL_VPE:
+	{
+		its_send_vinvall(vpe);
+		return 0;
+	}
+
 	default:
 		return -EINVAL;
 	}
-- 
2.1.4
