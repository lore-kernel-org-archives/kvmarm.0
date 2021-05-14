Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54327C43462
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 10:40:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB81B61457
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 10:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB81B61457
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EBB04B5E1;
	Fri, 14 May 2021 06:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YfWQOtnAmx9J; Fri, 14 May 2021 06:40:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4A84B6F9;
	Fri, 14 May 2021 06:40:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2D44B4E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 06:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TyedFIxiOIce for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 06:40:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 431574B468
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 06:40:49 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 520F261458;
 Fri, 14 May 2021 10:40:48 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lhVFO-001N6Q-MS; Fri, 14 May 2021 11:40:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/2] KVM: arm64: Move __adjust_pc out of line
Date: Fri, 14 May 2021 11:40:41 +0100
Message-Id: <20210514104042.1929168-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514104042.1929168-1-maz@kernel.org>
References: <20210514104042.1929168-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, tabba@google.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org
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

In order to make it easy to call __adjust_pc() from the EL1 code
(in the case of nVHE), rename it to __kvm_adjust_pc() and move
it out of line.

No expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11
---
 arch/arm64/include/asm/kvm_asm.h           |  2 ++
 arch/arm64/kvm/hyp/exception.c             | 18 +++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ------------------
 arch/arm64/kvm/hyp/nvhe/switch.c           |  3 +--
 arch/arm64/kvm/hyp/vhe/switch.c            |  3 +--
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index cf8df032b9c3..d5b11037401d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -201,6 +201,8 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
+extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
+
 extern u64 __vgic_v3_get_gic_config(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 73629094f903..0812a496725f 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -296,7 +296,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	*vcpu_pc(vcpu) = vect_offset;
 }
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu)
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_el1_is_32bit(vcpu)) {
 		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
@@ -329,3 +329,19 @@ void kvm_inject_exception(struct kvm_vcpu *vcpu)
 		}
 	}
 }
+
+/*
+ * Adjust the guest PC on entry, depending on flags provided by EL1
+ * for the purpose of emulation (MMIO, sysreg) or exception injection.
+ */
+void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
+		kvm_inject_exception(vcpu);
+		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+				      KVM_ARM64_EXCEPT_MASK);
+	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
+		kvm_skip_instr(vcpu);
+		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
+	}
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 61716359035d..4fdfeabefeb4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,8 +13,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu);
-
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -43,22 +41,6 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 }
 
-/*
- * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg) or exception injection.
- */
-static inline void __adjust_pc(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
-		kvm_inject_exception(vcpu);
-		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
-				      KVM_ARM64_EXCEPT_MASK);
-	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
-		kvm_skip_instr(vcpu);
-		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
-	}
-}
-
 /*
  * Skip an instruction while host sysregs are live.
  * Assumes host is always 64-bit.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index e9f6ea704d07..f7af9688c1f7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,7 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
@@ -201,7 +200,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7b8f7db5c1ed..b3229924d243 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -4,7 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
 #include <linux/arm-smccc.h>
@@ -132,7 +131,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
