Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB1D1EB9F9
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249678; cv=none; b=SmLzkW+WVnwvxTqb3UQir01skgf1n+wzAZtlyJrV1n40Rdo1/6k4wPXQEWsZThIjC2WCWjOKDUmYtZ8lfYoiKbmCTOfSXEvvYmjv0HvyIm9187SPZeyJmFPGc7qzyLGSi8wd230xr1Pukgx7+1uq0vJQnZr3+M0YQhxI2AZXKX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249678; c=relaxed/simple;
	bh=iOXWpao8tAMomenHhnLXm2BgavMdVLScmJoiwFvtpWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DJ5mcy6uPoxLsjnD6LhwsR616QAGQJe8bMd3Iql4ParwTT+yptm23F7kuyr1mUbXXRSfBmPJH9lFIud4lnfrKBfCHxjX6GY49lDeIVs4WMlqe5i1uoA0V5Hlx3JZuOLUBqAgaEOq/jXrL5qq3dFmMnH0T3+SHUV0A14w9wlmCNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kz9k9GA8; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kz9k9GA8"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385df53e559so12071406f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249673; x=1736854473; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEwlmUKHFzSaBhYRka1iF8EthtWsBcWlAWnCafzs3Pg=;
        b=kz9k9GA8PYT2WgzLvIKBll5OsupLhQpvAyPg2j1EJOG05AvzImQgs/LzWKpCbJzNoo
         fLkHIlc/DCaa7ZogZyn3U6AsHJiVppUrFV4eTIpN40jEoVdBPBMRRpNiVdQT9IWQSzGn
         mNjsgxyIm3y14A0J4xNqmP/CPqw9KXRn3yCUHtoTtUC3UHLV4308bGeq8OjfzFGd1XFA
         UgzG2ZiX3UAQlY8pXQqKF2BCXGOJszhkTauJBlf95K9SprnCz961WeEHKtb3lSkLWyez
         dTihZCVtyhdo0iunKNhuYaNO1assM1y9Y252qV7HXUQ44JO9x8TtFIqJHteLe3BGRksh
         JgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249673; x=1736854473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEwlmUKHFzSaBhYRka1iF8EthtWsBcWlAWnCafzs3Pg=;
        b=sOOdsAv2zx/edbk/xRJlk24CnhDH5ktt9AVI7szfrBs3DwJDFXObMvF2Nq+hCW7rUp
         96mjs0kWtbFua7eVB4VFCsjOYIuHb+bqvs5V3q0QsIUlr0QycQO/tX+BPXKc31M4X2Qe
         O3m8gFCsahbqcXDPAaPscK8lMIGYtu4wOe7deFNH7PhgyRqDo0RcKzXxjkAfHrdSdrDP
         InZmHYxEBVpYKEKEnGWFpA2l+tiT0A0QmDuERJnq3dygnASVy/ywu3u+7JvMcYCHnyii
         YJyEWImE3GJjh7sRGn9fBPoWlcpLPr5a7XUnB7crUOVMGiZxVg3TcNKNN52TYMaYmd84
         Tj0A==
X-Forwarded-Encrypted: i=1; AJvYcCWTWJvknWF6TFHl2xgAwH2hMaUZNVcvpudUF8ak1rIKL87VzpPb/pyR0jhF7UVY2kVaR/pacy0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2BauCsfg7AwMjxOABDyq/7Iyr7AICgjsSdZlGcGZJ49bzPzSd
	eBuN/uV96/TDzVhMad2Pd8u/oNwcVB+gqovSh9XCi2BgxyG4LZ0V6/xmDNOkEviC0UCPmmHum+A
	q
X-Gm-Gg: ASbGncvJPnBWsOHEWaVWqoGHjWyPuFF3PXue3SfzNt9tojtV0juyaURZA7awhZr0l/C
	A8ws5ek/a7fLDOIzWte680t+2lPGbunGU1ecQJCY87sxNRW+KeYdCOCUlEySB05xeo3gDxM/jtW
	Ynu2gUUZTZilLmB9YnUQbhejZsUgYmGAxDHlySyvf0DcEsflaUNwzOYJv3wtVQZ26fily3YG/Gy
	mOoIlca/YJhfZ9c0T67GbllChkg7/GM98wFlY75YJoC5rjbyUvovc3j
