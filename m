Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC3939020C
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113208; cv=none; b=bBEysXtAn1D95y6B0ANpbCllLpI9GcmjGHb45Syxv8tyKSMGbndOnGtXTg9h+qRmWC5YpR+XrU0hHf3P6DYwyTQr/5BfhhQtgtD6zCx79dvCwuDtXoxLNefJtW2KKzPzzZ3meufLX5R2ssPpzoidOwa1s7TXqYA7f65rnstKOik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113208; c=relaxed/simple;
	bh=d1hpiMRFdZxpuyMBateAzzMrtZDgNqqBolAYJJFqEkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XXUUjZsJCQ2hZnReO9/ZtDe0HJBGEpNr6ih+P10tJ9+3HHj94/854fQh4l30tyNEAo2hkylBsZxKSb5qb6EhZviGwn9dO6+1tzCv60eSRaudbAFHy9pEFenOwQieB9hOBLL7S3CD13LBOK2BSy0W9oovEgOjYcmiFc2xNLysuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JLfK9jyw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JLfK9jyw"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so4770912a91.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113206; x=1776718006; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDtbVk3LBocL0OBzLHiNFhK4Hxgjw9y2iVyvWfAweOc=;
        b=JLfK9jywS0WyMUETwNqqpU+LQxtXyWdVBEwZ/X3jcuTOXmida9P/mpDXft/g2gXvnr
         UwCf+1z/wIxOVpXXPkWia2Dsq4/u9T6mupSaqb8VgEMybynL6KzfpNRbWcQa7RIDQOi2
         wMoHwm9sVLNRCVRc6iZZ8ta8Ux6Q/9EMAzsL0NVtS0f1LguVcKzM8UhNKhobJRwPhx6v
         PgzJy9NnZrYCxZnAXTrHxSYx3NQQOfSKvXj/eP/60GKJOXiiV7gdhxZ/5nqX9bBQq+rg
         G3hEyYQoc/AnskPU+kR+tRdlC5yu3Ko5LoPrB65Ap6xeJ0/fGcXUPEyPPCgek7PLRzCF
         tl8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113206; x=1776718006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDtbVk3LBocL0OBzLHiNFhK4Hxgjw9y2iVyvWfAweOc=;
        b=Cgs+7JbiDbiEmwP/AvDmkWMKwKepE423XylRf/yTEW3AksA4NE11phsx9w1mFdk9JT
         mX92SsOxpb0cpGziX6hHEHbgAen9NNEZaviZSWlKiQPMMoQwXcu7h70Is4d6jVBw0y02
         q0qsdwe53G0B7VSKxQAu3oDij/wO8JvvaQoiryspwCYGxQ0e0L17U4T9MnORJElFKFwM
         pr0EtOdaoeXWASkK5kjq21I5bLg/70NcG9H+rNzCO9F7cKlqdb2YB5zSafhfTkQ8shjY
         nDystBjITpHSPAaAVvXPY4nmzVnYtebGZsQmkI9/eVhudvtOJ4Kwj9ygBVuNSesDeX+a
         obKA==
X-Forwarded-Encrypted: i=1; AFNElJ8qi84dOX8FjztX6c/p5++190bQSNdSyQBU2tN8lg+KxnnWsLhpPqClNf/y5rr/5ZiHZuynX4c=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr42kPp1idVIm3zmWDKDKfpSU54TFY6aqPWweN1/2sy4bhxmh7
	nX33NRwaSFkw96KdGUJUUqR4lrcOvFe+yUPnDYVIjReL5Zi3c37txe0ABXOPTQyNoD5QIA7xN3P
	muWjgk2T+m+LmDdLO9ri3PNcJUg==
X-Received: from pjbpq10.prod.google.com ([2002:a17:90b:3d8a:b0:35f:b90b:85d7])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d88:b0:35f:ba3f:e04e with SMTP id 98e67ed59e1d1-35fba3fe3ddmr4189553a91.11.1776113205851;
 Mon, 13 Apr 2026 13:46:45 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:29 -0700
