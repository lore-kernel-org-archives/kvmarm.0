Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F0EC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:55:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21BCE22242
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7HKJnki"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21BCE22242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFA94B1F6;
	Mon, 26 Oct 2020 09:55:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4jDgPSWEWAQr; Mon, 26 Oct 2020 09:55:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0215A4B227;
	Mon, 26 Oct 2020 09:55:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F324B1F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:55:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aQkbtxCQjrQ6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:55:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF45D4B1EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:55:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B93AF2463C;
 Mon, 26 Oct 2020 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603720518;
 bh=s6oF//VCZ95zVu0SM4huHksEJ3I/ZTsaCcQ8Wgm8yQE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=j7HKJnkiFXGqfEjoNBw3z8cW/ngb/s+PRoJ97zH/VJKVBJzsTL7xCyPoyevN069r4
 KpdFmKm2nqIkVIGgZQH6AXZOpMb6iw6fvP9tlyWkVXmzhJBiDabd4LQpz9tAFPDY5n
 4XkwD6CjjjIExqgqOuucz4AGRuPljYNUkbDq8Ru4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kX2eT-004Kjh-Ap; Mon, 26 Oct 2020 13:35:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 10/11] KVM: arm64: Consolidate exception injection
Date: Mon, 26 Oct 2020 13:34:49 +0000
Message-Id: <20201026133450.73304-11-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

Move the AArch32 exception injection code back into the inject_fault.c
file, removing the need for a few non-static functions now that AArch32
host support is a thing of the past.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  3 -
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/aarch32.c             | 95 ----------------------------
 arch/arm64/kvm/inject_fault.c        | 75 +++++++++++++++++++++-
 4 files changed, 73 insertions(+), 102 deletions(-)
 delete mode 100644 arch/arm64/kvm/aarch32.c

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5d957d0e7b69..3105bb73f539 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -42,9 +42,6 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
-void kvm_inject_undef32(struct kvm_vcpu *vcpu);
-void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
-void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1504c81fbf5d..9b32a89a25c8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 inject_fault.o regmap.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
-	 aarch32.o arch_timer.o \
+	 arch_timer.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
deleted file mode 100644
index ad453b47c517..000000000000
--- a/arch/arm64/kvm/aarch32.c
+++ /dev/null
@@ -1,95 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (not much of an) Emulation layer for 32bit guests.
- *
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * based on arch/arm/kvm/emulate.c
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- */
-
-#include <linux/bits.h>
-#include <linux/kvm_host.h>
-#include <asm/kvm_emulate.h>
-#include <asm/kvm_hyp.h>
-
-#define DFSR_FSC_EXTABT_LPAE	0x10
-#define DFSR_FSC_EXTABT_nLPAE	0x08
-#define DFSR_LPAE		BIT(9)
-
-static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
-{
-	preempt_disable();
-	if (vcpu->arch.sysregs_loaded_on_cpu) {
-		kvm_arch_vcpu_put(vcpu);
-		return true;
-	}
-
-	preempt_enable();
-	return false;
-}
-
-static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
-{
-	if (loaded) {
-		kvm_arch_vcpu_load(vcpu, smp_processor_id());
-		preempt_enable();
-	}
-}
-
-void kvm_inject_undef32(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_UND |
-			     KVM_ARM64_PENDING_EXCEPTION);
-}
-
-/*
- * Modelled after TakeDataAbortException() and TakePrefetchAbortException
- * pseudocode.
- */
-static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
-			 unsigned long addr)
-{
-	u32 *far, *fsr;
-	bool is_lpae;
-	bool loaded;
-
-	loaded = pre_fault_synchronize(vcpu);
-
-	if (is_pabt) {
-		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
-				     KVM_ARM64_PENDING_EXCEPTION);
-		far = &vcpu_cp15(vcpu, c6_IFAR);
-		fsr = &vcpu_cp15(vcpu, c5_IFSR);
-	} else { /* !iabt */
-		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
-				     KVM_ARM64_PENDING_EXCEPTION);
-		far = &vcpu_cp15(vcpu, c6_DFAR);
-		fsr = &vcpu_cp15(vcpu, c5_DFSR);
-	}
-
-	*far = addr;
-
-	/* Give the guest an IMPLEMENTATION DEFINED exception */
-	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
-	if (is_lpae) {
-		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
-	} else {
-		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
-		*fsr = DFSR_FSC_EXTABT_nLPAE;
-	}
-
-	post_fault_synchronize(vcpu, loaded);
-}
-
-void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)
-{
-	inject_abt32(vcpu, false, addr);
-}
-
-void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr)
-{
-	inject_abt32(vcpu, true, addr);
-}
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 7a1b5ccb1363..5e64246a6b6e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -64,6 +64,75 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
 }
 
+#define DFSR_FSC_EXTABT_LPAE	0x10
+#define DFSR_FSC_EXTABT_nLPAE	0x08
+#define DFSR_LPAE		BIT(9)
+
+static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		kvm_arch_vcpu_put(vcpu);
+		return true;
+	}
+
+	preempt_enable();
+	return false;
+}
+
+static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
+{
+	if (loaded) {
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		preempt_enable();
+	}
+}
+
+static void inject_undef32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_UND |
+			     KVM_ARM64_PENDING_EXCEPTION);
+}
+
+/*
+ * Modelled after TakeDataAbortException() and TakePrefetchAbortException
+ * pseudocode.
+ */
+static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
+			 unsigned long addr)
+{
+	u32 *far, *fsr;
+	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);
+
+	if (is_pabt) {
+		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
+				     KVM_ARM64_PENDING_EXCEPTION);
+		far = &vcpu_cp15(vcpu, c6_IFAR);
+		fsr = &vcpu_cp15(vcpu, c5_IFSR);
+	} else { /* !iabt */
+		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
+				     KVM_ARM64_PENDING_EXCEPTION);
+		far = &vcpu_cp15(vcpu, c6_DFAR);
+		fsr = &vcpu_cp15(vcpu, c5_DFSR);
+	}
+
+	*far = addr;
+
+	/* Give the guest an IMPLEMENTATION DEFINED exception */
+	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
+	if (is_lpae) {
+		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
+	} else {
+		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
+		*fsr = DFSR_FSC_EXTABT_nLPAE;
+	}
+
+	post_fault_synchronize(vcpu, loaded);
+}
+
 /**
  * kvm_inject_dabt - inject a data abort into the guest
  * @vcpu: The VCPU to receive the data abort
@@ -75,7 +144,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	if (vcpu_el1_is_32bit(vcpu))
-		kvm_inject_dabt32(vcpu, addr);
+		inject_abt32(vcpu, false, addr);
 	else
 		inject_abt64(vcpu, false, addr);
 }
@@ -91,7 +160,7 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	if (vcpu_el1_is_32bit(vcpu))
-		kvm_inject_pabt32(vcpu, addr);
+		inject_abt32(vcpu, true, addr);
 	else
 		inject_abt64(vcpu, true, addr);
 }
@@ -106,7 +175,7 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_el1_is_32bit(vcpu))
-		kvm_inject_undef32(vcpu);
+		inject_undef32(vcpu);
 	else
 		inject_undef64(vcpu);
 }
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
