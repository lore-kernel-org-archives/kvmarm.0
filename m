Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722E3C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:07:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6F84B178;
	Mon, 29 Nov 2021 15:07:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XTzK+yuivrnR; Mon, 29 Nov 2021 15:07:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E484B1DB;
	Mon, 29 Nov 2021 15:07:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2794B106
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKYccg2xt6Ym for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:11 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85AF84B178
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:09 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 99673B8159E;
 Mon, 29 Nov 2021 20:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8EC53FD0;
 Mon, 29 Nov 2021 20:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216428;
 bh=KL8kMrCOfU3Bi8GZMSXLpGFz3bOYBmmc7KK3lpfO310=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DRJmlyqaOSLX0sOWghGpFawVs8A6Zf/5sttywwz+Lmx8SuMRCS6Xx4KpZiY40QL/N
 CD91mctsCItLeSZ/S5Uy997IHLx+mFI11gSzwcMnV65UY/eUNzOHuZJB7cEv3mQuVy
 gbtG+uzR01rbmPuMf7g/wpzDnvJHhHLt5KCFtoTk8DhvNC5brgu2v7dBPX2/VyFB4+
 IP9/D1iXXy2QH1L39TCGYQ52ihigD9IVbtxBZLBb3okVFZgvBifkcEZCPguKk+gMhY
 gLzOqCRe8i/7ufXpNyN4QaRH2d0XxBnmG7KKyLN5kK69vsLwA8QNr/jGNTtcL67Ja+
 wYRWsTW1YFbcA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqt-008gvR-MB; Mon, 29 Nov 2021 20:02:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 20/69] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Date: Mon, 29 Nov 2021 20:01:01 +0000
Message-Id: <20211129200150.351436-21-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
we deal with a lot of the state. So when the guest flips this bit
(sysregs are live), do the put/load dance so that we have a consistent
state.

Yes, this is slow. Don't do it.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 875040bcfbe1..c1408dff58fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -183,9 +183,24 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		goto memory_write;
 
 	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
+		bool need_put_load;
+
 		if (!is_hyp_ctxt(vcpu))
 			goto memory_write;
 
+		/*
+		 * HCR_EL2.E2H is nasty: it changes the way we interpret a
+		 * lot of the EL2 state, so treat is as a full state
+		 * transition.
+		 */
+		need_put_load = ((reg == HCR_EL2) &&
+				 vcpu_el2_e2h_is_set(vcpu) != !!(val & HCR_E2H));
+
+		if (need_put_load) {
+			preempt_disable();
+			kvm_arch_vcpu_put(vcpu);
+		}
+
 		/*
 		 * Always store a copy of the write to memory to avoid having
 		 * to reverse-translate virtual EL2 system registers for a
@@ -193,6 +208,11 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		if (need_put_load) {
+			kvm_arch_vcpu_load(vcpu, smp_processor_id());
+			preempt_enable();
+		}
+
 		switch (reg) {
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