In-Reply-To: <20260413204630.1149038-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260413204630.1149038-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-7-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 6/7] lib: arm64: Add guest-internal
 exception handling (EL1)
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 lib/arm64/asm-offsets.c |  2 ++
 lib/arm64/asm/guest.h   | 26 ++++++++++++++
 lib/arm64/asm/sysreg.h  |  1 +
 lib/arm64/guest.c       | 39 +++++++++++++++++++++
 lib/arm64/guest_arch.S  | 78 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 146 insertions(+)

diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index ceeecce5..fc9f28fb 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -37,11 +37,13 @@ int main(void)
 	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
 	OFFSET(GUEST_VTTBR_OFFSET, guest, vttbr_el2);
 	OFFSET(GUEST_SCTLR_OFFSET, guest, sctlr_el1);
+	OFFSET(GUEST_VBAR_OFFSET, guest, vbar_el1);
 	OFFSET(GUEST_SP_EL1_OFFSET, guest, sp_el1);
 	OFFSET(GUEST_ESR_OFFSET, guest, esr_el2);
 	OFFSET(GUEST_FAR_OFFSET, guest, far_el2);
 	OFFSET(GUEST_HPFAR_OFFSET, guest, hpfar_el2);
 	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
+	OFFSET(GUEST_TPIDR_EL1_OFFSET, guest, tpidr_el1);
 
 	return 0;
 }
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
index b99641ef..8b40f3a5 100644
--- a/lib/arm64/asm/guest.h
+++ b/lib/arm64/asm/guest.h
@@ -29,6 +29,26 @@ enum guest_handler_result {
 struct guest;
 typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
 
+/*
+ * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
+ * We use a simplified frame: x0-x30, elr, spsr. size = 33*8
+ */
+struct guest_el1_regs {
+	unsigned long regs[31];
+	unsigned long elr;
+	unsigned long spsr;
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
@@ -42,15 +62,18 @@ struct guest {
 	unsigned long vttbr_el2;
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
 };
@@ -62,4 +85,7 @@ void guest_run(struct guest *guest);
 unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset);
 void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler);
 
+void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector);
+void guest_install_el1_handler(struct guest *guest, enum vector v, guest_el1_handler_t handler);
+
 #endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 857bee98..a298ceff 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -137,6 +137,7 @@ asm(
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
 #define SYS_SCTLR_EL1		sys_reg(3, 5, 1, 0, 0)
+#define SYS_VBAR_EL1		sys_reg(3, 5, 12, 0, 0)
 
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
index dd42ccd6..54c8b429 100644
--- a/lib/arm64/guest.c
+++ b/lib/arm64/guest.c
@@ -36,9 +36,45 @@ unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vecto
 	return 1;
 }
 
