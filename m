Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E91C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20F5D61163
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20F5D61163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F3D4B1FD;
	Wed, 25 Aug 2021 12:19:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-A8KoyYnA2L; Wed, 25 Aug 2021 12:19:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411D84B28C;
	Wed, 25 Aug 2021 12:18:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D09C4064F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ZIGqw0I4QkW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C364B259
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A35DB113E;
 Wed, 25 Aug 2021 09:17:57 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 504613F66F;
 Wed, 25 Aug 2021 09:17:56 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 28/39] KVM: arm64: nVHE: Save PMSCR_EL1 to the host
 context
Date: Wed, 25 Aug 2021 17:18:04 +0100
Message-Id: <20210825161815.266051-29-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The SPE registers are now part of the KVM register context, use the host
context to save the value of PMSCR_EL1 instead of a dedicated field in
host_debug_state.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h  |  2 --
 arch/arm64/include/asm/kvm_hyp.h   |  6 ++++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 10 ++++++----
 arch/arm64/kvm/hyp/nvhe/switch.c   |  4 ++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4c0d3d5ba285..351b77dc7732 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -356,8 +356,6 @@ struct kvm_vcpu_arch {
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
 	} host_debug_state;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 657d0c94cf82..48619c2c0dc6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -84,8 +84,10 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
-void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
+				    struct kvm_cpu_context *host_ctxt);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
+				       struct kvm_cpu_context *host_ctxt);
 #endif
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7d3f25868cae..6db58722f045 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -81,11 +81,12 @@ static void __debug_restore_trace(u64 trfcr_el1)
 	write_sysreg_s(trfcr_el1, SYS_TRFCR_EL1);
 }
 
-void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
+				    struct kvm_cpu_context *host_ctxt)
 {
 	/* Disable and flush SPE data generation */
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
-		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_save_spe(__ctxt_sys_reg(host_ctxt, PMSCR_EL1));
 	/* Disable and flush Self-Hosted Trace generation */
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
 		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
@@ -96,10 +97,11 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest_common(vcpu);
 }
 
-void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
+				       struct kvm_cpu_context *host_ctxt)
 {
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
-		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_restore_spe(ctxt_sys_reg(host_ctxt, PMSCR_EL1));
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0c70d897a493..04d654e71a6e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -200,7 +200,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
 	 * before we load guest Stage1.
 	 */
-	__debug_save_host_buffers_nvhe(vcpu);
+	__debug_save_host_buffers_nvhe(vcpu, host_ctxt);
 
 	__kvm_adjust_pc(vcpu);
 
@@ -248,7 +248,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_restore_host_buffers_nvhe(vcpu);
+	__debug_restore_host_buffers_nvhe(vcpu, host_ctxt);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
