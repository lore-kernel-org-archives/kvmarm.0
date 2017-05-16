From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 2/3] KVM: arm/arm64: Separate guest and uaccess writes to dist {sc}active
Date: Tue, 16 May 2017 12:04:30 +0200
Message-ID: <20170516100431.4101-3-cdall@linaro.org>
References: <20170516100431.4101-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516100431.4101-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Factor out the core register modifier functionality from the entry
points from the register description table, and only call the
prepare/finish functions from the guest path, not the uaccess path.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 +++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  8 ++++---
 virt/kvm/arm/vgic/vgic-mmio.c    | 50 ++++++++++++++++++++++++++++++++++------
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 +++++++
 4 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 95543a2..8bafe9a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -311,10 +311,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive,
+		NULL, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_cactive,
+		NULL, vgic_mmio_uaccess_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 99da1a2..23c0d564 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -456,11 +456,13 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive,
+		NULL, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
-		VGIC_ACCESS_32bit),
+		vgic_mmio_read_active, vgic_mmio_write_cactive,
+		NULL, vgic_mmio_uaccess_write_cactive,
+		1, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
 		8, VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 1c17b2a..64cbcb4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -251,38 +251,74 @@ static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
 
-void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
-			     gpa_t addr, unsigned int len,
-			     unsigned long val)
+static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len,
+				      unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 
-	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, false);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
-	vgic_change_active_finish(vcpu, intid);
 }
 
-void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
-	int i;
 
 	vgic_change_active_prepare(vcpu, intid);
+
+	__vgic_mmio_write_cactive(vcpu, addr, len, val);
+
+	vgic_change_active_finish(vcpu, intid);
+}
+
+void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	__vgic_mmio_write_cactive(vcpu, addr, len, val);
+}
+
+static void __vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len,
+				      unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, true);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+}
+
+void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+
+	vgic_change_active_prepare(vcpu, intid);
+
+	__vgic_mmio_write_sactive(vcpu, addr, len, val);
+
 	vgic_change_active_finish(vcpu, intid);
 }
 
+void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	__vgic_mmio_write_sactive(vcpu, addr, len, val);
+}
+
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len)
 {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 27924a3..5693f6df 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -167,6 +167,14 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
+void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val);
+
+void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val);
+
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len);
 
-- 
2.9.0
