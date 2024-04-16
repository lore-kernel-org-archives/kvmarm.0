Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA6D2907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261437; cv=none; b=TaGphln83wzqTEw7pdqGYfmPXnna88sqzGgI4Gr13dEKQO+FaugpIMqRl7Iq1OOwvbuPf3+1MchFhKmZuiS/yOm0QcIn9syJ9S24Yab3glcgvd1B+YrE2kJfLs38Wcl6ieyPKg1Dj/IT93KWnXg7jTQOIe54ZAkxs/UyaiL/XrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261437; c=relaxed/simple;
	bh=gvGuZcHVjiPaUm6KoMI6w8p1iy5IT9kAs0Nd/tY785U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kmzxgo8SRcWPA8THnOLS1JW73FL3dJcbKonF63NFq7ITnamb2OUV2Y6X3M+/UOJPWWY+yMUelBXqmE1rHvJ6Mt25bMhKFDrz4cRmZTXhqOaBDsRdN3dsSWICVo0d8FhuGcPbvG2W8M7EwPCTcyeoGC9JyPO/FNgO3FJKmanZ6uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lobBFW3o; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lobBFW3o"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41663448bcbso25286765e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261433; x=1713866233; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TaP19xTkiFTk1/IiTXep9aJX93Ug6pqVy1y+lz5pHDE=;
        b=lobBFW3oSW0RwyeiBvcIfvfROLyka4W71vV3zRWhrid3+9mCX4BQONwK9OerP8Hu5G
         7DoG6cyPqhRpgxhKoIJQ8RH1IQGwdJft/s1Z/eABA1HkB8d2H9zfL28X9Aq9ylJolXP2
         Rsb2v2nPj55x63ay3S3+n0OviDRq75kkl51smy8xfZJj5GVeqZ+jxm7aCubusFZ/MP+v
         FMzksIb9lzRSY9ANrM3J7RIRu2aQJcOD56p4fbxaVwQig+S6D2oDEBoYrkMyOSa55/8I
         LbTZnxXSKiya2eiOXu2jD1q/QXSFyGjb5zJo0Q4Giu4NC6obV+r+9H5Ln+nIsQFoONfa
         qoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261433; x=1713866233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TaP19xTkiFTk1/IiTXep9aJX93Ug6pqVy1y+lz5pHDE=;
        b=BuYz4DxC3yCS9r05eqSuJkU/NbFoK1tNqevclT5wsZnet6Ei+wJG9lQZcKDs9/33Lu
         JKjScDTkJvkdEpxAIH7xSv/xFfSpnX072d0KBLyOdgF03S3ZssNtotNghYeFqQYMxj5R
         IOmO3RoGkgIIxgKaTPqDZgXFrsp9y1nAfpiWnWOBtBMdvb/+K85jNPdDW/VFEF6PFw26
         rXmKPzVAoB9K9og5YzMWt0nbJVDKlXKVk9/OrnuobVmZcqybjC5KhmyD4Y17NDdLZUjc
         Dk98Ag5w4LrWPsyWa22QOud80rip8wfjJLyvjBQjUdko0NyUEGxu5wZqXQLjbMVABJpY
         w9kw==
X-Gm-Message-State: AOJu0Yw0GV3Nyy4vHqAYkjMB35YNMUj+gTnDKzn/ji+m/9JqKcPLTLrA
	RJ2OmGW81/xcZvod7YZPVl/oIIcLwVQe1wby8V7/lB+86KgkRw0BUh85Prlj8tj4vHXmmW+PBqB
	YFa9nOmV6vmPtb97MSYb13IGCIb4rIk4ITcHc+KCvRxXEcgEAJynTnmkV8FqRaYh7qKCz26bZtS
	9rYWc40U7ZRo4qi1Wvm8OC47Cb/JE=
X-Google-Smtp-Source: AGHT+IEcl0wjkR2r2sjLq5Br3egoZp/+xLHoGRrBJfmUSdAz46mF4KpG5AF/hylIO6v939EUwmjna5q2RQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:56d3:b0:418:4e4a:fec5 with SMTP id
 ju19-20020a05600c56d300b004184e4afec5mr12715wmb.3.1713261433231; Tue, 16 Apr
 2024 02:57:13 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:05 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-15-tabba@google.com>
Subject: [PATCH v2 14/47] KVM: arm64: Split up nvhe/fixed_config.h
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

In preparation for using some of the pKVM fixed configuration register
definitions to filter the available VM CAPs in the host, split the
nvhe/fixed_config.h header so that the definitions can be shared
with the host, while keeping the hypervisor function prototypes in
the nvhe/ namespace.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h             | 205 ++++++++++++++++
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ------------------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   1 -
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   2 +-
 7 files changed, 212 insertions(+), 227 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ad9cfb5c1ff4..5bf5644aa5db 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020 - Google LLC
  * Author: Quentin Perret <qperret@google.com>
+ * Author: Fuad Tabba <tabba@google.com>
  */
 #ifndef __ARM64_KVM_PKVM_H__
 #define __ARM64_KVM_PKVM_H__
@@ -10,6 +11,7 @@
 #include <linux/memblock.h>
 #include <linux/scatterlist.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/sysreg.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
 #define KVM_MAX_PVMS 255
