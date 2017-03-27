From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 07/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Mon, 27 Mar 2017 11:30:57 +0200
Message-ID: <1490607072-21610-8-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1C040A14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R19hZsH1Of0N for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:29:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 899E540A95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:59 -0400 (EDT)
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

GITS_CREADR needs to be restored so let's implement the associated
uaccess_write_its callback. The write only is allowed if the its
is disabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- REGISTER_ITS_DESC_UACCESS now introduced in this patch
- we now check the its is disabled
---
 virt/kvm/arm/vgic/vgic-its.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9b9ea86..a5f3abe 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1213,6 +1213,28 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
 	return extract_bytes(its->creadr, addr & 0x7, len);
 }
 
+static void vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
+					       struct vgic_its *its,
+					       gpa_t addr, unsigned int len,
+					       unsigned long val)
+{
+	u32 reg;
+
+	mutex_lock(&its->cmd_lock);
+
+	if (its->enabled)
+		goto out;
+ 
+	reg = update_64bit_reg(its->creadr, addr & 7, len, val);
+	reg = ITS_CMD_OFFSET(reg);
+	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser))
+		goto out;
+
+	its->creadr = reg;
+out:
+	mutex_unlock(&its->cmd_lock);
+}
+
 #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
 static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 					      struct vgic_its *its,
@@ -1317,6 +1339,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
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
@@ -1339,8 +1371,9 @@ static struct vgic_register_region its_registers[] = {
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
