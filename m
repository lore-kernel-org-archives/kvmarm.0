Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116AC2AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346264; cv=none; b=ZlkrEft8nVpyjt5X5nS+lV/AfebKQTAL9RxHVF3/tOpC8OBj7nzc6WCbgn677P0Fu/zKVTPX2aCJD0429BtkIRDQpN76jDH1TWQgbl90qk2yot+/Q6vjH/waVJEaRN6E1XR7GlxmFONLH1OVHtPMTMmnB6PgJjhVsY5tIbIDbc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346264; c=relaxed/simple;
	bh=gpdoDMolE5IVQozMLvqalMkT+GTxbtawk7VAmpSYmNQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q9+s4jdIgHVqCsR4EVHd3F3HjSHdBzhh1qYqNURqP6LguqYnPe9Lw0dPC6oOCjcnwFmOCqC0i5bWJKgZV2xuI23HNwwRso0h3uOXPUTM0Bm4YrhZydsD5xEGVebh7Igjxmaqpua8zxF/PG0+gBefWFzbDL6stcDJUhPICPw4L+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bREcXRY3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bREcXRY3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so14588815e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346261; x=1734951061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zRQ7PRNmj+nfvYjoMEi8DazszN7AvCLCuGHxHUZQekY=;
        b=bREcXRY3piTC/NTnaJpWI3/smedQMbDoXMcOIBlD6a/nIySJQrpGUVoxv98zdQ+6mn
         /3Ri9t3YJaQpJ0DdzEkaH33XKqNagJFLKL4WvGK0Ua8K7UVb+kzFzVWto92Kgmxrb6+b
         79mNb3t640Z7Y4v9Xki7H+EKP/+2aU+clpFfiHCGHwKu6LLMX9z3hjlcWe8qUSsY3gCo
         ddekDxPUew7dBzZb+oy+SOa9Y2Vbpc1xJwevZ7z8yweuaqvTIajikSLFlIvUVPEUOi9l
         qZfCkkQWkglknHUfPlQB+JlzDwZqupMWA6PFlNjO3haTgc8xFhbbzk7QmNN/97FVMXq0
         OdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346261; x=1734951061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRQ7PRNmj+nfvYjoMEi8DazszN7AvCLCuGHxHUZQekY=;
        b=xOAjD6Zt6bZ5rLnNishRBWzM9P/2sgNS8TAY4t6k44HbkUAv9uUFKzERoF6mJy/N+s
         kIEUObCWsQ3QDVpGBO76Hgmb46uNvEhaAj9z762Pz2rmhwe7gobvMwmCGrlmmnzXEUDu
         vpcnHwKpr+hKqPqgo6iXD01u4QEp3XgdDDMC5MfY6NfXlqPRY9wlOjmhi8JyvJLsoZys
         W+i6f2V56a1SMQBrhNMPB2Kvc/VA+WxDSJaYgtG+ssvwLOjitKfvlD2i/YsL925eojrL
         p96ilbjt58uPRmxi+mgoYd5v3cJE7JuToXjoYXzMcUHOBphuqQrrokS+Z68uFfqbyOQ0
         H0vQ==
X-Gm-Message-State: AOJu0YyXQu1b1MOiyEybiProJj7j5el9A4ApBKvq0IkAagzqe+yaN3Jp
	DEk2UUm0Qv061NBcb3T+pvBaJbQQdccMj0SHASqb8oPuJ+rFtW0QVsB4qRntk8T9gcQ4uztK/ss
	BS8xV24hmq+hKbG1cL7bqwXiz/PM24w7Y02KrdAzf+n9pC/3tYTxmnMWV0SCQ+KvU6vxpimcboM
	2R0CK6rA7DED6uQxJTff+gmHQvlhg=
