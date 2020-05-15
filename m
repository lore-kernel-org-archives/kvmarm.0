Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D909C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 390AB20709
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="epUHLrxn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 390AB20709
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC604B4DF;
	Fri, 15 May 2020 06:59:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ok36eVz0Kbrr; Fri, 15 May 2020 06:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E474B505;
	Fri, 15 May 2020 06:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 156914B4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l14N0t8xLNaJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:59:24 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D47F4B4FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:11 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id l11so3077689wru.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=BE9nyaoIVsy0Uu4Bb4/XGauSOljVERYPioc3Z6j5llE=;
 b=epUHLrxnN08kuUW6lif5uKugTZk0Ai/VIfR4EIYIQfNJJN0K9msHRKQ5i60Zenqicr
 xqvAr4WMl3pGig+CWO/4afBDyGepV/MGYpXKmvVJNgdCFhqfse3d5oT+J5mlRf+kJCJU
 p2PM4DVDBaLNqC4mxZj9Y9gK5ykdV+ABfXYC1QkdGJF4oco8afENi2mSJ8dVZMfW+Ol1
 VYZQLbSoBQXKYw+ki8ENVNTdphn30KsIwFA9bzoEYwvE6jUstNNykLIedsL4UfeCCvDn
 rhra3aSnv852lvTVZd6cxokJNXLSnfDdTxF+aKBsMoX89UtaSXHn6/aZ7R2aJUeDqSML
 7c8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=BE9nyaoIVsy0Uu4Bb4/XGauSOljVERYPioc3Z6j5llE=;
 b=hVWdBERO+c9EqzWGKD/bjh60gmNwElQec3chxAjk5t46QAel4TVoVMJMoZxDZrC9hN
 YFEscfuxA49QIANr3rVVjom9OykgExRJHbIW6hzOyqXuRiJqN2Gk6NiJu3gGvlDVx95z
 IGTJwb4PlIOcDf+Ja8MB7te751FChRx0yg8CMg15Z2+gsSXWZZBfBMDSozV0F6ghmKDg
 Gb2SM8wXNGaq1Zmy66bVRw72wkp7wxmMQ2qmuHPgh9Wrekvw4Y/6HBS3P+5T4Ra3mw9H
 +QDTOixx/xQKSgaVEEEOHEm5lGwjdbzN6P6Swo3ZhZ6xAHLz++cwl1eXgVoapjmJveQJ
 a8nA==
X-Gm-Message-State: AOAM531j7cHcnwEUMZ/Pf1NP4Jy/lVzk6i7Cls0ut1DspbdCzoBiZrgx
 1QNUT8Pf+v7jrLfsrZgSDbWFHA==
X-Google-Smtp-Source: ABdhPJyunXb0BnPE3U8JLRPzsnbIpHBh+Pal1ueJlmJdY5FA0sOnlFUxb+pZcb1Day+tyy4FjstVPg==
X-Received: by 2002:adf:f9c1:: with SMTP id w1mr3873290wrr.342.1589540349741; 
 Fri, 15 May 2020 03:59:09 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id t71sm3101615wmt.31.2020.05.15.03.59.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:59:09 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 08/14] arm64: kvm: Split hyp/debug-sr.c to VHE/nVHE
Date: Fri, 15 May 2020 11:58:35 +0100
Message-Id: <20200515105841.73532-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

This patch is part of a series which builds KVM's non-VHE hyp code separately
from VHE and the rest of the kernel.

debug-sr.c contains KVM's code for context-switching debug registers, with some
parts shared between VHE/nVHE. These common routines are moved to debug-sr.h,
VHE-specific code is left in debug-sr.c and nVHE-specific code is moved to
nvhe/debug-sr.c.

Functions are slightly refactored to move code hidden behind `has_vhe()` checks
to the corresponding .c files.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h     |   3 -
 arch/arm64/kvm/hyp/debug-sr.c      | 214 +----------------------------
 arch/arm64/kvm/hyp/debug-sr.h      | 172 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  77 +++++++++++
 5 files changed, 256 insertions(+), 212 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index f8d94190af80..5de3a5998bcd 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,15 +61,12 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__kvm_nvhe___debug_switch_to_guest = __debug_switch_to_guest;
