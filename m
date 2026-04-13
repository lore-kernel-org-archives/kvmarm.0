Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30252DB7A3
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113206; cv=none; b=q1+DO3cfxACLlOuL+lCiwEVPD7CgbjxoRwy7FXHZCbMQbdfYoWgQAQANNSVaWxUj+vHyY30anFXjOSQme7xx+APHAtCC8oVQS2X+Avca0zl9VPshbkxYYTyOxROXtHEoCOWaD72ltWjrsGn1b2Z373ufi4JuwQdKgbKwgLw8K9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113206; c=relaxed/simple;
	bh=egE8h5G9RcCL/0q0/TPgnTl/B99ngwkmIy1cPwNVcr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZcdMqwjZ2SjODPeGBHDS1hnNPhnbiBmTSOsqqRo39QEVaN/5m6vQmLOhcDaZ30BCw5XxUwFDAArDGvQI1K4809y5yP6PVbaTnkvnUaYEnQivs76svy1EEEyf/mOiwJyxFl47UrZ2OnMuuFDvQK6ypyKwlHsVLfgE9lCCOkcnIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ebT4mfD7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebT4mfD7"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b249541063so44914855ad.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113204; x=1776718004; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCy7y9cRCPRGPHLP2huO2x6+VFSLwKAXTwsS9u/7e8M=;
        b=ebT4mfD7E0FsWS0vzEZMc0BAuVLfPcJhuKfwZ2OsIZTLaNOqFwVRvxAk90jblt4z79
         jMJ3XSBdSQ2cV5AQaUzCBMPmORjyrDc6BeG+HnsQPA3JOGZTuLFqI2sMmgHOHLi2MHeX
         fKBoB4ICDV+nkYYFrtw7YSMm+33knU3VGXBnuRhRHLuNgKgGK95rFyfe/tZDz+pzsA15
         6a6MqZ7tIX7+gx884snoCJBxL04tWzS+87lacclFWqyo07UdFEXff0LpX2gOI2YrsMxQ
         yRqdoK+KX3h3+Ssv4baTP9P8viXF+eihbhpTPZFKkZKUABlRMVUS2jiW3OMSK0/cwoIF
         go6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113204; x=1776718004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCy7y9cRCPRGPHLP2huO2x6+VFSLwKAXTwsS9u/7e8M=;
        b=VvclsKCcygwHd9tPSIhypRV9Xq69puvBd/xkKXXK25feT6z1VwsXhvd7961pkQr5tY
         N7HiQuGkKnPnWPaQUhRRrRjWUCwfiuiIOVeMvAgVgP4U2OaPOhRN6gzr7+6e3lCtvJbK
         4fVUOrI1tQZMUAM0tLLtDhn9+5Qp7atNTKeb/ykAJlTdwUL0iocCNtWcdBVsRoU5suD0
         ID46qLUIdrNi/9rneYM4DtXoSeyedNaocwuHt8ePZLu3NKvahI/bueyNzw6nQhuwFzHV
         6ywBa/3hXhNyPKuLp1FqvJG5ss/xGCw2+RuHOamGbyqxCUjoVaA6mA3v6yIoErhmK3GS
         cANQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Vk6Cewqwo3/3L03mdCu6RgdTmjy1p9wgpZsEyExEURCxpYZqbEMGowW/z33rxMAjP9VRUaQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq02dzMtiSbo2ILSpOkF1R2qSZ48f5Mgv6feiJFkcAr9TL2P+t
	pLc5o3HzVPqj5w/HkSV4Zhkwl0nKdquhE4fQNFp/l0+buPVzPdS1NxVW8dsCBiEfznWAsTUznJC
	wuHVUPQlRyZhME92wRzMmhaPBUQ==
X-Received: from pldp11.prod.google.com ([2002:a17:902:eacb:b0:2b0:5cd7:c89a])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3585:b0:2b2:539b:d2a0 with SMTP id d9443c01a7336-2b2d5a69ad6mr171628945ad.45.1776113204003;
 Mon, 13 Apr 2026 13:46:44 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:28 -0700
In-Reply-To: <20260413204630.1149038-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260413204630.1149038-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-6-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 5/7] lib: arm64: Add support for guest exit
 exception handling
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement the logic to intercept and handle exceptions from managed
guests at EL2. This completes the context switch loop by providing a
mechanism to save guest state, route exceptions to C handlers, and
either resume the guest or return to the host.

Key additions:
- 'guest_hyp_vectors': An EL2 vector table installed during guest
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
---
 lib/arm64/asm/guest.h  |  19 +++++++
 lib/arm64/guest.c      |  30 +++++++++++
 lib/arm64/guest_arch.S | 111 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)

diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
index 826c44f8..b99641ef 100644
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
@@ -36,6 +49,9 @@ struct guest {
 	unsigned long hpfar_el2;
 	unsigned long exit_code;
 
+	/* Exception Handlers in EL2 */
+	guest_handler_t handlers[VECTOR_MAX];
+
 	struct s2_mmu *s2mmu;
 };
 
