Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F415218AC
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867826; cv=none; b=FsDHxglEu3Q0jXRaukRc8uAzg3Oj1yu37Ff2zq8XtJ98u3pzvxEIeWuTg3BCy0P2ZzvK+pztUAEiblOepiJV6qGsrRekoPnD84FHXt/4ghGOkVtOwK7D5XgfeERhSG/+cLUqS/4EnnEHe60Mzpkl/7q75KlRwFIZpeZnYMEHSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867826; c=relaxed/simple;
	bh=F146AjrToHixwUsZJqqiVjPe/PxI/aD1NvrVj16tlC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5KYaG4SX8VqjvqOXYMbZ5nzv2UQQWxCHsqOTCWdKK99QTZcF7QlZHP60HeBDndgsGHvc+fqDkMaG9nuo0JgE+U7XpSDtr4eKxHj6GrLsPugQEUJdbFBengKQnrKWJLq0iCl+EzzdECG9KB2HQfZpWC9JP41cOn62+oQZJgEv2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FCq6zsSg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FCq6zsSg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BF55169E;
	Thu,  1 Oct 2026 08:17:01 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43DBC3F86F;
	Thu,  1 Oct 2026 08:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867824; bh=F146AjrToHixwUsZJqqiVjPe/PxI/aD1NvrVj16tlC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCq6zsSg8Ro6y35GMe+AtAauJzlS3IX4XdWDFuQAPaI8RptBKvXjYYKHAVik0C4ya
	 zRS9Wp5a6vDOlJb0D1Xdjs3RsRVDeIVXjKe05a0yxAde7kHSouFwLdqKZ3MNxhkTEO
	 C1oYwr3IHQbhaqDN2By7QRoOjLPbWIRacO/xN6AE=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 5/8] lib: arm64: Add support for guest exit exception handling
Date: Thu,  1 Oct 2026 16:16:42 +0100
Message-ID: <20261001151645.2427065-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jing Zhang <jingzhangos@google.com>

Implement the logic to intercept and handle exceptions from managed
guests at EL2. This completes the context switch loop by providing a
mechanism to save guest state, route exceptions to C handlers, and
either resume the guest or return to the host.

Key additions:
- 'hyp_el2_vectors': An EL2 vector table installed during guest
  execution to trap guest exits (Synchronous, IRQ, etc.).
- 'guest_c_exception_handler': A C-level dispatcher that updates the
  guest context with exception info (ESR, FAR, HPFAR) and invokes
  registered per-vector handlers.
- Integrated save/restore logic: guest_run() now handles the full
  cycle of saving host state, loading guest state, trapping exits,
  and optionally resuming or returning.
- Handler API: Added guest_install_handler() to allow tests to register
  custom logic for specific exception types.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm64/asm-offsets.c |   1 +
 lib/arm64/asm/guest.h   |  19 +++++++
 lib/arm64/guest.c       |  94 +++++++++++++++++++++++++++++++++--
 lib/arm64/guest_arch.S  | 106 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 212 insertions(+), 8 deletions(-)

diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index c55e4bb9..1fc595ff 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -33,6 +33,7 @@ int main(void)
 
 	OFFSET(GUEST_X_OFFSET, guest, x);
 	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
+	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
 
 	return 0;
 }
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
index 50fc3338..9ad344e1 100644
--- a/lib/arm64/asm/guest.h
+++ b/lib/arm64/asm/guest.h
@@ -16,6 +16,19 @@
 /* Guest stack size */
 #define GUEST_STACK_SIZE		SZ_64K
 
