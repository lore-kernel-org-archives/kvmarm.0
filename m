Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC5FC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 15:17:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6280024631
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 15:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6280024631
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6C24B884;
	Tue, 17 Nov 2020 10:17:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WPqMC7z33w72; Tue, 17 Nov 2020 10:17:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7494B887;
	Tue, 17 Nov 2020 10:17:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B4B4B884
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D7l8qR3GRDmM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 10:17:02 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93A584B87F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:00 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cb8fw0kzCz15L8v;
 Tue, 17 Nov 2020 23:16:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Nov 2020 23:16:45 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <maz@kernel.org>
Subject: [PATCH] KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last
 for userspace
Date: Tue, 17 Nov 2020 23:16:29 +0800
Message-ID: <20201117151629.1738-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

It was recently reported that if GICR_TYPER is accessed before the RD base
address is set, we'll suffer from the unset @rdreg dereferencing. Oops...

	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;

It's "expected" that users will access registers in the redistributor if
the RD has been properly configured (e.g., the RD base address is set). But
it hasn't yet been covered by the existing documentation.

Per discussion on the list [1], the reporting of the GICR_TYPER.Last bit
for userspace never actually worked. And it's difficult for us to emulate
it correctly given that userspace has the flexibility to access it any
time. Let's just drop the reporting of the Last bit for userspace for now
(userspace should have full knowledge about it anyway) and it at least
prevents kernel from panic ;-)

[1] https://lore.kernel.org/kvmarm/c20865a267e44d1e2c0d52ce4e012263@kernel.org/

Fixes: ba7b3f1275fd ("KVM: arm/arm64: Revisit Redistributor TYPER last bit computation")
Reported-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

This may be the easiest way to fix the issue and to get the fix backported
to stable tree. There is still some work can be done since (at least) we
have code duplicates between the MMIO and uaccess callbacks.

 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 52d6f24f65dc..15a6c98ee92f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -273,6 +273,23 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	return extract_bytes(value, addr & 7, len);
 }
 
+static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
+						 gpa_t addr, unsigned int len)
+{
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	int target_vcpu_id = vcpu->vcpu_id;
+	u64 value;
+
+	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
+	value |= ((target_vcpu_id & 0xffff) << 8);
+
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
+
+	/* reporting of the Last bit is not supported for userspace */
+	return extract_bytes(value, addr & 7, len);
+}
+
 static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
@@ -593,8 +610,9 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
-		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
+		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
