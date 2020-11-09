Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56304C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB5DF20809
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbDMp3L5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB5DF20809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4FA4BA29;
	Mon,  9 Nov 2020 16:48:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RkOjXf4MX+c7; Mon,  9 Nov 2020 16:47:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 389454BA62;
	Mon,  9 Nov 2020 16:47:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F02A4BA48
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HLNHrliEPCBV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 16:47:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D3E64BA36
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:56 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 198D020809;
 Mon,  9 Nov 2020 21:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604958475;
 bh=eBqeS9hvXYIsmL9ITilVkeXYS6Ayz+yTHXO3HZO5FG4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=JbDMp3L57Ua4P5RFeWlBNUYyMuoJZtqrICiQB79m/bttjMb6/KRnpFyVdJu5+iIQJ
 ZCIgKThsxtMjRY7qKOoxY1oWF9rRwuOIgm8rv1skR1IFnMFF6uRk5MPDcuokrbRjuq
 9EMv0ta36D9JAT/V4+emgwvkZd1WwnaJA6WppyHs=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 7/9] KVM: arm64: Allocate hyp vectors statically
Date: Mon,  9 Nov 2020 21:47:24 +0000
Message-Id: <20201109214726.15276-8-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109214726.15276-1-will@kernel.org>
References: <20201109214726.15276-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
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

The EL2 vectors installed when a guest is running point at one of the
following configurations for a given CPU:

  - Straight at __kvm_hyp_vector
  - A trampoline containing an SMC sequence to mitigate Spectre-v2 and
    then a direct branch to __kvm_hyp_vector
  - A dynamically-allocated trampoline which has an indirect branch to
    __kvm_hyp_vector
  - A dynamically-allocated trampoline containing an SMC sequence to
    mitigate Spectre-v2 and then an indirect branch to __kvm_hyp_vector

The indirect branches mean that VA randomization at EL2 isn't trivially
bypassable using Spectre-v3a (where the vector base is readable by the
guest).

Rather than populate these vectors dynamically, configure everything
statically and use an enumerated type to identify the vector "slot"
corresponding to one of the configurations above. This both simplifies
the code, but also makes it much easier to implement at EL2 later on.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  5 ---
 arch/arm64/include/asm/spectre.h | 36 ++++++++++++++-
 arch/arm64/kernel/cpu_errata.c   |  2 +
 arch/arm64/kernel/proton-pack.c  | 63 ++++++--------------------
 arch/arm64/kvm/arm.c             | 76 ++++++++++++--------------------
 arch/arm64/kvm/hyp/Makefile      |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 72 +++++++++++++++++-------------
 arch/arm64/kvm/hyp/smccc_wa.S    | 32 --------------
 arch/arm64/kvm/va_layout.c       | 16 +------
 9 files changed, 120 insertions(+), 184 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/smccc_wa.S

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 54387ccd1ab2..94b7c9a99576 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -34,8 +34,6 @@
  */
 #define KVM_VECTOR_PREAMBLE	(2 * AARCH64_INSN_SIZE)
 
-#define __SMCCC_WORKAROUND_1_SMC_SZ 36
-
 #define KVM_HOST_SMCCC_ID(id)						\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_64,				\
@@ -175,7 +173,6 @@ extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
 DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 
-extern atomic_t arm64_el2_vector_last_slot;
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
@@ -198,8 +195,6 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
-
 /*
  * Obtain the PC-relative address of a kernel symbol
  * s: symbol
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index d22f8b7d9c50..fa86b8f655b7 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -28,11 +28,41 @@ enum mitigation_state {
 
 struct task_struct;
 
+/*
+ * Note: the order of this enum corresponds to __bp_harden_hyp_vecs and
+ * we rely on having the direct vectors first.
+ */
+enum arm64_hyp_spectre_vector {
+	/*
+	 * Take exceptions directly to __kvm_hyp_vector. This must be
+	 * 0 so that it used by default when mitigations are not needed.
+	 */
+	HYP_VECTOR_DIRECT,
+
+	/*
+	 * Bounce via a slot in the hypervisor text mapping of
+	 * __bp_harden_hyp_vecs, which contains an SMC call.
+	 */
+	HYP_VECTOR_SPECTRE_DIRECT,
+
+	/*
+	 * Bounce via a slot in a special mapping of __bp_harden_hyp_vecs
+	 * next to the idmap page.
+	 */
+	HYP_VECTOR_INDIRECT,
+
+	/*
+	 * Bounce via a slot in a special mapping of __bp_harden_hyp_vecs
+	 * next to the idmap page, which contains an SMC call.
+	 */
+	HYP_VECTOR_SPECTRE_INDIRECT,
+};
+
 typedef void (*bp_hardening_cb_t)(void);
 
 struct bp_hardening_data {
-	int			hyp_vectors_slot;
-	bp_hardening_cb_t	fn;
+	enum arm64_hyp_spectre_vector	slot;
+	bp_hardening_cb_t		fn;
 };
 
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
@@ -53,6 +83,8 @@ enum mitigation_state arm64_get_spectre_v2_state(void);
 bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
