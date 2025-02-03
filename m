Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983AE1D5173
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607563; cv=none; b=rctaFUSC78NHzYWEIvYJtem60fKCUKyJ7vet8Wp7p5VMFvjVf8Yk2cgSwoh3xfF3Z3BPkaFDcfEc1oue2HAFf6nUPBp7wG3neG9PZ1EBq28NLLRSr0Fw9xZq2UvYEnGu1UI4T1Xerw0f1MLQorzDQ+Mg0+eoUhvaaOoQsTLzJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607563; c=relaxed/simple;
	bh=qI9InkdJlG3ONsCF2amZtFUht/2CoaJ8pQWWGv2hGTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rkotzGLARN1sFb4n6Rx6XdLEoR0tHvWvwXPTIU1dZRO/EKoVo9Y2HONPFkdYOuVilCj9kVk7p1ZkMB+jGVq011GWOYDd9AYVxx1jneYknL2GjRb1yWiXJMiuf3fA8z8qHLssdg3yWfUsvxju1yn5ED8hkb1X8UBDIvn2H+y7ahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LW15B7nB; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LW15B7nB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738607554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=760i6dR476/MTNrnwbRQgXi1sS911UZgG0OKDU/QKBc=;
	b=LW15B7nB+9b3JDc/pkJfTqG1u/J5RKDp9Kt6nctYtrFiGGNKtWoZJTQOFg6JtRBJph4oIB
	jNZp4vnvuRueOaCNgjT1GJ84A278jDRfCJPdHPZMXP2UZ81knbnnjdKx043jcREqd3NLYq
	ysF4YUwju1LsdY0/7RwZcgGHeLumoOw=
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
	Oliver Upton <oliver.upton@linux.dev>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH v2 11/14] KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
Date: Mon,  3 Feb 2025 10:31:08 -0800
Message-Id: <20250203183111.191519-12-oliver.upton@linux.dev>
In-Reply-To: <20250203183111.191519-1-oliver.upton@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
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

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 22 ++++++++++++++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b5b9dbaf1fdd..3456996dd65f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -525,6 +525,25 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -536,6 +555,9 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
+
+	/* Apple shenanigans */
+	[0x3F]				= kvm_hyp_handle_impdef,
 };
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index ee4316cb3690..772c1b008e43 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -105,6 +105,7 @@ WORKAROUND_CAVIUM_TX2_219_TVM
 WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_NVIDIA_CARMEL_CNP
+WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF
 WORKAROUND_REPEAT_TLBI
-- 
2.39.5

