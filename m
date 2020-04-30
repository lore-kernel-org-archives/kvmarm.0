Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D660C47253
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B718624956
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="d6CsR5eE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B718624956
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7159A4B536;
	Thu, 30 Apr 2020 10:49:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qpXueEevgXNu; Thu, 30 Apr 2020 10:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 834004B494;
	Thu, 30 Apr 2020 10:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 248114B4DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9CdGrzGddgj6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:49:03 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5426A4B4D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:03 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id 188so2190331wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=FjOhuVLumRuIz5DqCnJtHllE6aJ7knqtOcOqchqCoP0=;
 b=d6CsR5eE/2qsuxYygVgKLlf4mEw7CQgXvj+bFpfqCLASJfWKdEEqt8ZOcCf2GcmHGq
 WckMhcMboTjvLyMxCJ/FXrWKv3q2d/0ph8HuGKR/kKXO9lAanvvKJYK2owDIxVaqlvoL
 xPrCK//SLreaASmsUfZCfUrBb39jTSWEDHLloIrbWsTJOHPKjImfXA2msvSa6IZaIN+I
 /rgaM0cxZZqFfMEhkY9o5xJdOsiF3Z2VnRZQTx+cUrVPAcgBXYcufHhRr5oaG9D3WMkv
 2lTEFn9PWJFKZiHfTgQxvtVRxyvZdIIy3lN4nvk4LwZpvIpJML6YeWFdfOdIXW0xq1fS
 Qv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=FjOhuVLumRuIz5DqCnJtHllE6aJ7knqtOcOqchqCoP0=;
 b=f7YQoc+LHyDVH5KH9h+wsbSdqbkhv1G/wel+XatJBliUggYh9R8FmzETGbJoKa1pmK
 MDTr7m1MVuh40G7m25MwNBCRc0akgMLKPq6unJCEBjM7RCnonowv3BShAOgNB5LSt2HN
 vIuV3QxcU6o1TX9QTlzmsZF8Ywsw10WXuJ3yZiB2L9JGVowWaNB+UZyPU3D5ay5GW9pc
 Cl4YJa8CdYHwRKrrarUpEuWqr85BpPDtSCd21Wi+eeKYwQTxZ0Z9D6akXV2/DWC4gNZm
 Ta9I4zWL+MpWk2jVYIV9nceLSV9XjgT41Ecf5NiU7jsi4WnNjlFBMzUBKGN+MMHSKQts
 566g==
X-Gm-Message-State: AGi0PuYn++ISJTPWymfO9FZUMDm8j/sPK2QRn0t25pagdU5fq2hFr4wL
 IEmYUqX/jq2BaYYKNwENBF+IJQ==
X-Google-Smtp-Source: APiQypIpR706rjdCf/ZS+HC3QHzlGhtv1fzyIp5yTp43CXqfsiIX7l2v8svou2NbjfSyCkGK4Sng/Q==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr3573099wmg.114.1588258142098; 
 Thu, 30 Apr 2020 07:49:02 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id e5sm4151260wru.92.2020.04.30.07.49.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:49:01 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 09/15] arm64: kvm: Split hyp/debug-sr.c to VHE/nVHE
Date: Thu, 30 Apr 2020 15:48:25 +0100
Message-Id: <20200430144831.59194-10-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
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
to the corresponding .c file.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h     |   3 -
 arch/arm64/kvm/hyp/debug-sr.c      | 214 +----------------------------
 arch/arm64/kvm/hyp/debug-sr.h      | 167 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  77 +++++++++++
 5 files changed, 251 insertions(+), 212 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index e2282a4304c5..0e9ede9c473a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,15 +61,12 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__hyp_text___debug_switch_to_guest = __debug_switch_to_guest;
-__hyp_text___debug_switch_to_host = __debug_switch_to_host;
 __hyp_text___fpsimd_restore_state = __fpsimd_restore_state;
 __hyp_text___fpsimd_save_state = __fpsimd_save_state;
 __hyp_text___guest_enter = __guest_enter;
 __hyp_text___guest_exit = __guest_exit;
 __hyp_text___icache_flags = __icache_flags;
 __hyp_text___kvm_enable_ssbs = __kvm_enable_ssbs;
-__hyp_text___kvm_get_mdcr_el2 = __kvm_get_mdcr_el2;
 __hyp_text___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
 __hyp_text___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
 __hyp_text___sysreg32_restore_state = __sysreg32_restore_state;
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
index 000000000000..1e849f31cb74
--- /dev/null
+++ b/arch/arm64/kvm/hyp/debug-sr.h
@@ -0,0 +1,167 @@
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
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 82fbd0b76501..bca3b862927c 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,7 @@ asflags-y := -D__HYPERVISOR__
 ccflags-y := -D__HYPERVISOR__ -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 	     $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := switch.o tlb.o host_hypercall.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o host_hypercall.o ../hyp-entry.o
 
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
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