+void cpu_el2_vector_harden_enable(const struct arm64_cpu_capabilities *__unused);
+
 enum mitigation_state arm64_get_spectre_v4_state(void);
 bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v4_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 61314fd70f13..7a040abaedea 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -459,9 +459,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	},
 #ifdef CONFIG_RANDOMIZE_BASE
 	{
+	/* Must come after the Spectre-v2 entry */
 		.desc = "EL2 vector hardening",
 		.capability = ARM64_HARDEN_EL2_VECTORS,
 		ERRATA_MIDR_RANGE_LIST(ca57_a72),
+		.cpu_enable = cpu_el2_vector_harden_enable,
 	},
 #endif
 	{
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index c18eb7d41274..a4ba94129750 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -26,6 +26,7 @@
 
 #include <asm/spectre.h>
 #include <asm/traps.h>
+#include <asm/virt.h>
 
 /*
  * We try to ensure that the mitigation state can never change as the result of
@@ -169,72 +170,26 @@ bool has_spectre_v2(const struct arm64_cpu_capabilities *entry, int scope)
 	return true;
 }
 
-DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
-
 enum mitigation_state arm64_get_spectre_v2_state(void)
 {
 	return spectre_v2_state;
 }
 
-#ifdef CONFIG_KVM
-#include <asm/cacheflush.h>
-#include <asm/kvm_asm.h>
-
-atomic_t arm64_el2_vector_last_slot = ATOMIC_INIT(-1);
-
-static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
-				const char *hyp_vecs_end)
-{
-	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
-	int i;
-
-	for (i = 0; i < SZ_2K; i += 0x80)
-		memcpy(dst + i, hyp_vecs_start, hyp_vecs_end - hyp_vecs_start);
-
-	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
-}
+DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 static void install_bp_hardening_cb(bp_hardening_cb_t fn)
 {
-	static DEFINE_RAW_SPINLOCK(bp_lock);
-	int cpu, slot = -1;
-	const char *hyp_vecs_start = __smccc_workaround_1_smc;
-	const char *hyp_vecs_end = __smccc_workaround_1_smc +
-				   __SMCCC_WORKAROUND_1_SMC_SZ;
+	__this_cpu_write(bp_hardening_data.fn, fn);
 
 	/*
 	 * Vinz Clortho takes the hyp_vecs start/end "keys" at
 	 * the door when we're a guest. Skip the hyp-vectors work.
 	 */
-	if (!is_hyp_mode_available()) {
-		__this_cpu_write(bp_hardening_data.fn, fn);
+	if (!is_hyp_mode_available())
 		return;
-	}
 
-	raw_spin_lock(&bp_lock);
-	for_each_possible_cpu(cpu) {
-		if (per_cpu(bp_hardening_data.fn, cpu) == fn) {
-			slot = per_cpu(bp_hardening_data.hyp_vectors_slot, cpu);
-			break;
-		}
-	}
-
-	if (slot == -1) {
-		slot = atomic_inc_return(&arm64_el2_vector_last_slot);
-		BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
-		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
-	}
-
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.fn, fn);
-	raw_spin_unlock(&bp_lock);
+	__this_cpu_write(bp_hardening_data.slot, HYP_VECTOR_SPECTRE_DIRECT);
 }
-#else
-static void install_bp_hardening_cb(bp_hardening_cb_t fn)
-{
-	__this_cpu_write(bp_hardening_data.fn, fn);
-}
-#endif	/* CONFIG_KVM */
 
 static void call_smc_arch_workaround_1(void)
 {
@@ -315,6 +270,14 @@ void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
 	update_mitigation_state(&spectre_v2_state, state);
 }
 
+void cpu_el2_vector_harden_enable(const struct arm64_cpu_capabilities *__unused)
+{
+	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
+
+	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS))
+		data->slot += HYP_VECTOR_INDIRECT;
+}
+
 /*
  * Spectre v4.
  *
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 044c5fc81f90..ec6dce70c611 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,14 +51,6 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 
-/* Hypervisor VA of the indirect vector trampoline page */
-static void *__kvm_bp_vect_base;
-/*
- * Slot in the hyp vector page for use by the indirect vector trampoline
- * when mitigation against Spectre-v2 is not required.
- */
-static int __kvm_harden_el2_vector_slot;
-
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
@@ -1303,33 +1295,36 @@ static unsigned long nvhe_percpu_order(void)
 	return size ? get_order(size) : 0;
 }
 
