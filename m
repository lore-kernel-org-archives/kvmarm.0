From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 34/52] irqchip/gic-v3: Advertise GICv4 support to KVM
Date: Wed, 28 Jun 2017 16:03:53 +0100
Message-ID: <20170628150411.15846-35-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CC049BFC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TtPN9Mrti9y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8615C40D6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:26 -0400 (EDT)
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

As KVM needs to know about the availability of GICv4 to enable
direct injection of interrupts, let's advertise the feature in
the gic_kvm_info structure.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c           | 2 ++
 include/linux/irqchip/arm-gic-common.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index efbd998baa9c..7ce88148da1f 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1156,6 +1156,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 	if (!ret)
 		gic_v3_kvm_info.vcpu = r;
 
+	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
@@ -1452,6 +1453,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 		vcpu->end = vcpu->start + ACPI_GICV2_VCPU_MEM_SIZE - 1;
 	}
 
+	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index c647b0547bcd..0a83b4379f34 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -27,6 +27,8 @@ struct gic_kvm_info {
 	unsigned int	maint_irq;
 	/* Virtual control interface */
 	struct resource vctrl;
+	/* vlpi support */
+	bool		has_v4;
 };
 
 const struct gic_kvm_info *gic_get_kvm_info(void);
-- 
2.11.0
