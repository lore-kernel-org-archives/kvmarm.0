Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F80851B178
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867828; cv=none; b=hv5QVNGiSQ57DaOfFhFPGUIqIioErrsscAQnNFaCmQbFEJgWRk+NeNquY1KDDHl0VF5lc3b2DriYuyN2/U3dzsRiISMnwDpfgoILcRKyTNTn9LcPyImMjzImIlV0TO0mGqi0pSvWOf5KnbqdDELX8nxndc5iPLz9DspC+/JgPn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867828; c=relaxed/simple;
	bh=dz/JW1ZlcykMN2HmG3O9V1Ye+xCcSosIN0m9OZpFmY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfWMVHp1BTgW6MzzHGfb0LcqWyCNydnN1IHoZjI0ICtiMmHKfQOn+HdI4DQw/WYSBmw7uvw6TlkvPuBnuBxDTLMmYoFs2YEgU7LJwjUVITz2R2h0hiQc1llCnX0MfDo3+Dq1fpSvjqA9GQRhADX7/O9UC7vk+sIH+NegGLmx74k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e8tf+gRL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e8tf+gRL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6179497;
	Thu,  1 Oct 2026 08:17:02 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE2403F8C6;
	Thu,  1 Oct 2026 08:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867826; bh=dz/JW1ZlcykMN2HmG3O9V1Ye+xCcSosIN0m9OZpFmY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8tf+gRL3lVb7KLppmqYLsIgWxTdr/8/7H9GvBbajfZqLXmlggr9LziT3sO0Nzpnh
	 VFdpbTdiGKQsdFxzjSooVsY6FGvvhso3GslFmXZsuO02WaPHNKLrS2PWMDG9yhM25V
	 2jb0ZEebaHEGHznvSQaKA7Pn5gSHju4SxzCpDVvE=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 6/8] lib: arm64: Add guest-internal exception handling
Date: Thu,  1 Oct 2026 16:16:43 +0100
Message-ID: <20261001151645.2427065-7-joey.gouly@arm.com>
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

Implement the infrastructure for managed guests to handle their own
exceptions at EL1. This allows guests to manage internal traps
independently of the EL2 host.

Changes include:
- 'guest_el1_vectors': A dedicated EL1 vector table for guests,
  supporting synchronous exceptions, IRQs, FIQs, and SErrors.
- 'guest_context': A per-guest metadata structure tracked via
  TPIDR_EL1, containing a dispatch table for guest-internal handlers.
- 'guest_el1_c_handler': C-level dispatcher that executes registered
  guest handlers or triggers an HVC trap back to the host for unhandled
  exceptions.
- Integrated setup: guest_create() now allocates and maps the guest
  context, while the context switch logic ensures VBAR_EL1 and
  TPIDR_EL1 are correctly saved and restored.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm64/asm-offsets.c |  5 +++
 lib/arm64/asm/guest.h   | 27 +++++++++++++++
 lib/arm64/asm/sysreg.h  |  1 +
 lib/arm64/guest.c       | 51 ++++++++++++++++++++++++++++
 lib/arm64/guest_arch.S  | 74 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 158 insertions(+)

diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index 1fc595ff..5081f1df 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -35,5 +35,10 @@ int main(void)
 	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
 	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
 
