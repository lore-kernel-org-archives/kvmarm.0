Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11BF187859
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099998; cv=none; b=EBToIUkn+iWDYAe2v5dXF3Qjb3iwQMa9AuaAqzc1dn8qZweEiUcHmdKtCGLqQ1R7e9ycnLnCCpHZxlO4PJOx8CL9VOKLzs361ng9FJ00d+CkUTRiXjnMSRmKXpS8QNeyTVxZVxTwb7IvGNlIpCYSRYVkwhTTkrUHMMs7LwAuuY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099998; c=relaxed/simple;
	bh=C64arskZ+oyVREXEyb3xonRiXqP9GCkSWo/TzqKmYvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CvvqtOfzw8GiyNe6u1u9Wk21O8N1G60uRY+srFvS513MKipN1ral63/pknJ8yEygI1w4NcuNKe6eZlqmEdZgDzWN9gyhTanzijVGGcs3/19pAKq/aBmwQathXyqTZ3XuqwWbnsFUp3+kaY++wfPRilhzgnpD4Trc+7HFU/byB58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DIjl9rhr; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIjl9rhr"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e388f173db4so5091762276.3
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099996; x=1732704796; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRbY7Vyx0Y8lmzFhWa+fjhDBwE77t0ZGbcF3URsKydk=;
        b=DIjl9rhrkKjJtlHGM6kQuX43K4Jwt1fMITRknqxqVWnqixB+cZEQgMPDtNIVe1+xf8
         9/v1pBxPwICS8DCdJQQcGONLFlt7KQ6VvAeGLSuRwFp9DPSa1v2PlFG+zHa4JZyzx5HF
         +SaEqjR8p5fgF20L9LvE2nKr6suvLPGcemeLw6jeQQ4AqQwJHcS1NBHk19LHekoifRe7
         sWxNtsweAmyZC5DnCyjflqxgYSKbfw7CklxjcIJ2YZDEF3v3CORSdlNapLQ2Mbt9KmgO
         nJ012XOfkk/55DfZvtpl3VCvhCZ1DROqficlGOsKYrGTo4/BUcFpj0cS+BssmwZFTpdE
         U0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099996; x=1732704796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRbY7Vyx0Y8lmzFhWa+fjhDBwE77t0ZGbcF3URsKydk=;
        b=OoBQ0k6ziHxo7tve3VKQv8Lm3TU9vv3tsF9vShGXWH8R7LG5PKyE/b55nxonr7euds
         RCHlpeh5c6U9BrQVJnfjyhKWOXqXBVV1VYWuDTSm1Z8ZAr9GqboFnEtoR/fLOG1xIg5N
         PsmYSLjPA9lLxKHMmmnnw5aI9jp799knjgUG9ysViGYBURm6WX5URAicIdc36I1fFReE
         20IfUSPWhAZau6ansQVIut+bBP32msLSBg+Ico9c8x1m4mwJpdJWFmDhHcbhWApEeepT
         y61ePrDIrKAwZ/8xBul4Gk6BpPSHBb4tKxQmScj0UVDgrXwH2b/9BgWa/nOMUjCnlmYd
         VodQ==
X-Gm-Message-State: AOJu0YxkdpX9EYYhLE1MEH5Oi0u5RWVCI0TZj+FZhhvjcnL+oD/8gJNh
	bqmNHEt+38mogdSrtA7k9e0oR46QxCqGWw2xaS2vlxqIHfet3tHsRmmbL4tn5Q1ImtbqQm2N6++
	XfTm817llub1zFzT/8g8Ocy4rcwGO+BmcP9L/C1FjxE0AbTaRFUtZPF/m3YyzdkI5A4E8KvfVzp
	SO48iTVww0Fx5aKo33AfcMoTigd00=
X-Google-Smtp-Source: AGHT+IFiO+bXR6ubOFcJjGoy5bT14oeAFXxeLbdNwCIsrAC63WbidQF6Y7aneenw77F5AuzifIsqhr7WAg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:688e:0:b0:e38:164f:5bf2 with SMTP id
 3f1490d57ef6-e38cb728250mr858276.9.1732099995224; Wed, 20 Nov 2024 02:53:15
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:50 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-9-tabba@google.com>
Subject: [PATCH v1 08/12] KVM: arm64: Remove fixed_config.h header
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

The few remaining items in the header that we still need are
better suited for pkvm.h. Move them there and delete the file.

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
index 764d6d700598..17783c8ddb92 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -11,7 +11,7 @@
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/fixed_config.h>
+#include <nvhe/pkvm.h>
 
 #include "../../sys_regs.h"
 
-- 
2.47.0.338.g60cca15819-goog

