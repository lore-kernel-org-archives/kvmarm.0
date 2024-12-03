Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682420B1E8
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733254407; cv=none; b=sP+0lvarSZj8SxAPe8mzpIa5Q+d4dryKPdlVBMM5YHX7Z1TtOmXOWuNgrCZTfiKHV6ilQwBMIukLbqupbuuYUzw47bCypKZJzgniSqpN289e3zVuIiioLKJTpaNpXRac3/h2N/eiMaqLLi7CfnuOyZd0XEmf+3nkgvpLTvpfYFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733254407; c=relaxed/simple;
	bh=+PCEKzJasw8AkjeutmkmAB6tX4dV1GuYLClM918Nj6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OCSh2xMrAwLB7T0QP+sHSLoulZdDJTyO32C83+NArDCLOsX4NYG6ycP0xGG0Ap/STgcrmesOoPYctAclX2/nmw7aKlkvCuQ/+Jv7Hxfzt/xwGVroPmeneOTluqbPYYatYKe7QC0sFL7Pb8i7BMME+RuR4MXVFCdpdL1tv65ojg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ABfJj9lO; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ABfJj9lO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733254404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMkV/pqTTQ4xGbpkYJlRc+3Uzn+DOzgWu1oY5Quf894=;
	b=ABfJj9lOUFa4QL4SfDh/jffUv3QARMw9/qmSXApo0zcKjvYQ1rRQd+3TngiKXbuDemxIZX
	kim99oIrleFv7LnfgqRboKU6JwQ6ve1ragyhaEG0B1ydXQS5E8W5MGudukU1XcsV4neKw7
	Cbv0I4ov+FGLPOjwUgp/MCzn05hnkgc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH 11/14] KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
Date: Tue,  3 Dec 2024 11:32:17 -0800
Message-Id: <20241203193220.1070811-12-oliver.upton@linux.dev>
In-Reply-To: <20241203193220.1070811-1-oliver.upton@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Apple M* CPUs provide an IMPDEF trap for PMUv3 sysregs, where ESR_EL2.EC
is a reserved value (0x3F) and a sysreg-like ISS is reported in
AFSR1_EL2.

Compute a synthetic ESR for these PMUv3 traps, giving the illusion of
something architectural to the rest of KVM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 22 ++++++++++++++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c3995..da2ccaefaf6f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -418,6 +418,25 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
+static bool kvm_hyp_handle_impdef(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 iss;
+
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return false;
+
+	/*
+	 * Compute a synthetic ESR for a sysreg trap. Conveniently, AFSR1_EL2
+	 * is populated with a correct ISS for a sysreg trap. These fruity
+	 * parts are 64bit only, so unconditionally set IL.
+	 */
+	iss = ESR_ELx_ISS(read_sysreg_s(SYS_AFSR1_EL2));
+	vcpu->arch.fault.esr_el2 = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SYS64) |
+				   FIELD_PREP(ESR_ELx_ISS_MASK, iss) |
+				   ESR_ELx_IL;
+	return false;
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -429,6 +448,9 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
+
+	/* Apple shenanigans */
+	[0x3F]				= kvm_hyp_handle_impdef,
 };
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b291eb73f5e0..a9c7111b831e 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -105,6 +105,7 @@ WORKAROUND_CAVIUM_TX2_219_TVM
 WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_NVIDIA_CARMEL_CNP
+WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
-- 
2.39.5

