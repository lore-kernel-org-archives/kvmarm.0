From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 12/15] arm: setup SPI IRQ routing tables
Date: Wed, 20 Jul 2016 18:04:32 +0100
Message-ID: <20160720170435.28090-13-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FBA49B60
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:58:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N+7e7TgGSX6Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 12:58:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3647049B3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:57:54 -0400 (EDT)
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Since we soon start using GSI routing on ARM platforms too, we have
to setup the initial SPI routing table. Before the first call to
KVM_SET_GSI_ROUTING, the kernel holds this table internally, but this
is overwritten with the ioctl, so we have to explicitly set it up
here.
The routing is actually not used for IRQs triggered by KVM_IRQ_LINE,
but it needs to be here anyway. We use a simple 1:1 mapping.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 12139fe..a0b392e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -19,6 +19,8 @@
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
 #endif
 
+#define IRQCHIP_GIC 0
+
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
@@ -41,6 +43,34 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int irq__routing_init(struct kvm *kvm)
+{
+	int r;
+	int irqlines = ALIGN(irq__get_nr_allocated_lines(), 32);
+
+	/*
+	 * This describes the default routing that the kernel uses without
+	 * any routing explicitly set up via KVM_SET_GSI_ROUTING. So we
+	 * don't need to commit these setting right now. The first actual
+	 * user (MSI routing) will engage these mappings then.
+	 */
+	for (next_gsi = 0; next_gsi < irqlines; next_gsi++) {
+		r = irq__allocate_routing_entry();
+		if (r)
+			return r;
+
+		irq_routing->entries[irq_routing->nr++] =
+			(struct kvm_irq_routing_entry) {
+				.gsi = next_gsi,
+				.type = KVM_IRQ_ROUTING_IRQCHIP,
+				.u.irqchip.irqchip = IRQCHIP_GIC,
+				.u.irqchip.pin = next_gsi,
+		};
+	}
+
+	return 0;
+}
+
 static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
 {
 	struct kvm_create_device its_device = {
@@ -247,6 +277,8 @@ static int gic__init_gic(struct kvm *kvm)
 			return ret;
 	}
 
+	irq__routing_init(kvm);
+
 	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
 		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &vgic_init_attr);
 		if (ret)
-- 
2.9.0
