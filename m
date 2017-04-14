From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 10/22] KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_iidr
Date: Fri, 14 Apr 2017 12:15:22 +0200
Message-ID: <1492164934-988-11-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The GITS_IIDR revision field is used to encode the migration ABI
revision. So we need to restore it to check the table layout is
readable by the destination.

By writing the IIDR, userspace thus force the ABI revision to be
used and this msut be less or equal than the max revision KVM supports.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v4 -> v5
- rename user_revision into abi_rev and REV into MAX_ABI_REV
- IIDR reports abi_rev set by userspace if any.
- If value set by userspace exceeds the max supported revision, an
  error is reported.
- add some defines

v4: creation
---
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 virt/kvm/arm/vgic/vgic-its.c       | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9648bad..54c20bd 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -241,6 +241,10 @@
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
index 69ecfe4..1b5797e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -401,7 +401,23 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
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
+	u64 tmp = 0;
+
+	tmp = update_64bit_reg(tmp, addr & 3, len, val);
+	tmp = GITS_IIDR_REV(tmp);
+
+	if (tmp > MAX_ABI_REV)
+		return -EINVAL;
+	return vgic_its_set_abi(its, tmp);
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
@@ -1382,8 +1398,9 @@ static struct vgic_register_region its_registers[] = {
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
