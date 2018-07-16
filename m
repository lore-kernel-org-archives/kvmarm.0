From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v4 06/10] KVM: arm/arm64: vgic: Permit uaccess writes to
 return errors
Date: Mon, 16 Jul 2018 15:06:23 +0200
Message-ID: <1531746387-7033-7-git-send-email-christoffer.dall@arm.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF004A11E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:53:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id obx9FvXnJlYz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 08:53:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521504A15C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:53:52 -0400 (EDT)
In-Reply-To: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we do not allow any vgic mmio write operations to fail, which
makes sense from mmio traps from the guest.  However, we should be able
to report failures to userspace, if userspace writes incompatible values
to read-only registers.  Rework the internal interface to allow errors
to be returned on the write side for userspace writes.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 12 +++++++-----
 virt/kvm/arm/vgic/vgic-mmio.c    | 18 +++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio.h    | 19 +++++++++++--------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ebe10a0..ef57a1a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -249,9 +249,9 @@ static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
-static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
-					  gpa_t addr, unsigned int len,
-					  unsigned long val)
+static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
+					 gpa_t addr, unsigned int len,
+					 unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
@@ -276,6 +276,8 @@ static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+
+	return 0;
 }
 
 /* We want to avoid outer shareable. */
@@ -468,7 +470,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
@@ -541,7 +543,7 @@ static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ff9655c..e1e7998 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -40,6 +40,13 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 	/* Ignore */
 }
 
+int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+			       unsigned int len, unsigned long val)
+{
+	/* Ignore */
+	return 0;
+}
+
 /*
  * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
  * of the enabled bit, so there is only one function for both here.
@@ -363,11 +370,12 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
-void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len,
 				     unsigned long val)
 {
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
+	return 0;
 }
 
 static void __vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
@@ -399,11 +407,12 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
-void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len,
 				     unsigned long val)
 {
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
+	return 0;
 }
 
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
@@ -735,10 +744,9 @@ static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
 	if (region->uaccess_write)
-		region->uaccess_write(r_vcpu, addr, sizeof(u32), *val);
-	else
-		region->write(r_vcpu, addr, sizeof(u32), *val);
+		return region->uaccess_write(r_vcpu, addr, sizeof(u32), *val);
 
+	region->write(r_vcpu, addr, sizeof(u32), *val);
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 5693f6df..9c3d6d3 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -37,8 +37,8 @@ struct vgic_register_region {
 	unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
 				      unsigned int len);
 	union {
-		void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
-				      unsigned int len, unsigned long val);
+		int (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
+				     unsigned int len, unsigned long val);
 		int (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
 					 gpa_t addr, unsigned int len,
 					 unsigned long val);
@@ -134,6 +134,9 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
 void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 			unsigned int len, unsigned long val);
 
+int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+			       unsigned int len, unsigned long val);
+
 unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
@@ -167,13 +170,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
-void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len,
-				     unsigned long val);
+int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val);
 
-void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len,
-				     unsigned long val);
+int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val);
 
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len);
-- 
2.7.4
