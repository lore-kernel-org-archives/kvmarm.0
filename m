Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3E12264A7
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620113; cv=none; b=lLAOKf/sbnoSdbY6Ods1eQittLZVumWQdO4p97F8Ui4mJQl1b8GFwn2eV9vtxLAMNqOH9gswiQb71T9LpWL2uCEh8vXFZ2mcMcX/6kGes/IrdWnjeIHZE5GQ4p7kOQOOCybMuE3dL4/14GPr7j/QswZwFp5YcgEEntkImf9+4dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620113; c=relaxed/simple;
	bh=bI5a4vjg5oY6tgfFgKml4ung/nTnLBJ+vk2M8tkHhIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EczAGq9KP4OkFxUAMSmqcRzowioiAE+8thtuwj+tnBbyfyH02PDR4SXonOhl8PDNcLhyPGLgdUrgQQyrYeUgQoaDVZEAqI7Mb3wIb8qqKjChhk2spdIy+IowBTzBYjIesC1VmUAl1+pB0wtUvM2FBTG2Z7xVJPyVV8BCAK3iGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPYqC8cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPYqC8cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3397C19423;
	Fri, 27 Mar 2026 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620113;
	bh=bI5a4vjg5oY6tgfFgKml4ung/nTnLBJ+vk2M8tkHhIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPYqC8cB4F5k3ld7rixonzpY90WRo6+u6h4WNjwrCMd34KIl2bcmSnuorg/odPy1G
	 Mm3Lx8Kjc74qoV4Acn85z1tMHCwwy5dcJ2ApD5cIbyPGN8Ax/LRi2D8pMBcCET/OW2
	 Pt7AZV/YvtadduLlbS0AoGb6Szdxd0KZWRzJD5JIt2BAamjsh5sW/2SXXCJFgAc92r
	 56uVtNMKFI9f2ZAGoPK5UtDhVQVRqXmZ6bAEmlfH1rXzQatLzLxr3iN0xUvZv488wL
	 663+mbdyx8xXmyDwddkY133Oewh7QWxIa3+y8Igmgd7ZZOi1gLCRrourCrUHEFLFBP
	 9+wsytzaY5W/g==
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
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 19/38] KVM: arm64: Inject SIGSEGV on illegal accesses
Date: Fri, 27 Mar 2026 14:00:18 +0000
Message-ID: <20260327140039.21228-20-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 37 +++++++++++++++++++++++++++
 arch/arm64/mm/fault.c                 | 22 ++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ca266a4d9d50..0e57dc1881e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -18,6 +18,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
+#include <nvhe/trap_handler.h>
 
 #define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_AS_S1 | KVM_PGTABLE_S2_IDMAP)
 
@@ -612,6 +613,39 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
+{
+	u64 ec, esr, spsr;
+
+	esr = read_sysreg_el2(SYS_ESR);
+	spsr = read_sysreg_el2(SYS_SPSR);
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
+	inject_host_exception(esr);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -635,6 +669,9 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
 	switch (host_stage2_idmap(addr)) {
+	case -EPERM:
+		host_inject_mem_abort(host_ctxt);
+		fallthrough;
 	case -EEXIST:
 	case 0:
 		break;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index be9dab2c7d6a..3abfc7272d63 100644
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
+	 * injected a stage-2 abort -- see host_inject_mem_abort().
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
2.53.0.1018.g2bb0e51243-goog

