Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95E2904
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 13:12:21 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-545d3b026a8so169185657b3.7
        for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680268341; x=1682860341;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ppDEHCncVnZ8ejE+ldxU+BdB1gik71A27ogTq2h6lDw=;
        b=Gz6Q23YPuEDl6cxVF8Q6hZPzrzG9igDwJi0Cl/c2w+1l6kMywI4w+5oO0zBhGTO25H
         j+A6mOcBeDqt+4QCIgyf3PjbJQAduNF4HfXAKU50my7OQW065AJNzD9XHubzwBMqqOZc
         H3q27oq3glwZOqNS65IuPaDJNwUrJs66vc5NHDz7X9WmzmemSm4dm9/kZZpW3Xe5kPOw
         XC9M16LCpPCd1oU8djIMpRECh1etQWCYFX2x81lkB+LW8RCkU1Dio8AwYBgnmnIOiAZO
         i7bLOpNNJIRv6tJzOUgb9L1VFqmyfFd+ne19eJq6IOHpaeJhibkg/tQHPpNThqfc3zjK
         syUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680268341; x=1682860341;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppDEHCncVnZ8ejE+ldxU+BdB1gik71A27ogTq2h6lDw=;
        b=z8tXG1QrulnFIoXjeR0kPWm4oTOcA7NwVJApsOS82XJn62xM8ZnaIihCiDMIaop01s
         2Gxla6EZenBNytOtHaJe9VLB7VwshJUrtEDieJ8ejjp3Ouf8yFkz8QvRH954zNG+4U8T
         EXEhwpEqZ0Spx8RbBs02zuiOjykAeOXDCfcjBx9orKzNRHKAXTPx9MLNH8CPfwU8yGma
         KMvXW5/8onQOWG/pSp/9HfKd9/0FEPIZDZIWNihgJGbpcSHCXVRlXNKnfpAhLoRliKgI
         8TBtp6lsFMUtNltB6GWibKOUuPQ5H3eX9OZ63xOs0GGp8FwKz5sGVjTnFT4IpjtYQlcw
         vUSA==
X-Gm-Message-State: AAQBX9euBvgYwDQtafUHBgOyejXI6CA6sr8WEA0cIXW/sxTCQ9hVpOw2
	dl+rGTuMXExEoUo/WNC+1rZooIpBv8gyGTaM3tJpp3BJUo2jIXY6bA14K3zd9uNHO1JCDl5ApmA
	1rJkDo25XhO3mexjuqEduOKbagzkqHu3/rt9y3cw7QbKCey5E2bpkiLJWnPY=
X-Google-Smtp-Source: AKy350aC/bjTDB4XD86fAW/nEdgos/jRCFxE6YQkNfsHrmOPZRM5BzqPIfFtUfkijO2aKXRqqS3eAor2Uw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:d007:0:b0:546:81f:a89e with SMTP id
 v7-20020a81d007000000b00546081fa89emr7628531ywi.9.1680268340861; Fri, 31 Mar
 2023 06:12:20 -0700 (PDT)
Date: Fri, 31 Mar 2023 14:12:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331131218.2063233-1-tabba@google.com>
Subject: [PATCH v3] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@google.com, will@kernel.org, pbonzini@redhat.com, 
	james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	reijiw@google.com, ricarkol@google.com, rananta@google.com, 
	jingzhangos@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing pKVM code attempts to do that using a value
initialized to 0, but never set. To advertise csv2/3 to protected
guests, pass the csv values to hyp when initializing hyp's view
of guests' ID_AA64PFR0_EL1.

Similar to non-protected KVM, these are system-wide, rather than
per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>

Changes from V2: Fix masking not to affect bits other than CSV2/3.
---
 arch/arm64/kvm/arm.c                          | 24 ++++++++++++++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..0ae927c99fa1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,9 +1889,31 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
+static u64 get_hyp_id_aa64pfr0_el1(void)
+{
+	u64 mask = ~0ULL;
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
+	if (arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED)
+		mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+
+	if (arm64_get_meltdown_state() != SPECTRE_UNAFFECTED)
+		mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+
+	return read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1) & mask;
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

