Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FFE4D9FE
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154483; cv=none; b=HY9eSsa9kqusj5+8IHDNsixzM2bf2Ux4Amj/9uZ/k7EWRUOogKmtj2gn1/CPYrDgLRULDZ1xPsiRp8F1R7xEzB4dSOv2ucrCnPEllsxSYH4QQevnRxi+Tmyn2ympnRe0nj3jVFiBXL9MTJHz62WMC5Qt0kLJbUUPYwYIiUm/l0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154483; c=relaxed/simple;
	bh=jlokVIfWLgAdN7T1UO25YZNwizBrY6SZag8AGA1rH78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ckyHTcSh9PYiy5/Z9m9wT7sll5voUI9j3e9PtfDZtSzBH1nCmhjRaJJtQrSvbR0t0FlZgXhZEcRQIBZnKdW/uAvsOVxzoFTkm/mvctpKSdF+GVcssyRkNH3LrHmSaw97qxoZVvPiIT/nsV1VjUO+ofVXnfisqx0FySGTk4Y4GTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=idNc4yiy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="idNc4yiy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434a9dce888so28224495e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154480; x=1733759280; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NbfxC+fR9/uDI8W1cpOyy7vtTQ2CjdcHlP59+LYE8Uw=;
        b=idNc4yiy2qiZwmgNMyx2ZqFogHZ0G13umeLsLAdcGmtz6036ZgBcLICG8n0W0Znb7q
         jaSZss3gvvG2/YmDPxxqYk7uILb5bK9Shs///Snjqqs8OgfnQoOZgTFAkkiON/rfTHE2
         KIw6TukmsIYkUUlbfNDzGAYqhuRsdYO7/x8ElGQZAOd3DBEeKw5q+UsVsPa1PUVfWhzK
         n24I3BsnoNSunp2Kmwl1p0422hhYNKtToSDkoWDJPNcPUJ12kPgYIzYDvHxTpUXJn0fX
         qhvjhOROka5DMCg/cMcF6s9xcZ/AFSmFY+XXG+gl0k8LkTFoVUETxcpgzafKMvIa9Nkf
         aCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154480; x=1733759280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NbfxC+fR9/uDI8W1cpOyy7vtTQ2CjdcHlP59+LYE8Uw=;
        b=Jm9GHEl8+ioMOzGRgN9KB4GLPlge/1yzHBeISg/EOwbYB1j7XFEDtJcJVZpiaZKP5d
         jeA/yYylVZlBbrHJjxGaAcKc5apkWqZr374Ujt4eXMG19SAruJ5bxqtVkqS/hhMPPXcW
         HWWafdQZXH9dkUnUX25/zA6WQtFKUbx1kK8DukqICdRBqXYe+SryczWOdF9RVoZCI1Y2
         alvjEdRxJhJrucdDLj/XyQziuBNe6aLbwHEvNHIgXPCxOgvOg51t/02KYc97JLUp7ETX
         njqSuqym85vr6V4aB0vSM9tuiEo9VlxQQy70fNN3q1rU5XwTJ////5qWDKw0/ZwDGAbd
         lxPw==
X-Gm-Message-State: AOJu0Yx0GYP93H+KooGBHioAANXVFA7BsLFwccksnTo71AMPwtZktJot
	s6Y+eAtyj0W1e03hGfvUh2nlZSJ3khWZsFCWd6IzKuTwwgkqh4U7glIJ366/B5FohtXmky7EMHv
	8SilK5TF0kSChg/o4TrB/WF3j3ntU1FdBERZeUBvAfG9ysLuLMyEBBGL8CXx1xyn7csrtqXw8GU
	2HUAXoUo3qca5ATv7s+2TMvx8bGSU=
X-Google-Smtp-Source: AGHT+IE9+9RWKEBLBqD2njimlutPRxnVob73f3H3Ulhy+fUDehzZX41Bf18Rqx5qH3eOymnVjulgPzDhSQ==
X-Received: from wmj5.prod.google.com ([2002:a05:600c:245:b0:434:a4a6:487a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f18:b0:434:a663:a59d
 with SMTP id 5b1f17b1804b1-434a9dff4edmr189552765e9.32.1733154479929; Mon, 02
 Dec 2024 07:47:59 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:35 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-9-tabba@google.com>
Subject: [PATCH v4 08/14] KVM: arm64: Remove fixed_config.h header
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The few remaining items needed in fixed_config.h are better
suited for pkvm.h. Move them there and delete it.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 206 ------------------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   1 -
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 -
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   2 +-
 6 files changed, 6 insertions(+), 210 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
deleted file mode 100644
index 37a6d2434e47..000000000000
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ /dev/null
@@ -1,206 +0,0 @@
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
- * Each field in the masks represents the highest supported *unsigned* value for
- * the feature, if supported by the system.
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
- *
- * Restrict to the following *unsigned* features for protected VMs:
- * - AArch64 guests only (no support for AArch32 guests):
- *	AArch32 adds complexity in trap handling, emulation, condition codes,
- *	etc...
- * - RAS (v1)
- *	Supported by KVM
- */
-#define PVM_ID_AA64PFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) | \
-	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL0, IMP) | \
-	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL1, IMP) | \
-	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL2, IMP) | \
-	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL3, IMP) | \
-	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, IMP) \
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
- *
- * Restrict to the following *unsigned* features for protected VMs:
- * - 40-bit IPA
- * - 16-bit ASID
- */
-#define PVM_ID_AA64MMFR0_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGEND) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_SNSMEM) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGENDEL0) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_EXS) | \
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
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_I8MM) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
-	)
-
-#define PVM_ID_AA64ISAR2_ALLOW (\
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_ATS1A)| \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
-	)
-
-bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
-bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
-void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
-int kvm_check_pvm_sysreg_table(void);
-
-#endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 24a9a8330d19..6ff7cbc33000 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -70,4 +70,9 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
+int kvm_check_pvm_sysreg_table(void);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3b4ea97148b9..ffa500b500f2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -9,7 +9,6 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index cbdd18cd3f98..31bd729ea45c 100644
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
index cc69106734ca..7786a83d0fa8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -26,7 +26,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
 
-#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
 
 /* Non-VHE specific context */
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index b6140590b569..2f2f1ca32b80 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -11,7 +11,7 @@
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/fixed_config.h>
+#include <nvhe/pkvm.h>
 
 #include "../../sys_regs.h"
 
-- 
2.47.0.338.g60cca15819-goog

