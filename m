From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 10/37] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Tue,  9 May 2017 12:44:39 +0200
Message-ID: <20170509104506.30929-11-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77EDA40C4A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WFmxOIyJ-nu0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:10 -0400 (EDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
 [209.85.220.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2FE840B3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:07 -0400 (EDT)
Received: by mail-qk0-f178.google.com with SMTP id a72so58961523qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:22 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

GITS_CREADR needs to be restored so let's implement the associated
uaccess_write_its callback. The write only is allowed if the its
is disabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index fd2660d..bf3ff09 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1213,6 +1213,33 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
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
+	if (cmd_offset >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	its->creadr = cmd_offset;
+out:
+	mutex_unlock(&its->cmd_lock);
+	return ret;
+}
+
 #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
 static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 					      struct vgic_its *its,
@@ -1317,6 +1344,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
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
@@ -1339,8 +1376,9 @@ static struct vgic_register_region its_registers[] = {
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
2.9.0
