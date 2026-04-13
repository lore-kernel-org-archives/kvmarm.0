Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0907838F239
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113205; cv=none; b=TNeblx7SuqDGAs6Efa03h2y35/+8qYbStYB+iD3S4N0pNcgzmN1qILEscxvwzDV8yPHzIFbGX8ETemHjDQy5ghMHJsJONhnNrXyIyCfJohL3P0bpS/n5zauR/5RKIENTZxZ2UGMVuM94YwIkHuH9UckSUGhQWWcR4YCE9f8rHBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113205; c=relaxed/simple;
	bh=I+/cajPkLn4nNPOMKRMAQoR6cqCrwHrD8L73THmYyWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Szm/rIo7sBtHMcwDzYR99C8UtVSoaL5NjGC5nHx5FcNLE1m6NZmuCL8QW4rS+pO7roLEHVNoROJrdA5tBnHjuE+eY5a3X7DWqppp9dvIWVTFHl5/23uIRScoWB3BcchYK0Oy5bbYKKdB+0Gqo55Yvd3uPUFlYBtBs06Z+hBqkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbYRL2P7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbYRL2P7"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741b950511so2567119a12.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113202; x=1776718002; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qsVnqHQUTAoVaU1kPP0zp8iZeWdHzEzLLXQXpB1Fwdo=;
        b=IbYRL2P7WeD+9P2IPB2ZAlgen7+uXYhc4NpFUrD5yAv9+UngkbBaViow37+37ufbg0
         kICYepM3hZ/H3SzoT1LKlsx2tYdiEhA7m8Ut4KCIRb6RipLI4e5Hkuq9talnCL+uQKUk
         qKVmSd/Np+98U13i9Q31YchRdBJBRi9eOO5zgqAEriTTsNVe0I/YP8sH2CUMDB1I/X5N
         j3dP3GSe4tyYDmPfez8Kvy72izjbYOBFj7g333v+ksBFTMiFgLmAN0VYhsZ2Kc9dsSWG
         5GdJKB7Scgxt1GTQswX/i8mx9bkcJEVnfU/0aGhhQSKOYuysp1rMgyiV1KaH26Qtsjqy
         YKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113202; x=1776718002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsVnqHQUTAoVaU1kPP0zp8iZeWdHzEzLLXQXpB1Fwdo=;
        b=DaCf9FazcIhyujYccf92MZrjbaaXxhvWHhX+9ie/LC+Dcd/jbokZ1kiMA6Yumk6Jq9
         Bxgffsi9HLni2VvdOCp5tZISA4aifN1ZlmtRv1qXqdwp+5fATToj3WGxB/Kw9fvHnC0i
         T2rzjcphPhZv4borOSwhK4YIxdQEQTSem9BXQSdJxQ2eTvE6sDEMxkole+i5pz+04lXi
         Wm8Q4FNOEO4dpdWarasYc4ADeMKFtw9aWJ+1aApjMxOgDzrLzxcf4xTqfWpCbh1vXk/N
         cq8j2bcTXqodgvEfGk2w7idu14UuTISjWMRla39GFStZeCBNG52HmlzviFnPSTUYufa/
         d3Mg==
X-Forwarded-Encrypted: i=1; AFNElJ+hupJxYmnSAqbCJIY4rWR3L+vfzN1+D9jZ3mo9Fc6S8toDYhHxQpqUagRswacxUamA8OEvhso=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy0macv/6lj4LsYx2SSwSRr0JtiWKDnzwT8ch8h1O3asSfogVK
	OchLHFfk/Ujn/lSLYajHJpwmMnQ/mUK7cMfysbdUZCRvIOIqnZSaMuEIfFqtPnN+8c8oge5b4fq
	I6Y6TLA00HKpQo1TkShLXsPHahA==
X-Received: from pfgs39.prod.google.com ([2002:a05:6a00:17a7:b0:82c:e9cd:a73f])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3e05:b0:82f:37e3:ae72 with SMTP id d2e1a72fcca58-82f37e3b155mr6534611b3a.5.1776113202099;
 Mon, 13 Apr 2026 13:46:42 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:27 -0700
In-Reply-To: <20260413204630.1149038-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260413204630.1149038-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-5-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 4/7] lib: arm64: Add foundational guest
 execution framework
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce the infrastructure to manage and execute guest when running
at EL2. This provides the basis for testing advanced features like
nested virtualization and GICv4 direct interrupt injection.

The framework includes:
- 'struct guest': Encapsulates vCPU state (GPRs, EL1/EL2 sysregs) and
  Stage-2 MMU context.
