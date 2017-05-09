From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 12/37] KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_iidr
Date: Tue,  9 May 2017 12:44:41 +0200
Message-ID: <20170509104506.30929-13-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

The GITS_IIDR revision field is used to encode the migration ABI
revision. So we need to restore it to check the table layout is
readable by the destination.

By writing the IIDR, userspace thus forces the ABI revision to be
used and this must be less than or equal to the max revision KVM
supports.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 include/linux/irqchip/arm-gic-v3.h |  5 +++++
 virt/kvm/arm/vgic/vgic-its.c       | 23 ++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 81ebe43..2eaea30 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -242,6 +242,11 @@
 #define GITS_TYPER_PTA			(1UL << 19)
 #define GITS_TYPER_HWCOLLCNT_SHIFT	24
 
+#define GITS_IIDR_REV_SHIFT		12
+#define GITS_IIDR_REV_MASK		(0xf << GITS_IIDR_REV_SHIFT)
+#define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
+#define GITS_IIDR_PRODUCTID_SHIFT	24
+
 #define GITS_CBASER_VALID			(1ULL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
 #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4f6ea46..9338efb 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -434,7 +434,23 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
 					     struct vgic_its *its,
 					     gpa_t addr, unsigned int len)
 {
-	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+	u32 val;
+
+	val = (its->abi_rev << GITS_IIDR_REV_SHIFT) & GITS_IIDR_REV_MASK;
+	val |= (PRODUCT_ID_KVM << GITS_IIDR_PRODUCTID_SHIFT) | IMPLEMENTER_ARM;
+	return val;
+}
+
+static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
+					    struct vgic_its *its,
+					    gpa_t addr, unsigned int len,
+					    unsigned long val)
+{
+	u32 rev = GITS_IIDR_REV(val);
+
+	if (rev >= NR_ITS_ABIS)
+		return -EINVAL;
+	return vgic_its_set_abi(its, rev);
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
@@ -1415,8 +1431,9 @@ static struct vgic_register_region its_registers[] = {
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
2.9.0