@@ -43,4 +59,7 @@ struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule g
 void guest_destroy(struct guest *guest);
 void guest_run(struct guest *guest);
 
+unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset);
+void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler);
+
 #endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
index 68dd449d..dd42ccd6 100644
--- a/lib/arm64/guest.c
+++ b/lib/arm64/guest.c
@@ -12,6 +12,30 @@
 #include <alloc_page.h>
 #include <alloc.h>
 
+/*
+ * C-Entry for Exception Handling
+ * Returns 0 to Resume Guest, 1 to Exit to Host Caller
+ */
+unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset)
+{
+	enum vector vector = (enum vector)guest->exit_code;
+
+	/* Save Trap Info */
+	guest->esr_el2 = read_sysreg(esr_el2);
+	guest->far_el2 = read_sysreg(far_el2);
+	guest->hpfar_el2 = read_sysreg(hpfar_el2);
+
+	/* Invoke Handler if registered */
+	if (guest->handlers[vector]) {
+		if (guest->handlers[vector](guest) == GUEST_ACTION_RESUME) {
+			return 0; /* ASM stub will restore and ERET */
+		}
+	}
+
+	/* Default: Exit to caller */
+	return 1;
+}
+
 static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
 {
 	struct guest *guest = calloc(1, sizeof(struct guest));
@@ -87,3 +111,9 @@ void guest_destroy(struct guest *guest)
 	s2mmu_destroy(guest->s2mmu);
 	free(guest);
 }
+
+void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler)
+{
+	if (v < VECTOR_MAX)
+		guest->handlers[v] = handler;
+}
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
index 70c19507..81874fd0 100644
--- a/lib/arm64/guest_arch.S
+++ b/lib/arm64/guest_arch.S
@@ -55,5 +55,116 @@ guest_run:
 	ldp	x29, x30, [x0, #232]
 	ldr	x0, [x0, #0]
 
+	/* Install Trap Handler */
+	adrp	x29, hyp_el2_vectors
+	add	x29, x29, :lo12:hyp_el2_vectors
+	msr	vbar_el2, x29
+
+	/* Restore x29 from struct (via tpidr_el2) */
+	mrs	x29, tpidr_el2
+	ldr	x29, [x29, #232]
+
 	isb
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
+	stp	x2, x3, [x0, #16]
+	stp	x4, x5, [x0, #32]
+	stp	x6, x7, [x0, #48]
+	stp	x8, x9, [x0, #64]
+	stp	x10, x11, [x0, #80]
+	stp	x12, x13, [x0, #96]
+	stp	x14, x15, [x0, #112]
+	stp	x16, x17, [x0, #128]
+	stp	x18, x19, [x0, #144]
+	stp	x20, x21, [x0, #160]
+	stp	x22, x23, [x0, #176]
+	stp	x24, x25, [x0, #192]
+	stp	x26, x27, [x0, #208]
+	stp	x28, x29, [x0, #224]
+	str	x30, [x0, #240]
+
+	ldp	x2, x3, [sp], #16
+	stp	x2, x3, [x0, #0]
+
+	mrs	x1, elr_el2
+	str	x1, [x0, #GUEST_ELR_OFFSET]
+	mrs	x1, spsr_el2
+	str	x1, [x0, #GUEST_SPSR_OFFSET]
+	mrs	x1, esr_el2
+	str	x1, [x0, #GUEST_ESR_OFFSET]
+	mrs	x1, far_el2
+	str	x1, [x0, #GUEST_FAR_OFFSET]
+	mrs	x1, hpfar_el2
+	str	x1, [x0, #GUEST_HPFAR_OFFSET]
+	mrs	x1, sp_el1
+	str	x1, [x0, #GUEST_SP_EL1_OFFSET]
+
+	/* x29 contains vector offset from entry */
+	mov	x1, x29
+	bl	guest_c_exception_handler
+	cbz	x0, guest_resume_guest
+
+	/* EXIT */
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
+	ldr	x1, [x0, #GUEST_ELR_OFFSET]
+	msr	elr_el2, x1
+	ldr	x1, [x0, #GUEST_SPSR_OFFSET]
+	msr	spsr_el2, x1
+	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
+	msr	sp_el1, x1
+
+	ldp	x1, x2, [x0, #8]
+	ldp	x3, x4, [x0, #24]
+	ldp	x5, x6, [x0, #40]
+	ldp	x7, x8, [x0, #56]
+	ldp	x9, x10, [x0, #72]
+	ldp	x11, x12, [x0, #88]
+	ldp	x13, x14, [x0, #104]
+	ldp	x15, x16, [x0, #120]
+	ldp	x17, x18, [x0, #136]
+	ldp	x19, x20, [x0, #152]
+	ldp	x21, x22, [x0, #168]
+	ldp	x23, x24, [x0, #184]
+	ldp	x25, x26, [x0, #200]
+	ldp	x27, x28, [x0, #216]
+	ldp	x29, x30, [x0, #232]
+	ldr	x0, [x0, #0]
+	eret
-- 
2.53.0.1213.gd9a14994de-goog

