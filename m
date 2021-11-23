Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20434C43217
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 14:23:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F9F4B1F2;
	Tue, 23 Nov 2021 09:23:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l9B+oe9ZOhaw; Tue, 23 Nov 2021 09:23:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059344B1F5;
	Tue, 23 Nov 2021 09:23:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0934B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:23:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5SKGq6k4dSm6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 09:22:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 579C54B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:22:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9E93060F24;
 Tue, 23 Nov 2021 14:22:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mpWhE-007Ijf-QQ; Tue, 23 Nov 2021 14:22:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] KVM: arm64: Move pkvm's special 32bit handling into a
 generic infrastructure
Date: Tue, 23 Nov 2021 14:22:47 +0000
Message-Id: <20211123142247.62532-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123142247.62532-1-maz@kernel.org>
References: <20211123142247.62532-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org,
 qperret@google.com, tabba@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

Protected KVM is trying to turn AArch32 exceptions into an illegal
exception entry. Unfortunately, it does that it a way that is a bit
abrupt, and too early for PSTATE to be available.

Instead, move it to the fixup code, which is a more reasonable place
for it. This will also be useful for the NV code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 8 +-------
 arch/arm64/kvm/hyp/vhe/switch.c         | 4 ++++
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d79fd101615f..96c5f3fb7838 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -403,6 +403,8 @@ typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu);
 
+static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code);
+
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
  *
@@ -435,6 +437,12 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 */
 	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
 
+	/*
+	 * Check whether we want to repaint the state one way or
+	 * another.
+	 */
+	early_exit_filter(vcpu, exit_code);
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c0e3fed26d93..d13115a12434 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -233,7 +233,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
  * Returns false if the guest ran in AArch32 when it shouldn't have, and
  * thus should exit to the host, or true if a the guest run loop can continue.
  */
-static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
@@ -248,10 +248,7 @@ static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
 		vcpu->arch.target = -1;
 		*exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
 		*exit_code |= ARM_EXCEPTION_IL;
-		return false;
 	}
-
-	return true;
 }
 
 /* Switch to the guest for legacy non-VHE systems */
@@ -316,9 +313,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
-		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
-			break;
-
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5a2cb5d9bc4b..fbb26b93c347 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -112,6 +112,10 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 	return hyp_exit_handlers;
 }
 
+static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+}
+
 /* Switch to the guest for VHE systems running in EL2 */
 static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
