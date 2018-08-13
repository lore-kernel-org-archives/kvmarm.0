From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/37] KVM: arm/arm64: vgic: Allow configuration of interrupt
 groups
Date: Mon, 13 Aug 2018 15:57:37 +0100
Message-ID: <20180813145755.16566-20-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2214A1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2fgMM40UJXXr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06C764A238
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:51 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Implement the required MMIO accessors for GICv2 and GICv3 for the
IGROUPR distributor and redistributor registers.

This can allow guests to change behavior compared to running on previous
versions of KVM, but only to align with the architecture and hardware
implementations.

This also allows userspace to configure the interrupts groups for GICv3.
We don't allow userspace to write the groups on GICv2 just yet, because
that would result in GICv2 guests not receiving interrupts after
migrating from an older kernel that exposes GICv2 interrupts as group 1.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c    |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 13 ++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 11 +++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  6 +++++
 5 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a7c19cda5835..c0c0b88af1d5 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -313,7 +313,7 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
-	dist->implementation_rev = 1;
+	dist->implementation_rev = 2;
 	dist->initialized = true;
 
 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 4f0f2c4165ec..ee164f831401 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -26,6 +26,8 @@
  * The Revision field in the IIDR have the following meanings:
  *
  * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
+ * Revision 2: Interrupt groups are guest-configurable and signaled using
+ * 	       their configured groups.
  */
 
 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
@@ -89,6 +91,14 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len,
+					    unsigned long val)
+{
+	/* Ignore writes from userspace */
+	return 0;
+}
+
 static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 				 gpa_t addr, unsigned int len,
 				 unsigned long val)
@@ -386,7 +396,8 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		NULL, vgic_mmio_uaccess_write_v2_misc,
 		12, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
+		vgic_mmio_read_group, vgic_mmio_write_group,
+		NULL, vgic_mmio_uaccess_write_v2_group, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index abdb0ec77b38..88e78b582139 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -59,6 +59,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
 }
 
+/*
+ * The Revision field in the IIDR have the following meanings:
+ *
+ * Revision 2: Interrupt groups are guest-configurable and signaled using
+ * 	       their configured groups.
+ */
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -471,7 +478,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
-		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
+		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
@@ -544,7 +551,7 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 
 static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
-		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
+		vgic_mmio_read_group, vgic_mmio_write_group, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index e1e79989d473..f56ff1cf52ec 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -47,6 +47,44 @@ int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 	return 0;
 }
 
+unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 value = 0;
+	int i;
+
+	/* Loop over all IRQs affected by this read */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->group)
+			value |= BIT(i);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return value;
+}
+
+void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
+			   unsigned int len, unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock_irqsave(&irq->irq_lock, flags);
+		irq->group = !!(val & BIT(i));
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 /*
  * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
  * of the enabled bit, so there is only one function for both here.
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 9c3d6d358014..a07f90acdaec 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -137,6 +137,12 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 			       unsigned int len, unsigned long val);
 
+unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu, gpa_t addr,
+				   unsigned int len);
+
+void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
+			   unsigned int len, unsigned long val);
+
 unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
-- 
2.18.0
