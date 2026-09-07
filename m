Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A3140DB38
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764428; cv=none; b=h9O228sHSlCvSyOXwCI6yQ5tNuCtnp438gumhpzsK7AlmkETLJjRoYPsB3A4172HcOF3hhQ+0mDM6Pkm1bZam6Ygj+gZdlaT2yX1FymhmWhGSgWQUa4UHCxf/YTlTPS0aR9w4pfVVDJLD29mIyovOz5YurQoS91YbwgHYjfP0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764428; c=relaxed/simple;
	bh=41Xda+gcZwufqjv1WD/GCAmoryhWvqMuJZ6VTvsgt8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iop1C4iHSzYM8bCXcXoRjpVmgx9dZNuDAMKM8RlvCW5ZpVG0pZ0zxSTq8WUfiAgACnpubFC/yd37LI/qk9Ji6uBp0hbLSjVIH11XUSUzgpSHvT2EJ8VT8pHXY5PYpGHmzOau31whlLl8aW6405X9LEzyk1p9JEKsXxTHoNoFa1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qWmqBDQh; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qWmqBDQh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=41Xda+gcZwufqjv1WD/GCAmoryhWvqMuJZ6VTvsgt8s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764423; v=1; x=1789369223;
 b=qWmqBDQhWrCbbbqOj/NUC0GTvDHM1qf+VsQ4LVXWOnpEwWomPKMKgeEQXRvTJi+kDexBGSqW
 fng9YSpj/VMd7SetSEAkw01WgroZ13mXuBq34pD1UT79dcg6hq5CKmK5HAYes4d9Ai10o8Ad04G
 LCxzk95QVXM1GN0FkCJH8wQ8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 911001f3171fd390;
	Mon, 07 Sep 2026 07:00:23 +0000
X-Mizu-Trace-ID: 911001f3171fd390
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 03/17] KVM: arm64: Introduce per-EC entry handlers for pKVM
Date: Mon,  7 Sep 2026 07:59:48 +0100
Message-Id: <20260907070002.3333525-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

Add an ESR_EL2.EC-indexed handler table, entry_hyp_vm_handlers[],
consulted from flush_hyp_vcpu() on re-entry when the previous exit was
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
index 27fe0cd5b2d7a..78a4d387f9fd4 100644
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
index c904647d2f760..49a0a992047ba 100644
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
index b6bfe502bcd04..ca7122b0bccdd 100644
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

