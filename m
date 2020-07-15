Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213E1C43458
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06A8020787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QMWHmArp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06A8020787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8854B40D;
	Wed, 15 Jul 2020 14:45:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id daaFtfjzG6Ja; Wed, 15 Jul 2020 14:45:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 456824B3FC;
	Wed, 15 Jul 2020 14:45:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64D634B3F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 65fdxDTucVJL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:54 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A0004B3D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:53 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id r19so1866737qvz.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=y12/I+xv8/r6BzID+OuBAmA/UPLEvbeHxWJspwHjmLY=;
 b=QMWHmArpumOfoI0/nRs4H8UTvlzQ4goDNpoTDifRAYOQz1z4862FP05pz2YUyPWU0D
 WB8SskFvSVqKabgqGbfdNNs9lEufGngJeM3UPBEIFD57CbqRkGSEnzBXigPTe/SKz6pw
 /SgYzeSVyvIlwwlH2WMG2ix8UBIBTuGi5oZz2xZ8Q+e8rB2+qxWnaycO3rpVfkoRDTot
 Hf6NLwmJ2dfuUTvdRWw568+rU2dicEHLBCx7v+968NIalD4bRff7rGLWQ4sN/77jxshl
 1kGQX5FSQc6UKsp3Ct/BrOUGXXItL4QPsfXdz77N91LdSmx4x3VHVmYmXLnvRq0vcxTs
 G9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y12/I+xv8/r6BzID+OuBAmA/UPLEvbeHxWJspwHjmLY=;
 b=WkWh/Thij5hI2SA9xhChVO5U92fIIDOFY+OlK3rHC3a2igYYL3D3GZBhrLgmKLHBsb
 cYpJi/SeqL1JWF+JcsdWGj90mh4CAbl81KgqUn3zIwj2IGE0IYzmLuel1WSTyUAl+1iG
 kBsst1Vnx7sS0e/BPB7t9MJUNqx4tw9xzO3SXwLLmNhQkt0MrXUqjop2lw/EzvvSGv9C
 HuCfHk6pI8yN5KWjcUsvZsjKkSetrTrh2BWhFN17FUp8WwLvmgxu5GUsZyp4sRxnI9vk
 59tXzO0L7eET4dqJ/BMTsT+zfs5L8Y4whTcIO6pC4n9tWlruv1RrjAc7gesONhTCTzKq
 3+Eg==
X-Gm-Message-State: AOAM531GvGGKYT0AtaBWSlD/OYFLgbn5x6m2lf+CrBoCrqzd/gF4aNci
 gb+OMM5SFwfaYHZBZ3NeJ0Wmw0CZ8GMsD+DeesiTcZ+fInZ0gBfceR1TSHuqfaLfhEAc1CO41r5
 nTZ721RZtg2b73JlPWV1vkHW35/tIkHWmdtaJ5fI1q+Ye3amOf5rssW+RaCCtqXz+XSwdwQ==
X-Google-Smtp-Source: ABdhPJxieFUMoPY8okCj4fN5K1wpcrghhrWofv2DEG/F6IbVtebjN10eCmYCl2N2FzmYRRJ0YtQqlKX1nyc=
X-Received: by 2002:ad4:452c:: with SMTP id l12mr711567qvu.198.1594838752564; 
 Wed, 15 Jul 2020 11:45:52 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:30 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-30-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 29/37] KVM: arm64: nVHE: Separate the save and restore of
 debug state
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

The primitives for save and restore are already available. SPE is always
switched but the debug state is only switched if both vcpus are using
the debug registers, as indicated by KVM_ARM64_DEBUG_DIRTY. The host
vcpu is marked as always using the debug registers.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h          |  4 +--
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 43 +++--------------------
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        | 40 +++++++--------------
 arch/arm64/kvm/hyp/nvhe/switch.c          | 38 +++++++++++++-------
 arch/arm64/kvm/hyp/vhe/debug-sr.c         | 22 ++++++++++--
 5 files changed, 65 insertions(+), 82 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 38d49f9b56c7..d4d366e0d78d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -96,8 +96,8 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __debug_switch_to_guest(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu);
-void __debug_switch_to_host(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu);
+void __debug_save_spe(struct kvm_vcpu *vcpu);
+void __debug_restore_spe(struct kvm_vcpu *vcpu);
 #else
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 0d342418d706..b02d6ffb4129 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -88,8 +88,8 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
-			       struct kvm_cpu_context *ctxt)
+static inline void __debug_save_state(struct kvm_guest_debug_arch *dbg,
+				      struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -106,8 +106,8 @@ static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
 	ctxt_sys_reg(ctxt, MDCCINT_EL1) = read_sysreg(mdccint_el1);
 }
 
-static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
-				  struct kvm_cpu_context *ctxt)
+static inline void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
+					 struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -124,39 +124,4 @@ static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
 
 	write_sysreg(ctxt_sys_reg(ctxt, MDCCINT_EL1), mdccint_el1);
 }
