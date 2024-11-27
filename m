Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC8194C9D
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701712; cv=none; b=pH+q1IBkk7Hb8QYxsqAFvPiuG+DxObcVbCon20JohEYu0hUHBck/YRN/+wavpkxFrSJXBUFaqydUjQFQuPjkCkQ3roqlFI28kwh8hInn3ohPitaPh50jHqI+lSK8I8uf8B8EB4vZ22iEkXQ0nO9k50NRm3JfC3VPZADMtj+GV70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701712; c=relaxed/simple;
	bh=BErkyHyhiDq43VD1qTGQtfYGDi/YBL3HvvqXF7yk5Lc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3nImahUxm4vffMq69TU6/IWT0oqKnW1JkSbIhsD9Im5sM12KxdJXdWq1fqsPiXjBCsQJRQQJUS/PON2+eNSTFBfw0YnMQqWiPKLCo5qxrczO/cGahh57eidP6dQSgfdrf/S1n4V2s1kzKBOTsYq/LV0BhUrECWg6jwvCj3cnUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x+q7VZKY; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x+q7VZKY"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cfd3a7e377so8430211a12.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701708; x=1733306508; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8IXZQtrQe+QG8clUE2zr1MHtw2SOo30KxSiJ2MznX8=;
        b=x+q7VZKYNJ/8GPP+dBWKmywRhuHGw5l7N6kRtXYBXMNvILSz2lyrGNUqYpQttB0yNb
         c2a6/1Wsmb4rAyXFqswGgWKW7rcUMYYuOB28avCullZ2g2uQZwnkJDgiHBUT7QoFtwUI
         kPhm6dTGR5Lm6P6IBS4pCEozJvHK0ZQ1nXrBzR0fC8CwvANkTffUpOcH9+izuxPjUktv
         0tQxnkASRMn4FkYtehxtNZRBoS4mSr+3x/UzVRjiKnij3KMxaAf+FxThSRO87Ic3d/np
         tXJmVEfgYhynVm51NEoEk6EAWTnhaMW/75nsI6GRRz5k3FDrzKmQjx/5D7OFJSTIyz8w
         fqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701708; x=1733306508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8IXZQtrQe+QG8clUE2zr1MHtw2SOo30KxSiJ2MznX8=;
        b=m7QNeSxchpQq7yc5ugpDIqoLlj/cISZk9BTOE4IboETWcsUcNWKGJK4LGSCd8e3d5k
         1G7J2zhTMKDJUZ60pj38nDWhuijfpb5UAoJ07BuAHyBq34lGM/5S77jybUc8qfYzhs42
         NjpQHrMj2W7jOnKNso64E520a5YZRE3dbhCYqPYWwDnnCPLIw5HGT4xHwneXN6IdwlM4
         ogs+o8oASAdPJUKgy+p8IvwMQy2WPkB1zm7v5kl6E181MQm1quEKFX0EJ8mROkV2nkdS
         5R16E4oupHr6gdtv7MknidhjGda7kvgkGsIgH3puGOLlg+LqYvHBCwrUakOmgfmBtDeF
         NYbA==
X-Forwarded-Encrypted: i=1; AJvYcCVWsY1+mZ7q96TUL5j+S/YaScaWvG774dGHnISmbtOb6RwwA0F79dwZgwbj4Ii8Kz6uKyszDJo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHhz/cwg/Rx/lZuL/fEp+KIXt0x0XDDMs5bgPnY/alY3OqHOVc
	t3wfDFzG9DUMPwzPRIDvCgOGjmnbD0CqSvEdRQDe7wHGROg2312jg94vzcGFE0I=
X-Gm-Gg: ASbGncusqopE4eML2zuDlTabrV5CRHA0BXhoPDyelB3445vT7EgfgCOM8FogT/Yyjt5
	xmjrxVdyQ789PgMLGcDo82NIxEz0+Ma9kh+hTAQx79QIK0vdwjOpSsdrNle/PqxY+np7PIgODTO
	wy2Y4mQeU3PjH3Bg/hhmeQCrov3YbfglIsQPj2oHx/STWv1Y7ybm374Cne/HTX3o47bzvxOB7vN
	eExpxf3e6+uSUtuFKPgJF8LQfFzC8FXCmtQ/Bj6PKLTxzCRrA==
X-Google-Smtp-Source: AGHT+IF6aoMeybQynniFtjBLCVbSjMXDujtwoTF9DDB/rAxTHRjQUri2uBbUKbvzHXkufJAm29/O+g==
X-Received: by 2002:a17:906:18b2:b0:aa5:b54:7549 with SMTP id a640c23a62f3a-aa580f4d9e2mr141128566b.34.1732701708364;
        Wed, 27 Nov 2024 02:01:48 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:01:47 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/8] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
