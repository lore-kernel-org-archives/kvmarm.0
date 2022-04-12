Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151B4C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:32:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4CAE4B24B;
	Tue, 12 Apr 2022 09:32:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ci+PHZaRbNoH; Tue, 12 Apr 2022 09:32:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B4A4B262;
	Tue, 12 Apr 2022 09:32:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EF784088C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YAOsqZbsR+G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ABB04B298
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6413169C;
 Tue, 12 Apr 2022 06:32:43 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 421EA3F70D;
 Tue, 12 Apr 2022 06:32:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 04/11] arm: Move arch specific VCPU features to the
 arch specific function
Date: Tue, 12 Apr 2022 14:32:24 +0100
Message-Id: <20220412133231.35355-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
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

KVM_CAP_ARM_EL1_32BIT and KVM_CAP_ARM_PMU_V3 are arm64 specific features.
They are set based on arm64 specific command line options and they target
arm64 hardware features. It makes little sense for kvmtool to set the
features in the code that is shared between arm and arm64. Move the logic
to set the feature bits to the arch specific function
kvm_cpu__select_features(), which is already used by arm64 to set other
arm64 specific features.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  4 +---
 arm/aarch64/kvm-cpu.c                  | 12 ++++++++++++
 arm/kvm-cpu.c                          |  8 --------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 35996dc0a0d6..4cbadf9175d8 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -6,9 +6,7 @@
 #include "arm-common/kvm-cpu-arch.h"
 
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
-	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
-	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	[0] = (!!(cpuid) << KVM_ARM_VCPU_POWER_OFF),				\
 }
 
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 9f3e8586880c..3b6224a599c8 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -130,6 +130,18 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 {
+	if (kvm->cfg.arch.aarch32_guest) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
+			die("32bit guests are not supported\n");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_EL1_32BIT;
+	}
+
+	if (kvm->cfg.arch.has_pmuv3) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
+			die("PMUv3 is not supported");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_PMU_V3;
+	}
+
 	/* Enable pointer authentication if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
 	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 00660d6e7a97..3a5c8a5a8e31 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -46,14 +46,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		.features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
 	};
 
-	if (kvm->cfg.arch.aarch32_guest &&
-	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
-		die("32bit guests are not supported\n");
-
-	if (kvm->cfg.arch.has_pmuv3 &&
-	    !kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
-		die("PMUv3 is not supported");
-
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
 	if (!vcpu)
 		return NULL;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
