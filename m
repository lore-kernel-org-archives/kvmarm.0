Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F0A2E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995635; cv=none; b=ZqEl1F321Qdqgpzy6Sr0pqTjop9xiuxJfBEhKNNVjx8vlJMt3ttGOcZbULHDYNoBBTBT4QUmPAYPBUPApwFVnVY1wEW719nRP4Bg2BprJsMfnkjgU+cWorcGlrkZ4QXjDoXK5EoFYZrpr0D9BGvodP6V4MZXWbD5ZksFlsykYT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995635; c=relaxed/simple;
	bh=7J6qPqEoRrPw3JFJecbMUHE1sLbGzmdh1F7Kh6GIebA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sMT9rO19wmChtPhMR8rY1elIIyAW9lX+iK493X91kY3KWOIoVbIaHY1zx0c0xTDCLDeEMTXuPTQwpoDU5Q9+obVs2s4ZySJlEI24YwRJhp3RfuLXcxTrpy8LKBKAcXLXp9/dMsBwCNkMjr1a/0zS16VLX4aoeJ0mDO2wDancxXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h2Q/YwVz; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h2Q/YwVz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIjOqsg1ou8KcNwUSqMV69H8agexYI/nlY1XBkMJswQ=;
	b=h2Q/YwVzjWAKgyihcFV6eDUseaWnT9zjLHve0am+cYmPCGZdKE/VxDyW0FY5cmlz2vbSg2
	w5XyJ5w9C7bvQ9MhoT/UjTOhxocPf6soDZhjOrrYmVz9q/Z2LG24DZ3OvuQ8WWmscEB0ZN
	uPWF8UZR+N0/HYYJfuj26p3ksjhUbaI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 12/27] KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
Date: Tue,  8 Jul 2025 10:25:17 -0700
Message-Id: <20250708172532.1699409-13-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index fd9e3ea84d9f..faca2b7211f1 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -120,6 +120,17 @@ static inline bool ctxt_has_ras(struct kvm_cpu_context *ctxt)
 	return kvm_has_ras(kern_hyp_va(vcpu->kvm));
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
@@ -158,6 +169,9 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
+
+	if (ctxt_has_sctlr2(ctxt))
+		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -268,6 +282,9 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
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

