Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0765EC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:28:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94E054B25A;
	Tue, 19 Apr 2022 14:28:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w5jNjmIley2w; Tue, 19 Apr 2022 14:28:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B97E4B279;
	Tue, 19 Apr 2022 14:28:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1C44B256
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPmoPpR5WYY7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:28:09 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F385F4B235
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7611561532;
 Tue, 19 Apr 2022 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C684C385B2;
 Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650392887;
 bh=uUy+JlNuQdHl8MYE1bsgBcntAZLzj7MRRZFVM5ah/YA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=htkI+9Y1ILPdrJBWwM7DGoa71dAMjbbgr1ttYed712X/j9g9W7bwMmmadkxS8fseZ
 KejS5ydt4kCdhTSyQCn/orOCCjhuFI9hJL34y36mNgJCUFOaoTshu0pQ/78+dkdGw1
 cLFpT0ywahbO2pi8ezQ+FK3t7zgQ4++JagoeNxKTmHZMQ7fxksF4cHUA33L0pNoNQw
 HjT76SgNtD22DvyOHubJYKN7w5SuJ0NX4lxjC5vUtHi21iyB+YorTnK8ZFkOPG+5zF
 l10HJeIusiDv5WK30KASriP2aFk/sOKUDAU3rqaA/Cq0V83WKtpzscJqQvtL2//01n
 myZuU/KdgH0jA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ngsa5-005QYF-K3; Tue, 19 Apr 2022 19:28:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 06/10] KVM: arm64: Offer early resume for non-blocking WFxT
 instructions
Date: Tue, 19 Apr 2022 19:27:51 +0100
Message-Id: <20220419182755.601427-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>
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

For WFxT instructions used with very small delays, it is not
unlikely that the deadline is already expired by the time we
reach the WFx handling code.

Check for this condition as soon as possible, and return to the
guest immediately if we can.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 4260f2cd1971..7726b01dc09a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -80,12 +80,14 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
  *
  * @vcpu:	the vcpu pointer
  *
- * WFE: Yield the CPU and come back to this vcpu when the scheduler
+ * WFE[T]: Yield the CPU and come back to this vcpu when the scheduler
  * decides to.
  * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
  * world-switches and schedule other host processes until there is an
  * incoming IRQ or FIQ to the VM.
  * WFIT: Same as WFI, with a timed wakeup implemented as a background timer
+ *
+ * WF{I,E}T can immediately return if the deadline has already expired.
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
@@ -94,15 +96,35 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
-		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		if ((esr & (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT)) == (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT))
+	}
+
+	if (esr & ESR_ELx_WFx_ISS_WFxT) {
+		if (esr & ESR_ELx_WFx_ISS_RV) {
+			u64 val, now;
+
+			now = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_TIMER_CNT);
+			val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+
+			if (now >= val)
+				goto out;
+		} else {
+			/* Treat WFxT as WFx if RN is invalid */
+			esr &= ~ESR_ELx_WFx_ISS_WFxT;
+		}
+	}
+
+	if (esr & ESR_ELx_WFx_ISS_WFE) {
+		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
+	} else {
+		if (esr & ESR_ELx_WFx_ISS_WFxT)
 			vcpu->arch.flags |= KVM_ARM64_WFIT;
+
 		kvm_vcpu_wfi(vcpu);
 	}
-
+out:
 	kvm_incr_pc(vcpu);
 
 	return 1;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
