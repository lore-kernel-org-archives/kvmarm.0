From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 04/13] KVM: arm64: ITS: Implement vgic_its_has_attr_regs and
 attr_regs_access
Date: Thu, 12 Jan 2017 16:56:44 +0100
Message-ID: <1484236613-24633-5-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE66740674
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCzmmcuKgoVM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:29 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C366E406A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:29 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements vgic_its_has_attr_regs and vgic_its_attr_regs_access
upon the MMIO framework. VGIC ITS KVM device KVM_DEV_ARM_VGIC_GRP_ITS_REGS
group becomes functional.

At least GITS_CREADR requires to differentiate a guest write action from a
user access. As such let's introduce a new uaccess_its_write
vgic_register_region callback.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c  | 74 ++++++++++++++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic-mmio.h |  9 ++++--
 2 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 058034d..55671585 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1287,13 +1287,14 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	*regptr = reg;
 }
 
-#define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
+#define REGISTER_ITS_DESC(off, rd, wr, uwr, length, acc)		\
 {								\
 	.reg_offset = off,					\
 	.len = length,						\
 	.access_flags = acc,					\
 	.its_read = rd,						\
 	.its_write = wr,					\
+	.uaccess_its_write = uwr,					\
 }
 
 static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
@@ -1304,28 +1305,28 @@ static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
 
 static struct vgic_register_region its_registers[] = {
 	REGISTER_ITS_DESC(GITS_CTLR,
-		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
+		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, NULL, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_IIDR,
-		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
+		vgic_mmio_read_its_iidr, its_mmio_write_wi, NULL, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_TYPER,
-		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_typer, its_mmio_write_wi, NULL, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CBASER,
-		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, 8,
+		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, NULL, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CWRITER,
-		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
-		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, NULL,
+		8, VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CREADR,
-		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_creadr, its_mmio_write_wi, NULL, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_BASER,
-		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
+		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, NULL, 0x40,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
-		vgic_mmio_read_its_idregs, its_mmio_write_wi, 0x30,
+		vgic_mmio_read_its_idregs, its_mmio_write_wi, NULL, 0x30,
 		VGIC_ACCESS_32bit),
 };
 
@@ -1448,14 +1449,63 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 int vgic_its_has_attr_regs(struct kvm_device *dev,
 			   struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	const struct vgic_register_region *region;
+	struct vgic_io_device iodev = {
+		.regions = its_registers,
+		.nr_regions = ARRAY_SIZE(its_registers),
+	};
+	gpa_t offset;
+
+	offset = attr->attr;
+
+	region = vgic_find_mmio_region(iodev.regions,
+				       iodev.nr_regions,
+				       offset);
+	if (!region)
+		return -ENXIO;
+	return 0;
 }
 
 int vgic_its_attr_regs_access(struct kvm_device *dev,
 			      struct kvm_device_attr *attr,
 			      u64 *reg, bool is_write)
 {
-	return -ENXIO;
+	const struct vgic_register_region *region;
+	struct vgic_io_device iodev = {
+		.regions = its_registers,
+		.nr_regions = ARRAY_SIZE(its_registers),
+	};
+	struct vgic_its *its = dev->private;
+	gpa_t addr, offset;
+	unsigned int len;
+
+	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
+		return -ENXIO;
+
+	offset = attr->attr;
+	if (offset & 0x7)
+		return -EINVAL;
+
+	addr = its->vgic_its_base + offset;
+
+	region = vgic_find_mmio_region(iodev.regions,
+				       iodev.nr_regions,
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (is_write) {
+		if (region->uaccess_its_write)
+			region->uaccess_its_write(dev->kvm, its, addr,
+						  len, *reg);
+		else
+			region->its_write(dev->kvm, its, addr, len, *reg);
+	} else {
+		*reg = region->its_read(dev->kvm, its, addr, len);
+	}
+	return 0;
 }
 
 static int vgic_its_has_attr(struct kvm_device *dev,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index ecf8bfb..4ab93cf 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -36,8 +36,13 @@ struct vgic_register_region {
 	};
 	unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
 				      unsigned int len);
-	void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
-			      unsigned int len, unsigned long val);
+	union {
+		void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
+				      unsigned int len, unsigned long val);
+		void (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
+					  gpa_t addr, unsigned int len,
+					  unsigned long val);
+	};
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
-- 
2.5.5
