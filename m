Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C0518152
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863085; cv=none; b=kaK4PuGMteQK0xVfjzZqaYYFo4kIiIVoLap+BVFhY/jU3KwoFnQcStr6EPi2E/bU96fj9Vme65jb3AgyNMoMqUFhOyVHlpYy8O1W9pEB41RM126MOLcgbAPYzSVtzx93Behk/oAEEWQB+hixG0t5SwVk/dlrwxm/PIwi5b2wEEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863085; c=relaxed/simple;
	bh=g2Xpuci6s/G0snGB/49noNoT1Evuyowz5hRqXAbGtyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y9xibtspFG0p1wS2aNsHv78jh6rYvdlXW1gauXtARJlzSFrRr5Vfp3+zSoFYeg7Pqp45Hdu9m5mDpfJDkB+mM3a6fiqzqTkEe7m9gqcoMu4BgdmLemIlwArnSpngQY4MIF0T4Yndh/AqJ0LHDgljDFAv8uNCoi2MSjjr7WHAeMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m1pygxC8; arc=none smtp.client-ip=95.215.58.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m1pygxC8"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=g2Xpuci6s/G0snGB/49noNoT1Evuyowz5hRqXAbGtyc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863075; v=1; x=1791467875;
 b=m1pygxC8GbK0XSS5ScvnRxiWU7xjjiZPCgNsqe5n+ydgYzOcivrUOCb7gioL8+WcFNdrJc0M
 y9JFl0gBMQAVMFsSjBxLHvi+QuT3F9HQAJh94nnAaODtyGFSnVN+2ODfz7/4CmDiiLIt0GZ0FPq
 3W2dfljApQahqslmB87PaU5A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 402fb4e270821fd7;
	Thu, 01 Oct 2026 13:57:55 +0000
X-Mizu-Trace-ID: 402fb4e270821fd7
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 05/18] KVM: arm64: Introduce per-EC entry handlers for pKVM
Date: Thu,  1 Oct 2026 14:56:58 +0100
Message-Id: <20261001135711.1640520-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

Add an ESR_EL2.EC-indexed handler table, entry_hyp_vm_handlers[],
read from flush_hyp_vcpu() on re-entry when the previous exit was
a trap: sync_hyp_vcpu() records the exit reason in the hyp vCPU as
exit_code, and the trap's exception class comes from its ESR_EL2. Its
single generic handler stands in until the per-EC marshalling patch
replaces the table with protected-only ones.

Entry carries the host's requested PC updates to the hyp vCPU: add
vcpu_copy_flag() to copy a masked set of flags between the two vCPU
structures, with PC_UPDATE_REQ covering INCREMENT_PC and the
pending-exception flags. The wholesale iflags copy moves into the
non-protected branch; a protected vCPU takes only PC_UPDATE_REQ.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h      | 19 +++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 39 +++++++++++++++++++++++---
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 286489a69dff5..37d0721d39a45 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1033,11 +1033,28 @@ struct kvm_vcpu_arch {
 		set;						\
 	})
 
+#define __vcpu_copy_flag(vt, vs, flagset, f, m)			\
+	do {							\
+		typeof(vs->arch.flagset) tmp, val;		\
+								\
+		__build_check_flag(vs, flagset, f, m);		\
+								\
+		val = READ_ONCE(vs->arch.flagset);		\
+		val &= (m);					\
+		__vcpu_flags_preempt_disable();			\
+		tmp = READ_ONCE(vt->arch.flagset);		\
+		tmp &= ~(m);					\
+		tmp |= val;					\
+		WRITE_ONCE(vt->arch.flagset, tmp);		\
+		__vcpu_flags_preempt_enable();			\
+	} while (0)
+
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
 #define vcpu_test_and_clear_flag(v, ...)			\
 	__vcpu_test_and_clear_flag((v), __VA_ARGS__)
+#define vcpu_copy_flag(vt, vs, ...) __vcpu_copy_flag((vt), (vs), __VA_ARGS__)
 
 /* KVM_ARM_VCPU_INIT completed */
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
@@ -1055,6 +1072,8 @@ struct kvm_vcpu_arch {
 #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
 /* Target EL/MODE (not a single flag, but let's abuse the macro) */
 #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
+/* Cover both PENDING_EXCEPTION and EXCEPT_MASK for global operations */
+#define PC_UPDATE_REQ		__vcpu_single_flag(iflags, GENMASK(3, 0))
 /* Host-set: the hyp flushes the non-protected vCPU state in on entry */
 #define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 5ddb407149667..ad42abaf31c5c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -26,6 +26,9 @@ struct pkvm_hyp_vcpu {
 	 * per-cpu pointer tracking us. Otherwise, NULL if not loaded.
 	 */
 	struct pkvm_hyp_vcpu **loaded_hyp_vcpu;
+
+	/* The previous exit's ARM_EXCEPTION_* code. */
+	u32 exit_code;
 };
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8b9d76e5336bb..e3f4bbb623492 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -31,6 +31,17 @@ unsigned int hyp_gicv3_nr_lr;
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
+
+static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
+}
+
+static const hyp_entry_exit_handler_fn entry_hyp_vm_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= handle_vm_entry_generic,
+};
+
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 {
 	__vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
@@ -216,6 +227,8 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	hyp_entry_exit_handler_fn ec_handler;
+	u8 esr_ec;
 
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
@@ -228,6 +241,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
 			flush_hyp_vcpu_state(hyp_vcpu);
+		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
 	} else {
 		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
 	}
@@ -245,16 +259,31 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
 						 (HCR_TWI | HCR_TWE | HCR_VSE);
 
-	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
-
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	flush_hyp_vgic_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
+
+	switch (ARM_EXCEPTION_CODE(hyp_vcpu->exit_code)) {
+	case ARM_EXCEPTION_IRQ:
+	case ARM_EXCEPTION_EL1_SERROR:
+	case ARM_EXCEPTION_IL:
+		break;
+	case ARM_EXCEPTION_TRAP:
+		esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
+		ec_handler = entry_hyp_vm_handlers[esr_ec];
+		if (ec_handler)
+			ec_handler(hyp_vcpu);
+		break;
+	default:
+		BUG();
+	}
+
+	hyp_vcpu->exit_code = 0;
 }
 
-static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
@@ -281,6 +310,8 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	host_vcpu->arch.hcr_el2 |= hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
 
 	sync_hyp_vgic_state(hyp_vcpu);
+
+	hyp_vcpu->exit_code = exit_reason;
 }
 
 static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
@@ -395,7 +426,7 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 
 		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
 
-		sync_hyp_vcpu(hyp_vcpu);
+		sync_hyp_vcpu(hyp_vcpu, ret);
 	} else {
 		/* The host is fully trusted, run its vCPU directly. */
 		fpsimd_lazy_switch_to_guest(host_vcpu);
-- 
2.39.5

