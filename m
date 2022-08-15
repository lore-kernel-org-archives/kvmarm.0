Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B9DC00140
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C6D4D893;
	Mon, 15 Aug 2022 18:58:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hEzOXgBUogqg; Mon, 15 Aug 2022 18:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AECD44D8BC;
	Mon, 15 Aug 2022 18:58:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DF104D873
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NTypnva5oFX0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:18 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93F594D878
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:17 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1C99F612C8;
 Mon, 15 Aug 2022 22:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC4BC433D6;
 Mon, 15 Aug 2022 22:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604296;
 bh=Oo8tA9qAycNOy/2ZCjmWZDTw4zdgVSiZ1gS2qLzkDmA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HVN5hxzeL3dk2zciEWXKy4XJf9KioQCdfmdrNwUZKgIq8T/BTZilg8uw/NZOlBV6B
 tB1uZkPx8HoBKTSdcct3Ps6JTn9tMkCtBe33NNAN94PLq9UwI3d84KliSDFgM6RtIa
 qA2Im47AY4tpBvYAwdcC2kdw/NC0aR60P/eB0yP+2eUhwRYv60FDsVhuwBeHuSF3yJ
 KCI1LXz4lgE8vwRlzT67Ge9o+u4/K/Vw/LjWBB7rEe11UssUiAA+jiP08BUEm+MeLY
 2B+W8mdUm8zs3Z0c5qUvdxL1EklMOT5gR815Ng08fgM+BMwmqTki2Uu7uKbZW0RxiR
 sK7frb2dYoRIA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 4/7] arm64/fpsimd: Stop using TIF_SVE to manage register
 saving in KVM
Date: Mon, 15 Aug 2022 23:55:26 +0100
Message-Id: <20220815225529.930315-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2622; i=broonie@kernel.org;
 h=from:subject; bh=Oo8tA9qAycNOy/2ZCjmWZDTw4zdgVSiZ1gS2qLzkDmA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7d9Q4o9ZKtH6fZShdkJLhXfnQAd8XVGOykhCKD
 W6mfGo6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO3QAKCRAk1otyXVSH0IuCB/
 9k4aa+J6p3yasms/u/GRdPz2s6O5ioND1u+Rav/PBnjon0kZjIYsI9pcLiSVSls0nh6BRsv6Dt1KfU
 h7em3/0maONAbD0m7sIc2JqciTdDl4r+mBSMOgGRKi8J80wgp8OPpotraPn4/hUbv2y+Ka0P+ajsVb
 Of9mn3cP3nZAORNhceTPUV0YaReSCiIvtoW2xpuzJaBCF2GdGGltILev59VC05bMBwuN1Y+skFtZD/
 Z93/XbqHKfIvfkBBzyCw6HseTbvBGcVIwRL0rYk6griP5boNJAUeL3HDYKQ+5D2SiH2xqdh532as4m
 aiT/FbewrdM57l3dCtLi3qTWj8shm2
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Now that we are explicitly telling the host FP code which register state
it needs to save we can remove the manipulation of TIF_SVE from the KVM
code, simplifying it and allowing us to optimise our handling of normal
tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
to_save to ensure we save the correct data for it.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 22 ++++------------------
 arch/arm64/kvm/fpsimd.c    |  3 ---
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 7be20ced2c45..aaea2dc02cbd 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -436,8 +436,8 @@ static void task_fpsimd_load(void)
  * last, if KVM is involved this may be the guest VM context rather
  * than the host thread for the VM pointed to by current. This means
  * that we must always reference the state storage via last rather
- * than via current, other than the TIF_ flags which KVM will
- * carefully maintain for us.
+ * than via current, if we are saving KVM state then it will have
+ * ensured that the type of registers to save is set in last->to_save.
  */
 static void fpsimd_save(void)
 {
@@ -454,27 +454,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
+	if ((last->to_save == FP_STATE_TASK && test_thread_flag(TIF_SVE)) ||
+	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
 		vl = last->sve_vl;
 	}
 
-	/*
-	 * For now we're just validating that the requested state is
-	 * consistent with what we'd otherwise work out.
-	 */
-	switch (last->to_save) {
-	case FP_STATE_TASK:
-		break;
-	case FP_STATE_FPSIMD:
-		WARN_ON_ONCE(save_sve_regs);
-		break;
-	case FP_STATE_SVE:
-		WARN_ON_ONCE(!save_sve_regs);
-		break;
-	}
-
 	if (system_supports_sme()) {
 		u64 *svcr = last->svcr;
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index db0b2bacaeb8..8a79823fce68 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -151,7 +151,6 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
@@ -208,7 +207,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
-	update_thread_flag(TIF_SVE, 0);
-
 	local_irq_restore(flags);
 }
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
