Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF8CC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 45F4522409
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iL4lBR6i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45F4522409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D33B84B517;
	Mon, 26 Oct 2020 11:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BLLV1HBv0o8z; Mon, 26 Oct 2020 11:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEAB94B526;
	Mon, 26 Oct 2020 11:58:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7AF4B510
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 94GAb6cvHSYy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:58:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CBB74B4FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:50 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 649A222460;
 Mon, 26 Oct 2020 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603727929;
 bh=yDQVsmhj3qq3xAPhRhYREIlUfQEoVRADDVR15q9DisI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=iL4lBR6iwQhPuolIO31iwMRLkvSWWihVQ5iXF2bnv8zwsmRcbD5Cpvf8+x4eXeJ4X
 6qllU25NqMHXMpzr0vFuxnsBr6wMCdM5Si0b6kfEQdMWAK/Ve5UX9ZhUgN26S9gGcr
 uBPC6h0+s2TRwm2g/xddlG97hYwEOlM3Uq14ec4g=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/9] KVM: arm64: Move BP hardening helpers into spectre.h
Date: Mon, 26 Oct 2020 15:58:29 +0000
Message-Id: <20201026155833.24847-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026155833.24847-1-will@kernel.org>
References: <20201026155833.24847-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>
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

The BP hardening helpers are an integral part of the Spectre-v2
mitigation, so move them into asm/spectre.h and inline the
arm64_get_bp_hardening_data() function at the same time.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/mmu.h     | 29 -----------------------------
 arch/arm64/include/asm/spectre.h | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c             |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   |  1 +
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index b2e91c187e2a..75beffe2ee8a 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -12,9 +12,6 @@
 #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
-#define BP_HARDEN_EL2_SLOTS 4
-#define __BP_HARDEN_HYP_VECS_SZ (BP_HARDEN_EL2_SLOTS * SZ_2K)
-
 #ifndef __ASSEMBLY__
 
 #include <linux/refcount.h>
@@ -41,32 +38,6 @@ static inline bool arm64_kernel_unmapped_at_el0(void)
 	return cpus_have_const_cap(ARM64_UNMAP_KERNEL_AT_EL0);
 }
 
-typedef void (*bp_hardening_cb_t)(void);
-
-struct bp_hardening_data {
-	int			hyp_vectors_slot;
-	bp_hardening_cb_t	fn;
-};
-
-DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
-
-static inline struct bp_hardening_data *arm64_get_bp_hardening_data(void)
-{
-	return this_cpu_ptr(&bp_hardening_data);
-}
-
-static inline void arm64_apply_bp_hardening(void)
-{
-	struct bp_hardening_data *d;
-
-	if (!cpus_have_const_cap(ARM64_SPECTRE_V2))
-		return;
-
-	d = arm64_get_bp_hardening_data();
-	if (d->fn)
-		d->fn();
-}
-
 extern void arm64_memblock_init(void);
 extern void paging_init(void);
 extern void bootmem_init(void);
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index fcdfbce302bd..d22f8b7d9c50 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -9,7 +9,15 @@
 #ifndef __ASM_SPECTRE_H
 #define __ASM_SPECTRE_H
 
+#define BP_HARDEN_EL2_SLOTS 4
+#define __BP_HARDEN_HYP_VECS_SZ (BP_HARDEN_EL2_SLOTS * SZ_2K)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/percpu.h>
+
 #include <asm/cpufeature.h>
+#include <asm/virt.h>
 
 /* Watch out, ordering is important here. */
 enum mitigation_state {
@@ -20,6 +28,27 @@ enum mitigation_state {
 
 struct task_struct;
 
+typedef void (*bp_hardening_cb_t)(void);
+
+struct bp_hardening_data {
+	int			hyp_vectors_slot;
+	bp_hardening_cb_t	fn;
+};
+
+DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
+
+static inline void arm64_apply_bp_hardening(void)
+{
+	struct bp_hardening_data *d;
+
+	if (!cpus_have_const_cap(ARM64_SPECTRE_V2))
+		return;
+
+	d = this_cpu_ptr(&bp_hardening_data);
+	if (d->fn)
+		d->fn();
+}
+
 enum mitigation_state arm64_get_spectre_v2_state(void);
 bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
@@ -29,4 +58,5 @@ bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v4_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 void spectre_v4_enable_task_mitigation(struct task_struct *tsk);
 
+#endif	/* __ASSEMBLY__ */
 #endif	/* __ASM_SPECTRE_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 23abf02dd1e0..c5c2fd04679e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1386,7 +1386,7 @@ static void cpu_hyp_reset(void)
  */
 static void cpu_set_hyp_vector(void)
 {
-	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
+	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
 	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 	int slot = -1;
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 0a5b36eb54b3..874eacdabc64 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -13,6 +13,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/mmu.h>
+#include <asm/spectre.h>
 
 .macro save_caller_saved_regs_vect
 	/* x0 and x1 were saved in the vector entry */
-- 
2.29.0.rc2.309.g374f81d7ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
