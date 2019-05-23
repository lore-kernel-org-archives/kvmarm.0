Return-Path: <SRS0=jV2N=TX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A84BC46470
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F130221019
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F130221019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADD394A4E6;
	Thu, 23 May 2019 06:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpnYxLorYvl9; Thu, 23 May 2019 06:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B8A4A4EA;
	Thu, 23 May 2019 06:35:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B57CE4A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C7E6vTjlmICr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 May 2019 06:35:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6044A4C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAF9515AB;
 Thu, 23 May 2019 03:35:39 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 958D83F718;
 Thu, 23 May 2019 03:35:37 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 08/15] arm64: KVM/debug: drop pmscr_el1 and use
 sys_regs[PMSCR_EL1] in kvm_cpu_context
Date: Thu, 23 May 2019 11:34:55 +0100
Message-Id: <20190523103502.25925-9-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

kvm_cpu_context now has support to stash the complete SPE buffer control
context. We no longer need the pmscr_el1 kvm_vcpu_arch and it can be
dropped.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/hyp/debug-sr.c     | 26 +++++++++++++++-----------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 559aa6931291..6921fdfd477b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -310,8 +310,6 @@ struct kvm_vcpu_arch {
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
 	} host_debug_state;
 
 	/* VGIC state */
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 618884df1dc4..a2714a5eb3e9 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -66,19 +66,19 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
+static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
 	u64 reg;
 
 	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
+	ctxt->sys_regs[PMSCR_EL1] = 0;
 
 	/* SPE present on this CPU? */
 	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
 						  ID_AA64DFR0_PMSVER_SHIFT))
 		return;
 
-	/* Yes; is it owned by EL3? */
+	/* Yes; is it owned by higher EL? */
 	reg = read_sysreg_s(SYS_PMBIDR_EL1);
 	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
 		return;
@@ -89,7 +89,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_el1_s(SYS_PMSCR);
+	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1_s(SYS_PMSCR);
 	write_sysreg_el1_s(0, SYS_PMSCR);
 	isb();
 
@@ -98,16 +98,16 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
+static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
 {
-	if (!pmscr_el1)
+	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
 
 	/* The host page table is installed, but not yet synchronised */
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_el1_s(pmscr_el1, SYS_PMSCR);
+	write_sysreg_el1_s(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
@@ -175,14 +175,15 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
 	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_restore_spe_nvhe(host_ctxt);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
@@ -198,8 +199,11 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
 	 * Non-VHE: Disable and flush SPE data generation
 	 * VHE: The vcpu can run, but it can't hide.
 	 */
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_save_spe_nvhe(host_ctxt);
 }
 
 void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
