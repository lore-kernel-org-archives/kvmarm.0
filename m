Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655A5C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 21:14:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCCCF4B120;
	Tue,  3 May 2022 17:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dzbl-VfQC-74; Tue,  3 May 2022 17:14:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC5749EFB;
	Tue,  3 May 2022 17:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE9149EF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 17:14:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7DRkhKF-b1Xz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 17:14:37 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E15B49EB2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 17:14:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id AC9C9CE2264;
 Tue,  3 May 2022 21:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB33C385A4;
 Tue,  3 May 2022 21:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651612470;
 bh=Z+qBVyuiKyHCjqN2cFxue54ljZPsduykzYWjN4ET7iQ=;
 h=From:To:Cc:Subject:Date:From;
 b=X026q+MxHHIHh5x2jk5t/EVzRTVi4HKlrwquyoDd8TUWyHcbH3NPMfnAHqPF5roYQ
 k0aFUramlaWP+kZO7amlehN0Z3Z5mwFrhWVM9ieT6d58FoI3su+okys3JnBq2LqDuW
 VASb7z0je69iC2Y3z6p/9uAXmSDBWw71HRsf5PiCwxAs8qdS4HmeTMpmej+gZsOk1J
 G3URyqBo2BYabZ64xLINaLPMAHYKEJjrstVqDBoPeasF0/gE1/wBJIvyyXa0jzTCAp
 iffq7XkS9PPiBh93A3/igFIbWgELqTjw8FeUGn6mGWpD9eEfVmKZz84UnpitUFaOYk
 j/Sw1P8sGm2jg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nlzql-008kLI-Cv; Tue, 03 May 2022 22:14:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC
Date: Tue,  3 May 2022 22:14:24 +0100
Message-Id: <20220503211424.3375263-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel@android.com,
 stable@vger.kernel.org, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel@android.com, stable@vger.kernel.org
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

When adding support for the slightly wonky Apple M1, we had to
populate ID_AA64PFR0_EL1.GIC==1 to present something to the guest,
as the HW itself doesn't advertise the feature.

However, we gated this on the in-kernel irqchip being created.
This causes some trouble for QEMU, which snapshots the state of
the registers before creating a virtual GIC, and then tries to
restore these registers once the GIC has been created.  Obviously,
between the two stages, ID_AA64PFR0_EL1.GIC has changed value,
and the write fails.

The fix is to actually emulate the HW, and always populate the
field if the HW is capable of it.

Fixes: 562e530fd770 ("KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Peter Maydell <peter.maydell@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..adf408c09cdb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1123,8 +1123,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		if (irqchip_in_kernel(vcpu->kvm) &&
-		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
 		}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
