Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3F5C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2CAD61360
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F2CAD61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8F054B1B6;
	Wed, 17 Nov 2021 10:37:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U+N-fFP4AcU3; Wed, 17 Nov 2021 10:37:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDD24B164;
	Wed, 17 Nov 2021 10:37:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466EC4B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R-d0EgI41SMB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1359D4B19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB367ED1;
 Wed, 17 Nov 2021 07:37:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 062EF3F5A1;
 Wed, 17 Nov 2021 07:37:43 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 25/38] KVM: arm64: VHE: Change MDCR_EL2 at world switch
 if VCPU has SPE
Date: Wed, 17 Nov 2021 15:38:29 +0000
Message-Id: <20211117153842.302159-26-alexandru.elisei@arm.com>
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

When a VCPU has the SPE feature, MDCR_EL2 sets the buffer owning regime to
EL1&0. Write the guest's MDCR_EL2 value as late as possible and restore the
host's value as soon as possible at each world switch to make the profiling
blackout window as small as possible for the host.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/debug.c          | 14 ++++++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c | 15 +++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 64629b4bb036..ee764ea0da5b 100644
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
index f85a13bfad3d..1a46a4840d17 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -35,6 +35,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	if (kvm_vcpu_has_spe(vcpu))
+		__restore_guest_mdcr_el2(vcpu);
+
 	___activate_traps(vcpu);
 
 	val = read_sysreg(cpacr_el1);
@@ -70,6 +73,9 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	extern char vectors[];	/* kernel exception vectors */
 
+	if (kvm_vcpu_has_spe(vcpu))
+		__restore_host_mdcr_el2(vcpu);
+
 	___deactivate_traps(vcpu);
 
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
@@ -82,6 +88,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
+
 	write_sysreg(vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
@@ -89,12 +96,16 @@ NOKPROBE_SYMBOL(__deactivate_traps);
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
 	__activate_traps_common(vcpu);
-	__restore_guest_mdcr_el2(vcpu);
+
+	if (!kvm_vcpu_has_spe(vcpu))
+		__restore_guest_mdcr_el2(vcpu);
 }
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	__restore_host_mdcr_el2(vcpu);
+	if (!kvm_vcpu_has_spe(vcpu))
+		__restore_host_mdcr_el2(vcpu);
+
 	__deactivate_traps_common(vcpu);
 }
 
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