+/*
+ * Result from Handler:
+ * RESUME: Keep guest running (ERET immediately)
+ * EXIT:   Return to Host C caller
+ */
+enum guest_handler_result {
+	GUEST_ACTION_RESUME,
+	GUEST_ACTION_EXIT
+};
+
+struct guest;
+typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
+
 struct guest {
 	/* General Purpose Registers */
 	unsigned long x[31]; /* x0..x30 */
@@ -35,6 +48,9 @@ struct guest {
 	unsigned long hpfar_el2;
 	unsigned long exit_code;
 
+	/* Exception Handlers in EL2 */
+	guest_handler_t handlers[VECTOR_MAX];
+
 	struct s2_mmu *s2mmu;
 	void *guest_stack;
 };
@@ -50,4 +66,7 @@ struct guest *guest_create_identity(int vmid, void (*guest_func)(void),
 void guest_destroy(struct guest *guest);
 void guest_run(struct guest *guest);
 
+unsigned long guest_c_exception_handler(struct guest *guest);
+void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler);
+
 #endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
index b348e628..afb91559 100644
--- a/lib/arm64/guest.c
+++ b/lib/arm64/guest.c
@@ -12,7 +12,47 @@
 #include <alloc_page.h>
 #include <alloc.h>
 
-extern void __guest_switch_regs(struct guest *guest);
+/* Host state owned by a guest_run() invocation, not by the guest. */
+struct guest_host_state {
+	unsigned long hcr_el2;
+	unsigned long vtcr_el2;
+	unsigned long vttbr_el2;
+	unsigned long vbar_el2;
+	unsigned long tpidr_el2;
+	unsigned long daif;
+};
+
+extern void __guest_switch_regs(struct guest *guest,
+				struct guest_host_state *host_state);
+
+static void guest_save_host_state(struct guest_host_state *state)
+{
+	state->hcr_el2 = read_sysreg(hcr_el2);
+	state->vtcr_el2 = read_sysreg(vtcr_el2);
+	state->vttbr_el2 = read_sysreg(vttbr_el2);
+	state->vbar_el2 = read_sysreg(vbar_el2);
+	state->tpidr_el2 = read_sysreg(tpidr_el2);
+	state->daif = read_sysreg(daif);
+}
+
+static void guest_restore_host_state(const struct guest_host_state *state)
+{
+	write_sysreg(state->vtcr_el2, vtcr_el2);
+	write_sysreg(state->vttbr_el2, vttbr_el2);
+	write_sysreg(state->vbar_el2, vbar_el2);
+	write_sysreg(state->hcr_el2, hcr_el2);
+	write_sysreg(state->tpidr_el2, tpidr_el2);
+	isb();
+	write_sysreg(state->daif, daif);
+}
+
+static void guest_save_state(struct guest *guest)
+{
+	guest->elr_el2 = read_sysreg(elr_el2);
+	guest->spsr_el2 = read_sysreg(spsr_el2);
+	guest->sctlr_el1 = read_sysreg_s(SYS_SCTLR_EL12);
+	guest->sp_el1 = read_sysreg(sp_el1);
+}
 
 static void guest_restore_state(const struct guest *guest)
 {
@@ -22,18 +62,58 @@ static void guest_restore_state(const struct guest *guest)
 	write_sysreg(guest->sp_el1, sp_el1);
 }
 
-static void guest_arch_enter(struct guest *guest)
+static void guest_arch_enter(struct guest *guest,
+			     struct guest_host_state *host_state)
 {
 	s2mmu_load(guest->s2mmu);
 	guest_restore_state(guest);
-	__guest_switch_regs(guest);
+	__guest_switch_regs(guest, host_state);
+}
+
+void guest_arch_exit(const struct guest_host_state *state)
+{
+	guest_restore_host_state(state);
 }
 
 void guest_run(struct guest *guest)
 {
-	guest_arch_enter(guest);
+	struct guest_host_state host_state;
+
+	guest_save_host_state(&host_state);
+	guest_arch_enter(guest, &host_state);
 }
 
+/*
+ * C-Entry for Exception Handling
+ * Returns 0 to Resume Guest, 1 to Exit to Host Caller
+ */
+unsigned long guest_c_exception_handler(struct guest *guest)
+{
+	enum vector vector;
+
+	/* Save guest system-register state before invoking the exit handler. */
+	guest_save_state(guest);
+	guest->esr_el2 = read_sysreg(esr_el2);
+	guest->far_el2 = read_sysreg(far_el2);
+	guest->hpfar_el2 = read_sysreg(hpfar_el2);
+
+	if (guest->exit_code >= VECTOR_MAX)
+		return 1;
+	vector = (enum vector)guest->exit_code;
+
+	/* Invoke Handler if registered */
+	if (guest->handlers[vector]) {
+		if (guest->handlers[vector](guest) == GUEST_ACTION_RESUME) {
+			guest_restore_state(guest);
+			return 0; /* ASM stub will restore and ERET */
+		}
+	}
+
+	/* Default: Exit to caller */
+	return 1;
+}
+
+
 struct guest *guest_create(struct s2_mmu *s2_ctx, unsigned long entry_ipa)
 {
 	struct guest *guest;
@@ -125,3 +205,9 @@ void guest_destroy(struct guest *guest)
 	free_pages(guest->guest_stack);
 	free(guest);
 }
+
+void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler)
+{
+	if (v < VECTOR_MAX)
+		guest->handlers[v] = handler;
+}
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
index 16b95835..33d0dc53 100644
--- a/lib/arm64/guest_arch.S
+++ b/lib/arm64/guest_arch.S
@@ -12,7 +12,10 @@
 
 .global __guest_switch_regs
 __guest_switch_regs:
