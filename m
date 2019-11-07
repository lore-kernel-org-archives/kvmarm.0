Return-Path: <SRS0=4x2k=Y7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FACC5DF61
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 16:04:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D3FB21D7E
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 16:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D3FB21D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 267394ACBC;
	Thu,  7 Nov 2019 11:04:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sCFgwXd1NFqV; Thu,  7 Nov 2019 11:04:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE464ACBD;
	Thu,  7 Nov 2019 11:04:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D11404AC83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 11:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tUFuJOtO-pS1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Nov 2019 11:04:24 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 952A44AC9E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 11:04:24 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iSkGk-0008Bm-Vh; Thu, 07 Nov 2019 17:04:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] KVM: arm64: Opportunistically turn off WFI trapping when
 using direct LPI injection
Date: Thu,  7 Nov 2019 16:04:12 +0000
Message-Id: <20191107160412.30301-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107160412.30301-1-maz@kernel.org>
References: <20191107160412.30301-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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

Just like we do for WFE trapping, it can be useful to turn off
WFI trapping when the physical CPU is not oversubscribed (that
is, the vcpu is the only runnable process on this CPU) *and*
that we're using direct injection of interrupts.

The conditions are reevaluated on each vcpu_load(), ensuring that
we don't switch to this mode on a busy system.

On a GICv4 system, this has the effect of reducing the generation
of doorbell interrupts to zero when the right conditions are
met, which is a huge improvement over the current situation
(where the doorbells are screaming if the CPU ever hits a
blocking WFI).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_emulate.h   | 4 ++--
 arch/arm64/include/asm/kvm_emulate.h | 9 +++++++--
 virt/kvm/arm/arm.c                   | 4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index e8ef349c04b4..9b118516d2db 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -95,12 +95,12 @@ static inline unsigned long *vcpu_hcr(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr;
 }
 
-static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr &= ~HCR_TWE;
 }
 
-static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr |= HCR_TWE;
 }
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7b835337f78b..5efe5ca8fecf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -87,14 +87,19 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
-static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count))
+		vcpu->arch.hcr_el2 &= ~HCR_TWI;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TWI;
 }
 
-static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= HCR_TWE;
+	vcpu->arch.hcr_el2 |= HCR_TWI;
 }
 
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4d07c968467a..12e0280291ce 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -416,9 +416,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
-		vcpu_clear_wfe_traps(vcpu);
+		vcpu_clear_wfx_traps(vcpu);
 	else
-		vcpu_set_wfe_traps(vcpu);
+		vcpu_set_wfx_traps(vcpu);
 
 	vcpu_ptrauth_setup_lazy(vcpu);
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
