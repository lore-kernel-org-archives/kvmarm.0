Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C291A2622
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065485; cv=none; b=PCQ2U1vZY6Fu1AfzwLRMU4G6y+nDp2qqm7itZ12/NHpRCzH8kGPqeUcn1AmImEAdgRiJLnQCsEj233M7iwfojbZA9aC4n2ytRVUtMNLR9zsTx4JGzSCFNGRcNlAHWX/J/Qxc7qzqF0tBc1X7yBZaYtzm4gXEMDxbkwjupW0Hpu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065485; c=relaxed/simple;
	bh=Lpd9Dv852KN81mDxr313SZ2EVA4RHwbx7HlJ0kkCpAY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXLcwWQMdMv1i68tNbi5y74eaK7dt/HeSlLfj3+I7KOW1pN7fxdVkg4fRGrF9399TWjAQWmQh+hAK71FpaRj4GGmH35SSABEu9Y3TMbMkVkR8m91yUgTkuoPIxeqF7JNafkfPps+RhFLqGD1R4ORDX7702m8pQcYPvfqgpCwQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=OvYiy/RL; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="OvYiy/RL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065484; x=1757601484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gUT0NHH1rkNY0jIUGubcfNpyrpnEMMZzd9a2sKPpzdA=;
  b=OvYiy/RLGsHEw2Y91pabEnpcXnmrBn5OxpEOSY4fZg7eJvCNNl9k1u6U
   6RytsYo8D8Dgvhb4Qro4VfUlQ0oRZ3Fq9uXT5szAXy51l05C6RmBDuJV9
   CRK68EfikhoQ1iw0jRkrusXQzmX3HiTj+JdtFn2aLISg6R6j3hkvqb66v
   M=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="24916368"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:36:54 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:10017]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.59:2525] with esmtp (Farcaster)
 id f9f29f1f-caf9-4ac7-bc5d-27f9e417256f; Wed, 11 Sep 2024 14:36:52 +0000 (UTC)
X-Farcaster-Flow-ID: f9f29f1f-caf9-4ac7-bc5d-27f9e417256f
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:36:52 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:36:51 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:36:49 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, =?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=
	<ptosi@google.com>, Ard Biesheuvel <ardb@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Javier Martinez Canillas <javierm@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, Mark Brown
	<broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Kristina Martsenko
	<kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, "David
 Hildenbrand" <david@redhat.com>, Roman Kagan <rkagan@amazon.de>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 4/7] KVM: Refactor Assembly-code to access vCPU gp-registers through a macro
Date: Wed, 11 Sep 2024 14:34:03 +0000
Message-ID: <20240911143421.85612-5-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Right now assembly code accesses vCPU gp-regs directly from the context struct
"struct kvm_cpu_context" using "CPU_XREG_OFFSET()".

Since we want to move gp-regs to dynamic memory, we can no longer assume that
gp-regs will be embedded in the context struct, thus split the access to two
steps.

The first is to get the gp-regs from the context using the assembly macro
"get_ctxt_gp_regs".

And the second is to access the gp-registers directly from within the
"struct user_pt_regs" by removing the offset "CPU_USER_PT_REGS" from the access
macro "CPU_XREG_OFFSET()".

I also changed variable naming and comments where appropriate.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/arm64/include/asm/kvm_asm.h | 48 +++++++++++++++++---------------
 arch/arm64/kvm/hyp/entry.S       | 15 ++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++---
 3 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2181a11b9d92..fa4fb642a5f5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -313,6 +313,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
 	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 .endm
 
+.macro get_ctxt_gp_regs ctxt, regs
+	add	\regs, \ctxt, #CPU_USER_PT_REGS
+.endm
+
 /*
  * KVM extable for unexpected exceptions.
  * Create a struct kvm_exception_table_entry output to a section that can be
@@ -329,7 +333,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
 	.popsection
 .endm
 
-#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
+#define CPU_XREG_OFFSET(x)	(8 * (x))
 #define CPU_LR_OFFSET		CPU_XREG_OFFSET(30)
 #define CPU_SP_EL0_OFFSET	(CPU_LR_OFFSET + 8)
 
@@ -337,34 +341,34 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
  * We treat x18 as callee-saved as the host may use it as a platform
  * register (e.g. for shadow call stack).
  */
