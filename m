Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E041EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9014C61360
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9014C61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44C2B4B133;
	Wed, 17 Nov 2021 10:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oy9zFQ2anLKL; Wed, 17 Nov 2021 10:37:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC354B1AD;
	Wed, 17 Nov 2021 10:37:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A544B160
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DkacNjejZmVj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AF6B4B183
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:44 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B87651FB;
 Wed, 17 Nov 2021 07:37:43 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ACF93F5A1;
 Wed, 17 Nov 2021 07:37:42 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 24/38] KVM: arm64: Move accesses to MDCR_EL2 out of
 __{activate, deactivate}_traps_common
Date: Wed, 17 Nov 2021 15:38:28 +0000
Message-Id: <20211117153842.302159-25-alexandru.elisei@arm.com>
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

To run a guest with SPE, MDCR_EL2 must be configured such that the buffer
owning regime is EL1&0. With VHE enabled, the guest runs at EL2 and
changing the owning regime to EL1&0 in vcpu_put() would mean creating an
extended blackout window for the host.

Move the acceses to MDCR_EL2 out of __activate_traps_common() and
__deactivate_traps_common() to prepare for executing them later in the run
loop in the VHE case.

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 +++++++++++-----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 ++
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 ++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7a0af1d39303..cf9b66a2acb0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -97,20 +97,26 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmselr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
-
-	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
-	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
-
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
 }
 
+static inline void __restore_guest_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+}
+
+static inline void __restore_host_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
+}
+
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 hcr = vcpu->arch.hcr_el2;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c0e3fed26d93..d1f55514effc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -41,6 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
+	__restore_guest_mdcr_el2(vcpu);
 
 	val = vcpu->arch.cptr_el2;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
@@ -91,6 +92,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
+	__restore_host_mdcr_el2(vcpu);
 	__deactivate_traps_common(vcpu);
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5a2cb5d9bc4b..f85a13bfad3d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -89,10 +89,12 @@ NOKPROBE_SYMBOL(__deactivate_traps);
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
 	__activate_traps_common(vcpu);
+	__restore_guest_mdcr_el2(vcpu);
 }
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
+	__restore_host_mdcr_el2(vcpu);
 	__deactivate_traps_common(vcpu);
 }
 
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