Date: Wed, 27 Nov 2024 10:01:18 +0000
Message-Id: <20241127100130.1162639-2-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127100130.1162639-1-james.clark@linaro.org>
References: <20241127100130.1162639-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

KVM caches MDCR_EL2 on a per-CPU basis in order to preserve the
configuration of MDCR_EL2.HPMN while running a guest. This is a bit
gross, since we're relying on some baked configuration rather than the
hardware definition of implemented counters.

Discover the number of implemented counters by reading PMCR_EL0.N
instead. This works because:

 - In VHE the kernel runs at EL2, and N always returns the number of
   counters implemented in hardware

 - In {n,h}VHE, the EL2 setup code programs MDCR_EL2.HPMN with the EL2
   view of PMCR_EL0.N for the host

Lastly, avoid traps under nested virtualization by saving PMCR_EL0.N in
host data.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h   |  5 +----
 arch/arm64/include/asm/kvm_host.h  |  7 +++++--
 arch/arm64/kvm/arm.c               |  2 +-
 arch/arm64/kvm/debug.c             | 29 +++++++++++------------------
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  5 -----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ------
 arch/arm64/kvm/hyp/vhe/debug-sr.c  |  5 -----
 7 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ca2590344313..063185c202ce 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -53,8 +53,7 @@
 enum __kvm_host_smccc_func {
 	/* Hypercalls available only prior to pKVM finalisation */
 	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
-	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2 = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
-	__KVM_HOST_SMCCC_FUNC___pkvm_init,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
 	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
 	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
 	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
@@ -247,8 +246,6 @@ extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
 extern u64 __vgic_v3_get_gic_config(void);
 extern void __vgic_v3_init_lrs(void);
 
-extern u64 __kvm_get_mdcr_el2(void);
-
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
 	"	.align		3\n"					\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f333b189fb43..ad514434f3fe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -642,7 +642,7 @@ struct kvm_host_data {
 	 * host_debug_state contains the host registers which are
 	 * saved and restored during world switches.
 	 */
-	 struct {
+	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
 		/* Statistical profiling extension */
@@ -652,6 +652,9 @@ struct kvm_host_data {
 		/* Values of trap registers for the host before guest entry. */
 		u64 mdcr_el2;
 	} host_debug_state;
+
+	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
+	unsigned int nr_event_counters;
 };
 
 struct kvm_host_psci_config {
@@ -1332,7 +1335,7 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 
-void kvm_arm_init_debug(void);
+void kvm_init_host_debug_data(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..ab1bf9ccf385 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2109,6 +2109,7 @@ static void cpu_set_hyp_vector(void)
 static void cpu_hyp_init_context(void)
 {
 	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
+	kvm_init_host_debug_data();
 
 	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
@@ -2117,7 +2118,6 @@ static void cpu_hyp_init_context(void)
 static void cpu_hyp_init_features(void)
 {
 	cpu_set_hyp_vector();
-	kvm_arm_init_debug();
 
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ce8886122ed3..0dbabb6e1108 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -21,8 +21,6 @@
 				DBG_MDSCR_KDE | \
 				DBG_MDSCR_MDE)
 
-static DEFINE_PER_CPU(u64, mdcr_el2);
-
 /*
  * save/restore_guest_debug_regs
  *
@@ -65,21 +63,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
 }
 
-/**
- * kvm_arm_init_debug - grab what we need for debug
- *
- * Currently the sole task of this function is to retrieve the initial
- * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
- * presumably been set-up by some knowledgeable bootcode.
- *
- * It is called once per-cpu during CPU hyp initialisation.
- */
-
-void kvm_arm_init_debug(void)
-{
-	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
-}
-
 /**
  * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
  *
@@ -99,7 +82,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
+					 *host_data_ptr(nr_event_counters));
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
@@ -343,3 +327,12 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 }
+
+void kvm_init_host_debug_data(void)
+{
+	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
+							      read_sysreg(pmcr_el0));
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 53efda0235cf..1e2a26d0196e 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -106,8 +106,3 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	__debug_switch_to_host_common(vcpu);
 }
-
-u64 __kvm_get_mdcr_el2(void)
-{
-	return read_sysreg(mdcr_el2);
-}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86e5..16f5da3a884a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -264,11 +264,6 @@ static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 	__vgic_v3_init_lrs();
 }
 
-static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
-{
-	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
-}
-
 static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
@@ -384,7 +379,6 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 static const hcall_t host_hcall[] = {
 	/* ___kvm_hyp_init */
-	HANDLE_FUNC(__kvm_get_mdcr_el2),
 	HANDLE_FUNC(__pkvm_init),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_cpu_set_vector),
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index 289689b2682d..0100339b09e0 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -19,8 +19,3 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	__debug_switch_to_host_common(vcpu);
 }
-
-u64 __kvm_get_mdcr_el2(void)
-{
-	return read_sysreg(mdcr_el2);
-}
-- 
2.34.1