-	/* x0 = struct guest pointer */
+	/*
+	 * x0 = struct guest pointer
+	 * x1 = host system-register state
+	 */
 
 	/* Save Host Callee-Saved Regs */
 	stp	x29, x30, [sp, #-16]!
@@ -21,13 +24,18 @@ __guest_switch_regs:
 	stp	x23, x24, [sp, #-16]!
 	stp	x21, x22, [sp, #-16]!
 	stp	x19, x20, [sp, #-16]!
+	stp	x1, xzr, [sp, #-16]!
 
 	/*
-	 * Commit the guest EL2 state only after the world-switch frame is valid.
+	 * Commit the guest EL2 state only after the exit frame is valid. No
+	 * exception may reach the guest vectors without this frame in place.
 	 */
-	ldr	x1, [x0, #GUEST_HCR_OFFSET]
+	ldr	x2, [x0, #GUEST_HCR_OFFSET]
+	adrp	x3, hyp_el2_vectors
+	add	x3, x3, :lo12:hyp_el2_vectors
 	msr	tpidr_el2, x0
-	msr	hcr_el2, x1
+	msr	vbar_el2, x3
+	msr	hcr_el2, x2
 	isb
 
 	/* Load Guest GPRs */
@@ -49,3 +57,93 @@ __guest_switch_regs:
 	ldr	x0, [x0, #GUEST_XREG_OFFSET(0)]
 
 	eret
+
+/* EL2 Hypervisor Vector Table */
+.macro hyp_el2_vector, vector_num
+	.align 7
+	stp	x0, x1, [sp, #-16]!
+	mrs	x0, tpidr_el2
+	mov	x1, \vector_num
+	str	x1, [x0, #GUEST_EXIT_CODE_OFFSET]
+	b	guest_common_exit
+.endm
+
+	.align 11
+.global hyp_el2_vectors
+hyp_el2_vectors:
+	.skip 0x200
+
+	hyp_el2_vector #4	/* ELxH_SYNC */
+	hyp_el2_vector #5	/* ELxH_IRQ */
+	hyp_el2_vector #6	/* ELxH_FIQ */
+	hyp_el2_vector #7	/* ELxH_ERROR */
+
+	hyp_el2_vector #8	/* ELx_LOW_SYNC_64 */
+	hyp_el2_vector #9	/* ELx_LOW_IRQ_64 */
+	hyp_el2_vector #10	/* ELx_LOW_FIQ_64 */
+	hyp_el2_vector #11	/* ELx_LOW_ERROR_64 */
+
+	.align 11
+
+guest_common_exit:
+	stp	x2, x3, [x0, #GUEST_XREG_OFFSET(2)]
+	stp	x4, x5, [x0, #GUEST_XREG_OFFSET(4)]
+	stp	x6, x7, [x0, #GUEST_XREG_OFFSET(6)]
+	stp	x8, x9, [x0, #GUEST_XREG_OFFSET(8)]
+	stp	x10, x11, [x0, #GUEST_XREG_OFFSET(10)]
+	stp	x12, x13, [x0, #GUEST_XREG_OFFSET(12)]
+	stp	x14, x15, [x0, #GUEST_XREG_OFFSET(14)]
+	stp	x16, x17, [x0, #GUEST_XREG_OFFSET(16)]
+	stp	x18, x19, [x0, #GUEST_XREG_OFFSET(18)]
+	stp	x20, x21, [x0, #GUEST_XREG_OFFSET(20)]
+	stp	x22, x23, [x0, #GUEST_XREG_OFFSET(22)]
+	stp	x24, x25, [x0, #GUEST_XREG_OFFSET(24)]
+	stp	x26, x27, [x0, #GUEST_XREG_OFFSET(26)]
+	stp	x28, x29, [x0, #GUEST_XREG_OFFSET(28)]
+	str	x30, [x0, #GUEST_XREG_OFFSET(30)]
+
+	ldp	x2, x3, [sp], #16
+	stp	x2, x3, [x0, #GUEST_XREG_OFFSET(0)]
+
+	bl	guest_c_exception_handler
+	cbz	x0, guest_resume_guest
+
+	/* EXIT */
+	/*
+	 * Restore the host system registers while this world-switch frame and
+	 * the guest exit vector are still valid.
+	 */
+	ldr	x0, [sp]
+	bl	guest_arch_exit
+	add	sp, sp, #16
+
+	/* Restore Host Callee-Saved Regs */
+	ldp	x19, x20, [sp], #16
+	ldp	x21, x22, [sp], #16
+	ldp	x23, x24, [sp], #16
+	ldp	x25, x26, [sp], #16
+	ldp	x27, x28, [sp], #16
+	ldp	x29, x30, [sp], #16
+	ret
+
+	/* RESUME */
+guest_resume_guest:
+	mrs	x0, tpidr_el2
+
+	ldp	x1, x2, [x0, #GUEST_XREG_OFFSET(1)]
+	ldp	x3, x4, [x0, #GUEST_XREG_OFFSET(3)]
+	ldp	x5, x6, [x0, #GUEST_XREG_OFFSET(5)]
+	ldp	x7, x8, [x0, #GUEST_XREG_OFFSET(7)]
+	ldp	x9, x10, [x0, #GUEST_XREG_OFFSET(9)]
+	ldp	x11, x12, [x0, #GUEST_XREG_OFFSET(11)]
+	ldp	x13, x14, [x0, #GUEST_XREG_OFFSET(13)]
+	ldp	x15, x16, [x0, #GUEST_XREG_OFFSET(15)]
+	ldp	x17, x18, [x0, #GUEST_XREG_OFFSET(17)]
+	ldp	x19, x20, [x0, #GUEST_XREG_OFFSET(19)]
+	ldp	x21, x22, [x0, #GUEST_XREG_OFFSET(21)]
+	ldp	x23, x24, [x0, #GUEST_XREG_OFFSET(23)]
+	ldp	x25, x26, [x0, #GUEST_XREG_OFFSET(25)]
+	ldp	x27, x28, [x0, #GUEST_XREG_OFFSET(27)]
+	ldp	x29, x30, [x0, #GUEST_XREG_OFFSET(29)]
+	ldr	x0, [x0, #GUEST_XREG_OFFSET(0)]
+	eret
-- 
2.43.0

