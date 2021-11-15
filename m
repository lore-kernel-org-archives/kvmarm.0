Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58798C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F41FB61BA1
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F41FB61BA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F2C4B103;
	Mon, 15 Nov 2021 11:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rIsDDv1pKE+E; Mon, 15 Nov 2021 11:55:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE2C4B1AD;
	Mon, 15 Nov 2021 11:55:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 181BD4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eojjw9RaF+pm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 677A04B19F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 155261FB;
 Mon, 15 Nov 2021 08:55:29 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A4163F7F5;
 Mon, 15 Nov 2021 08:55:27 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 2/9] arm: Move arch specific VCPU features to the arch
 specific function
Date: Mon, 15 Nov 2021 16:56:58 +0000
Message-Id: <20211115165705.195736-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165705.195736-1-alexandru.elisei@arm.com>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
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
index 8dfb82ecbc37..016cf5b2b9ea 100644
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
index 6a2408c632df..554414f81b7a 100644
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
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