- guest_create() / guest_destroy(): Handle lifecycle management and
  Stage-2 MMU setup, including identity mappings for guest code,
  stack, and UART.
- guest_run(): Assembly entry point that saves host callee-saved
  registers, caches the guest context pointer in TPIDR_EL2, and
  performs the exception return (ERET) to the guest.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arm/Makefile.arm64      |  2 +
 lib/arm64/asm-offsets.c | 13 ++++++
 lib/arm64/asm/guest.h   | 46 +++++++++++++++++++++
 lib/arm64/asm/sysreg.h  |  6 +++
 lib/arm64/guest.c       | 89 +++++++++++++++++++++++++++++++++++++++++
 lib/arm64/guest_arch.S  | 59 +++++++++++++++++++++++++++
 6 files changed, 215 insertions(+)
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/guest.c
 create mode 100644 lib/arm64/guest_arch.S

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 5e50f5ba..9026fd71 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -41,6 +41,8 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/stage2_mmu.o
+cflatobjs += lib/arm64/guest.o
+cflatobjs += lib/arm64/guest_arch.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index 80de023c..ceeecce5 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <kbuild.h>
 #include <asm/ptrace.h>
+#include <asm/guest.h>
 
 int main(void)
 {
@@ -30,5 +31,17 @@ int main(void)
 	DEFINE(S_FP, sizeof(struct pt_regs));
 	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
 
+	OFFSET(GUEST_X_OFFSET, guest, x);
+	OFFSET(GUEST_ELR_OFFSET, guest, elr_el2);
+	OFFSET(GUEST_SPSR_OFFSET, guest, spsr_el2);
+	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
+	OFFSET(GUEST_VTTBR_OFFSET, guest, vttbr_el2);
+	OFFSET(GUEST_SCTLR_OFFSET, guest, sctlr_el1);
+	OFFSET(GUEST_SP_EL1_OFFSET, guest, sp_el1);
+	OFFSET(GUEST_ESR_OFFSET, guest, esr_el2);
+	OFFSET(GUEST_FAR_OFFSET, guest, far_el2);
+	OFFSET(GUEST_HPFAR_OFFSET, guest, hpfar_el2);
+	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
+
 	return 0;
 }
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
new file mode 100644
index 00000000..826c44f8
--- /dev/null
+++ b/lib/arm64/asm/guest.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#ifndef _ASMARM64_GUEST_H_
+#define _ASMARM64_GUEST_H_
+
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/stage2_mmu.h>
+
+#define HCR_GUEST_FLAGS (HCR_EL2_VM | HCR_EL2_FMO | HCR_EL2_IMO | \
+			 HCR_EL2_AMO | HCR_EL2_RW | HCR_EL2_E2H)
+/* Guest stack size */
+#define GUEST_STACK_SIZE		SZ_64K
+
+struct guest {
+	/* General Purpose Registers */
+	unsigned long x[31]; /* x0..x30 */
+
+	/* Execution State */
+	unsigned long elr_el2;
+	unsigned long spsr_el2;
+
+	/* Control Registers */
+	unsigned long hcr_el2;
+	unsigned long vttbr_el2;
+	unsigned long sctlr_el1;
+	unsigned long sp_el1;
+
+	/* Exit Information */
+	unsigned long esr_el2;
+	unsigned long far_el2;
+	unsigned long hpfar_el2;
+	unsigned long exit_code;
+
+	struct s2_mmu *s2mmu;
+};
+
+struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule granule);
+void guest_destroy(struct guest *guest);
+void guest_run(struct guest *guest);
+
+#endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f2d05018..857bee98 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -118,6 +118,10 @@ asm(
 #define SCTLR_EL1_TCF0_SHIFT	38
 #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
 
+#define HCR_EL2_VM		_BITULL(0)
+#define HCR_EL2_FMO		_BITULL(3)
+#define HCR_EL2_IMO		_BITULL(4)
+#define HCR_EL2_AMO		_BITULL(5)
 #define HCR_EL2_TGE		_BITULL(27)
 #define HCR_EL2_RW		_BITULL(31)
 #define HCR_EL2_E2H		_BITULL(34)