@@ -20,6 +22,209 @@ int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 
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
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
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
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), ID_AA64PFR0_EL1_RAS_IMP) \
+	)
+
+/*
+ * Allow for protected VMs:
+ * - Branch Target Identification
+ * - Speculative Store Bypassing
+ */
+#define PVM_ID_AA64PFR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_BT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SSBS) \
+	)
+
+#define PVM_ID_AA64PFR2_ALLOW (0ULL)
+
+/*
+ * Allow for protected VMs:
+ * - Mixed-endian
+ * - Distinction between Secure and Non-secure Memory
+ * - Mixed-endian at EL0 only
+ * - Non-context synchronizing exception entry and exit
+ */
+#define PVM_ID_AA64MMFR0_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGEND) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_SNSMEM) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGENDEL0) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_EXS) \
+	)
+
+/*
+ * Restrict to the following *unsigned* features for protected VMs:
+ * - 40-bit IPA
+ * - 16-bit ASID
+ */
+#define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_PARANGE), ID_AA64MMFR0_EL1_PARANGE_40) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) \
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
+ * - Control for cache maintenance permission
+ */
+#define PVM_ID_AA64MMFR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_VMIDBits) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HPDS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_PAN) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_SpecSEI) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_CMOW) \
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
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_CnP) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_UAO) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_IESB) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_AT) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_IDS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_TTL) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_BBM) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_E0PD) \
+	)
+
+#define PVM_ID_AA64MMFR3_ALLOW (0ULL)
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
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_AES) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA1) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA2) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_CRC32) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_ATOMIC) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_RDM) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SM3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SM4) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_DP) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_FHM) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_TS) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_TLB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_RNDR) \
+	)
+
+/* Restrict pointer authentication to the basic version. */
+#define PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
+	)
+
+#define PVM_ID_AA64ISAR2_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
+	)
+
+#define PVM_ID_AA64ISAR1_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DPB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_JSCVT) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_FCMA) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_LRCPC) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_FRINTTS) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_SB) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_SPECRES) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_BF16) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DGH) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_I8MM) \
+	)
+
+#define PVM_ID_AA64ISAR2_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_ATS1A)| \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
+	)
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
deleted file mode 100644
index 51f043649146..000000000000
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ /dev/null
@@ -1,223 +0,0 @@
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
- * - Spectre/Meltdown Mitigation
- */
-#define PVM_ID_AA64PFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) \
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
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), ID_AA64PFR0_EL1_RAS_IMP) \
-	)
-
-/*
- * Allow for protected VMs:
- * - Branch Target Identification
- * - Speculative Store Bypassing
- */
-#define PVM_ID_AA64PFR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_BT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SSBS) \
-	)
-
-#define PVM_ID_AA64PFR2_ALLOW 0ULL
-
-/*
- * Allow for protected VMs:
- * - Mixed-endian
- * - Distinction between Secure and Non-secure Memory
- * - Mixed-endian at EL0 only
- * - Non-context synchronizing exception entry and exit
- */
-#define PVM_ID_AA64MMFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGEND) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_SNSMEM) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGENDEL0) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_EXS) \
-	)
-
-/*
- * Restrict to the following *unsigned* features for protected VMs:
- * - 40-bit IPA
- * - 16-bit ASID
- */
-#define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_PARANGE), ID_AA64MMFR0_EL1_PARANGE_40) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) \
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
- * - Control for cache maintenance permission
- */
-#define PVM_ID_AA64MMFR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_VMIDBits) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HPDS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_PAN) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_SpecSEI) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_CMOW) \
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
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_CnP) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_UAO) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_IESB) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_AT) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_IDS) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_TTL) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_BBM) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_E0PD) \
-	)
-
-#define PVM_ID_AA64MMFR3_ALLOW (0ULL)
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
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_AES) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA1) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA2) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_CRC32) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_ATOMIC) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_RDM) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SHA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SM3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_SM4) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_DP) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_FHM) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_TS) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_TLB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_RNDR) \
-	)
-
-/* Restrict pointer authentication to the basic version. */
-#define PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
-	)
-
-#define PVM_ID_AA64ISAR2_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
-	)
-
-#define PVM_ID_AA64ISAR1_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DPB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_JSCVT) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_FCMA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_LRCPC) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_FRINTTS) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_SB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_SPECRES) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_BF16) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DGH) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_I8MM) \
-	)
-
-#define PVM_ID_AA64ISAR2_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_ATS1A)| \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
-	)
-
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
-bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
-bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
-int kvm_check_pvm_sysreg_table(void);
-
-#endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 169fbfef61b7..79137e1b36c9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -79,4 +79,9 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+int kvm_check_pvm_sysreg_table(void);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6cd12ab389ea..17aae6fc6898 100644
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
index 859f22f754d3..42bfd82c9a99 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -12,7 +12,6 @@
 
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
-#include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 1f82d531a494..41e3db960ccc 100644
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
index edd969a1f36b..18c1ca0a66b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -11,7 +11,7 @@
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/fixed_config.h>
+#include <nvhe/pkvm.h>
 
 #include "../../sys_regs.h"
 
-- 
2.44.0.683.g7961c838ac-goog

