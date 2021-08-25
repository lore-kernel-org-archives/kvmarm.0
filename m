Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26766C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF5AA6115A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF5AA6115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7479F4B1FD;
	Wed, 25 Aug 2021 12:19:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mwop-alqAIsY; Wed, 25 Aug 2021 12:19:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D674B2B2;
	Wed, 25 Aug 2021 12:18:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D1B14B231
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nP-FgTgFHj2g for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A885D4B209
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EF94142F;
 Wed, 25 Aug 2021 09:17:54 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20EE23F66F;
 Wed, 25 Aug 2021 09:17:52 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 26/39] KVM: arm64: VHE: Change MDCR_EL2 at world switch
 if VCPU has SPE
Date: Wed, 25 Aug 2021 17:18:02 +0100
Message-Id: <20210825161815.266051-27-alexandru.elisei@arm.com>
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

When a VCPU has the SPE feature, MDCR_EL2 sets the buffer owning regime to
EL1&0. Write the guest's MDCR_EL2 value as late as possible and restore the
host's value as soon as possible at each world switch to make the profiling
blackout window as small as possible for the host.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  2 +-
 arch/arm64/kvm/debug.c             | 14 +++++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 +++++++++++++++++++++++-------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c |  2 +-
 4 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..657d0c94cf82 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 #endif
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 64e8211366b6..70712cd85f32 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -249,9 +249,19 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
-	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	if (has_vhe()) {
+		/*
+		 * MDCR_EL2 can modify the SPE buffer owning regime, defer the
+		 * write until the VCPU is run.
+		 */
+		if (kvm_vcpu_has_spe(vcpu))
+			goto out;
+
+		if (orig_mdcr_el2 != vcpu->arch.mdcr_el2)
+			write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	}
 
+out:
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 983ba1570d72..ec4e179d56ae 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -31,12 +31,29 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+static void __restore_host_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	u64 mdcr_el2;
+
+	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
+	write_sysreg(mdcr_el2, mdcr_el2);
+}
+
+static void __restore_guest_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	___activate_traps(vcpu);
 
+	if (kvm_vcpu_has_spe(vcpu))
+		__restore_guest_mdcr_el2(vcpu);
+
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
@@ -81,7 +98,11 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
+	if (kvm_vcpu_has_spe(vcpu))
+		__restore_host_mdcr_el2(vcpu);
+
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
+
 	write_sysreg(vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
@@ -90,16 +111,14 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
 	__activate_traps_common(vcpu);
 
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	if (!kvm_vcpu_has_spe(vcpu))
+		__restore_guest_mdcr_el2(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
+	if (!kvm_vcpu_has_spe(vcpu))
+		__restore_host_mdcr_el2(vcpu);
 
 	__deactivate_traps_common();
 }
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2a0b8c88d74f..007a12dd4351 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
