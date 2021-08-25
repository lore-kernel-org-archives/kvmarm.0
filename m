Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651FFC4320A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BDE86113A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BDE86113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1F3D4B27C;
	Wed, 25 Aug 2021 12:19:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YUSFcybfsIXd; Wed, 25 Aug 2021 12:19:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8867E4B295;
	Wed, 25 Aug 2021 12:18:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 839BB4B287
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EI3DLQK-t6Ue for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F094B205
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFB02D6E;
 Wed, 25 Aug 2021 09:17:47 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E5B93F66F;
 Wed, 25 Aug 2021 09:17:46 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 22/39] KVM: arm64: Add SPE VCPU device attribute to
 initialize SPE
Date: Wed, 25 Aug 2021 17:17:58 +0100
Message-Id: <20210825161815.266051-23-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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
 Documentation/virt/kvm/devices/vcpu.rst | 16 ++++++++++++++
 arch/arm64/include/asm/kvm_spe.h        |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    |  7 ++++--
 arch/arm64/kvm/spe.c                    | 29 ++++++++++++++++++++++++-
 5 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 05821d40849f..c275c320e500 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -185,3 +185,19 @@ Returns:
 Specifies the Profiling Buffer management interrupt number. The interrupt number
 must be a PPI and the interrupt number must be the same for each VCPU. SPE
 emulation requires an in-kernel vGIC implementation.
+
+4.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
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
index 2fe11868719d..2217b821ab37 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -23,7 +23,7 @@ struct kvm_vcpu_spe {
 
 void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
-int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu);
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -36,7 +36,7 @@ struct kvm_vcpu_spe {
 
 static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
-static inline int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
+static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
 
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu,
 				   struct kvm_device_attr *attr)
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
index 8f7025f2e4a0..6af7ef26d2c1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -633,8 +633,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	if (kvm_vcpu_has_spe(vcpu) && kvm_spe_check_supported_cpus(vcpu))
-		return -EPERM;
+	if (kvm_vcpu_has_spe(vcpu)) {
+		ret = kvm_spe_vcpu_first_run_init(vcpu);
+		if (ret)
+			return ret;
+	}
 
 	vcpu->arch.has_run_once = true;
 
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 2fdb42e27675..801ceb66a3d0 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -31,7 +31,7 @@ void kvm_spe_vm_init(struct kvm *kvm)
 	kvm_spe_init_supported_cpus();
 }
 
-int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu)
+static int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu)
 {
 	/* SPE is supported on all CPUs, we don't care about the VCPU mask */
 	if (cpumask_equal(supported_cpus, cpu_possible_mask))
@@ -43,6 +43,20 @@ int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = kvm_spe_check_supported_cpus(vcpu);
+	if (ret)
+		return ret;
+
+	if (!vcpu->arch.spe.initialized)
+		return -EPERM;
+
+	return 0;
+}
+
 static bool kvm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_supports_spe())
@@ -102,6 +116,18 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
@@ -138,6 +164,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
+	case KVM_ARM_VCPU_SPE_INIT:
 		return 0;
 	}
 
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
