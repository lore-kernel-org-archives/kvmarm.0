From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/58] KVM: arm/arm64: Allow GICv2 to supply a uaccess register function
Date: Fri, 30 Jun 2017 09:44:19 +0100
Message-ID: <20170630084514.6779-4-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, David Daney <david.daney@cavium.com>, Eric Auger <eric.auger@redhat.com>, Hu Huajun <huhuajun@huawei.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Stefan Traby <stefan@hello-penguin.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We are about to differentiate between writes from a VCPU and from
userspace to the GIC's GICD_ISACTIVER and GICD_ICACTIVER registers due
to different synchronization requirements.

Expand the macro to define a register description for the GIC to take
uaccess functions as well.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 +++++++++++-----------
 virt/kvm/arm/vgic/vgic-mmio.h    |  4 +++-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 0a4283ed9aa7..95543a20513a 100644
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
index ea4171acdef3..27924a3d8769 100644
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
2.11.0
