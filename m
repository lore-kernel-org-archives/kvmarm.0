Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C6AC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EB0120702
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gzsokIdk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EB0120702
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98CE84B56A;
	Thu, 25 Jun 2020 09:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sm0CkqyrzlRJ; Thu, 25 Jun 2020 09:14:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA60C4B543;
	Thu, 25 Jun 2020 09:14:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D9D4B17A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mxfagTHFgytU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:46 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 580074B544
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:46 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id t194so5882477wmt.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=FysI03Mbz00ccZe6C8KeO6iOVfF/8a4Zq9mr/plU1m0=;
 b=gzsokIdkXF0LQJq3yFGYtBz5rajfd5uTAXzxxH7ONOzaCWKQ4xOwcogMDmZYPxx3vc
 hKLWCHvxmkB6+RaU/1r3m5yz7OwpA1+gF6BSdily3CoJB//lr0ykbfk1YlkHBKfX6b9U
 DW/DixS9A7KGJk+JjnSmCd11AeEc3IV6ybP2pna90OSwLJCQ6/fd2l2LvhG2nlPDhR3M
 WhAOFRemDMU8pMFYgVlOvxl2ZzrK5Yv5uXEg1uXu4RJbPrSspeSlSCpJhlcGDVeOHw0m
 zIVoUN+lQCm1LBfTJDtUl1mPrJliFvqHx5J+EbuPqDvUo3WzkzdllWGMql5gvaP7ZzYn
 Dd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=FysI03Mbz00ccZe6C8KeO6iOVfF/8a4Zq9mr/plU1m0=;
 b=X9dzT2ldXAhkeYQ8ncRVSz6CrREphyDH0pkyjXeBsJT8Yecku8gSOnpZsXbSXJzFom
 U7aDpTUvwtjeW58bXz97U5qmaPAJchGuQw1/BKr0Rll4GD7/ilFsJfFQ/J7TZzmcve66
 Zq667+t8Mcfpb2tP7kg7wyOk5zx6DKce14ni2uTDb7FZWLbrS0b5b+ESh19YoL+9ubI6
 ZBURUHLMa33ZrFmCmUnrzeiKZgRZNk7YwqgugDuWrrwow4Tk0FZ7ov+gUJarBWpocgTU
 Isj0h6cjq3rtJnEn9S6zKVAlnqazbOMqf4MYVBnyqQ/sfVMZ0GHpbJ3/4BOTaYTvzb85
 l5wQ==
X-Gm-Message-State: AOAM532YXisz3RTzj33HU+N9v6wExGpWEenElmJozsQpVjDP8rPSm1jq
 pS096NMrEcft3l/uqI5ykXVRYA==
X-Google-Smtp-Source: ABdhPJybJPtMER3eRIJNtY+OsMjz4SkdGXB3AjNsswmtMnHednb2PUNUFW2x0QPkTIYVhPcogTXVDA==
X-Received: by 2002:a7b:cf35:: with SMTP id m21mr3447544wmg.181.1593090885247; 
 Thu, 25 Jun 2020 06:14:45 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id x13sm33106232wre.83.2020.06.25.06.14.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:44 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 10/15] arm64: kvm: Split hyp/debug-sr.c to VHE/nVHE
Date: Thu, 25 Jun 2020 14:14:15 +0100
Message-Id: <20200625131420.71444-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

debug-sr.c contains KVM's code for context-switching debug registers, with some
code shared between VHE/nVHE. These common routines are moved to a header file,
VHE-specific code is moved to vhe/debug-sr.c and nVHE-specific code to
nvhe/debug-sr.c.

