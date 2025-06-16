Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668CB3BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115102; cv=none; b=DDst2jyrI0BwUJJtzE2QZGdFq8AAYnnyH/eX0TvqxpHfv/jcqWPjhodPd5GrqBZu5/kQCL79GkWMh4/NYGs5UTYrZBlW2DDfh6BliXXijTETDOwW9U1VTMj44Ev7v/fflTHRf/QztuMyHclcvU8FbZC/nNGHTtajgTkKhj8BlNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115102; c=relaxed/simple;
	bh=fWaD+PrMx7K9L/gIKrTsE7QrPjFdDkTL73JtAydW05s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fa7oct/WBN5ZwebfJTXErCuWlA/JsFrdO6vSL7YnwU7NK43grrUHRz3rvEk9JsLit4FB7Y60bTPtGYlb7PQmWeQvs/DDnlaQRZHA/R0xx2vdC1SDl8+CT8OYL4xuSNTb7WTSq1qCoxq9dgNp+kIR/e9PJTyl0HfLT+uzIAmksqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RrT7Qz0O; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RrT7Qz0O"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Ve+/Rt3cm7sYHrBS9pKdP0Nq5luy2BHMwnfRUoInCE=;
	b=RrT7Qz0O/uuuhqfsHDxmF/WapccXW7ePVmxS8+7qxHByjRzBsueMRvSomyili2gAZfBcnP
	/XKDrLexx7Mp/SgNVQMIKx+/5pDFfkf4mLFzOxdPexGtLJy6kk8FiCmB/5Q6+T94o0AJEx
	Yx6UJtfM/qoXxu8xmbQxij0eK2w6kWA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/27] KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
Date: Mon, 16 Jun 2025 16:02:53 -0700
Message-Id: <20250616230308.1192565-13-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Restore SCTLR2_EL1 with the correct value for the given context when
FEAT_SCTLR2 is advertised to the guest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7fffeaf71dec..0cd7a01624f9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -109,6 +109,17 @@ static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt)
 	return kvm_has_s1poe(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_SCTLR2))
+		return false;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -147,6 +158,9 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
+
+	if (ctxt_has_sctlr2(ctxt))
+		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -257,6 +271,9 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
+
+	if (ctxt_has_sctlr2(ctxt))
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
 }
 
 /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 73e4bc7fde9e..f28c6cf4fe1b 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -77,6 +77,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
 	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
 	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
+
+	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
+		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
@@ -139,6 +142,9 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 	write_sysreg(__vcpu_sys_reg(vcpu, SP_EL2),		sp_el1);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ELR_EL2),		SYS_ELR);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, SPSR_EL2),	SYS_SPSR);
+
+	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, SCTLR2_EL2), SYS_SCTLR2);
 }
 
 /*
-- 
2.39.5

