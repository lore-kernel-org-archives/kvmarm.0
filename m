Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBE3C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 08:26:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40A6661211
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 08:26:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 40A6661211
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA5E4B09C;
	Fri, 24 Sep 2021 04:26:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NozDbmEwT1ns; Fri, 24 Sep 2021 04:26:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D5BF4B13D;
	Fri, 24 Sep 2021 04:26:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1FF4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 04:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qIL93V8DqrfD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 04:25:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30C804B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 04:25:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2EBD261250;
 Fri, 24 Sep 2021 08:25:54 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mTgWm-00ChmL-I6; Fri, 24 Sep 2021 09:25:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/5] KVM: arm64: vgic-v3: Align emulated cpuif LPI state
 machine with the pseudocode
Date: Fri, 24 Sep 2021 09:25:42 +0100
Message-Id: <20210924082542.2766170-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924082542.2766170-1-maz@kernel.org>
References: <20210924082542.2766170-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 christoffer.dall@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Having realised that a virtual LPI does transition through an active
state that does not exist on bare metal, align the CPU interface
emulation with the behaviour specified in the architecture pseudocode.

The LPIs now transition to active on IAR read, and to inactive on
EOI write. Special care is taken not to increment the EOIcount for
an LPI that isn't present in the LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index b3b50de496a3..20db2f281cf2 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -695,9 +695,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 		goto spurious;
 
 	lr_val &= ~ICH_LR_STATE;
-	/* No active state for LPIs */
-	if ((lr_val & ICH_LR_VIRTUAL_ID_MASK) <= VGIC_MAX_SPI)
-		lr_val |= ICH_LR_ACTIVE_BIT;
+	lr_val |= ICH_LR_ACTIVE_BIT;
 	__gic_v3_set_lr(lr_val, lr);
 	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
 	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
@@ -764,20 +762,18 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	/* Drop priority in any case */
 	act_prio = __vgic_v3_clear_highest_active_priority();
 
-	/* If EOIing an LPI, no deactivate to be performed */
-	if (vid >= VGIC_MIN_LPI)
-		return;
-
-	/* EOImode == 1, nothing to be done here */
-	if (vmcr & ICH_VMCR_EOIM_MASK)
-		return;
-
 	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
 	if (lr == -1) {
-		__vgic_v3_bump_eoicount();
+		/* Do not bump EOIcount for LPIs that aren't in the LRs */
+		if (!(vid >= VGIC_MIN_LPI))
+			__vgic_v3_bump_eoicount();
 		return;
 	}
 
+	/* EOImode == 1 and not an LPI, nothing to be done here */
+	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >= VGIC_MIN_LPI))
+		return;
+
 	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 
 	/* If priorities or group do not match, the guest has fscked-up. */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
