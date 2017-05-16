From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 1/3] KVM: arm/arm64: Allow GICv2 to supply a uaccess
 register function
Date: Tue, 16 May 2017 12:04:29 +0200
Message-ID: <20170516100431.4101-2-cdall@linaro.org>
References: <20170516100431.4101-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D85440625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 06:01:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gq3TXHSv7lgZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 06:01:18 -0400 (EDT)
Received: from mail-qk0-f169.google.com (mail-qk0-f169.google.com
 [209.85.220.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943B040A66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 06:01:18 -0400 (EDT)
Received: by mail-qk0-f169.google.com with SMTP id y201so123247687qka.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 03:04:46 -0700 (PDT)
In-Reply-To: <20170516100431.4101-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We are about to differentiate between writes from a VCPU and from
userspace to the GIC's GICD_ISACTIVER and GICD_ICACTIVER registers due
to different synchronization requirements.

Expand the macro to define a register description for the GIC to take
uaccess functions as well.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 +++++++++++-----------
 virt/kvm/arm/vgic/vgic-mmio.h    |  4 +++-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 0a4283e..95543a2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -296,34 +296,34 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
-		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
-		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
-		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
-		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
-		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
-		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
-		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
+		8, VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
-		vgic_mmio_read_target, vgic_mmio_write_target, 8,
+		vgic_mmio_read_target, vgic_mmio_write_target, NULL, NULL, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
-		vgic_mmio_read_config, vgic_mmio_write_config, 2,
+		vgic_mmio_read_config, vgic_mmio_write_config, NULL, NULL, 2,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
 		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index ea4171a..27924a3 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -75,7 +75,7 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
  * The _WITH_LENGTH version instantiates registers with a fixed length
  * and is mutually exclusive with the _PER_IRQ version.
  */
-#define REGISTER_DESC_WITH_BITS_PER_IRQ(off, rd, wr, bpi, acc)		\
+#define REGISTER_DESC_WITH_BITS_PER_IRQ(off, rd, wr, ur, uw, bpi, acc)	\
 	{								\
 		.reg_offset = off,					\
 		.bits_per_irq = bpi,					\
@@ -83,6 +83,8 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 		.access_flags = acc,					\
 		.read = rd,						\
 		.write = wr,						\
+		.uaccess_read = ur,					\
+		.uaccess_write = uw,					\
 	}
 
 #define REGISTER_DESC_WITH_LENGTH(off, rd, wr, length, acc)		\
-- 
2.9.0
