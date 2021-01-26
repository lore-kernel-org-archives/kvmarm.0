Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E25FC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:12:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB86922B2C
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB86922B2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FEAE4B2D6;
	Tue, 26 Jan 2021 09:12:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZPWFM6ExXbfm; Tue, 26 Jan 2021 09:12:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC314B2D1;
	Tue, 26 Jan 2021 09:12:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 859FB4B27B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:12:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QOveMI0zdI5b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 09:12:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFDD84B2DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:12:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 570BE11D4;
 Tue, 26 Jan 2021 06:12:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 581B63F7D7;
 Tue, 26 Jan 2021 06:12:04 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] KVM: arm64: vgic-v3: Rename VGIC_TO_MPIDR() to
 VGIC_TO_MPIDR_AFF()
Date: Tue, 26 Jan 2021 14:11:56 +0000
Message-Id: <20210126141156.39317-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210126141156.39317-1-alexandru.elisei@arm.com>
References: <20210126141156.39317-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

GICv3 doesn't have an MPIDR register, but it uses the affinity fields from
GICR_TYPER, which are also present in the MPIDR_EL1 register, to identify
the Redistributor associated with a PE.

The macro VGIC_TO_MPIDR() doesn't convert the affinity fields
originating from an userspace ioctl into a valid MPIDR_EL1 value like
its name would suggest (notably, the RES1 bit is missing); what it does
is to shift the affinity fields to the same positions as the fields from
the MPIDR_EL1 register. This value is then compared to the result of
kvm_vcpu_get_mpidr_aff() to find the corresponding VCPU.

Let's rename VGIC_TO_MPIDR() to VGIC_TO_MPIDR_AFF() to avoid any confusion
about what the macro does.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++++++------
 arch/arm64/kvm/vgic/vgic.h            | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 44419679f91a..043eeb264ed8 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -473,18 +473,18 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr)
 {
-	unsigned long vgic_mpidr, mpidr_reg;
+	unsigned long vgic_aff, mpidr_aff;
 
 	/*
 	 * For KVM_DEV_ARM_VGIC_GRP_DIST_REGS group,
-	 * attr might not hold MPIDR. Hence assume vcpu0.
+	 * attr might not hold MPIDR affinity. Hence assume vcpu0.
 	 */
 	if (attr->group != KVM_DEV_ARM_VGIC_GRP_DIST_REGS) {
-		vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
-			      KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+		vgic_aff = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+			    KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
 
-		mpidr_reg = VGIC_TO_MPIDR(vgic_mpidr);
-		reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
+		mpidr_aff = VGIC_TO_MPIDR_AFF(vgic_aff);
+		reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_aff);
 	} else {
 		reg_attr->vcpu = kvm_get_vcpu(dev->kvm, 0);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 64fcd7511110..66525b8e2aa4 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -34,12 +34,12 @@
 
 /*
  * The Userspace encodes the affinity differently from the MPIDR,
- * Below macro converts vgic userspace format to MPIDR reg format.
+ * Below macro converts vgic userspace format to MPIDR reg affinity format.
  */
-#define VGIC_TO_MPIDR(val) (VGIC_AFFINITY_LEVEL(val, 0) | \
-			    VGIC_AFFINITY_LEVEL(val, 1) | \
-			    VGIC_AFFINITY_LEVEL(val, 2) | \
-			    VGIC_AFFINITY_LEVEL(val, 3))
+#define VGIC_TO_MPIDR_AFF(val) (VGIC_AFFINITY_LEVEL(val, 0) | \
+				VGIC_AFFINITY_LEVEL(val, 1) | \
+				VGIC_AFFINITY_LEVEL(val, 2) | \
+				VGIC_AFFINITY_LEVEL(val, 3))
 
 /*
  * As per Documentation/virt/kvm/devices/arm-vgic-v3.rst,
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