-__kvm_nvhe___debug_switch_to_host = __debug_switch_to_host;
 __kvm_nvhe___fpsimd_restore_state = __fpsimd_restore_state;
 __kvm_nvhe___fpsimd_save_state = __fpsimd_save_state;
 __kvm_nvhe___guest_enter = __guest_enter;
 __kvm_nvhe___guest_exit = __guest_exit;
 __kvm_nvhe___icache_flags = __icache_flags;
 __kvm_nvhe___kvm_enable_ssbs = __kvm_enable_ssbs;
-__kvm_nvhe___kvm_get_mdcr_el2 = __kvm_get_mdcr_el2;
 __kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
 __kvm_nvhe___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
 __kvm_nvhe___sysreg32_restore_state = __sysreg32_restore_state;
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 0fc9872a1467..39e0b9bcc8b7 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -4,221 +4,19 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <linux/compiler.h>
-#include <linux/kvm_host.h>
+#include "debug-sr.h"
 
-#include <asm/debug-monitors.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_hyp.h>
-#include <asm/kvm_mmu.h>
-
-#define read_debug(r,n)		read_sysreg(r##n##_el1)
-#define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
-
-#define save_debug(ptr,reg,nr)						\
-	switch (nr) {							\
-	case 15:	ptr[15] = read_debug(reg, 15);			\
-			/* Fall through */				\
-	case 14:	ptr[14] = read_debug(reg, 14);			\
-			/* Fall through */				\
-	case 13:	ptr[13] = read_debug(reg, 13);			\
-			/* Fall through */				\
-	case 12:	ptr[12] = read_debug(reg, 12);			\
-			/* Fall through */				\
-	case 11:	ptr[11] = read_debug(reg, 11);			\
-			/* Fall through */				\
-	case 10:	ptr[10] = read_debug(reg, 10);			\
-			/* Fall through */				\
-	case 9:		ptr[9] = read_debug(reg, 9);			\
-			/* Fall through */				\
-	case 8:		ptr[8] = read_debug(reg, 8);			\
-			/* Fall through */				\
-	case 7:		ptr[7] = read_debug(reg, 7);			\
-			/* Fall through */				\
-	case 6:		ptr[6] = read_debug(reg, 6);			\
-			/* Fall through */				\
-	case 5:		ptr[5] = read_debug(reg, 5);			\
-			/* Fall through */				\
-	case 4:		ptr[4] = read_debug(reg, 4);			\
-			/* Fall through */				\
-	case 3:		ptr[3] = read_debug(reg, 3);			\
-			/* Fall through */				\
-	case 2:		ptr[2] = read_debug(reg, 2);			\
-			/* Fall through */				\
-	case 1:		ptr[1] = read_debug(reg, 1);			\
-			/* Fall through */				\
-	default:	ptr[0] = read_debug(reg, 0);			\
-	}
-
-#define restore_debug(ptr,reg,nr)					\
-	switch (nr) {							\
-	case 15:	write_debug(ptr[15], reg, 15);			\
-			/* Fall through */				\
-	case 14:	write_debug(ptr[14], reg, 14);			\
-			/* Fall through */				\
-	case 13:	write_debug(ptr[13], reg, 13);			\
-			/* Fall through */				\
-	case 12:	write_debug(ptr[12], reg, 12);			\
-			/* Fall through */				\
-	case 11:	write_debug(ptr[11], reg, 11);			\
-			/* Fall through */				\
-	case 10:	write_debug(ptr[10], reg, 10);			\
-			/* Fall through */				\
-	case 9:		write_debug(ptr[9], reg, 9);			\
-			/* Fall through */				\
-	case 8:		write_debug(ptr[8], reg, 8);			\
-			/* Fall through */				\
-	case 7:		write_debug(ptr[7], reg, 7);			\
-			/* Fall through */				\
-	case 6:		write_debug(ptr[6], reg, 6);			\
-			/* Fall through */				\
-	case 5:		write_debug(ptr[5], reg, 5);			\
-			/* Fall through */				\
-	case 4:		write_debug(ptr[4], reg, 4);			\
-			/* Fall through */				\
-	case 3:		write_debug(ptr[3], reg, 3);			\
-			/* Fall through */				\
-	case 2:		write_debug(ptr[2], reg, 2);			\
-			/* Fall through */				\
-	case 1:		write_debug(ptr[1], reg, 1);			\
-			/* Fall through */				\
-	default:	write_debug(ptr[0], reg, 0);			\
-	}
-
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
-{
-	u64 aa64dfr0;
-	int brps, wrps;
-
-	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
-	brps = (aa64dfr0 >> 12) & 0xf;
-	wrps = (aa64dfr0 >> 20) & 0xf;
-
-	save_debug(dbg->dbg_bcr, dbgbcr, brps);
-	save_debug(dbg->dbg_bvr, dbgbvr, brps);
-	save_debug(dbg->dbg_wcr, dbgwcr, wrps);
-	save_debug(dbg->dbg_wvr, dbgwvr, wrps);
-
-	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
-}
-
-static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-					     struct kvm_guest_debug_arch *dbg,
-					     struct kvm_cpu_context *ctxt)
-{
-	u64 aa64dfr0;
-	int brps, wrps;
-
-	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
-
-	brps = (aa64dfr0 >> 12) & 0xf;
-	wrps = (aa64dfr0 >> 20) & 0xf;
-
-	restore_debug(dbg->dbg_bcr, dbgbcr, brps);
-	restore_debug(dbg->dbg_bvr, dbgbvr, brps);
-	restore_debug(dbg->dbg_wcr, dbgwcr, wrps);
-	restore_debug(dbg->dbg_wvr, dbgwvr, wrps);
-
-	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
-}
-
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
-	struct kvm_guest_debug_arch *guest_dbg;
-
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
-
-	__debug_save_state(vcpu, host_dbg, host_ctxt);
-	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
+	__debug_switch_to_guest_common(vcpu);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
-	struct kvm_guest_debug_arch *guest_dbg;
-
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
-
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
-
-	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
-	__debug_restore_state(vcpu, host_dbg, host_ctxt);
-
-	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __hyp_text __kvm_get_mdcr_el2(void)
+u32 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/debug-sr.h b/arch/arm64/kvm/hyp/debug-sr.h
new file mode 100644
index 000000000000..6a94553493a1
--- /dev/null
+++ b/arch/arm64/kvm/hyp/debug-sr.h
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_DEBUG_SR_H__
+#define __ARM64_KVM_HYP_DEBUG_SR_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/debug-monitors.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+#define read_debug(r,n)		read_sysreg(r##n##_el1)
+#define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
+
+#define save_debug(ptr,reg,nr)						\
+	switch (nr) {							\
+	case 15:	ptr[15] = read_debug(reg, 15);			\
+			/* Fall through */				\
+	case 14:	ptr[14] = read_debug(reg, 14);			\
+			/* Fall through */				\
+	case 13:	ptr[13] = read_debug(reg, 13);			\
+			/* Fall through */				\
+	case 12:	ptr[12] = read_debug(reg, 12);			\
+			/* Fall through */				\
+	case 11:	ptr[11] = read_debug(reg, 11);			\
+			/* Fall through */				\
+	case 10:	ptr[10] = read_debug(reg, 10);			\
+			/* Fall through */				\
+	case 9:		ptr[9] = read_debug(reg, 9);			\
+			/* Fall through */				\
+	case 8:		ptr[8] = read_debug(reg, 8);			\
+			/* Fall through */				\
+	case 7:		ptr[7] = read_debug(reg, 7);			\
+			/* Fall through */				\
+	case 6:		ptr[6] = read_debug(reg, 6);			\
+			/* Fall through */				\
+	case 5:		ptr[5] = read_debug(reg, 5);			\
+			/* Fall through */				\
+	case 4:		ptr[4] = read_debug(reg, 4);			\
+			/* Fall through */				\
+	case 3:		ptr[3] = read_debug(reg, 3);			\
+			/* Fall through */				\
+	case 2:		ptr[2] = read_debug(reg, 2);			\
+			/* Fall through */				\
+	case 1:		ptr[1] = read_debug(reg, 1);			\
+			/* Fall through */				\
+	default:	ptr[0] = read_debug(reg, 0);			\
+	}
+
+#define restore_debug(ptr,reg,nr)					\
+	switch (nr) {							\
+	case 15:	write_debug(ptr[15], reg, 15);			\
+			/* Fall through */				\
+	case 14:	write_debug(ptr[14], reg, 14);			\
+			/* Fall through */				\
+	case 13:	write_debug(ptr[13], reg, 13);			\
+			/* Fall through */				\
+	case 12:	write_debug(ptr[12], reg, 12);			\
+			/* Fall through */				\
+	case 11:	write_debug(ptr[11], reg, 11);			\
+			/* Fall through */				\
+	case 10:	write_debug(ptr[10], reg, 10);			\
+			/* Fall through */				\
+	case 9:		write_debug(ptr[9], reg, 9);			\
+			/* Fall through */				\
+	case 8:		write_debug(ptr[8], reg, 8);			\
+			/* Fall through */				\
+	case 7:		write_debug(ptr[7], reg, 7);			\
+			/* Fall through */				\
+	case 6:		write_debug(ptr[6], reg, 6);			\
+			/* Fall through */				\
+	case 5:		write_debug(ptr[5], reg, 5);			\
+			/* Fall through */				\
+	case 4:		write_debug(ptr[4], reg, 4);			\
+			/* Fall through */				\
+	case 3:		write_debug(ptr[3], reg, 3);			\
+			/* Fall through */				\
+	case 2:		write_debug(ptr[2], reg, 2);			\
+			/* Fall through */				\
+	case 1:		write_debug(ptr[1], reg, 1);			\
+			/* Fall through */				\
+	default:	write_debug(ptr[0], reg, 0);			\
+	}
+
+static inline void __hyp_text
+__debug_save_state(struct kvm_vcpu *vcpu, struct kvm_guest_debug_arch *dbg,
+		   struct kvm_cpu_context *ctxt)
+{
+	u64 aa64dfr0;
+	int brps, wrps;
+
+	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
+	brps = (aa64dfr0 >> 12) & 0xf;
+	wrps = (aa64dfr0 >> 20) & 0xf;
+
+	save_debug(dbg->dbg_bcr, dbgbcr, brps);
+	save_debug(dbg->dbg_bvr, dbgbvr, brps);
+	save_debug(dbg->dbg_wcr, dbgwcr, wrps);
+	save_debug(dbg->dbg_wvr, dbgwvr, wrps);
+
+	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
+}
+
+static inline void __hyp_text
+__debug_restore_state(struct kvm_vcpu *vcpu, struct kvm_guest_debug_arch *dbg,
+		      struct kvm_cpu_context *ctxt)
+{
+	u64 aa64dfr0;
+	int brps, wrps;
+
+	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	brps = (aa64dfr0 >> 12) & 0xf;
+	wrps = (aa64dfr0 >> 20) & 0xf;
+
+	restore_debug(dbg->dbg_bcr, dbgbcr, brps);
+	restore_debug(dbg->dbg_bvr, dbgbvr, brps);
+	restore_debug(dbg->dbg_wcr, dbgwcr, wrps);
+	restore_debug(dbg->dbg_wvr, dbgwvr, wrps);
+
+	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
+}
+
+static inline void __hyp_text
+__debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
+
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, host_dbg, host_ctxt);
+	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
+}
+
+static inline void __hyp_text
+__debug_switch_to_host_common(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
+
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
+	__debug_restore_state(vcpu, host_dbg, host_ctxt);
+
+	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+}
+
+#endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index bbfd9d27d742..33a80da34154 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
 	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := switch.o tlb.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
new file mode 100644
index 000000000000..b3752cfdcf3d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/debug-monitors.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+#include "../debug-sr.h"
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
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
