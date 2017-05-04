From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 08/24] KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_creadr
Date: Thu,  4 May 2017 13:44:28 +0200
Message-ID: <1493898284-29504-9-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

GITS_CREADR needs to be restored so let's implement the associated
uaccess_write_its callback. The write only is allowed if the its
is disabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- remove usage of update_64bit_reg and check alignment of cmd offset

v4 -> v5:
- keep Stalled bit
- vgic_mmio_uaccess_write_its_creadr can now return an error

v3 -> v4:
- REGISTER_ITS_DESC_UACCESS now introduced in this patch
- we now check the its is disabled
---
 virt/kvm/arm/vgic/vgic-its.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 222fad5..18588ef 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1213,6 +1213,34 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
 	return extract_bytes(its->creadr, addr & 0x7, len);
 }
 
+static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
+					      struct vgic_its *its,
+					      gpa_t addr, unsigned int len,
+					      unsigned long val)
+{
+	u32 cmd_offset;
+	int ret = 0;
+
+	mutex_lock(&its->cmd_lock);
+
+	if (its->enabled) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	cmd_offset = ITS_CMD_OFFSET(val);
+	if ((cmd_offset >= ITS_CMD_BUFFER_SIZE(its->cbaser)) ||
+	    (cmd_offset & 0x1F)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	its->creadr = val;
+out:
+	mutex_unlock(&its->cmd_lock);
+	return ret;
+}
+
 #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
 static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 					      struct vgic_its *its,
@@ -1317,6 +1345,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	.its_write = wr,					\
 }
 
+#define REGISTER_ITS_DESC_UACCESS(off, rd, wr, uwr, length, acc)\
+{								\
+	.reg_offset = off,					\
+	.len = length,						\
+	.access_flags = acc,					\
+	.its_read = rd,						\
+	.its_write = wr,					\
+	.uaccess_its_write = uwr,				\
+}
+
 static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
 			      gpa_t addr, unsigned int len, unsigned long val)
 {
@@ -1339,8 +1377,9 @@ static struct vgic_register_region its_registers[] = {
 	REGISTER_ITS_DESC(GITS_CWRITER,
 		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_ITS_DESC(GITS_CREADR,
-		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
+	REGISTER_ITS_DESC_UACCESS(GITS_CREADR,
+		vgic_mmio_read_its_creadr, its_mmio_write_wi,
+		vgic_mmio_uaccess_write_its_creadr, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_BASER,
 		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
-- 
2.5.5
