Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E14C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D675560F6E
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 15:09:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D675560F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 894DF4B139;
	Sun, 10 Oct 2021 11:09:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eqH++LdxLCTG; Sun, 10 Oct 2021 11:09:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E47C04B0C3;
	Sun, 10 Oct 2021 11:09:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEBB04B0D7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ly2b354meJ-o for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 11:09:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC54F4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 11:09:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B0A6360F58;
 Sun, 10 Oct 2021 15:09:24 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZaS2-00FrmD-Pw; Sun, 10 Oct 2021 16:09:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing
 a virtual GICv3
Date: Sun, 10 Oct 2021 16:09:06 +0100
Message-Id: <20211010150910.2911495-2-maz@kernel.org>
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

Until now, we always let ID_AA64PFR0_EL1.GIC reflect the value
visible on the host, even if we were running a GICv2-enabled VM
on a GICv3+compat host.

That's fine, but we also now have the case of a host that does not
expose ID_AA64PFR0_EL1.GIC==1 despite having a vGIC. Yes, this is
confusing. Thank you M1.

Let's go back to first principles and expose ID_AA64PFR0_EL1.GIC=1
when a GICv3 is exposed to the guest. This also hides a GICv4.1
CPU interface from the guest which has no business knowing about
the v4.1 extension.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..0e8fc29df19c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1075,6 +1075,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+		if (irqchip_in_kernel(vcpu->kvm) &&
+		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
+		}
 		break;
 	case SYS_ID_AA64PFR1_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
