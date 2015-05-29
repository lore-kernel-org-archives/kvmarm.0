From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 07/13] KVM: arm64: implement basic ITS register handlers
Date: Fri, 29 May 2015 10:53:23 +0100
Message-ID: <1432893209-27313-8-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA80852477
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f7Skj445fcAG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 05:43:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADC4152443
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:52 -0400 (EDT)
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add emulation for some basic MMIO registers used in the ITS emulation.
This includes:
- GITS_{CTLR,TYPER,IIDR}
- ID registers
- GITS_{CBASER,CREAD,CWRITER}
  those implement the ITS command buffer handling

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h             |   3 +
 include/linux/irqchip/arm-gic-v3.h |   8 ++
 virt/kvm/arm/its-emul.c            | 172 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h            |   1 +
 virt/kvm/arm/vgic-v3-emul.c        |   2 +
 5 files changed, 186 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d76c2d9..3b8e3a1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -159,6 +159,9 @@ struct vgic_io_device {
 struct vgic_its {
 	bool			enabled;
 	spinlock_t		lock;
+	u64			cbaser;
+	int			creadr;
+	int			cwriter;
 };
 
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index df4e527..0b450c7 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -179,15 +179,23 @@
 #define GITS_BASER			0x0100
 #define GITS_IDREGS_BASE		0xffd0
 #define GITS_PIDR2			GICR_PIDR2
+#define GITS_PIDR4			0xffd0
+#define GITS_CIDR0			0xfff0
+#define GITS_CIDR1			0xfff4
+#define GITS_CIDR2			0xfff8
+#define GITS_CIDR3			0xfffc
 
 #define GITS_TRANSLATER			0x10040
 
 #define GITS_CTLR_ENABLE		(1U << 0)
 #define GITS_CTLR_QUIESCENT		(1U << 31)
 
+#define GITS_TYPER_PLPIS		(1UL << 0)
+#define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
 #define GITS_TYPER_PTA			(1UL << 19)
+#define GITS_TYPER_HWCOLLCNT_SHIFT	24
 
 #define GITS_CBASER_VALID		(1UL << 63)
 #define GITS_CBASER_nCnB		(0UL << 59)
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index 7b283ce..82bc34a 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -32,10 +32,62 @@
 #include "vgic.h"
 #include "its-emul.h"
 
+#define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
+
+/* distributor lock is hold by the VGIC MMIO handler */
 static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
 				  struct kvm_exit_mmio *mmio,
 				  phys_addr_t offset)
 {
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	u32 reg;
+	bool was_enabled;
+
+	switch (offset & ~3) {
+	case 0x00:		/* GITS_CTLR */
+		/* We never defer any command execution. */
+		reg = GITS_CTLR_QUIESCENT;
+		if (its->enabled)
+			reg |= GITS_CTLR_ENABLE;
+		was_enabled = its->enabled;
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
+		its->enabled = !!(reg & GITS_CTLR_ENABLE);
+		return !was_enabled && its->enabled;
+	case 0x04:		/* GITS_IIDR */
+		reg = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
+		break;
+	case 0x08:		/* GITS_TYPER */
+		/*
+		 * We use linear CPU numbers for redistributor addressing,
+		 * so GITS_TYPER.PTA is 0.
+		 * To avoid memory waste on the guest side, we keep the
+		 * number of IDBits and DevBits low for the time being.
+		 * This could later be made configurable by userland.
+		 * Since we have all collections in linked list, we claim
+		 * that we can hold all of the collection tables in our
+		 * own memory and that the ITT entry size is 1 byte (the
+		 * smallest possible one).
+		 */
+		reg = GITS_TYPER_PLPIS;
+		reg |= 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
+		reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
+		reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
+		break;
+	case 0x0c:
+		/* The upper 32bits of TYPER are all 0 for the time being.
+		 * Should we need more than 256 collections, we can enable
+		 * some bits in here.
+		 */
+		vgic_reg_access(mmio, NULL, offset & 3,
+				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+		break;
+	}
+
 	return false;
 }
 
@@ -43,20 +95,107 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
 				    struct kvm_exit_mmio *mmio,
 				    phys_addr_t offset)
 {
+	u32 reg = 0;
+	int idreg = (offset & ~3) + GITS_IDREGS_BASE;
+
+	switch (idreg) {
+	case GITS_PIDR2:
+		reg = GIC_PIDR2_ARCH_GICv3;
+		break;
+	case GITS_PIDR4:
+		/* This is a 64K software visible page */
+		reg = 0x40;
+		break;
+	/* Those are the ID registers for (any) GIC. */
+	case GITS_CIDR0:
+		reg = 0x0d;
+		break;
+	case GITS_CIDR1:
+		reg = 0xf0;
+		break;
+	case GITS_CIDR2:
+		reg = 0x05;
+		break;
+	case GITS_CIDR3:
+		reg = 0xb1;
+		break;
+	}
+	vgic_reg_access(mmio, &reg, offset & 3,
+			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
 	return false;
 }
 
+static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
+{
+	return -ENODEV;
+}
+
 static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
 				    struct kvm_exit_mmio *mmio,
 				    phys_addr_t offset)
 {
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	int mode = ACCESS_READ_VALUE;
+
+	mode |= its->enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
+
+	vgic_handle_base_register(vcpu, mmio, offset, &its->cbaser, mode);
+	if (mmio->is_write)
+		its->creadr = 0;
 	return false;
 }
 
