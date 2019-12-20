Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EF4C43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 11:19:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5803724679
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 11:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5803724679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B334A522;
	Fri, 20 Dec 2019 06:19:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WmB-c+5SR7yX; Fri, 20 Dec 2019 06:19:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E444A535;
	Fri, 20 Dec 2019 06:19:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7154A522
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 06:19:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id azCEDftGSC+W for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 06:19:12 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98EB14A50F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 06:19:10 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 4A1A6CC09BE5C294C012;
 Fri, 20 Dec 2019 19:19:02 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 20 Dec 2019 19:18:54 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <maz@kernel.org>
Subject: [PATCH] KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as RAZ
Date: Fri, 20 Dec 2019 19:18:33 +0800
Message-ID: <20191220111833.1422-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Although guest will hardly read and use the PTZ (Pending Table Zero)
bit in GICR_PENDBASER, let us emulate the architecture strictly.
As per IHI 0069E 9.11.30, PTZ field is WO, and reads as 0.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

Noticed when checking all fields of GICR_PENDBASER register.
But _not_ sure whether it's worth a fix, as Linux never sets
the PTZ bit before enabling LPI (set GICR_CTLR_ENABLE_LPIS).

And I wonder under which scenarios can this bit be written as 1.
It seems difficult for software to determine whether the pending
table contains all zeros when writing this bit.

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 7dfd15dbb308..ebc218840fc2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -414,8 +414,11 @@ static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	u64 value = vgic_cpu->pendbaser;
 
-	return extract_bytes(vgic_cpu->pendbaser, addr & 7, len);
+	value &= ~GICR_PENDBASER_PTZ;
+
+	return extract_bytes(value, addr & 7, len);
 }
 
 static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