X-Google-Smtp-Source: AGHT+IHbyZC/6R2NLq2cscP6k/cxmIqPHv5zu3Yng+oav3cmo3eJA6Bdt7S3W1BSgUHa3jUWyRCpEw==
X-Received: by 2002:a5d:47af:0:b0:385:f10a:335 with SMTP id ffacd0b85a97d-38a221face5mr50014560f8f.21.1736249673009;
        Tue, 07 Jan 2025 03:34:33 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:34:32 -0800 (PST)
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
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 03/10] KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of vCPU
Date: Tue,  7 Jan 2025 11:32:40 +0000
Message-Id: <20250107113252.260631-4-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Add flags to kvm_host_data to track if SPE/TRBE is present +
programmable on a per-CPU basis. Set the flags up at init rather than
vcpu_load() as the programmability of these buffers is unlikely to
change.

Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20241219224116.3941496-4-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  | 19 +++++++++-------
 arch/arm64/kvm/arm.c               |  3 ---
 arch/arm64/kvm/debug.c             | 36 ++++++++----------------------
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  8 +++----
 4 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 064f5dfca7f4..fb252d540850 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -610,6 +610,10 @@ struct cpu_sve_state {
  * field.
  */
 struct kvm_host_data {
+#define KVM_HOST_DATA_FLAG_HAS_SPE	0
+#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
+	unsigned long flags;
+
 	struct kvm_cpu_context host_ctxt;
 
 	/*
@@ -911,10 +915,6 @@ struct kvm_vcpu_arch {
 #define EXCEPT_AA64_EL2_SERR	__vcpu_except_flags(7)
 /* Guest debug is live */
 #define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
-/* Save SPE context if active  */
-#define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
-/* Save TRBE context if active  */
-#define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
@@ -1310,6 +1310,13 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+#define host_data_test_flag(flag)					\
+	(test_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags)))
+#define host_data_set_flag(flag)					\
+	set_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
+#define host_data_clear_flag(flag)					\
+	clear_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
+
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(void)
 {
@@ -1370,10 +1377,6 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 	return (!has_vhe() && attr->exclude_host);
 }
 
-/* Flags for host debug state */
-void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
-
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab1bf9ccf385..3822774840e1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -617,15 +617,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu_set_pauth_traps(vcpu);
 
-	kvm_arch_vcpu_load_debug_state_flags(vcpu);
-
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_vhe(vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d8ea6fe6a2a2..1ee2fd765b62 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -294,40 +294,22 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
+void kvm_init_host_debug_data(void)
 {
-	u64 dfr0;
+	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
+							      read_sysreg(pmcr_el0));
 
-	/* For VHE, there is nothing to do */
 	if (has_vhe())
 		return;
 
-	dfr0 = read_sysreg(id_aa64dfr0_el1);
-	/*
-	 * If SPE is present on this CPU and is available at current EL,
-	 * we may need to check if the host state needs to be saved.
-	 */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
-	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(PMBIDR_EL1_P_SHIFT)))
-		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_SPE);
+	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
+		host_data_set_flag(HAS_SPE);
 
-	/* Check if we have TRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
-}
-
-void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
-{
-	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
-	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
-}
-
-void kvm_init_host_debug_data(void)
-{
-	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
-
-	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
-		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
-							      read_sysreg(pmcr_el0));
+		host_data_set_flag(HAS_TRBE);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 1e2a26d0196e..858bb38e273f 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -82,10 +82,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
+	if (host_data_test_flag(HAS_SPE))
 		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
+	if (host_data_test_flag(HAS_TRBE))
 		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
 }
 
@@ -96,9 +96,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
+	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
+	if (host_data_test_flag(HAS_TRBE))
 		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
 }
 
-- 
2.34.1

