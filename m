From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 10/24] KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_iidr
Date: Thu,  4 May 2017 13:44:30 +0200
Message-ID: <1493898284-29504-11-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

The GITS_IIDR revision field is used to encode the migration ABI
revision. So we need to restore it to check the table layout is
readable by the destination.

By writing the IIDR, userspace thus forces the ABI revision to be
used and this must be less than or equal to the max revision KVM
supports.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- fix typos in the commit message
- dont't use update_64bit_reg anymore

v4 -> v5
- rename user_revision into abi_rev and REV into MAX_ABI_REV
- IIDR reports abi_rev set by userspace if any.
- If value set by userspace exceeds the max supported revision, an
  error is reported.
- add some defines

v4: creation
---
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 virt/kvm/arm/vgic/vgic-its.c       | 20 +++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 81ebe43..59f1abd 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -242,6 +242,10 @@
 #define GITS_TYPER_PTA			(1UL << 19)
 #define GITS_TYPER_HWCOLLCNT_SHIFT	24
 
+#define GITS_IIDR_REV_SHIFT		12
+#define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
+#define GITS_IIDR_PRODUCTID_SHIFT	24
+
 #define GITS_CBASER_VALID			(1ULL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
 #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c336cce..072efbd 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -411,7 +411,20 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
 					     struct vgic_its *its,
 					     gpa_t addr, unsigned int len)
 {
-	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+	return (PRODUCT_ID_KVM << GITS_IIDR_PRODUCTID_SHIFT) |
+	       (its->abi_rev << GITS_IIDR_REV_SHIFT) | IMPLEMENTER_ARM;
+}
+
+static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
+					    struct vgic_its *its,
+					    gpa_t addr, unsigned int len,
+					    unsigned long val)
+{
+	u32 rev = GITS_IIDR_REV(val);
+
+	if (rev > MAX_ABI_REV)
+		return -EINVAL;
+	return vgic_its_set_abi(its, rev);
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
@@ -1393,8 +1406,9 @@ static struct vgic_register_region its_registers[] = {
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
-- 
2.5.5
