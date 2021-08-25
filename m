Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD99C432BE
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D99D461153
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D99D461153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD784B213;
	Wed, 25 Aug 2021 12:19:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vBGnpIZDBuEJ; Wed, 25 Aug 2021 12:19:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618234B230;
	Wed, 25 Aug 2021 12:18:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B184B28F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j4zxOaRuqx6o for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3B84B283
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4360C1435;
 Wed, 25 Aug 2021 09:17:59 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E72953F66F;
 Wed, 25 Aug 2021 09:17:57 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 29/39] KVM: arm64: Rename DEBUG_STATE_SAVE_SPE ->
 DEBUG_SAVE_SPE_BUFFER flags
Date: Wed, 25 Aug 2021 17:18:05 +0100
Message-Id: <20210825161815.266051-30-alexandru.elisei@arm.com>
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

Setting the KVM_ARM64_DEBUG_STATE_SAVE_SPE flag will stop profiling to
drain the buffer, if the buffer is enabled when switching to the guest, and
then re-enable profiling on the return to the host. Rename it to
KVM_ARM64_DEBUG_SAVE_SPE_BUFFER to avoid any confusion with what a SPE
enabled VCPU will do, which is to save and restore the full SPE state on a
world switch, and not just part of it, some of the time. This also matches
the name of the function __debug_save_host_buffers_nvhe(), which makes use
of the flag to decide if the buffer should be drained.

Similar treatment was applied to KVM_ARM64_DEBUG_STATE_SAVE_TRBE, which was
renamed to KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER, for consistency and to better
reflect what it is doing.

CC: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h  | 24 ++++++++++++------------
 arch/arm64/kvm/debug.c             | 11 ++++++-----
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  8 ++++----
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 351b77dc7732..e704847a7645 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -439,18 +439,18 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
-#define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
-#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
-#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
-#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
-#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
-#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
-#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
-#define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
-#define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
-#define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
-#define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+#define KVM_ARM64_DEBUG_DIRTY			(1 << 0)
+#define KVM_ARM64_FP_ENABLED			(1 << 1) /* guest FP regs loaded */
+#define KVM_ARM64_FP_HOST			(1 << 2) /* host FP regs loaded */
+#define KVM_ARM64_HOST_SVE_IN_USE		(1 << 3) /* backup for host TIF_SVE */
+#define KVM_ARM64_HOST_SVE_ENABLED		(1 << 4) /* SVE enabled for EL0 */
+#define KVM_ARM64_GUEST_HAS_SVE			(1 << 5) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_SVE_FINALIZED		(1 << 6) /* SVE config completed */
+#define KVM_ARM64_GUEST_HAS_PTRAUTH		(1 << 7) /* PTRAUTH exposed to guest */
+#define KVM_ARM64_PENDING_EXCEPTION		(1 << 8) /* Exception pending */
+#define KVM_ARM64_EXCEPT_MASK			(7 << 9) /* Target EL/MODE */
+#define KVM_ARM64_DEBUG_SAVE_SPE_BUFFER		(1 << 12) /* Save SPE buffer if active  */
+#define KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER	(1 << 13) /* Save TRBE buffer if active  */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 70712cd85f32..6e5fc1887215 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -299,22 +299,23 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
 		return;
 
 	dfr0 = read_sysreg(id_aa64dfr0_el1);
+
 	/*
 	 * If SPE is present on this CPU and is available at current EL,
-	 * we may need to check if the host state needs to be saved.
+	 * we may need to check if the host buffer needs to be drained.
 	 */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_PMSVER_SHIFT) &&
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(SYS_PMBIDR_EL1_P_SHIFT)))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_SPE;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_SAVE_SPE_BUFFER;
 
 	/* Check if we have TRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_TRBE_SHIFT) &&
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_PROG))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_TRBE;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER;
 }
 
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.flags &= ~(KVM_ARM64_DEBUG_STATE_SAVE_SPE |
-			      KVM_ARM64_DEBUG_STATE_SAVE_TRBE);
+	vcpu->arch.flags &= ~(KVM_ARM64_DEBUG_SAVE_SPE_BUFFER |
+			      KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 6db58722f045..186b90b5fd20 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -85,10 +85,10 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				    struct kvm_cpu_context *host_ctxt)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
 		__debug_save_spe(__ctxt_sys_reg(host_ctxt, PMSCR_EL1));
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER)
 		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
 }
 
@@ -100,9 +100,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				       struct kvm_cpu_context *host_ctxt)
 {
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
 		__debug_restore_spe(ctxt_sys_reg(host_ctxt, PMSCR_EL1));
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER)
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
 }
 
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
