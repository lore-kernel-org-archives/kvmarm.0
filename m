Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61383002DD
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628240; cv=none; b=H76LmjiuB2zq2w3u6jUiBoLSE+RLeNX8UUYADlAAbpCX0rdXLBC8Ilgvyew/LnAxEoKOQ7rebNuTJWyRXtey47KZ7j/SovGiTPJ1JLSF9uOdi1ku14Bvl+oFOUKF4pUWWIAPPm5djHTTH1maHtH31GRee8j+Gh8hS6aJvdsNEX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628240; c=relaxed/simple;
	bh=6G8rwd4Cp4GzcAdEjkhvN/tkAkcxL4sQESVuYpuTUTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScLc9+iV2uzckTjuQAeMv0T2aNfCG2b1XsCPVE3trTvugbj/Mzlsi6BiBEzSO7Sl8ZFupBiP6SrFinwSWqzOLyoXtHe6v44Z1LkVVbiIb6CZ/gQiMypE/NyxDTL9jz6UJ+wISMuXjDe8qNqek9LCCRwsP/IXiPqQ9dBxmb4/hhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOam0qNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOam0qNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F463C19422;
	Mon,  5 Jan 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628239;
	bh=6G8rwd4Cp4GzcAdEjkhvN/tkAkcxL4sQESVuYpuTUTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOam0qNF5J5kwyYbbOemetk4Qyz6Q1RNcofuyRkoFGYgQv/i+uiWvZJnVwP8SpiBh
	 Fa9A+5eMUmBEPH0bgba16tuh+ySCEM2jWhJd82rhkvv2wbSeoI77pKghmK3dkEzvOQ
	 EkxnqRHiF1VZaI2/1+NWtgSPhXUUMILeiPemBM3HRmc3t0mDYNuzP1vGlq4xj2sNKC
	 iORF/3GPF1TVs1bGE+xhLbx2C3czB9DR7TtcTVULm3CueCBKd02Qz27hi4974hJDSn
	 EBst/ZjVJrA1SAXyglyI8jsTWMUtKMxZDYR73Y/IOf55ngYIC3+4sWkQDXytNpfRJB
	 78H21W7xcEzwQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 16/30] KVM: arm64: Inject SIGSEGV on illegal accesses
Date: Mon,  5 Jan 2026 15:49:24 +0000
Message-ID: <20260105154939.11041-17-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

The pKVM hypervisor will currently panic if the host tries to access
memory that it doesn't own (e.g. protected guest memory). Sadly, as
guest memory can still be mapped into the VMM's address space, userspace
can trivially crash the kernel/hypervisor by poking into guest memory.

To prevent this, inject the abort back in the host with S1PTW set in the
ESR, hence allowing the host to differentiate this abort from normal
userspace faults and inject a SIGSEGV cleanly.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 50 ++++++++++++++++++++++++++-
 arch/arm64/mm/fault.c                 | 22 ++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index edbfe0e3dc58..0336143cbb24 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -603,6 +603,50 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static void host_inject_abort(struct kvm_cpu_context *host_ctxt)
+{
+	u64 spsr = read_sysreg_el2(SYS_SPSR);
+	u64 esr = read_sysreg_el2(SYS_ESR);
+	u64 ventry, ec;
+
+	/* Repaint the ESR to report a same-level fault if taken from EL1 */
+	if ((spsr & PSR_MODE_MASK) != PSR_MODE_EL0t) {
+		ec = ESR_ELx_EC(esr);
+		if (ec == ESR_ELx_EC_DABT_LOW)
+			ec = ESR_ELx_EC_DABT_CUR;
+		else if (ec == ESR_ELx_EC_IABT_LOW)
+			ec = ESR_ELx_EC_IABT_CUR;
+		else
+			WARN_ON(1);
+		esr &= ~ESR_ELx_EC_MASK;
+		esr |= ec << ESR_ELx_EC_SHIFT;
+	}
+
+	/*
+	 * Since S1PTW should only ever be set for stage-2 faults, we're pretty
+	 * much guaranteed that it won't be set in ESR_EL1 by the hardware. So,
+	 * let's use that bit to allow the host abort handler to differentiate
+	 * this abort from normal userspace faults.
+	 *
+	 * Note: although S1PTW is RES0 at EL1, it is guaranteed by the
+	 * architecture to be backed by flops, so it should be safe to use.
+	 */
+	esr |= ESR_ELx_S1PTW;
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(spsr, SYS_SPSR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el1(read_sysreg_el2(SYS_FAR), SYS_FAR);
+
+	ventry = read_sysreg_el1(SYS_VBAR);
+	ventry += get_except64_offset(spsr, PSR_MODE_EL1h, except_type_sync);
+	write_sysreg_el2(ventry, SYS_ELR);
+
+	spsr = get_except64_cpsr(spsr, system_supports_mte(),
+				 read_sysreg_el1(SYS_SCTLR), PSR_MODE_EL1h);
+	write_sysreg_el2(spsr, SYS_SPSR);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -627,7 +671,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
 	ret = host_stage2_idmap(addr);
-	BUG_ON(ret && ret != -EAGAIN);
+
+	if (ret == -EPERM)
+		host_inject_abort(host_ctxt);
+	else
+		BUG_ON(ret && ret != -EAGAIN);
 }
 
 struct check_walk_data {
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index be9dab2c7d6a..2294f2061866 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -43,6 +43,7 @@
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/virt.h>
 
 struct fault_info {
 	int	(*fn)(unsigned long far, unsigned long esr,
@@ -269,6 +270,15 @@ static inline bool is_el1_permission_fault(unsigned long addr, unsigned long esr
 	return false;
 }
 
+static bool is_pkvm_stage2_abort(unsigned int esr)
+{
+	/*
+	 * S1PTW should only ever be set in ESR_EL1 if the pkvm hypervisor
+	 * injected a stage-2 abort -- see host_inject_abort().
+	 */
+	return is_pkvm_initialized() && (esr & ESR_ELx_S1PTW);
+}
+
 static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 							unsigned long esr,
 							struct pt_regs *regs)
@@ -279,6 +289,9 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	if (!is_el1_data_abort(esr) || !esr_fsc_is_translation_fault(esr))
 		return false;
 
+	if (is_pkvm_stage2_abort(esr))
+		return false;
+
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
@@ -395,6 +408,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 			msg = "read from unreadable memory";
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
+	} else if (is_pkvm_stage2_abort(esr)) {
+		msg = "access to hypervisor-protected memory";
 	} else {
 		if (esr_fsc_is_translation_fault(esr) &&
 		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
@@ -621,6 +636,13 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 					 addr, esr, regs);
 	}
 
+	if (is_pkvm_stage2_abort(esr)) {
+		if (!user_mode(regs))
+			goto no_context;
+		arm64_force_sig_fault(SIGSEGV, SEGV_ACCERR, far, "stage-2 fault");
+		return 0;
+	}
+
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
 	if (!(mm_flags & FAULT_FLAG_USER))
-- 
2.52.0.351.gbe84eed79e-goog

