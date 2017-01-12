From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 05/13] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Thu, 12 Jan 2017 16:56:45 +0100
Message-ID: <1484236613-24633-6-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F26C40423
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wUG5XqQBYvKc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:33 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9677A40670
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:33 -0500 (EST)
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

GITS_CREADR needs to be restored so let's implement the associated
uaccess_write_its callback.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 virt/kvm/arm/vgic/vgic-its.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 55671585..e174220 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1225,6 +1225,25 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
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
+	reg = update_64bit_reg(its->creadr, addr & 7, len, val);
+	reg = ITS_CMD_OFFSET(reg);
+	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
+		mutex_unlock(&its->cmd_lock);
+		return;
+	}
+
+	its->creadr = reg;
+	mutex_unlock(&its->cmd_lock);
+}
+
 #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
 static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 					      struct vgic_its *its,
@@ -1320,7 +1339,8 @@ static struct vgic_register_region its_registers[] = {
 		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, NULL,
 		8, VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CREADR,
-		vgic_mmio_read_its_creadr, its_mmio_write_wi, NULL, 8,
+		vgic_mmio_read_its_creadr, its_mmio_write_wi,
+		vgic_mmio_uaccess_write_its_creadr, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_BASER,
 		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, NULL, 0x40,
-- 
2.5.5
