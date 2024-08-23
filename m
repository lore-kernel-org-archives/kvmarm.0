Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFC91953B0
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724448450; cv=none; b=EUlJwoCnm4xPyxa8k3x36UJUrstWujCnKGUl5S+miXvyW3o4gi8q3rR+2mt53yutPN+FeNPM4WXVuvuoxFAVtKmAVC0z5caUTTMIQuyGkEwDNwgino9VNf8Cr058TzGw8CyY5jSK9bf7JhghPAo1gBc+G1v2pbitzXzUTDoNhw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724448450; c=relaxed/simple;
	bh=QFz0jGZ4vYWt+0ZQvAblk1Wo50c5S4UO+ZsO6kCia3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4a8fxzJdqBmqF9BrXPRkgcvk64SRwmQs1rpj2VtC45lBNLJ/8WkdkSOc0+yw7x7rj71NzNmeieUVM0WM94ElBLxRHN/+UCA83Bc1iFc7gtj+ZB/NhhjEFSgPJZStQMiyZppUBi9ftYd47E+Uhfa0CXI6RmH2HhWWRqrrIbkiWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QB5KUljX; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QB5KUljX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724448445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORck1PIOLLJqHNA9ftt7cP+6gjI3GmhlHDcsXfnJGh4=;
	b=QB5KUljX5rk1LmlG2O8bCPrEbIv1JYXlj5mjW3cjdNuYlfMkK1nU8hLjznU8vxkLrWhPx7
	hr7uLNXu/NotmYC9Kb8j5fWeXWTdZYYooZUPsGhyU4x3Ly8RhJotcFvMN05p4Sv+BTkCLN
	dr+sEobcpxQbDNTxYJu1wYjhKY3q2fQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: Move host SVE/SME state flags out of vCPU
Date: Fri, 23 Aug 2024 21:27:02 +0000
Message-ID: <20240823212703.3576061-3-oliver.upton@linux.dev>
In-Reply-To: <20240823212703.3576061-1-oliver.upton@linux.dev>
References: <20240823212703.3576061-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're running a bit tight on vCPU state flags, and there's no good
reason for tracking bits of host state in the vCPU. Rather than do the
unspeakable and add another byte of sflags, move some of the obvious
host bits over to kvm_host_data where they really belong.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 26 ++++++++++++++++----------
 arch/arm64/kvm/fpsimd.c           | 12 ++++++------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..f959d03decfc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -584,6 +584,12 @@ struct cpu_sve_state {
  * field.
  */
 struct kvm_host_data {
+	/* SVE enabled for EL0 */
+#define HOST_SVE_ENABLED	0
+	/* SME enabled for EL0 */
+#define HOST_SME_ENABLED	1
+	unsigned long flags;
+
 	struct kvm_cpu_context host_ctxt;
 
 	/*
@@ -879,22 +885,18 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
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
@@ -1265,6 +1267,10 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+#define host_data_set_flag(nr)		set_bit(nr, host_data_ptr(flags))
+#define host_data_test_flag(nr)		test_bit(nr, host_data_ptr(flags))
+#define host_data_clear_flag(nr)	clear_bit(nr, host_data_ptr(flags))
+
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(void)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c53e5b14038d..f7712c89adef 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -64,14 +64,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
 
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
@@ -167,7 +167,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
+		if (host_data_test_flag(HOST_SME_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
 		else
 			sysreg_clear_set(CPACR_EL1,
@@ -226,7 +226,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
-		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
+		if (host_data_test_flag(HOST_SVE_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
 		else
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
-- 
2.46.0.295.g3b9ea8a38a-goog

