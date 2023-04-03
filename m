Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31875683
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 13:29:57 +0000 (UTC)
Received: by mail-wm1-f73.google.com with SMTP id m7-20020a05600c4f4700b003ee7e120bdfso14556438wmq.6
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 06:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680528596; x=1683120596;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oun7qMM2JUBPgRqVRj6J3hUTComs6LVMUqOvGs8eiTc=;
        b=kcyvPXE7vL/9/ecIqW8heZZ6+GGxDUIwrs1ulyOKJkikSiBfJj6IkS2Wrs2pOcHsun
         HZyvKLgfqguEdx4k0Js+4KpxBv9I2UGZFP9eQVYmqFKdBY7jGLjLg0zanbcW/UVlTCVA
         PSDW1XTOMSU3o571tJ4sHjm63lQST9I2ZSx10Xei3O1FhxYA0VjeGhXbCSQMxPvitdym
         csW4uSMBIVqS8wEqPXf2ByA46v4tnqQkTuNa5/Gl8xLcjefyKzqFN0CUeydtTCruKQnr
         5umGYtVk3J1xxTsEt2qI2pOei3aNv7xomupQzHoUV4qdmzG/MigW23FBj8bYowkr8tKZ
         6BYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680528596; x=1683120596;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oun7qMM2JUBPgRqVRj6J3hUTComs6LVMUqOvGs8eiTc=;
        b=3+rRu61QJjUC6YnaHWcWjFmdE2JAfISU4TKSMhXCSDDUo+msK4Q8pGYnhr6ADBNONr
         zpY48B+T2VVcTaq1WBkA0VPloSWOL1yiYLiVyRioOjxcTeuGyjJNV6FY6qSSC2bYGMMI
         +B208+RfxBf1INpznLqq9XMTDpUmqsurf0q1v1mxNSKkHyCPd+oh9HQLPG042cmorjip
         wG/Ucip2IE6mO8C1QcUGaSIUzdp58t2l/Y7s21U1+O7OhGgJGIH3em3oiaIXhYeFGOxs
         vQIKlHuqrnRKaCDriiVyXc6o+yG+JutggFskY+gJo5g0FEycSO9GQMYvkXKI7yI+ig9c
         CZYA==
X-Gm-Message-State: AAQBX9eBJP2/XRlXSq96TTpznXv6b8ua2X+RUgDrS85ANsS0ALxArWsS
	Ni9m41p2ZP76YlfSeQTiWRrvD9DSVbhHgleefjWsN5Jn5NK31QL8Df1TX0HLLxtMV2el3Guk0fp
	kWtTeGVRfgHMyF1wgg2EjbXiqsEhuyPYHpll70ZruZu90IrcaNi30DrN/pvE=
X-Google-Smtp-Source: AKy350bZwNgenk8WoqYwlytq7Txbepp4RVWcEfbi8W2Tt1LqUPLAahTi7FvfVeWHJa9DXI6kD+NWGbTxQw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6b43:0:b0:2ce:ad47:6060 with SMTP id
 x3-20020a5d6b43000000b002cead476060mr5969571wrw.5.1680528595792; Mon, 03 Apr
 2023 06:29:55 -0700 (PDT)
Date: Mon,  3 Apr 2023 14:29:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403132953.2069621-1-tabba@google.com>
Subject: [PATCH v4] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, oupton@google.com, will@kernel.org, 
	pbonzini@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, reijiw@google.com, ricarkol@google.com, 
	rananta@google.com, jingzhangos@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing pKVM code attempts to advertise CSV2/3 using values
initialized to 0, but never set. To advertise CSV2/3 to protected
guests, pass the CSV2/3 values to hyp when initializing hyp's
view of guests' ID_AA64PFR0_EL1.

Similar to non-protected KVM, these are system-wide, rather than
per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>

---

Based on: 197b6b60ae7b (6.3-rc4)
Changes from V3: Fix masking to constrain CSV2/3 to 1 (Oliver).

 arch/arm64/kvm/arm.c                          | 25 ++++++++++++++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..04401c2851f8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,9 +1889,32 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
+static u64 get_hyp_id_aa64pfr0_el1(void)
+{
+	u64 mask = ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+		     ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
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
+	mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+			   arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
+
+	mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+			   arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
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
 

base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.40.0.348.gf938b09366-goog