X-Google-Smtp-Source: AGHT+IHM5JhLqokh7SSz5/5oRxVL9Rs9IFvD+8QtCPfDiuD93MS42ARuKyN2VDCNYkrVzHM3iakRK0lxow==
X-Received: from wmnm10.prod.google.com ([2002:a05:600c:160a:b0:434:9e7b:42c1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c12:b0:434:f623:9fe3
 with SMTP id 5b1f17b1804b1-4362aa3d8bbmr117978245e9.16.1734346261312; Mon, 16
 Dec 2024 02:51:01 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:41 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-2-tabba@google.com>
Subject: [PATCH v5 01/17] KVM: arm64: Consolidate allowed and restricted VM
 feature checks
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The definitions for features allowed and allowed with
restrictions for protected guests, which are based on feature
registers, were defined and checked for separately, even though
they are handled in the same way. This could result in missing
checks for certain features, e.g., pointer authentication,
causing traps for allowed features.

Consolidate the definitions into one. Use that new definition to
construct the guest view of the feature registers for
consistency.

Signed-off-by: Fuad Tabba <tabba@google.com>

---

Note: This patch ends up being a no-op, since none of the changes
in it survive the series. It's included because it makes the rest
of the series flow more smoothly.
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 55 +++++++------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  6 +-
 3 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index f957890c7e38..d1e59b88ff66 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -14,11 +14,8 @@
  * guest virtual machines, depending on the mode KVM is running in and on the
  * type of guest that is running.
  *
- * The ALLOW masks represent a bitmask of feature fields that are allowed
- * without any restrictions as long as they are supported by the system.
- *
- * The RESTRICT_UNSIGNED masks, if present, represent unsigned fields for
- * features that are restricted to support at most the specified feature.
+ * Each field in the masks represents the highest supported *unsigned* value for
+ * the feature, if supported by the system.
  *
  * If a feature field is not present in either, than it is not supported.
  *
@@ -34,16 +31,7 @@
  * - Floating-point and Advanced SIMD
  * - Data Independent Timing
  * - Spectre/Meltdown Mitigation
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
+ *
  * Restrict to the following *unsigned* features for protected VMs:
  * - AArch64 guests only (no support for AArch32 guests):
  *	AArch32 adds complexity in trap handling, emulation, condition codes,
@@ -51,7 +39,12 @@
  * - RAS (v1)
  *	Supported by KVM
  */
-#define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
+#define PVM_ID_AA64PFR0_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) | \
 	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL0, IMP) | \
 	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL1, IMP) | \
 	SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL2, IMP) | \
@@ -77,20 +70,16 @@
  * - Distinction between Secure and Non-secure Memory
  * - Mixed-endian at EL0 only
  * - Non-context synchronizing exception entry and exit
+ *
+ * Restrict to the following *unsigned* features for protected VMs:
+ * - 40-bit IPA
+ * - 16-bit ASID
  */
 #define PVM_ID_AA64MMFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGEND) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_SNSMEM) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_BIGENDEL0) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_EXS) \
-	)
-
-/*
- * Restrict to the following *unsigned* features for protected VMs:
- * - 40-bit IPA
- * - 16-bit ASID
- */
-#define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
+	ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_EXS) | \
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_PARANGE), ID_AA64MMFR0_EL1_PARANGE_40) | \
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) \
 	)
@@ -185,15 +174,6 @@
 	)
 
 /* Restrict pointer authentication to the basic version. */
-#define PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
-	)
-
-#define PVM_ID_AA64ISAR2_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
-	)
-
 #define PVM_ID_AA64ISAR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DPB) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_JSCVT) | \
@@ -206,13 +186,16 @@
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_SPECRES) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_BF16) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DGH) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_I8MM) \
+	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_I8MM) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
 	)
 
 #define PVM_ID_AA64ISAR2_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_ATS1A)| \
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
 	)
 
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 01616c39a810..76a70fee7647 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -36,9 +36,9 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
-		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_EL0_IMP);
+		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL0_IMP);
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_EL1_IMP);
+		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL1_IMP);
 
 	/*
 	 * Linux guests assume support for floating-point and Advanced SIMD. Do
@@ -362,8 +362,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), PVM_ID_AA64PFR0_ALLOW))
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
 
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED) &&
-	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED))
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_ALLOW) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_ALLOW))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
 
 	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 2860548d4250..59fb2f056177 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -89,7 +89,7 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
-		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
+		PVM_ID_AA64PFR0_ALLOW);
 
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
@@ -189,7 +189,7 @@ static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
 	u64 set_mask;
 
 	set_mask = get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
-		PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED);
+		PVM_ID_AA64MMFR0_ALLOW);
 
 	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
 }
@@ -276,7 +276,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
 	 * of AArch32 feature id registers.
 	 */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_EL1_EL1_IMP);
+		     PVM_ID_AA64PFR0_ALLOW) > ID_AA64PFR0_EL1_EL1_IMP);
 
 	return pvm_access_raz_wi(vcpu, p, r);
 }
-- 
2.47.1.613.gc27f4b7a9f-goog