+static int its_cmd_buffer_size(struct kvm *kvm)
+{
+	struct vgic_its *its = &kvm->arch.vgic.its;
+
+	return ((its->cbaser & 0xff) + 1) << 12;
+}
+
+static gpa_t its_cmd_buffer_base(struct kvm *kvm)
+{
+	struct vgic_its *its = &kvm->arch.vgic.its;
+
+	return BASER_BASE_ADDRESS(its->cbaser);
+}
+
 static bool handle_mmio_gits_cwriter(struct kvm_vcpu *vcpu,
 				     struct kvm_exit_mmio *mmio,
 				     phys_addr_t offset)
 {
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	u64 cmd_buf[4];
+	gpa_t cbaser = its_cmd_buffer_base(vcpu->kvm);
+	u32 reg;
+	int ret;
+
+	spin_lock(&its->lock);
+	switch (offset & ~3) {
+	case 0x00:
+		reg = its->cwriter & 0xfffe0;
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
+		reg &= 0xfffe0;
+		if (reg > its_cmd_buffer_size(vcpu->kvm))
+			break;
+		while (its->creadr != reg) {
+			ret = kvm_read_guest(vcpu->kvm, cbaser + its->creadr,
+					     cmd_buf, 32);
+			if (ret)
+				break;
+			vits_handle_command(vcpu, cmd_buf);
+			its->creadr += 32;
+			if (its->creadr == its_cmd_buffer_size(vcpu->kvm))
+				its->creadr = 0;
+		}
+		its->cwriter = reg;
+		break;
+	case 0x04:
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+		break;
+	}
+	spin_unlock(&its->lock);
 	return false;
 }
 
@@ -64,6 +203,22 @@ static bool handle_mmio_gits_creadr(struct kvm_vcpu *vcpu,
 				    struct kvm_exit_mmio *mmio,
 				    phys_addr_t offset)
 {
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	u32 reg;
+
+	spin_lock(&its->lock);
+	switch (offset & ~3) {
+	case 0x00:
+		reg = its->creadr & 0xfffe0;
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
+		break;
+	case 0x04:
+		vgic_reg_access(mmio, &reg, offset & 3,
+				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+		break;
+	}
+	spin_unlock(&its->lock);
 	return false;
 }
 
@@ -119,9 +274,26 @@ int vits_init(struct kvm *kvm)
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_its_base))
 		return -ENXIO;
 
+	dist->pendbaser = kmalloc(sizeof(u64) * dist->nr_cpus, GFP_KERNEL);
+	if (!dist->pendbaser)
+		return -ENOMEM;
+
 	spin_lock_init(&its->lock);
 
 	its->enabled = false;
 
 	return -ENXIO;
 }
+
+void vits_destroy(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_its *its = &dist->its;
+
+	if (!vgic_has_its(kvm))
+		return;
+
+	kfree(dist->pendbaser);
+
+	its->enabled = false;
+}
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index 5dc8e2f..472a6d0 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -31,5 +31,6 @@
 
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vits_init(struct kvm *kvm);
+void vits_destroy(struct kvm *kvm);
 
 #endif
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 4e40684..fa81c4b 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -881,6 +881,8 @@ static void vgic_v3_destroy_model(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
+	vits_destroy(kvm);
+
 	kfree(dist->irq_spi_mpidr);
 	dist->irq_spi_mpidr = NULL;
 }
-- 
2.3.5
