Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D386C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40B9061360
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 40B9061360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA204B187;
	Wed, 17 Nov 2021 10:37:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C4W+J2FNKUpa; Wed, 17 Nov 2021 10:37:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E6B4B1B2;
	Wed, 17 Nov 2021 10:37:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA9A4B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5YWx1yNN-kh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B29994B173
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FBD41FB;
 Wed, 17 Nov 2021 07:37:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C22AB3F5A1;
 Wed, 17 Nov 2021 07:37:38 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 22/38] KVM: arm64: Add SPE VCPU device attribute to
 initialize SPE
Date: Wed, 17 Nov 2021 15:38:26 +0000
Message-Id: <20211117153842.302159-23-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: Sudeep Holla <sudeep.holla@arm.com>
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

From: Sudeep Holla <sudeep.holla@arm.com>

Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_INIT) VCPU ioctl to initialize
SPE. Initialization can only be done once for a VCPU. If the feature bit is
set, then SPE must be initialized before the VCPU can be run.

[ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
	       for SPE" ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_spe.h        |  6 ++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    |  4 ++++
 arch/arm64/kvm/spe.c                    | 24 ++++++++++++++++++++++++
 5 files changed, 51 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index a27b149c3b8b..0ed852315664 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -255,3 +255,19 @@ Returns:
 Specifies the Profiling Buffer management interrupt number. The interrupt number
 must be a PPI and the interrupt number must be the same for each VCPU. SPE
 emulation requires an in-kernel vGIC implementation.
+
+5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
+-----------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+Returns:
+
+	 =======  ============================================
+	 -EBUSY   SPE already initialized for this VCPU
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ============================================
+
+Request initialization of the Statistical Profiling Extension for this VCPU.
+Must be done after initializaing the in-kernel irqchip and after setting the
+Profiling Buffer management interrupt number for the VCPU.
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index a5484953d06f..14df2c830fda 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -22,6 +22,7 @@ struct kvm_vcpu_spe {
 };
 
 int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu);
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -37,6 +38,11 @@ static inline int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu,
 				   struct kvm_device_attr *attr)
 {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c55d94a1a8f5..d4c0b53a5fb2 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -370,6 +370,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
 #define   KVM_ARM_VCPU_SPE_IRQ		0
+#define   KVM_ARM_VCPU_SPE_INIT		1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8a7c01d1df58..5270f3b9886c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -652,6 +652,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return ret;
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
+	if (ret)
+		return ret;
+
+	ret = kvm_spe_vcpu_first_run_init(vcpu);
 
 	/*
 	 * Initialize traps for protected VMs.
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 7520d7925460..a3d5bcd1a96b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -45,6 +45,17 @@ int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_spe(vcpu))
+		return 0;
+
+	if (!vcpu->arch.spe.initialized)
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool kvm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_supports_spe())
@@ -104,6 +115,18 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		vcpu->arch.spe.irq_num = irq;
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_INIT:
+		if (!vcpu->arch.spe.irq_num)
+			return -ENXIO;
+
+		if (!vgic_initialized(vcpu->kvm))
+			return -ENXIO;
+
+		if (kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq_num, &vcpu->arch.spe))
+			return -ENXIO;
+
+		vcpu->arch.spe.initialized = true;
+		return 0;
 	}
 
 	return -ENXIO;
@@ -140,6 +163,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
+	case KVM_ARM_VCPU_SPE_INIT:
 		return 0;
 	}
 
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