@@ -132,6 +136,8 @@ asm(
 #define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
+#define SYS_SCTLR_EL1		sys_reg(3, 5, 1, 0, 0)
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
new file mode 100644
index 00000000..68dd449d
--- /dev/null
+++ b/lib/arm64/guest.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#include <libcflat.h>
+#include <asm/guest.h>
+#include <asm/io.h>
+#include <asm/sysreg.h>
+#include <asm/barrier.h>
+#include <alloc_page.h>
+#include <alloc.h>
+
+static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
+{
+	struct guest *guest = calloc(1, sizeof(struct guest));
+
+	guest->elr_el2 = (unsigned long)entry_point;
+	guest->spsr_el2 = 0x3C5; /* M=EL1h, DAIF=Masked */
+	guest->hcr_el2 = HCR_GUEST_FLAGS;
+
+	if (s2_ctx) {
+		guest->vttbr_el2 = virt_to_phys(s2_ctx->pgd);
+		guest->vttbr_el2 |= ((unsigned long)s2_ctx->vmid << 48);
+	} else {
+		printf("Stage 2 MMU context missing!");
+	}
+
+	guest->sctlr_el1 = read_sysreg(sctlr_el1);
+	/* Disable guest stage 1 translation */
+	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
+	guest->sctlr_el1 |= SCTLR_EL1_I;
+
+	guest->s2mmu = s2_ctx;
+
+	return guest;
+}
+
+struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule granule)
+{
+	unsigned long guest_pa, code_base, stack_pa;
+	unsigned long *stack_page;
+	struct guest *guest;
+	struct s2_mmu *ctx;
+
+	ctx = s2mmu_init(vmid, granule, true);
+	/*
+	 * Map the Host's code segment Identity Mapped (IPA=PA).
+	 * To be safe, we map a large chunk (e.g., 2MB) around the function
+	 * to capture any helper functions the compiler might generate calls to.
+	 */
+	guest_pa = virt_to_phys((void *)guest_func);
+	code_base = guest_pa & ~(SZ_2M - 1);
+	s2mmu_map(ctx, code_base, code_base, SZ_2M, S2_MAP_RW);
+
+	/*
+	 * Map Stack
+	 * Allocate 16 pages (64K) in Host, get its PA, and map it for Guest.
+	 */
+	stack_page = alloc_pages(get_order(GUEST_STACK_SIZE >> PAGE_SHIFT));
+	stack_pa = virt_to_phys(stack_page);
+	/* Identity Map it (IPA = PA) */
+	s2mmu_map(ctx, stack_pa, stack_pa, GUEST_STACK_SIZE, S2_MAP_RW);
+
+	s2mmu_enable(ctx);
+
+	/* Create Guest */
+	/* Entry point is the PA of the function (Identity Mapped) */
+	guest = __guest_create(ctx, (void *)guest_pa);
+
+	/*
+	 * Setup Guest Stack Pointer
+	 * Must match where we mapped the stack + Offset
+	 */
+	guest->sp_el1 = stack_pa + GUEST_STACK_SIZE;
+
+	/* Map UART identity mapped, printf() available to guest */
+	s2mmu_map(ctx, 0x09000000, 0x09000000, PAGE_SIZE, S2_MAP_DEVICE);
+
+	return guest;
+}
+
+void guest_destroy(struct guest *guest)
+{
+	s2mmu_disable(guest->s2mmu);
+	s2mmu_destroy(guest->s2mmu);
+	free(guest);
+}
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
new file mode 100644
index 00000000..70c19507
--- /dev/null
+++ b/lib/arm64/guest_arch.S
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#define __ASSEMBLY__
+#include <asm/asm-offsets.h>
+#include <asm/sysreg.h>
+
+.global guest_run
+guest_run:
+	/* x0 = struct guest pointer */
+
+	/* Save Host Callee-Saved Regs */
+	stp	x29, x30, [sp, #-16]!
+	stp	x27, x28, [sp, #-16]!
+	stp	x25, x26, [sp, #-16]!
+	stp	x23, x24, [sp, #-16]!
+	stp	x21, x22, [sp, #-16]!
+	stp	x19, x20, [sp, #-16]!
+
+	/* Cache Guest Pointer in TPIDR_EL2 */
+	msr	tpidr_el2, x0
+
+	/* Load Guest System Registers */
+	ldr	x1, [x0, #GUEST_ELR_OFFSET]
+	msr	elr_el2, x1
+	ldr	x1, [x0, #GUEST_SPSR_OFFSET]
+	msr	spsr_el2, x1
+	ldr	x1, [x0, #GUEST_HCR_OFFSET]
+	msr	hcr_el2, x1
+	ldr	x1, [x0, #GUEST_VTTBR_OFFSET]
+	msr	vttbr_el2, x1
+	ldr	x1, [x0, #GUEST_SCTLR_OFFSET]
+	msr_s	SYS_SCTLR_EL1, x1
+	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
+	msr	sp_el1, x1
+
+	/* Load Guest GPRs */
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
+
+	isb
+	eret
-- 
2.53.0.1213.gd9a14994de-goog