-static int kvm_map_vectors(void)
+/* A lookup table holding the hypervisor VA for each vector slot */
+static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
+
+static void kvm_init_vector_slot(void *base, enum arm64_hyp_spectre_vector slot)
 {
-	int slot;
+	hyp_spectre_vector_selector[slot] = base + (slot * SZ_2K);
+}
+
+static int kvm_init_vector_slots(void)
+{
+	int err;
+	void *base;
+
+	base = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
+	kvm_init_vector_slot(base, HYP_VECTOR_DIRECT);
+
+	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
+	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	/*
-	 * SV2  = ARM64_SPECTRE_V2
-	 * HEL2 = ARM64_HARDEN_EL2_VECTORS
-	 *
-	 * !SV2 + !HEL2 -> use direct vectors
-	 *  SV2 + !HEL2 -> use hardened vectors in place
-	 * !SV2 +  HEL2 -> allocate one vector slot and use exec mapping
-	 *  SV2 +  HEL2 -> use hardened vectors and use exec mapping
-	 */
 	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS))
 		return 0;
 
-	/*
-	 * Always allocate a spare vector slot, as we don't know yet which CPUs
-	 * have a BP hardening slot that we can reuse.
-	 */
-	slot = atomic_inc_return(&arm64_el2_vector_last_slot);
-	BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
-	__kvm_harden_el2_vector_slot = slot;
+	err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
+				       __BP_HARDEN_HYP_VECS_SZ, &base);
+	if (err)
+		return err;
 
-	return create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
-					__BP_HARDEN_HYP_VECS_SZ,
-					&__kvm_bp_vect_base);
+	kvm_init_vector_slot(base, HYP_VECTOR_INDIRECT);
+	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_INDIRECT);
+	return 0;
 }
 
 static void cpu_init_hyp_mode(void)
@@ -1406,24 +1401,9 @@ static void cpu_hyp_reset(void)
 static void cpu_set_hyp_vector(void)
 {
 	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
-	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
-	int slot = -1;
-
-	if (cpus_have_const_cap(ARM64_SPECTRE_V2) && data->fn) {
-		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
-		slot = data->hyp_vectors_slot;
-	}
-
-	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS) && !has_vhe()) {
-		vect = __kvm_bp_vect_base;
-		if (slot == -1)
-			slot = __kvm_harden_el2_vector_slot;
-	}
-
-	if (slot != -1)
-		vect += slot * SZ_2K;
+	void *vector = hyp_spectre_vector_selector[data->slot];
 
-	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vect;
+	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
 }
 
 static void cpu_hyp_reinit(void)
@@ -1661,9 +1641,9 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
-	err = kvm_map_vectors();
+	err = kvm_init_vector_slots();
 	if (err) {
-		kvm_err("Cannot map vectors\n");
+		kvm_err("Cannot initialise vector slots\n");
 		goto out_err;
 	}
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 4a81eddabcd8..687598e41b21 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,4 +10,4 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o smccc_wa.o
+obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 874eacdabc64..f5e126e82db2 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -188,52 +188,62 @@ SYM_CODE_START(__kvm_hyp_vector)
 	valid_vect	el1_error		// Error 32-bit EL1
 SYM_CODE_END(__kvm_hyp_vector)
 
-.macro hyp_ventry
-	.align 7
+.macro spectrev2_smccc_wa1_smc
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
+	smc	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	add	sp, sp, #(8 * 2)
+.endm
+
+.macro hyp_ventry	indirect, spectrev2
+	.align	7
 1:	esb
