Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9E86337
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648128; cv=none; b=gziqjZUGIJZSBVR71t8ccCzGS2Sz6htnLxUpmPW+lJlggCqa8oppZff+l/ge5lYi2SnRwTIYdrW//WPYn6lKmRVW+Hg4tLhkNRZlGyxO5Qdmji5+JJdQr7z6LSxApb2ZhO9YftzkpxaocNDSF6M2wQiE9ed5Tzf8i528xgQn2lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648128; c=relaxed/simple;
	bh=bs6QAaVVsD60fC1VwBn8d9M9M6jldFLaFT0nCyHUXH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSEl8xjs7xoaTCbq8ApedUT/++OMOSKakIo1EsFWB65X0EJOKtDzsOfFS5jEZSyRRh+0KmBhb8bmClEMyjJiIxjXP+r36XokhtscRVP9Fm9l6jR6aXG13d9qd3sPM5nd/Q+3wwNek5PhPm1b9knZ7oLwqkPD/P0o82lj3mX+/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=opck6Wzn; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="opck6Wzn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Q3szi4lFo1opWi8A0WIoPReSA8gqQE22VeVA23yYg0=;
	b=opck6Wznvh4Fql7guUH/Ast6d73UoBEr46eUICqcTj1yBkJWRMCYJifQ+fIuCsfraqYBXb
	cRpFYqRqvD3yXWw9f1MsOFZVlFQ0xgVtSIFcyGfLOg9trIoPbfc9i7OiXMPHsMo1Hm9YxJ
	iptWZdeiwMeBxgKQfFPILmspeyLSt18=
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
Subject: [PATCH v4 16/19] KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
Date: Thu, 19 Dec 2024 14:41:13 -0800
Message-Id: <20241219224116.3941496-17-oliver.upton@linux.dev>
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

Inject debug exceptions into vEL2 if MDCR_EL2.TDE is set.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/emulate-nested.c     | 23 +++++++++++++++++++----
 arch/arm64/kvm/handle_exit.c        |  3 +++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 233e65522716..ec6e28d63d26 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -64,6 +64,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 }
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
+extern bool forward_debug_exception(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1ffbfd1c3cf2..e37fb598cc24 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2345,14 +2345,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	return true;
 }
 
-static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+static bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
 	bool control_bit_set;
 
 	if (!vcpu_has_nv(vcpu))
 		return false;
 
-	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
 	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
@@ -2360,9 +2360,24 @@ static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
 	return false;
 }
 
+static bool forward_hcr_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, HCR_EL2, control_bit);
+}
+
 bool forward_smc_trap(struct kvm_vcpu *vcpu)
 {
-	return forward_traps(vcpu, HCR_TSC);
+	return forward_hcr_traps(vcpu, HCR_TSC);
+}
+
+static bool forward_mdcr_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, MDCR_EL2, control_bit);
+}
+
+bool forward_debug_exception(struct kvm_vcpu *vcpu)
+{
+	return forward_mdcr_traps(vcpu, MDCR_EL2_TDE);
 }
 
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
@@ -2406,7 +2421,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	 * Forward this trap to the virtual EL2 if the virtual
 	 * HCR_EL2.NV bit is set and this is coming from !EL2.
 	 */
-	if (forward_traps(vcpu, HCR_NV))
+	if (forward_hcr_traps(vcpu, HCR_NV))
 		return;
 
 	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1e302f0c8903..512d152233ff 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -183,6 +183,9 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 
+	if (!vcpu->guest_debug && forward_debug_exception(vcpu))
+		return 1;
+
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = lower_32_bits(esr);
 	run->debug.arch.hsr_high = upper_32_bits(esr);
-- 
2.39.5