Functions are slightly refactored to move code hidden behind `has_vhe()` checks
to the corresponding .c files.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h                |  5 --
 arch/arm64/kvm/hyp/Makefile                   |  2 +-
 .../{debug-sr.c => include/hyp/debug-sr.h}    | 78 +++----------------
 arch/arm64/kvm/hyp/nvhe/Makefile              |  2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            | 77 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile               |  2 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c             | 26 +++++++
 7 files changed, 118 insertions(+), 74 deletions(-)
 rename arch/arm64/kvm/hyp/{debug-sr.c => include/hyp/debug-sr.h} (71%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/debug-sr.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 1ed219207ae3..663d5b70fa49 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -66,11 +66,6 @@ __efistub__ctype		= _ctype;
 /* Symbols defined in aarch32.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(kvm_skip_instr32);
 
-/* Symbols defined in debug-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__debug_switch_to_guest);
-KVM_NVHE_ALIAS(__debug_switch_to_host);
-KVM_NVHE_ALIAS(__kvm_get_mdcr_el2);
-
 /* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__guest_enter);
 KVM_NVHE_ALIAS(__guest_exit);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 7462d3a8a6f2..fc09025d2e97 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 debug-sr.o entry.o fpsimd.o
+	 entry.o fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
similarity index 71%
rename from arch/arm64/kvm/hyp/debug-sr.c
rename to arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index e95af204fec7..e041dbd23243 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -4,6 +4,9 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#ifndef __ARM64_KVM_HYP_DEBUG_SR_H__
+#define __ARM64_KVM_HYP_DEBUG_SR_H__
+
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
@@ -85,53 +88,9 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
-{
-	u64 reg;
-
-	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
-
-	/* SPE present on this CPU? */
-	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
-						  ID_AA64DFR0_PMSVER_SHIFT))
-		return;
-
-	/* Yes; is it owned by EL3? */
-	reg = read_sysreg_s(SYS_PMBIDR_EL1);
-	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
-		return;
-
-	/* No; is the host actually using the thing? */
-	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
-	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
-		return;
-
-	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
-	isb();
-
-	/* Now drain all buffered data to memory */
-	psb_csync();
-	dsb(nsh);
-}
-
-static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
-{
-	if (!pmscr_el1)
-		return;
-
-	/* The host page table is installed, but not yet synchronised */
-	isb();
-
-	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
-}
-
-static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-					  struct kvm_guest_debug_arch *dbg,
-					  struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
+						 struct kvm_guest_debug_arch *dbg,
+						 struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -148,9 +107,9 @@ static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
 }
 
-static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-					     struct kvm_guest_debug_arch *dbg,
-					     struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
+						    struct kvm_guest_debug_arch *dbg,
+						    struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -168,20 +127,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -194,16 +146,13 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -218,7 +167,4 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
-u32 __hyp_text __kvm_get_mdcr_el2(void)
-{
-	return read_sysreg(mdcr_el2);
-}
+#endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8b3ac38eaa44..b3cb67b63d67 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := switch.o tlb.o hyp-init.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
new file mode 100644
index 000000000000..828c0d48e790
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/debug-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/debug-monitors.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
+{
+	u64 reg;
+
+	/* Clear pmscr in case of early return */
+	*pmscr_el1 = 0;
+
+	/* SPE present on this CPU? */
+	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
+						  ID_AA64DFR0_PMSVER_SHIFT))
+		return;
+
+	/* Yes; is it owned by EL3? */
+	reg = read_sysreg_s(SYS_PMBIDR_EL1);
+	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
+		return;
+
+	/* No; is the host actually using the thing? */
+	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
+		return;
+
+	/* Yes; save the control register and disable data generation */
+	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
+	write_sysreg_s(0, SYS_PMSCR_EL1);
+	isb();
+
+	/* Now drain all buffered data to memory */
+	psb_csync();
+	dsb(nsh);
+}
+
+static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
+{
+	if (!pmscr_el1)
+		return;
+
+	/* The host page table is installed, but not yet synchronised */
+	isb();
+
+	/* Re-enable data generation */
+	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+}
+
+void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	/* Disable and flush SPE data generation */
+	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_switch_to_guest_common(vcpu);
+}
+
+void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_switch_to_host_common(vcpu);
+}
+
+u32 __hyp_text __kvm_get_mdcr_el2(void)
+{
+	return read_sysreg(mdcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 9f71cd3ba50d..62bdaf272b03 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := switch.o tlb.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
new file mode 100644
index 000000000000..f1e2e5a00933
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/debug-sr.h>
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	__debug_switch_to_guest_common(vcpu);
+}
+
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	__debug_switch_to_host_common(vcpu);
+}
+
+u32 __kvm_get_mdcr_el2(void)
+{
+	return read_sysreg(mdcr_el2);
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