-	.rept 26
-	nop
-	.endr
-/*
- * The default sequence is to directly branch to the KVM vectors,
- * using the computed offset. This applies for VHE as well as
- * !ARM64_HARDEN_EL2_VECTORS. The first vector must always run the preamble.
- *
- * For ARM64_HARDEN_EL2_VECTORS configurations, this gets replaced
- * with:
- *
- * stp	x0, x1, [sp, #-16]!
- * movz	x0, #(addr & 0xffff)
- * movk	x0, #((addr >> 16) & 0xffff), lsl #16
- * movk	x0, #((addr >> 32) & 0xffff), lsl #32
- * br	x0
- *
- * Where:
- * addr = kern_hyp_va(__kvm_hyp_vector) + vector-offset + KVM_VECTOR_PREAMBLE.
- * See kvm_patch_vector_branch for details.
- */
-alternative_cb	kvm_patch_vector_branch
+	.if \spectrev2 != 0
+	spectrev2_smccc_wa1_smc
+	.else
 	stp	x0, x1, [sp, #-16]!
-	b	__kvm_hyp_vector + (1b - 0b + KVM_VECTOR_PREAMBLE)
+	.endif
+	.if \indirect != 0
+	alternative_cb  kvm_patch_vector_branch
+	/*
+	 * For ARM64_HARDEN_EL2_VECTORS configurations, these NOPs get replaced
+	 * with:
+	 *
+	 * movz	x0, #(addr & 0xffff)
+	 * movk	x0, #((addr >> 16) & 0xffff), lsl #16
+	 * movk	x0, #((addr >> 32) & 0xffff), lsl #32
+	 *
+	 * Where:
+	 * addr = kern_hyp_va(__kvm_hyp_vector) + vector-offset + KVM_VECTOR_PREAMBLE.
+	 * See kvm_patch_vector_branch for details.
+	 */
 	nop
 	nop
 	nop
-alternative_cb_end
+	alternative_cb_end
+	br	x0
+	.else
+	b	__kvm_hyp_vector + (1b - 0b + KVM_VECTOR_PREAMBLE)
+	.endif
 .endm
 
-.macro generate_vectors
+.macro generate_vectors	indirect, spectrev2
 0:
 	.rept 16
-	hyp_ventry
+	hyp_ventry	\indirect, \spectrev2
 	.endr
 	.org 0b + SZ_2K		// Safety measure
 .endm
 
 	.align	11
 SYM_CODE_START(__bp_harden_hyp_vecs)
-	.rept BP_HARDEN_EL2_SLOTS
-	generate_vectors
-	.endr
+	generate_vectors indirect = 0, spectrev2 = 0 // HYP_VECTOR_DIRECT
+	generate_vectors indirect = 0, spectrev2 = 1 // HYP_VECTOR_SPECTRE_DIRECT
+	generate_vectors indirect = 1, spectrev2 = 0 // HYP_VECTOR_INDIRECT
+	generate_vectors indirect = 1, spectrev2 = 1 // HYP_VECTOR_SPECTRE_INDIRECT
 1:	.org __bp_harden_hyp_vecs + __BP_HARDEN_HYP_VECS_SZ
 	.org 1b
 SYM_CODE_END(__bp_harden_hyp_vecs)
diff --git a/arch/arm64/kvm/hyp/smccc_wa.S b/arch/arm64/kvm/hyp/smccc_wa.S
deleted file mode 100644
index b0441dbdf68b..000000000000
--- a/arch/arm64/kvm/hyp/smccc_wa.S
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2015-2018 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- */
-
-#include <linux/arm-smccc.h>
-#include <linux/linkage.h>
-
-#include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-
-	/*
-	 * This is not executed directly and is instead copied into the vectors
-	 * by install_bp_hardening_cb().
-	 */
-	.data
-	.pushsection	.rodata
-	.global		__smccc_workaround_1_smc
-SYM_DATA_START(__smccc_workaround_1_smc)
-	esb
-	sub	sp, sp, #(8 * 4)
-	stp	x2, x3, [sp, #(8 * 0)]
-	stp	x0, x1, [sp, #(8 * 2)]
-	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
-	smc	#0
-	ldp	x2, x3, [sp, #(8 * 0)]
-	ldp	x0, x1, [sp, #(8 * 2)]
-	add	sp, sp, #(8 * 4)
-1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
-	.org 1b
-SYM_DATA_END(__smccc_workaround_1_smc)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 760db2c84b9b..1ae327006815 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -137,7 +137,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	u64 addr;
 	u32 insn;
 
-	BUG_ON(nr_inst != 5);
+	BUG_ON(nr_inst != 3);
 
 	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) ||
 	    WARN_ON_ONCE(has_vhe())) {
@@ -160,15 +160,6 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	 */
 	addr += KVM_VECTOR_PREAMBLE;
 
-	/* stp x0, x1, [sp, #-16]! */
-	insn = aarch64_insn_gen_load_store_pair(AARCH64_INSN_REG_0,
-						AARCH64_INSN_REG_1,
-						AARCH64_INSN_REG_SP,
-						-16,
-						AARCH64_INSN_VARIANT_64BIT,
-						AARCH64_INSN_LDST_STORE_PAIR_PRE_INDEX);
-	*updptr++ = cpu_to_le32(insn);
-
 	/* movz x0, #(addr & 0xffff) */
 	insn = aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
 					 (u16)addr,
@@ -192,9 +183,4 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 					 AARCH64_INSN_VARIANT_64BIT,
 					 AARCH64_INSN_MOVEWIDE_KEEP);
 	*updptr++ = cpu_to_le32(insn);
-
-	/* br x0 */
-	insn = aarch64_insn_gen_branch_reg(AARCH64_INSN_REG_0,
-					   AARCH64_INSN_BRANCH_NOLINK);
-	*updptr++ = cpu_to_le32(insn);
 }
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
