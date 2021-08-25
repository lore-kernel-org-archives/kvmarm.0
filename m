Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669B2C4320E
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A3BB6115A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0A3BB6115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52844B1FD;
	Wed, 25 Aug 2021 12:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ikktKx-aoLn9; Wed, 25 Aug 2021 12:18:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2394B276;
	Wed, 25 Aug 2021 12:18:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E52124B21E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFQBEkaM9X93 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6BA44B213
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A439D113E;
 Wed, 25 Aug 2021 09:17:42 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 559F33F66F;
 Wed, 25 Aug 2021 09:17:41 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 19/39] KVM: arm64: Do not emulate SPE on CPUs which
 don't have SPE
Date: Wed, 25 Aug 2021 17:17:55 +0100
Message-Id: <20210825161815.266051-20-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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

The kernel allows heterogeneous systems where FEAT_SPE is not present on
all CPUs. This presents a challenge for KVM, as it will have to touch the
SPE registers when emulating SPE for a guest, and those accesses will cause
an undefined exception if SPE is not present on the CPU.

Avoid this situation by comparing the cpumask of the physical CPUs that
support SPE with the cpu list provided by userspace via the
KVM_ARM_VCPU_SUPPORTED_CPUS ioctl and refusing the run the VCPU if there is
a mismatch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h |  2 ++
 arch/arm64/kvm/arm.c             |  3 +++
 arch/arm64/kvm/spe.c             | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 328115ce0b48..ed67ddbf8132 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -16,11 +16,13 @@ static __always_inline bool kvm_supports_spe(void)
 
 void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
+int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu);
 #else
 #define kvm_supports_spe()	(false)
 
 static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
+static inline int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 82cb7b5b3b45..8f7025f2e4a0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -633,6 +633,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (kvm_vcpu_has_spe(vcpu) && kvm_spe_check_supported_cpus(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 83f92245f881..8d2afc137151 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -30,3 +30,15 @@ void kvm_spe_vm_init(struct kvm *kvm)
 	/* Set supported_cpus if it isn't already initialized. */
 	kvm_spe_init_supported_cpus();
 }
+
+int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu)
+{
+	/* SPE is supported on all CPUs, we don't care about the VCPU mask */
+	if (cpumask_equal(supported_cpus, cpu_possible_mask))
+		return 0;
+
+	if (!cpumask_subset(&vcpu->arch.supported_cpus, supported_cpus))
+		return -ENOEXEC;
+
+	return 0;
+}
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
