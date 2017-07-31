From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 35/59] irqchip/gic-v3: Advertise GICv4 support to KVM
Date: Mon, 31 Jul 2017 18:26:13 +0100
Message-ID: <20170731172637.29355-36-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
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
index 17f0ad41864f..e2b8409dd76e 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1159,6 +1159,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 	if (!ret)
 		gic_v3_kvm_info.vcpu = r;
 
+	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
 	gic_set_kvm_info(&gic_v3_kvm_info);
 }
 
@@ -1455,6 +1456,7 @@ static void __init gic_acpi_setup_kvm_info(void)
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
