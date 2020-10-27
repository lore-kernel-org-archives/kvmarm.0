Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B21C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B859F22202
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B859F22202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A0114B4E8;
	Tue, 27 Oct 2020 13:26:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EKdWr+VGcHB1; Tue, 27 Oct 2020 13:26:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 054654B500;
	Tue, 27 Oct 2020 13:26:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444254B4C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qARKwNiRY9QG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7B0E4B49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C7EF15AD;
 Tue, 27 Oct 2020 10:26:22 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 593F33F719;
 Tue, 27 Oct 2020 10:26:21 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 06/16] KVM: arm64: Introduce SPE primitives
Date: Tue, 27 Oct 2020 17:26:55 +0000
Message-Id: <20201027172705.15181-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

KVM SPE emulation depends on the configuration option KVM_ARM_SPE and on on
having hardware SPE support on all CPUs. The host driver must be
compiled-in because we need the SPE interrupt to be enabled; it will be
used to kick us out of the guest when the profiling buffer management
interrupt is asserted by the GIC (for example, when the buffer is full).

Add a VCPU flag to inform KVM that the guest has SPE enabled.

It's worth noting that even though the KVM_ARM_SPE config option is gated
by the SPE host driver being compiled-in, we don't actually check that the
driver was loaded successfully when we advertise SPE support for guests.
That's because we can live with the SPE interrupt being disabled. There is
a delay between when the SPE hardware asserts the interrupt and when the
GIC samples the interrupt line and asserts it to the CPU. If the SPE
interrupt is disabled at the GIC level, this delay will be larger, at most
a host timer tick.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 +++++++++
 arch/arm64/kvm/Kconfig            |  8 ++++++++
 include/kvm/arm_spe.h             | 19 +++++++++++++++++++
 3 files changed, 36 insertions(+)
 create mode 100644 include/kvm/arm_spe.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 25d326aecded..43eee197764f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -406,6 +406,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
+#define KVM_ARM64_GUEST_HAS_SPE		(1 << 8) /* SPE exposed to guest */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
@@ -419,6 +420,14 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
 
+#ifdef CONFIG_KVM_ARM_SPE
+#define vcpu_has_spe(vcpu)						\
+	(cpus_have_final_cap(ARM64_SPE) &&				\
+	 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SPE))
+#else
+#define vcpu_has_spe(vcpu)		false
+#endif
+
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 043756db8f6e..8b35c0b806a7 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -57,6 +57,14 @@ config KVM_ARM_PMU
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
+config KVM_ARM_SPE
+	bool "Virtual Statistical Profiling Extension (SPE) support"
+	depends on ARM_SPE_PMU
+	default y
+	help
+	  Adds support for a virtual Statistical Profiling Extension (SPE) in
+	  virtual machines.
+
 endif # KVM
 
 endif # VIRTUALIZATION
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
new file mode 100644
index 000000000000..db51ef15bf45
--- /dev/null
+++ b/include/kvm/arm_spe.h
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 ARM Ltd.
+ */
+
+#ifndef __ASM_ARM_KVM_SPE_H
+#define __ASM_ARM_KVM_SPE_H
+
+#ifdef CONFIG_KVM_ARM_SPE
+static inline bool kvm_arm_supports_spe(void)
+{
+	return cpus_have_final_cap(ARM64_SPE);
+}
+
+#else
+#define kvm_arm_supports_spe()	false
+
+#endif /* CONFIG_KVM_ARM_SPE */
+#endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