+	OFFSET(GUEST_EL1_X_OFFSET, guest_el1_regs, regs);
+	OFFSET(GUEST_EL1_ELR_OFFSET, guest_el1_regs, elr);
+	OFFSET(GUEST_EL1_SPSR_OFFSET, guest_el1_regs, spsr);
+	DEFINE(GUEST_EL1_REGS_SIZE, sizeof(struct guest_el1_regs));
+
 	return 0;
 }
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
index 9ad344e1..d62fdc65 100644
--- a/lib/arm64/asm/guest.h
+++ b/lib/arm64/asm/guest.h
@@ -29,6 +29,27 @@ enum guest_handler_result {
 struct guest;
 typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
 
+/*
+ * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
+ * We use a simplified frame: x0-x30, elr, spsr. size = 34*8
+ */
+struct guest_el1_regs {
+	unsigned long regs[31];
+	unsigned long elr;
+	unsigned long spsr;
+	unsigned long reserved;
+};
+
+typedef void (*guest_el1_handler_t)(struct guest_el1_regs *regs, unsigned int esr);
+
+/*
+ * Guest Context Structure
+ * This will be pointed to by TPIDR_EL1 while the guest is running.
+ */
+struct guest_context {
+	guest_el1_handler_t handlers[VECTOR_MAX];
+};
+
 struct guest {
 	/* General Purpose Registers */
 	unsigned long x[31]; /* x0..x30 */
@@ -41,15 +62,18 @@ struct guest {
 	unsigned long hcr_el2;
 	unsigned long sctlr_el1;
 	unsigned long sp_el1;
+	unsigned long vbar_el1;
 
 	/* Exit Information */
 	unsigned long esr_el2;
 	unsigned long far_el2;
 	unsigned long hpfar_el2;
 	unsigned long exit_code;
+	unsigned long tpidr_el1;
 
 	/* Exception Handlers in EL2 */
 	guest_handler_t handlers[VECTOR_MAX];
+	struct guest_context *guest_context;
 
 	struct s2_mmu *s2mmu;
 	void *guest_stack;
@@ -69,4 +93,7 @@ void guest_run(struct guest *guest);
 unsigned long guest_c_exception_handler(struct guest *guest);
 void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler);
 
+void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector);
+void guest_install_el1_handler(struct guest *guest, enum vector v, guest_el1_handler_t handler);
+
 #endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index b3b7e221..8903b630 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -166,6 +166,7 @@ asm(
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
 #define SYS_SCTLR_EL12		sys_reg(3, 5, 1, 0, 0)
+#define SYS_VBAR_EL12		sys_reg(3, 5, 12, 0, 0)
 
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
index afb91559..821f281d 100644
--- a/lib/arm64/guest.c
+++ b/lib/arm64/guest.c
@@ -24,6 +24,7 @@ struct guest_host_state {
 
 extern void __guest_switch_regs(struct guest *guest,
 				struct guest_host_state *host_state);
+void guest_arch_exit(const struct guest_host_state *state);
 
 static void guest_save_host_state(struct guest_host_state *state)
 {
@@ -52,6 +53,8 @@ static void guest_save_state(struct guest *guest)
 	guest->spsr_el2 = read_sysreg(spsr_el2);
 	guest->sctlr_el1 = read_sysreg_s(SYS_SCTLR_EL12);
 	guest->sp_el1 = read_sysreg(sp_el1);
+	guest->vbar_el1 = read_sysreg_s(SYS_VBAR_EL12);
+	guest->tpidr_el1 = read_sysreg(tpidr_el1);
 }
 
 static void guest_restore_state(const struct guest *guest)
@@ -60,6 +63,8 @@ static void guest_restore_state(const struct guest *guest)
 	write_sysreg(guest->spsr_el2, spsr_el2);
 	write_sysreg_s(guest->sctlr_el1, SYS_SCTLR_EL12);
 	write_sysreg(guest->sp_el1, sp_el1);
+	write_sysreg_s(guest->vbar_el1, SYS_VBAR_EL12);
+	write_sysreg(guest->tpidr_el1, tpidr_el1);
 }
 
 static void guest_arch_enter(struct guest *guest,
@@ -113,10 +118,32 @@ unsigned long guest_c_exception_handler(struct guest *guest)
 	return 1;
 }
 
+void guest_install_el1_handler(struct guest *guest, enum vector v, guest_el1_handler_t handler)
+{
+	if (guest && guest->guest_context && v < VECTOR_MAX)
+		guest->guest_context->handlers[v] = handler;
+}
+
+void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector)
+{
+	struct guest_context *ctx = (struct guest_context *)read_sysreg(tpidr_el1);
+	unsigned int esr = read_sysreg(esr_el1);
+
+	if (ctx && vector < VECTOR_MAX && ctx->handlers[vector]) {
+		ctx->handlers[vector](regs, esr);
+	} else {
+		asm volatile("hvc #0xFFFF");
+	}
+}
+
+extern void guest_el1_vectors(void);
 
 struct guest *guest_create(struct s2_mmu *s2_ctx, unsigned long entry_ipa)
 {
 	struct guest *guest;
+	struct guest_context *guest_ctx;
+	unsigned long guest_ctx_pa;
+	int ret;
 
 	if (!s2_ctx)
 		return NULL;
@@ -125,6 +152,21 @@ struct guest *guest_create(struct s2_mmu *s2_ctx, unsigned long entry_ipa)
 	if (!guest)
 		return NULL;
 
+	/* Allocate the internal context table */
+	guest_ctx = (void *)alloc_page();
+	if (!guest_ctx)
+		goto free_guest;
+	memset(guest_ctx, 0, PAGE_SIZE);
+	guest->guest_context = guest_ctx;
+
+	guest_ctx_pa = virt_to_phys(guest_ctx);
+	ret = s2mmu_map(s2_ctx, guest_ctx_pa, guest_ctx_pa, PAGE_SIZE,
+			S2_MAP_RW);
+	if (ret)
+		goto free_guest_ctx;
+
+	guest->tpidr_el1 = guest_ctx_pa;
+
 	guest->elr_el2 = entry_ipa;
 	guest->spsr_el2 = PSR_MODE_EL1h |
 		PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
@@ -135,9 +177,16 @@ struct guest *guest_create(struct s2_mmu *s2_ctx, unsigned long entry_ipa)
 	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
 	guest->sctlr_el1 |= SCTLR_EL1_I;
 
+	guest->vbar_el1 = virt_to_phys((void *)guest_el1_vectors);
 	guest->s2mmu = s2_ctx;
 
 	return guest;
+
+free_guest_ctx:
+	free_page(guest_ctx);
+free_guest:
+	free(guest);
+	return NULL;
 }
 
 struct guest *guest_create_identity(int vmid, void (*guest_func)(void),
@@ -203,6 +252,8 @@ void guest_destroy(struct guest *guest)
 {
 	s2mmu_destroy(guest->s2mmu);
 	free_pages(guest->guest_stack);
+	if (guest->guest_context)
+		free_page(guest->guest_context);
 	free(guest);
 }
 
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
index 33d0dc53..1ccba114 100644
--- a/lib/arm64/guest_arch.S
+++ b/lib/arm64/guest_arch.S
@@ -9,6 +9,7 @@
 #include <asm/sysreg.h>
 
 #define GUEST_XREG_OFFSET(x)	(GUEST_X_OFFSET + 8 * (x))
+#define GUEST_EL1_XREG_OFFSET(x)	(GUEST_EL1_X_OFFSET + 8 * (x))
 
 .global __guest_switch_regs
 __guest_switch_regs:
@@ -147,3 +148,76 @@ guest_resume_guest:
 	ldp	x29, x30, [x0, #GUEST_XREG_OFFSET(29)]
 	ldr	x0, [x0, #GUEST_XREG_OFFSET(0)]
 	eret
+
+/* EL1 Vector Table */
+.macro guest_el1_vector, vector_num
+	.align 7
+	sub	sp, sp, #GUEST_EL1_REGS_SIZE
+	/* Save x29 and x30 before using x29 for the vector number. */
+	stp	x29, x30, [sp, #GUEST_EL1_XREG_OFFSET(29)]
+	mov	x29, \vector_num
+	b       guest_el1_common
+.endm
+
+.align 11
+.global guest_el1_vectors
+guest_el1_vectors:
+	.skip 0x200
+
+	guest_el1_vector #4	/* Sync */
+	guest_el1_vector #5	/* IRQ */
+	guest_el1_vector #6	/* FIQ */
+	guest_el1_vector #7	/* SError */
+
+	.align 11
+
+guest_el1_common:
+	stp	x0, x1, [sp, #GUEST_EL1_XREG_OFFSET(0)]
+	stp	x2, x3, [sp, #GUEST_EL1_XREG_OFFSET(2)]
+	stp	x4, x5, [sp, #GUEST_EL1_XREG_OFFSET(4)]
+	stp	x6, x7, [sp, #GUEST_EL1_XREG_OFFSET(6)]
+	stp	x8, x9, [sp, #GUEST_EL1_XREG_OFFSET(8)]
+	stp	x10, x11, [sp, #GUEST_EL1_XREG_OFFSET(10)]
+	stp	x12, x13, [sp, #GUEST_EL1_XREG_OFFSET(12)]
+	stp	x14, x15, [sp, #GUEST_EL1_XREG_OFFSET(14)]
+	stp	x16, x17, [sp, #GUEST_EL1_XREG_OFFSET(16)]
+	stp	x18, x19, [sp, #GUEST_EL1_XREG_OFFSET(18)]
+	stp	x20, x21, [sp, #GUEST_EL1_XREG_OFFSET(20)]
+	stp	x22, x23, [sp, #GUEST_EL1_XREG_OFFSET(22)]
+	stp	x24, x25, [sp, #GUEST_EL1_XREG_OFFSET(24)]
+	stp	x26, x27, [sp, #GUEST_EL1_XREG_OFFSET(26)]
+	str	x28, [sp, #GUEST_EL1_XREG_OFFSET(28)]
+
+	mrs	x0, elr_el1
+	str	x0, [sp, #GUEST_EL1_ELR_OFFSET]
+	mrs	x0, spsr_el1
+	str	x0, [sp, #GUEST_EL1_SPSR_OFFSET]
+
+	mov	x0, sp
+	mov	x1, x29
+	bl	guest_el1_c_handler
+
+	ldr	x0, [sp, #GUEST_EL1_ELR_OFFSET]
+	msr	elr_el1, x0
+	ldr	x0, [sp, #GUEST_EL1_SPSR_OFFSET]
+	msr	spsr_el1, x0
+
+	ldp	x0, x1, [sp, #GUEST_EL1_XREG_OFFSET(0)]
+	ldp	x2, x3, [sp, #GUEST_EL1_XREG_OFFSET(2)]
+	ldp	x4, x5, [sp, #GUEST_EL1_XREG_OFFSET(4)]
+	ldp	x6, x7, [sp, #GUEST_EL1_XREG_OFFSET(6)]
+	ldp	x8, x9, [sp, #GUEST_EL1_XREG_OFFSET(8)]
+	ldp	x10, x11, [sp, #GUEST_EL1_XREG_OFFSET(10)]
+	ldp	x12, x13, [sp, #GUEST_EL1_XREG_OFFSET(12)]
+	ldp	x14, x15, [sp, #GUEST_EL1_XREG_OFFSET(14)]
+	ldp	x16, x17, [sp, #GUEST_EL1_XREG_OFFSET(16)]
+	ldp	x18, x19, [sp, #GUEST_EL1_XREG_OFFSET(18)]
+	ldp	x20, x21, [sp, #GUEST_EL1_XREG_OFFSET(20)]
+	ldp	x22, x23, [sp, #GUEST_EL1_XREG_OFFSET(22)]
+	ldp	x24, x25, [sp, #GUEST_EL1_XREG_OFFSET(24)]
+	ldp	x26, x27, [sp, #GUEST_EL1_XREG_OFFSET(26)]
+	ldp	x28, x29, [sp, #GUEST_EL1_XREG_OFFSET(28)]
+	ldr	x30, [sp, #GUEST_EL1_XREG_OFFSET(30)]
+
+	add	sp, sp, #GUEST_EL1_REGS_SIZE
+	eret
-- 
2.43.0