-
-static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu,
-						  struct kvm_guest_debug_arch *host_dbg,
-						  struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *guest_dbg;
-
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
-	guest_ctxt = &vcpu->arch.ctxt;
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
-
-	__debug_save_state(host_dbg, host_ctxt);
-	__debug_restore_state(guest_dbg, guest_ctxt);
-}
-
-static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu,
-						 struct kvm_guest_debug_arch *host_dbg,
-						 struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *guest_dbg;
-
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
-	guest_ctxt = &vcpu->arch.ctxt;
-	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
-
-	__debug_save_state(guest_dbg, guest_ctxt);
-	__debug_restore_state(host_dbg, host_ctxt);
-}
-
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 4bf0eeb41a44..e344be6fa30a 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -14,11 +14,16 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static void __debug_save_spe(u64 *pmscr_el1)
+void __debug_save_spe(struct kvm_vcpu *vcpu)
 {
 	u64 reg;
+	u64 *pmscr_el1;
+
+	if (!vcpu->arch.ctxt.is_host)
+		return;
 
 	/* Clear pmscr in case of early return */
+	pmscr_el1 = __hyp_this_cpu_ptr(kvm_host_pmscr_el1);
 	*pmscr_el1 = 0;
 
 	/* SPE present on this CPU? */
@@ -46,8 +51,14 @@ static void __debug_save_spe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __debug_restore_spe(u64 pmscr_el1)
+void __debug_restore_spe(struct kvm_vcpu *vcpu)
 {
+	u64 pmscr_el1;
+
+	if (!vcpu->arch.ctxt.is_host)
+		return;
+
+	pmscr_el1 = __hyp_this_cpu_read(kvm_host_pmscr_el1);
 	if (!pmscr_el1)
 		return;
 
@@ -58,31 +69,6 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __debug_switch_to_guest(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
-
-	host_ctxt = &host_vcpu->arch.ctxt;
-	host_dbg = host_vcpu->arch.debug_ptr;
-
-	/* Disable and flush SPE data generation */
-	__debug_save_spe(__hyp_this_cpu_ptr(kvm_host_pmscr_el1));
-	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
-}
-
-void __debug_switch_to_host(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
-
-	host_ctxt = &host_vcpu->arch.ctxt;
-	host_dbg = host_vcpu->arch.debug_ptr;
-
-	__debug_restore_spe(__hyp_this_cpu_read(kvm_host_pmscr_el1));
-	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
-}
-
 u32 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7fdf1a9ab47e..25c64392356b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/debug-sr.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
@@ -176,8 +177,6 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 	__activate_traps(vcpu);
 
 	__timer_enable_traps(vcpu);
-
-	__debug_switch_to_guest(host_vcpu, vcpu);
 }
 
 static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
@@ -192,12 +191,6 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 
 	__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 
-	/*
-	 * This must come after restoring the host sysregs, since a non-VHE
-	 * system may enable SPE here and make use of the TTBRs.
-	 */
-	__debug_switch_to_host(host_vcpu, vcpu);
-
 	__pmu_switch_to_host();
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
@@ -205,16 +198,22 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 		gic_write_pmr(GIC_PRIO_IRQOFF);
 }
 
-static void __vcpu_save_state(struct kvm_vcpu *vcpu)
+static void __vcpu_save_state(struct kvm_vcpu *vcpu, bool save_debug)
 {
 	__sysreg_save_state_nvhe(&vcpu->arch.ctxt);
 	__sysreg32_save_state(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
 	__fpsimd_save_fpexc32(vcpu);
+
+	__debug_save_spe(vcpu);
+
+	if (save_debug)
+		__debug_save_state(kern_hyp_va(vcpu->arch.debug_ptr),
+				   &vcpu->arch.ctxt);
 }
 
-static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
+static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 {
 	struct kvm_vcpu *running_vcpu;
 
@@ -231,6 +230,16 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
 
 	__hyp_vgic_restore_state(vcpu);
 
+	/*
+	 * This must come after restoring the sysregs since SPE may make use if
+	 * the TTBRs.
+	 */
+	__debug_restore_spe(vcpu);
+
+	if (restore_debug)
+		__debug_restore_state(kern_hyp_va(vcpu->arch.debug_ptr),
+				      &vcpu->arch.ctxt);
+
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
 
@@ -245,6 +254,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 
 	if (running_vcpu != vcpu) {
+		bool switch_debug;
+
 		if (!running_vcpu->arch.ctxt.is_host &&
 		    !vcpu->arch.ctxt.is_host) {
 			/*
@@ -256,8 +267,11 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 			return ARM_EXCEPTION_IRQ;
 		}
 
-		__vcpu_save_state(running_vcpu);
-		__vcpu_restore_state(vcpu);
+		switch_debug = (vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) &&
+			(running_vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
+
+		__vcpu_save_state(running_vcpu, switch_debug);
+		__vcpu_restore_state(vcpu, switch_debug);
 	}
 
 	__set_vcpu_arch_workaround_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index 7a68e1215277..a1462a8f16b1 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -13,23 +13,41 @@
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
+
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
 
 	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
-	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
+	guest_ctxt = &vcpu->arch.ctxt;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(host_dbg, host_ctxt);
+	__debug_restore_state(guest_dbg, guest_ctxt);
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
+
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
 
 	host_ctxt = __hyp_this_cpu_ptr(kvm_host_ctxt);
 	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
-	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
+	guest_ctxt = &vcpu->arch.ctxt;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(guest_dbg, guest_ctxt);
+	__debug_restore_state(host_dbg, host_ctxt);
 }
 
 u32 __kvm_get_mdcr_el2(void)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
