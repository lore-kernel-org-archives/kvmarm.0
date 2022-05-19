Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096D2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9184B348;
	Thu, 19 May 2022 09:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f3wMJfox-0sy; Thu, 19 May 2022 09:45:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F38424B3F2;
	Thu, 19 May 2022 09:45:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AA74B3F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xju1CL-zbOe2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:06 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E4314B40D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:05 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0CB617A3;
 Thu, 19 May 2022 13:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7759CC36AE7;
 Thu, 19 May 2022 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967903;
 bh=NVIjWTZHHjkEdmFZZbMXsFiyFQQsWE9eTuQhs7pZgzs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=moLrW7+TJ5kt4af5rrP0VkOPYRUvenme9y0sKpDxbIotLGhKd5q8V/FJsoun9m9u3
 f18churJ8CY0nHNQpfknitsbCjFMcLF9p+7OZrH0Jc5JBDwcasXMo315lqAKTAs8sn
 TvgEqN3yTdWz4cuo+EyM+o0lb3qjrTCSfMt3eMbLh4r9y9DelBjjtK6r1+CCjcujz+
 sutRfNYM/uoJjnx+pgUZhRzPCFSdSCCMjpERnL2x1zTds4IQ4gn5525l8trYGgbi4l
 2VWNIk6P4fJcb6DxiyruxoYUy7n0p+3onK2Lt8j35CKdClAwS5d0cv6SVva2KqHd3E
 KHouor9nHFxqg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 40/89] KVM: arm64: Split up nvhe/fixed_config.h
Date: Thu, 19 May 2022 14:41:15 +0100
Message-Id: <20220519134204.5379-41-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

In preparation for using some of the pKVM fixed configuration register
definitions to filter the available VM CAPs in the host, split the
nvhe/fixed_config.h header so that the definitions can be shared
with the host, while keeping the hypervisor function prototypes in
the nvhe/ namespace.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h             | 190 ++++++++++++++++
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 205 ------------------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   1 -
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   2 +-
 7 files changed, 197 insertions(+), 210 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 1dc7372950b1..b92440cfb5b4 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -2,12 +2,14 @@
 /*
  * Copyright (C) 2020 - Google LLC
  * Author: Quentin Perret <qperret@google.com>
+ * Author: Fuad Tabba <tabba@google.com>
  */
 #ifndef __ARM64_KVM_PKVM_H__
 #define __ARM64_KVM_PKVM_H__
 
 #include <linux/memblock.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/sysreg.h>
 
 /* Maximum number of protected VMs that can be created. */
 #define KVM_MAX_PVMS 255
@@ -18,6 +20,194 @@ int kvm_init_pvm(struct kvm *kvm);
 int kvm_shadow_create(struct kvm *kvm);
 void kvm_shadow_destroy(struct kvm *kvm);
 
