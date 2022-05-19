Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE36BC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 627A64B45F;
	Thu, 19 May 2022 09:47:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QQGGeci-T12H; Thu, 19 May 2022 09:47:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F9874B44F;
	Thu, 19 May 2022 09:47:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A2D4B45F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZoSYlp87XdOB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:48 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 865EF4B443
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 14221617A0;
 Thu, 19 May 2022 13:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AF1C385B8;
 Thu, 19 May 2022 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968066;
 bh=p4epx9gpbWHrqgR4lCHBD+OJVcMuF2+CwY/eYIiDFs8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=b3NX1aHtHJU6tzqRl9/COho2WNeulJ3zXdWEhi9RI6d91qW/bA7+rXfzwLabysnxO
 rO0lDyDbRy7+Ymcg/NMsVi0LFInppO07IoqKihDBZeGvEEZ0hX1PlW0uPD8Ad3XHyi
 c8C5LIbwC99YWuru23eZYC0e53HGfhJjVr/BmrIp4337cXYJRHlVnsKEcH8rEfdLLQ
 6rzguHJ/GqQ4HyblsBpNR+h4jwwchu/+kTWu7VzFwibZI9t2BOafulpf2jFNGIfTgR
 trXoPHJ+qV8DfeiQRy67jGv5XvrFq47kqruU5D4EfOJd6oI3Io2aqFr6w2mzHk6aDH
 fBDIBwcjZNNqQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 81/89] KVM: arm64: Inject SIGSEGV on illegal accesses
Date: Thu, 19 May 2022 14:41:56 +0100
Message-Id: <20220519134204.5379-82-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Quentin Perret <qperret@google.com>

The pKVM hypervisor will currently panic if the host tries to access
memory that it doesn't own (e.g. protected guest memory). Sadly, as
guest memory can still be mapped into the VMM's address space, userspace
can trivially crash the kernel/hypervisor by poking into guest memory.

To prevent this, inject the abort back in the host with S1PTW set in the
ESR, hence allowing the host to differentiate this abort from normal
userspace faults and inject a SIGSEGV cleanly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 50 ++++++++++++++++++++++++++-
 arch/arm64/mm/fault.c                 | 22 ++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d0544259eb01..8459dc33e460 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -549,6 +549,50 @@ static int host_stage2_idmap(u64 addr)
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
@@ -560,7 +604,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 
 	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
 	ret = host_stage2_idmap(addr);
-	BUG_ON(ret && ret != -EAGAIN);
+
+	if (ret == -EPERM)
+		host_inject_abort(host_ctxt);
+	else
+		BUG_ON(ret && ret != -EAGAIN);
 }
 
 struct pkvm_mem_transition {
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 77341b160aca..2b2c16a2535c 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -41,6 +41,7 @@
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/virt.h>
 
 struct fault_info {
 	int	(*fn)(unsigned long far, unsigned int esr,
@@ -257,6 +258,15 @@ static inline bool is_el1_permission_fault(unsigned long addr, unsigned int esr,
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
 							unsigned int esr,
 							struct pt_regs *regs)
@@ -268,6 +278,9 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	    (esr & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_FAULT)
 		return false;
 
+	if (is_pkvm_stage2_abort(esr))
+		return false;
+
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
@@ -383,6 +396,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 			msg = "read from unreadable memory";
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
+	} else if (is_pkvm_stage2_abort(esr)) {
+		msg = "access to hypervisor-protected memory";
 	} else {
 		if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
 			return;
@@ -572,6 +587,13 @@ static int __kprobes do_page_fault(unsigned long far, unsigned int esr,
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
 
 	/*
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
