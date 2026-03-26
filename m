Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121E4035CF;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539336; cv=none; b=KsLZmRHgGQoXDxHaocESf+npFl083ecrRjp/B2CPST1jSu6EjCWtRbZeTapOFPUKthTpQuBcCzQtmRujC/96p5642RbyRrUrd60mWqqjeBFgdCVNsdbfGhuyUvafQxtMrrEgB83Hkmvxl7aAHAC1G8bSTDIAdBaIwbvhn6ntb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539336; c=relaxed/simple;
	bh=L1mSvPjSIYoG8LtAIHtXZGudc3PJdk/BtNGgyIfZ3nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfqN5boT2uXLj7v+JoFLzDaaSK82w77n2ONRNoUuJXb2U+tibbUHd142ZbNaV49blxuMVTWVRdEWppUP1HclOuFn4Ku8lrAm4BySKZH4Z/gQA/AGr1aE63HlTVHR7mU8F3iZ+GbXIKgEtUqCRmjKc0/UZFqyIIGfX951tn5xVLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfoV327f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfoV327f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB4BC2BCB4;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539336;
	bh=L1mSvPjSIYoG8LtAIHtXZGudc3PJdk/BtNGgyIfZ3nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfoV327fJ0oy9O00rrNJkeQYzD5b3uvDehN/+psrdwR157578h7h9M+lGiPGSvKVP
	 sQamcXC5qi8JdRKa5DeY9bDyT1wQDUvUUG+DNm9fIA98P9rBAI/sOo8zjBkMZtC+s7
	 ntLMPbqbi37po59lYuAAxE2qqzzWi+4zsxjDK0LyPLCb6E7a5K2H7Itum3VCSJCTMf
	 SQPAwLUa2e/uwUiPzd2idLPowOxP3ewf/OW2LCxEDY+mJQE5VTm8xx6neq7trcHRMa
	 7lFAB2aYj/cljuE8w+1rK/q00wbltrTT3jGRUJdgGV6XPGvhjCWsyvYDacZrzbPs0c
	 kNsFL2VGUbxeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkA-000000060II-1qbh;
	Thu, 26 Mar 2026 15:35:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 01/15] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
Date: Thu, 26 Mar 2026 15:35:16 +0000
Message-ID: <20260326153530.3981879-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we are OK with rewriting idregs at finalize time, resetting
the guest's cpuif (GICv3) or redistributor (GICv3) addresses once
we start running the guest is a pretty bad idea.

Move back this initialisation to vgic creation time.

Fixes: a258a383b9177 ("KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE")
Link: https://patch.msgid.link/20260323174713.3183111-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 47169604100f2..fd872079f2a24 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -147,6 +147,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		break;
+	}
+	
 	/*
 	 * We've now created the GIC. Update the system register state
 	 * to accurately reflect what we've created.
@@ -684,10 +693,8 @@ void kvm_vgic_finalize_idregs(struct kvm *kvm)
 
 	switch (type) {
 	case KVM_DEV_TYPE_ARM_VGIC_V2:
-		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 		break;
-- 
2.47.3