+/* --- EL1 (Guest-Internal) Vector Handling --- */
+
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
+		printf("Guest: Unhandled Exception Vector %d, ESR=0x%x\n", vector, esr);
+		asm volatile("hvc #0xFFFF");
+	}
+}
+
+extern void guest_el1_vectors(void);
+
 static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
 {
 	struct guest *guest = calloc(1, sizeof(struct guest));
+	struct guest_context *guest_ctx;
+	unsigned long guest_ctx_pa;
+
+	/* Allocate the internal context table */
+	guest_ctx = (void *)alloc_page();
+	memset(guest_ctx, 0, PAGE_SIZE);
+	guest->guest_context = guest_ctx;
+
+	guest_ctx_pa = virt_to_phys(guest_ctx);
+	if (s2_ctx)
+		s2mmu_map(s2_ctx, guest_ctx_pa, guest_ctx_pa, PAGE_SIZE, S2_MAP_RW);
+
+	guest->tpidr_el1 = guest_ctx_pa;
 
 	guest->elr_el2 = (unsigned long)entry_point;
 	guest->spsr_el2 = 0x3C5; /* M=EL1h, DAIF=Masked */
@@ -56,6 +92,7 @@ static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
 	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
 	guest->sctlr_el1 |= SCTLR_EL1_I;
 
+	guest->vbar_el1 = (unsigned long)guest_el1_vectors;
 	guest->s2mmu = s2_ctx;
 
 	return guest;
@@ -109,6 +146,8 @@ void guest_destroy(struct guest *guest)
 {
 	s2mmu_disable(guest->s2mmu);
 	s2mmu_destroy(guest->s2mmu);
+	if (guest->guest_context)
+		free_page(guest->guest_context);
 	free(guest);
 }
 
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
index 81874fd0..32d640e6 100644
--- a/lib/arm64/guest_arch.S
+++ b/lib/arm64/guest_arch.S
@@ -34,8 +34,12 @@ guest_run:
 	msr	vttbr_el2, x1
 	ldr	x1, [x0, #GUEST_SCTLR_OFFSET]
 	msr_s	SYS_SCTLR_EL1, x1
+	ldr	x1, [x0, #GUEST_VBAR_OFFSET]
+	msr_s	SYS_VBAR_EL1, x1
 	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
 	msr	sp_el1, x1
+	ldr	x1, [x0, #GUEST_TPIDR_EL1_OFFSET]
+	msr	tpidr_el1, x1
 
 	/* Load Guest GPRs */
 	ldp	x1, x2, [x0, #8]
@@ -125,6 +129,8 @@ guest_common_exit:
 	str	x1, [x0, #GUEST_HPFAR_OFFSET]
 	mrs	x1, sp_el1
 	str	x1, [x0, #GUEST_SP_EL1_OFFSET]
+	mrs_s	x1, SYS_VBAR_EL1
+	str	x1, [x0, #GUEST_VBAR_OFFSET]
 
 	/* x29 contains vector offset from entry */
 	mov	x1, x29
@@ -168,3 +174,75 @@ guest_resume_guest:
 	ldp	x29, x30, [x0, #232]
 	ldr	x0, [x0, #0]
 	eret
+
+/* EL1 Vector Table */
+.macro guest_el1_vector, vector_num
+	.align 7
+	stp     x29, x30, [sp, #-16]!
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
+	sub	sp, sp, #264
+	stp	x0, x1, [sp, #0]
+	stp	x2, x3, [sp, #16]
+	stp	x4, x5, [sp, #32]
+	stp	x6, x7, [sp, #48]
+	stp	x8, x9, [sp, #64]
+	stp	x10, x11, [sp, #80]
+	stp	x12, x13, [sp, #96]
+	stp	x14, x15, [sp, #112]
+	stp	x16, x17, [sp, #128]
+	stp	x18, x19, [sp, #144]
+	stp	x20, x21, [sp, #160]
+	stp	x22, x23, [sp, #176]
+	stp	x24, x25, [sp, #192]
+	stp	x26, x27, [sp, #208]
+	stp	x28, x30, [sp, #224]
+
+	mrs	x0, elr_el1
+	str	x0, [sp, #248]
+	mrs	x0, spsr_el1
+	str	x0, [sp, #256]
+
+	mov	x0, sp
+	mov	x1, x29
+	bl	guest_el1_c_handler
+
+	ldr	x0, [sp, #248]
+	msr	elr_el1, x0
+	ldr	x0, [sp, #256]
+	msr	spsr_el1, x0
+
+	ldp	x0, x1, [sp, #0]
+	ldp	x2, x3, [sp, #16]
+	ldp	x4, x5, [sp, #32]
+	ldp	x6, x7, [sp, #48]
+	ldp	x8, x9, [sp, #64]
+	ldp	x10, x11, [sp, #80]
+	ldp	x12, x13, [sp, #96]
+	ldp	x14, x15, [sp, #112]
+	ldp	x16, x17, [sp, #128]
+	ldp	x18, x19, [sp, #144]
+	ldp	x20, x21, [sp, #160]
+	ldp	x22, x23, [sp, #176]
+	ldp	x24, x25, [sp, #192]
+	ldp	x26, x27, [sp, #208]
+	ldp	x28, x30, [sp, #224]
+
+	add	sp, sp, #264
+	ldp	x29, x30, [sp], #16
+	eret
-- 
2.53.0.1213.gd9a14994de-goog