-.macro save_callee_saved_regs ctxt
-	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
-	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
-	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
-	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
-	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
-	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
-	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.macro save_callee_saved_regs regs
+	str	x18,      [\regs, #CPU_XREG_OFFSET(18)]
+	stp	x19, x20, [\regs, #CPU_XREG_OFFSET(19)]
+	stp	x21, x22, [\regs, #CPU_XREG_OFFSET(21)]
+	stp	x23, x24, [\regs, #CPU_XREG_OFFSET(23)]
+	stp	x25, x26, [\regs, #CPU_XREG_OFFSET(25)]
+	stp	x27, x28, [\regs, #CPU_XREG_OFFSET(27)]
+	stp	x29, lr,  [\regs, #CPU_XREG_OFFSET(29)]
 .endm
 
-.macro restore_callee_saved_regs ctxt
-	// We require \ctxt is not x18-x28
-	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
-	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
-	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
-	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
-	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
-	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
-	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.macro restore_callee_saved_regs regs
+	// We require \regs is not x18-x28
+	ldr	x18,      [\regs, #CPU_XREG_OFFSET(18)]
+	ldp	x19, x20, [\regs, #CPU_XREG_OFFSET(19)]
+	ldp	x21, x22, [\regs, #CPU_XREG_OFFSET(21)]
+	ldp	x23, x24, [\regs, #CPU_XREG_OFFSET(23)]
+	ldp	x25, x26, [\regs, #CPU_XREG_OFFSET(25)]
+	ldp	x27, x28, [\regs, #CPU_XREG_OFFSET(27)]
+	ldp	x29, lr,  [\regs, #CPU_XREG_OFFSET(29)]
 .endm
 
-.macro save_sp_el0 ctxt, tmp
+.macro save_sp_el0 regs, tmp
 	mrs	\tmp,	sp_el0
-	str	\tmp,	[\ctxt, #CPU_SP_EL0_OFFSET]
+	str	\tmp,	[\regs, #CPU_SP_EL0_OFFSET]
 .endm
 
-.macro restore_sp_el0 ctxt, tmp
-	ldr	\tmp,	  [\ctxt, #CPU_SP_EL0_OFFSET]
+.macro restore_sp_el0 regs, tmp
+	ldr	\tmp,	  [\regs, #CPU_SP_EL0_OFFSET]
 	msr	sp_el0, \tmp
 .endm
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 4433a234aa9b..628a123bcdc1 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -28,6 +28,9 @@ SYM_FUNC_START(__guest_enter)
 
 	adr_this_cpu x1, kvm_hyp_ctxt, x2
 
+	// Get gp-regs pointer from the context
+	get_ctxt_gp_regs x1, x1
+
 	// Store the hyp regs
 	save_callee_saved_regs x1
 
@@ -62,6 +65,9 @@ alternative_else_nop_endif
 	// when this feature is enabled for kernel code.
 	ptrauth_switch_to_guest x29, x0, x1, x2
 
+	// Get gp-regs pointer from the context
+	get_ctxt_gp_regs x29, x29
+
 	// Restore the guest's sp_el0
 	restore_sp_el0 x29, x0
 
@@ -108,6 +114,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// current state is saved to the guest context but it will only be
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	get_ctxt_gp_regs x0, x0
 	adr_l	x1, hyp_panic
 	str	x1, [x0, #CPU_XREG_OFFSET(30)]
 
@@ -120,6 +127,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// vcpu x0-x1 on the stack
 
 	add	x1, x1, #VCPU_CONTEXT
+	get_ctxt_gp_regs x1, x1
 
 	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 
@@ -145,6 +153,10 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Store the guest's sp_el0
 	save_sp_el0	x1, x2
 
+	// Recover vCPU context to x1
+	get_vcpu_ptr    x1, x2
+	add     x1, x1, #VCPU_CONTEXT
+
 	adr_this_cpu x2, kvm_hyp_ctxt, x3
 
 	// Macro ptrauth_switch_to_hyp format:
@@ -157,6 +169,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// mte_switch_to_hyp(g_ctxt, h_ctxt, reg1)
 	mte_switch_to_hyp x1, x2, x3
 
+	// Get gp-regs pointer from the context
+	get_ctxt_gp_regs x2, x2
+
 	// Restore hyp's sp_el0
 	restore_sp_el0 x2, x3
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d610fc51f4d..31afa7396294 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -17,6 +17,12 @@
 SYM_FUNC_START(__host_exit)
 	get_host_ctxt	x0, x1
 
+	/* Keep host context in x1 */
+	mov	x1, x0
+
+	/* Get gp-regs pointer from the context */
+	get_ctxt_gp_regs x0, x0
+
 	/* Store the host regs x2 and x3 */
 	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
 
@@ -36,7 +42,10 @@ SYM_FUNC_START(__host_exit)
 	/* Store the host regs x18-x29, lr */
 	save_callee_saved_regs x0
 
-	/* Save the host context pointer in x29 across the function call */
+	/* Save the host context pointer in x28 across the function call */
+	mov	x28, x1
+
+	/* Save the host gp-regs pointer in x29 across the function call */
 	mov	x29, x0
 
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
@@ -46,7 +55,7 @@ alternative_else_nop_endif
 
 alternative_if ARM64_KVM_PROTECTED_MODE
 	/* Save kernel ptrauth keys. */
-	add x18, x29, #CPU_APIAKEYLO_EL1
+	add x18, x28, #CPU_APIAKEYLO_EL1
 	ptrauth_save_state x18, x19, x20
 
 	/* Use hyp keys. */
@@ -58,6 +67,7 @@ alternative_else_nop_endif
 __skip_pauth_save:
 #endif /* CONFIG_ARM64_PTR_AUTH_KERNEL */
 
+	mov	x0, x28
 	bl	handle_trap
 
 __host_enter_restore_full:
@@ -68,7 +78,7 @@ b __skip_pauth_restore
 alternative_else_nop_endif
 
 alternative_if ARM64_KVM_PROTECTED_MODE
-	add x18, x29, #CPU_APIAKEYLO_EL1
+	add x18, x28, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state x18, x19, x20
 alternative_else_nop_endif
 __skip_pauth_restore:
@@ -101,7 +111,8 @@ SYM_FUNC_END(__host_exit)
  * void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
  */
 SYM_FUNC_START(__host_enter)
-	mov	x29, x0
+	mov	x28, x0
+	get_ctxt_gp_regs x0, x29
 	b	__host_enter_restore_full
 SYM_FUNC_END(__host_enter)
 
@@ -141,6 +152,7 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	/* Enter the host, conditionally restoring the host context. */
 	cbz	x29, __host_enter_without_restoring
+	get_ctxt_gp_regs x29, x29
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

