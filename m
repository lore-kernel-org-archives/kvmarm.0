Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51715C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:28:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB18961629
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:28:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB18961629
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7674B2A0;
	Mon, 10 May 2021 13:28:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wtsx5haZ6iNs; Mon, 10 May 2021 13:28:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6222C4B844;
	Mon, 10 May 2021 13:28:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D261B4B2A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id erZuEmUux2q5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 13:28:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 238964B863
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 402C461625;
 Mon, 10 May 2021 17:28:28 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg9Gr-000Uqg-44; Mon, 10 May 2021 18:00:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v4 64/66] KVM: arm64: nv: Enable ARMv8.4-NV support
Date: Mon, 10 May 2021 17:59:18 +0100
Message-Id: <20210510165920.1913477-65-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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

As all the VNCR-capable system registers are nicely separated
from the rest of the crowd, let's set HCR_EL2.NV2 on and let
the ball rolling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h     |  1 +
 arch/arm64/include/asm/kvm_emulate.h | 23 +++++++++++++----------
 arch/arm64/include/asm/sysreg.h      |  1 +
 arch/arm64/kvm/hyp/vhe/switch.c      | 14 +++++++++++++-
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6a4a11fcc9df..ce682bcce56f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -14,6 +14,7 @@
 /* Hyp Configuration Register (HCR) bits */
 #define HCR_ATA		(UL(1) << 56)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV2		(UL(1) << 45)
 #define HCR_AT		(UL(1) << 44)
 #define HCR_NV1		(UL(1) << 43)
 #define HCR_NV		(UL(1) << 42)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 50e31006dc07..2f57c5aa2ac5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -242,21 +242,24 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 
 static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
 {
-	if (!__vcpu_el2_e2h_is_set(ctxt)) {
-		/*
-		 * Clear the .M field when writing SPSR to the CPU, so that we
-		 * can detect when the CPU clobbered our SPSR copy during a
-		 * local exception.
-		 */
-		val &= ~0xc;
-	}
+	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	if (enhanced_nested_virt_in_use(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
+		return val;
 
-	return val;
+	/*
+	 * Clear the .M field when writing SPSR to the CPU, so that we
+	 * can detect when the CPU clobbered our SPSR copy during a
+	 * local exception.
+	 */
+	return val &= ~0xc;
 }
 
 static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
 {
-	if (__vcpu_el2_e2h_is_set(ctxt))
+	struct kvm_vcpu *vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	if (enhanced_nested_virt_in_use(vcpu) || __vcpu_el2_e2h_is_set(ctxt))
 		return val;
 
 	/*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 286b09dbfc61..ff12d4c8b2d8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -544,6 +544,7 @@
 #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b665a3cc288e..bd4ae1296de4 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -46,7 +46,13 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			 * the EL1 virtual memory control register accesses
 			 * as well as the AT S1 operations.
 			 */
-			hcr |= HCR_TVM | HCR_TRVM | HCR_AT | HCR_TTLB | HCR_NV1;
+			if (enhanced_nested_virt_in_use(vcpu)) {
+				hcr &= ~HCR_TVM;
+			} else {
+				hcr |= HCR_TVM | HCR_TRVM | HCR_TTLB;
+			}
+
+			hcr |= HCR_AT | HCR_NV1;
 		} else {
 			/*
 			 * For a guest hypervisor on v8.1 (VHE), allow to
@@ -78,6 +84,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			if (!vcpu_el2_tge_is_set(vcpu))
 				hcr |= HCR_AT | HCR_TTLB;
 		}
+
+		if (enhanced_nested_virt_in_use(vcpu)) {
+			hcr |= HCR_AT | HCR_TTLB | HCR_NV2;
+			write_sysreg_s(vcpu->arch.ctxt.vncr_array,
+				       SYS_VNCR_EL2);
+		}
 	} else if (nested_virt_in_use(vcpu)) {
 		hcr |= __vcpu_sys_reg(vcpu, HCR_EL2);
 	}
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
