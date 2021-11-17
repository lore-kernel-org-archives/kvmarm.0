Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C18C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8469561BFA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8469561BFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F274B1B2;
	Wed, 17 Nov 2021 10:37:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OUNNO9qSrkrx; Wed, 17 Nov 2021 10:37:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 803754B1AD;
	Wed, 17 Nov 2021 10:37:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7947C4B19D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LTF5qBxCDSZ4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C2C4B183
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35854ED1;
 Wed, 17 Nov 2021 07:37:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AB323F5A1;
 Wed, 17 Nov 2021 07:37:48 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 27/38] KVM: arm64: nVHE: Save PMSCR_EL1 to the host
 context
Date: Wed, 17 Nov 2021 15:38:31 +0000
Message-Id: <20211117153842.302159-28-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
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
index dd7746836477..e29e9de42cfb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -360,8 +360,6 @@ struct kvm_vcpu_arch {
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
 	} host_debug_state;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 5afd14ab15b9..0a5ff4361069 100644
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
index df361d839902..565c31c15311 100644
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
index d1f55514effc..b6489e244025 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -290,7 +290,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
 	 * before we load guest Stage1.
 	 */
-	__debug_save_host_buffers_nvhe(vcpu);
+	__debug_save_host_buffers_nvhe(vcpu, host_ctxt);
 
 	__kvm_adjust_pc(vcpu);
 
@@ -342,7 +342,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_restore_host_buffers_nvhe(vcpu);
+	__debug_restore_host_buffers_nvhe(vcpu, host_ctxt);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
