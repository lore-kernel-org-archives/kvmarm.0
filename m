From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Mon, 27 Mar 2017 11:30:58 +0200
Message-ID: <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC1B40AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kSQhm0ccPRpB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:30:04 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4D5A40A14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:04 -0400 (EDT)
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The GITS_IIDR revision field is used to encode the version of the
table layout (ABI). So we need to restore it to check the table
layout to be restored is compatible with the destination vITS.

The user selected revision is stored in the user_revision field.
It will be compared against the REV num at table restoration time.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4: creation
---
 include/kvm/arm_vgic.h       |  2 ++
 virt/kvm/arm/vgic/vgic-its.c | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b72dd2a..41b71ca 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -162,6 +162,8 @@ struct vgic_its {
 	u32			creadr;
 	u32			cwriter;
 
+	u32			user_revision;
+
 	/* Protects the device and collection lists */
 	struct mutex		its_lock;
 	struct list_head	device_list;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a5f3abe..169b486 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -33,6 +33,9 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+/* ITS Table Layout ABI Revision */
+#define REV 0x1
+
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
  * If this LPI is already mapped on another ITS, we increase its refcount
@@ -384,7 +387,19 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
 					     struct vgic_its *its,
 					     gpa_t addr, unsigned int len)
 {
-	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+	return (PRODUCT_ID_KVM << 24) | (REV << 12) | IMPLEMENTER_ARM;
+}
+
+static void vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
+					     struct vgic_its *its,
+					     gpa_t addr, unsigned int len,
+					     unsigned long val)
+{
+	u64 tmp = 0;
+
+	tmp = update_64bit_reg(tmp, addr & 3, len, val);
+	tmp = (tmp & GENMASK(15, 12)) >> 12;
+	its->user_revision = tmp;
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
@@ -1359,8 +1374,9 @@ static struct vgic_register_region its_registers[] = {
 	REGISTER_ITS_DESC(GITS_CTLR,
 		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_ITS_DESC(GITS_IIDR,
-		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
+	REGISTER_ITS_DESC_UACCESS(GITS_IIDR,
+		vgic_mmio_read_its_iidr, its_mmio_write_wi,
+		vgic_mmio_uaccess_write_its_iidr, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_TYPER,
 		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
@@ -1458,6 +1474,8 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
 	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
 
+	its->user_revision = 0;
+
 	dev->private = its;
 
 	return 0;
-- 
2.5.5
