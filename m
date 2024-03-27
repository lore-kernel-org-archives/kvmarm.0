Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0E137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560963; cv=none; b=A2ft639GAQ56ep2ulItDCe8dJBDkbgXfrm6Q68AcTuHRLXSkfUKnM8LPTbwHP//CkjIfVBwdlKdaG+Scem74yNpWVmg7wRbOw5PCkj2ni7WJC19qf67vZz6UZBN4ZHTCnWJTePnGjknVc5pTIkyYgxIwHqj3HVlRn7MdPyicUdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560963; c=relaxed/simple;
	bh=CGBJlvPMEl7DXOLdB8UDiMP7dMg27r9qxBOwloeSwgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qIy1t508Njk9dHwLU5MAXJxaqb0TksJAkXnKpHvVkRCSO9CiNx1DsIggF5UXyuC8Ts5rCN+TqKJC7K8Z4xQxSFFADoYxTB9htDx+64G0bnWBmX1TVGdNd5b53luugvxCYwmj9/VQlADd/37oAKXGj7ZK2akU9RGlqP82DsvtKUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FJeeVZIb; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FJeeVZIb"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-341678a510bso523f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560959; x=1712165759; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T2hDj/e4ANAQ5GxsVkM7CEYML6MTEuDdeREhtog+d3I=;
        b=FJeeVZIbDVObYri5htoWRZEOeSNiwhaDnHPWjC1W8uVWX9dT/3Ldv6LovBPDz0NIkK
         cSimXDdLbVFsZM+TMmoOJcrsJRzgFWBl7aRwgMR2NuHIb9V/DZyVQl0/pwsZs+ynkEqj
         ZoyRSk27wbrX7JbdhceBvtJKLvVLWrl86aYtIuMmhbhlz5tzwDigtk3is8jgCJ2AqLy2
         VE+mWeNG7msZFcpKzR/4Oly8OhO1ITDZc1ToxV+QVo7BtOG0KJgJ3Znqgxk2KyLQ/mAe
         0u3ErrEbUay1U9ItgNQQHEXbwl3GD6rGeQBTolvDE73xO5Jg24gSbEzz4iCUCmr5bmL6
         3tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560959; x=1712165759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T2hDj/e4ANAQ5GxsVkM7CEYML6MTEuDdeREhtog+d3I=;
        b=fPHJebNbcb0HKDZ+kQRJz1tDlomjKvuFhNaTUc+z95FuT6Ckc1WhTmvJX245RHxS+4
         pDLWxTV7jHQaGSiBznJtrlX2zdIQ7l/Wlp2kGkh8m/VID/g1UNfQ1FWMW9sTkTuujSBC
         jYPd+pCckpGyNFAHgLkMhke58n8osSEe5TqmRF+vF5wvIr8Id3iezAuGZPE1tyw1sjsl
         3zvYu6V8Z4xfXVlDNGguV/xuHoqYw9v7FgI6OJbIgXrpK2C/aI7x++Fkh97WZkh/tfxr
         zG8qQ49E5haUqka4BiOAJZbERUyHMHK2WCTXuLO2vp/hhJPuN7FYboFc8UI9Tmbfjzej
         z79Q==
X-Gm-Message-State: AOJu0Yz9pXXFOKMlUfSF5deh726JkzEfwptkDIL1tFx+XfpJgpH7ElvJ
	syGRF295Rw/AAGFIgZVfPYEzhhx8wY0urFml7pHAZCHp7nzEPC4+E4Qh+rjqtkVhPifAZYzcM6P
	WutCtCDc6Xggl6/VLVICeRA4iBYckr+7MGQ9iDZShr4fVXux8iciUx1UYXx41z6WhLp1YnIxMS6
	FnEBKbp7UepvVgsa0SFMT3+JYSSDk=
X-Google-Smtp-Source: AGHT+IFa3gaI+Uiha8BhGsU+++0DTFyA4MBcQrEgmcwpuwWWxQ1FMUa31kDd/VIl+PVduWZV3W8H/c+pVg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:50d2:0:b0:33e:bf76:15cf with SMTP id
 f18-20020a5d50d2000000b0033ebf7615cfmr23wrt.10.1711560958987; Wed, 27 Mar
 2024 10:35:58 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:58 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-12-tabba@google.com>
Subject: [PATCH v1 11/44] KVM: arm64: Split up nvhe/fixed_config.h
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index c59e16d38819..0fc1cf5bae8c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -78,4 +78,9 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+int kvm_check_pvm_sysreg_table(void);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 26dd9a20ad6e..7b5d245a371e 100644
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
index bc58d1b515af..d41163d1fed3 100644
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
index 2a0b0d6da7c7..302b6cf8f92c 100644
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
2.44.0.478.gd926399ef9-goog

