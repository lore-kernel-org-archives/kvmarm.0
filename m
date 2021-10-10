Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5CC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 580C46109E
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 580C46109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ECB14B11C;
	Sun, 10 Oct 2021 11:09:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FM+hjWGD8ufj; Sun, 10 Oct 2021 11:09:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB434B134;
	Sun, 10 Oct 2021 11:09:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D11284B0C0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SOEYxUoIdMvj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B0A54B0C3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CC75C610D1;
 Sun, 10 Oct 2021 15:09:25 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZaS4-00FrmD-22; Sun, 10 Oct 2021 16:09:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 5/5] KVM: arm64: vgic-v3: Align emulated cpuif LPI state
 machine with the pseudocode
Date: Sun, 10 Oct 2021 16:09:10 +0100
Message-Id: <20211010150910.2911495-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010150910.2911495-1-maz@kernel.org>
References: <20211010150910.2911495-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Joey Gouly <joey.gouly@arm.com>
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
