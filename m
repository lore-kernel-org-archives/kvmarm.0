Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCA11C5CC9
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648101; cv=none; b=iR90Gmx9a676EI2iT7Q9k+p/2H3127AlWUsr+sua7sSL6cJpukHIdH9106uFJViegSVhctPd0w9mhuGHQk3Uj1LqAC2RlLS1t6kWmvGjYUG3dLbrPC3sceEiEOCx9Lsn0e2OlcgHVZ+SBhrlrXPw031/fPebCP/uubX9ekKnQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648101; c=relaxed/simple;
	bh=9hnlQqpGM0lXZOgwzi3VD9kyFDXHQ4dqHB28MD0YOsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iSg3aw82udtfyUb/dKmiwzT5REf+6z4oG9/94mhyCTDfsCd3ep4sEBX60IMJ9S2L4C9L4KlYHdUK32kxUDGV1BmNlBieG9FRXMVfR6uuW618v+1SYHqzypddyW7MhIOr2pgoFrkGxNyQ/WcL/pXDQ9xCD/O+m4M7rl2KTueMXE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=axjfK1NZ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="axjfK1NZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9haBtz62WZA+vCCInPIjd2gy4GzsbEUbFkuV1fLaWng=;
	b=axjfK1NZ4LAiV3e7yeSEqcxQse2e6a+gurhEDAOsGPIshqME49MfXRhkdNwnqLlhSMDSn7
	bj91SMJeFWahwqTD3hu6PP93dSi8ciDtStdRERrZu66HDKhyZGuleHA1Qj1vmr1ucvM++w
	UaNL3oGoJhOFGTEddyuqP/RKur4GB24=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 04/19] KVM: arm64: Move host SME/SVE tracking flags to host data
Date: Thu, 19 Dec 2024 14:41:01 -0800
Message-Id: <20241219224116.3941496-5-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The SME/SVE state tracking flags have no business in the vCPU. Move them
to kvm_host_data.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 22 ++++++++++------------
 arch/arm64/kvm/fpsimd.c           | 12 ++++++------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb252d540850..d196bf0fce52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -610,8 +610,10 @@ struct cpu_sve_state {
  * field.
  */
 struct kvm_host_data {
-#define KVM_HOST_DATA_FLAG_HAS_SPE	0
-#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
+#define KVM_HOST_DATA_FLAG_HAS_SPE			0
+#define KVM_HOST_DATA_FLAG_HAS_TRBE			1
+#define KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED		2
+#define KVM_HOST_DATA_FLAG_HOST_SME_ENABLED		3
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -916,22 +918,18 @@ struct kvm_vcpu_arch {
 /* Guest debug is live */
 #define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
 
-/* SVE enabled for host EL0 */
-#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
-#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
+#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(0))
 /* WFIT instruction trapped */
-#define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
+#define IN_WFIT			__vcpu_single_flag(sflags, BIT(1))
 /* vcpu system registers loaded on physical CPU */
-#define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
+#define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(2))
 /* Software step state is Active-pending */
-#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
+#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(3))
 /* PMUSERENR for the guest EL0 is on physical CPU */
-#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
+#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(4))
 /* WFI instruction trapped */
-#define IN_WFI			__vcpu_single_flag(sflags, BIT(7))
+#define IN_WFI			__vcpu_single_flag(sflags, BIT(5))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ea5484ce1f3b..0e0f37d1990a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -65,14 +65,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
 	*host_data_ptr(fpmr_ptr) = kern_hyp_va(&current->thread.uw.fpmr);
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
+	host_data_clear_flag(HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
+		host_data_set_flag(HOST_SVE_ENABLED);
 
 	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
+		host_data_clear_flag(HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
+			host_data_set_flag(HOST_SME_ENABLED);
 
 		/*
 		 * If PSTATE.SM is enabled then save any pending FP
@@ -168,7 +168,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
+		if (host_data_test_flag(HOST_SME_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
 		else
 			sysreg_clear_set(CPACR_EL1,
@@ -227,7 +227,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
-		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
+		if (host_data_test_flag(HOST_SVE_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
 		else
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
-- 
2.39.5

