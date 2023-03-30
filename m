Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23721C31
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 10:17:41 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5458dde029bso184885737b3.13
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 03:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680171460; x=1682763460;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ylRwiMX8ut2POJ76uV8i6cLT1vV2RTRi3142P8I6X9w=;
        b=og1YnZM81nYRf+s9WECcFORcLXwQiufjrmqjL79QNb28mLcDvWIJ5GRE17FKi1LqNU
         O/aSCDrQIsGcpRmZ7wfyHZeNtXllMwylE+Mxv3OJriuep7iwsY7pQZ8l1yfSFAFcg2k+
         6aDQjY6YvtgtkSngCsvstZscAJcyzPRKSqvD1k0M54xBmMPXpC1Wa4PaU+E0BHrkGc+S
         3x9DvdSKAbcab197MhoQgZ0Hz0hkTGU6lrv5KmDeFx3hMg7XEC7bxbhKHJalXyFkfKea
         /8mxH4DEcK7dzbU/V7DKWwjc2zF5LJCEVvcK4XWnow1RgCD9raVEIIZ3Z0mjLgren5E5
         /qjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680171460; x=1682763460;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ylRwiMX8ut2POJ76uV8i6cLT1vV2RTRi3142P8I6X9w=;
        b=M9ZF4B/TCR2lNJy9iTB+SOY6TQR0qbR65o5ZsbUEpEPR6+70YF7FFoNZ74JrkM1/aA
         rSkGoyX/9YKs0adiPJkLgwgPtGUKCV8XapHq3WWthp/BKHNHujmDcu+mzE5UpnJb8Q5h
         KQlttSqIC8/bpJSfz8veoFPcee5i2/3zpmpChdrjEARYloKF8oZnehhOhKWQ1S4ljrNB
         pJ3xgwA5njIp8XyHA1E3A6hNfaKdCb6DLQvqu4gCbl+hXOBJKMpwD18MG0j7HhlAIkWT
         /uCUeeFbZPosa8+CMmBs3hkGk/GqInsjCkF4RYvDQ1HUzXUwg8Na7df+3TqnDCov9hic
         PfWg==
X-Gm-Message-State: AAQBX9diRnnXJ1nMbKWwLLbHxkOgLLCCdQJ+lMHKsYIWicK8RCVhJ+ZA
	9FQ0cmW1Neo2aIqZvVZigpTvGejGtE7R2SORI4XW7GvZjG5pTAp4ZUo2NqfKcv15kIcEWDvJr4Z
	bhm1JtHd01rp1Caa5Zb7O75MncyKYlRiUO477yt2omFb/wvFd8H/gNXPDGyI=
X-Google-Smtp-Source: AKy350bQ/uQN2JTU4adaq02l9XVBASrtSJy+t8umqvqTHrYF4h7QdbIl4o+bC0fVB0+G0HQ0mtrumzRAig==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1004:b0:b75:968e:f282 with SMTP id
 w4-20020a056902100400b00b75968ef282mr14857594ybt.11.1680171460612; Thu, 30
 Mar 2023 03:17:40 -0700 (PDT)
Date: Thu, 30 Mar 2023 11:17:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330101738.698181-1-tabba@google.com>
Subject: [PATCH v2] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@google.com, will@kernel.org, pbonzini@redhat.com, 
	james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	reijiw@google.com, ricarkol@google.com, rananta@google.com, 
	jingzhangos@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing pKVM code attempts to do that using a value
initialized to 0 but never set. To advertise csv2/3 to a
protected guest, pass their values to hyp when initializing hyp's
view of guests' ID_AA64PFR0_EL1.

Similar to non-protected KVM, these are system-wide, rather than
per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c                          | 24 ++++++++++++++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..68e8e04e1143 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,9 +1889,31 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
+static u64 get_hyp_id_aa64pfr0_el1(void)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	/*
+	 * Track whether the system isn't affected by spectre/meltown in the
+	 * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
+	 * Although this is per-CPU, we make it global for simplicity, e.g., not
+	 * to have to worry about vcpu migration.
+	 *
+	 * Unlike for non-protected VMs, userspace cannot override this for
+	 * protected VMs.
+	 */
+	val &= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+		arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
+
+	val &= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+		arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
+
+	return val;
+}
+
 static void kvm_hyp_init_symbols(void)
 {
-	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 07edfc7524c9..37440e1dda93 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -33,11 +33,14 @@
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
  * - Data Independent Timing
+ * - Spectre/Meltdown Mitigation
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) \
 	)
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 08d2b004f4b7..edd969a1f36b 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -85,19 +85,12 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
 
 static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 {
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
-
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
 

base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.40.0.348.gf938b09366-goog