+/*
+ * Definitions for features to be allowed or restricted for guest virtual
+ * machines, depending on the mode KVM is running in and on the type of guest
+ * that is running.
+ *
+ * The ALLOW masks represent a bitmask of feature fields that are allowed
+ * without any restrictions as long as they are supported by the system.
+ *
+ * The RESTRICT_UNSIGNED masks, if present, represent unsigned fields for
+ * features that are restricted to support at most the specified feature.
+ *
+ * If a feature field is not present in either, than it is not supported.
+ *
+ * The approach taken for protected VMs is to allow features that are:
+ * - Needed by common Linux distributions (e.g., floating point)
+ * - Trivial to support, e.g., supporting the feature does not introduce or
+ * require tracking of additional state in KVM
+ * - Cannot be trapped or prevent the guest from using anyway
+ */
+
+/*
+ * Allow for protected VMs:
+ * - Floating-point and Advanced SIMD
+ * - Data Independent Timing
+ */
+#define PVM_ID_AA64PFR0_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64PFR0_FP) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_DIT) \
+	)
+
+/*
+ * Restrict to the following *unsigned* features for protected VMs:
+ * - AArch64 guests only (no support for AArch32 guests):
+ *	AArch32 adds complexity in trap handling, emulation, condition codes,
+ *	etc...
+ * - RAS (v1)
+ *	Supported by KVM
+ */
+#define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL2), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL3), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_RAS), ID_AA64PFR0_RAS_V1) \
+	)
+
+/*
+ * Allow for protected VMs:
+ * - Branch Target Identification
+ * - Speculative Store Bypassing
+ */
+#define PVM_ID_AA64PFR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
+	)
+
+/*
+ * Allow for protected VMs:
+ * - Mixed-endian
+ * - Distinction between Secure and Non-secure Memory
+ * - Mixed-endian at EL0 only
+ * - Non-context synchronizing exception entry and exit
+ */
+#define PVM_ID_AA64MMFR0_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_BIGENDEL) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_SNSMEM) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_BIGENDEL0) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EXS) \
+	)
+
+/*
+ * Restrict to the following *unsigned* features for protected VMs:
+ * - 40-bit IPA
+ * - 16-bit ASID
+ */
+#define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_PARANGE), ID_AA64MMFR0_PARANGE_40) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_ASID), ID_AA64MMFR0_ASID_16) \
+	)
+
+/*
+ * Allow for protected VMs:
+ * - Hardware translation table updates to Access flag and Dirty state
+ * - Number of VMID bits from CPU
+ * - Hierarchical Permission Disables
+ * - Privileged Access Never
+ * - SError interrupt exceptions from speculative reads
+ * - Enhanced Translation Synchronization
+ */
+#define PVM_ID_AA64MMFR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_VMIDBITS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_HPD) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_PAN) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_SPECSEI) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_ETS) \
+	)
+
+/*
+ * Allow for protected VMs:
+ * - Common not Private translations
+ * - User Access Override
+ * - IESB bit in the SCTLR_ELx registers
+ * - Unaligned single-copy atomicity and atomic functions
+ * - ESR_ELx.EC value on an exception by read access to feature ID space
+ * - TTL field in address operations.
+ * - Break-before-make sequences when changing translation block size
+ * - E0PDx mechanism
+ */
+#define PVM_ID_AA64MMFR2_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_CNP) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_UAO) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_IESB) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_AT) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_IDS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_TTL) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_BBM) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_E0PD) \
+	)
+
+/*
+ * No support for Scalable Vectors for protected VMs:
+ *	Requires additional support from KVM, e.g., context-switching and
+ *	trapping at EL2
+ */
+#define PVM_ID_AA64ZFR0_ALLOW (0ULL)
+
+/*
+ * No support for debug, including breakpoints, and watchpoints for protected
+ * VMs:
+ *	The Arm architecture mandates support for at least the Armv8 debug
+ *	architecture, which would include at least 2 hardware breakpoints and
+ *	watchpoints. Providing that support to protected guests adds
+ *	considerable state and complexity. Therefore, the reserved value of 0 is
+ *	used for debug-related fields.
+ */
+#define PVM_ID_AA64DFR0_ALLOW (0ULL)
+#define PVM_ID_AA64DFR1_ALLOW (0ULL)
+
+/*
+ * No support for implementation defined features.
+ */
+#define PVM_ID_AA64AFR0_ALLOW (0ULL)
+#define PVM_ID_AA64AFR1_ALLOW (0ULL)
+
+/*
+ * No restrictions on instructions implemented in AArch64.
+ */
+#define PVM_ID_AA64ISAR0_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_AES) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA1) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA2) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_CRC32) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_RDM) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_SM3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_SM4) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_DP) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_FHM) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_TS) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_TLB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_RNDR) \
+	)
+
+#define PVM_ID_AA64ISAR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_DPB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_JSCVT) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_FCMA) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_LRCPC) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_FRINTTS) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_SB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_SPECRES) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_BF16) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_DGH) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_I8MM) \
+	)
+
+#define PVM_ID_AA64ISAR2_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) \
+	)
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
deleted file mode 100644
index 5ad626527d41..000000000000
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ /dev/null
@@ -1,205 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Google LLC
- * Author: Fuad Tabba <tabba@google.com>
- */
-
-#ifndef __ARM64_KVM_FIXED_CONFIG_H__
-#define __ARM64_KVM_FIXED_CONFIG_H__
-
-#include <asm/sysreg.h>
-
-/*
- * This file contains definitions for features to be allowed or restricted for
- * guest virtual machines, depending on the mode KVM is running in and on the
- * type of guest that is running.
- *
- * The ALLOW masks represent a bitmask of feature fields that are allowed
- * without any restrictions as long as they are supported by the system.
- *
- * The RESTRICT_UNSIGNED masks, if present, represent unsigned fields for
- * features that are restricted to support at most the specified feature.
- *
- * If a feature field is not present in either, than it is not supported.
- *
- * The approach taken for protected VMs is to allow features that are:
- * - Needed by common Linux distributions (e.g., floating point)
- * - Trivial to support, e.g., supporting the feature does not introduce or
- * require tracking of additional state in KVM
- * - Cannot be trapped or prevent the guest from using anyway
- */
-
-/*
- * Allow for protected VMs:
- * - Floating-point and Advanced SIMD
- * - Data Independent Timing
- */
-#define PVM_ID_AA64PFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64PFR0_FP) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_DIT) \
-	)
-
-/*
- * Restrict to the following *unsigned* features for protected VMs:
- * - AArch64 guests only (no support for AArch32 guests):
- *	AArch32 adds complexity in trap handling, emulation, condition codes,
- *	etc...
- * - RAS (v1)
- *	Supported by KVM
- */
-#define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), ID_AA64PFR0_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1), ID_AA64PFR0_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL2), ID_AA64PFR0_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL3), ID_AA64PFR0_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_RAS), ID_AA64PFR0_RAS_V1) \
-	)
-
-/*
- * Allow for protected VMs:
- * - Branch Target Identification
- * - Speculative Store Bypassing
- */
-#define PVM_ID_AA64PFR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
-	)
-
-/*
- * Allow for protected VMs:
- * - Mixed-endian
- * - Distinction between Secure and Non-secure Memory
- * - Mixed-endian at EL0 only
- * - Non-context synchronizing exception entry and exit
- */
-#define PVM_ID_AA64MMFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_BIGENDEL) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_SNSMEM) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_BIGENDEL0) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EXS) \
-	)
-
-/*
- * Restrict to the following *unsigned* features for protected VMs:
- * - 40-bit IPA
- * - 16-bit ASID
- */
-#define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_PARANGE), ID_AA64MMFR0_PARANGE_40) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_ASID), ID_AA64MMFR0_ASID_16) \
-	)
-
-/*
- * Allow for protected VMs:
- * - Hardware translation table updates to Access flag and Dirty state
- * - Number of VMID bits from CPU
- * - Hierarchical Permission Disables
- * - Privileged Access Never
- * - SError interrupt exceptions from speculative reads
- * - Enhanced Translation Synchronization
- */
-#define PVM_ID_AA64MMFR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_VMIDBITS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_HPD) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_PAN) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_SPECSEI) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_ETS) \
-	)
-
-/*
- * Allow for protected VMs:
- * - Common not Private translations
- * - User Access Override
- * - IESB bit in the SCTLR_ELx registers
- * - Unaligned single-copy atomicity and atomic functions
- * - ESR_ELx.EC value on an exception by read access to feature ID space
- * - TTL field in address operations.
- * - Break-before-make sequences when changing translation block size
- * - E0PDx mechanism
- */
-#define PVM_ID_AA64MMFR2_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_CNP) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_UAO) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_IESB) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_AT) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_IDS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_TTL) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_BBM) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_E0PD) \
-	)
-
-/*
- * No support for Scalable Vectors for protected VMs:
- *	Requires additional support from KVM, e.g., context-switching and
- *	trapping at EL2
- */
-#define PVM_ID_AA64ZFR0_ALLOW (0ULL)
-
-/*
- * No support for debug, including breakpoints, and watchpoints for protected
- * VMs:
- *	The Arm architecture mandates support for at least the Armv8 debug
- *	architecture, which would include at least 2 hardware breakpoints and
- *	watchpoints. Providing that support to protected guests adds
- *	considerable state and complexity. Therefore, the reserved value of 0 is
- *	used for debug-related fields.
- */
-#define PVM_ID_AA64DFR0_ALLOW (0ULL)
-#define PVM_ID_AA64DFR1_ALLOW (0ULL)
-
-/*
- * No support for implementation defined features.
- */
-#define PVM_ID_AA64AFR0_ALLOW (0ULL)
-#define PVM_ID_AA64AFR1_ALLOW (0ULL)
-
-/*
- * No restrictions on instructions implemented in AArch64.
- */
-#define PVM_ID_AA64ISAR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_AES) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA1) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA2) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_CRC32) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_RDM) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_SHA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_SM3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_SM4) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_DP) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_FHM) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_TS) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_TLB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_RNDR) \
-	)
-
-#define PVM_ID_AA64ISAR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_DPB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_JSCVT) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_FCMA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_LRCPC) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_FRINTTS) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_SB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_SPECRES) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_BF16) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_DGH) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_I8MM) \
-	)
-
-#define PVM_ID_AA64ISAR2_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) \
-	)
-
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
-bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
-bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
-int kvm_check_pvm_sysreg_table(void);
-
-#endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index e600dc4965c4..f76af6e0177a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -67,5 +67,9 @@ struct kvm_shadow_vcpu_state *
 pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx);
 void pkvm_put_shadow_vcpu_state(struct kvm_shadow_vcpu_state *shadow_state);
 
-#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+int kvm_check_pvm_sysreg_table(void);
 
+#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index b29142a09e36..960427d6c168 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -6,7 +6,6 @@
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
-#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c55661976f64..37002b9d7434 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -11,7 +11,6 @@
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/early_alloc.h>
-#include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..9d2b971e8613 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -26,8 +26,8 @@
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
 
-#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
+#include <nvhe/pkvm.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 188fed1c174b..ddea42d7baf9 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -11,7 +11,7 @@
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/fixed_config.h>
+#include <nvhe/pkvm.h>
 
 #include "../../sys_regs.h"
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
