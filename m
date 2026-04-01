Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC4B38644D;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039791; cv=none; b=ZNeg33us2QgNT6jQ3gwIAgtsHCnR9XRvAR1rKWzjHQJii1YvOLlY4MRmtfUavjOFLRTVpzxvEUSP/fu8oObbJvs0I2h3ZjKtcFVGT8/XrvdNLfbpYXFxb9yaOIglHEQgv4esXgnPdqrsSX5/+6V3jN5/b7dqKPq3lVRD3rZ7tYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039791; c=relaxed/simple;
	bh=0Dwza5wtWzXLnzyMRtfcuvqkajZMUXf1iFoYojfEAEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIziHNuEctbjlQa25e4sewsWO+aLy+AvJbiRjcScAs3IXHn4Ub9uuCVrIDFZuuy1pLOSH2jlVUba1LfPJoyrmcxiK0DFBaPaAiwYvCAbK/KAAvxHko07ZEP/gxTcFFGyojKUsk04qaUH1Ite/QdRkO16etEs49BpjiuSavSC96A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfusRmbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfusRmbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54070C2BC9E;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039791;
	bh=0Dwza5wtWzXLnzyMRtfcuvqkajZMUXf1iFoYojfEAEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfusRmbS0ULclFjgxQqLhWPcuON1OM3epb1skIZ0d+Ht4hxnGN68orOf2TAmq2EIu
	 z0fTQmxVqbupBLjXkA2qlEpLVWlkI8hyN2luuyW/gqS5yDnYPKmNEQ6Y5L0QVLm2v9
	 1hMxiNrJoARgvrFAlTpBdGJxtGzvnDGkEUSVP1oBqWi3mqZF7gehXoPUiIMh++3rOm
	 UQKAQBh2/8YM0qe2BmXa6P0g7/43zvnwBCBfusYvT1gR1jhn8Z710uaD3vZleUjjby
	 LzrO05SqkfGY8k7avmzNF2VGZ/EHFURlwwOo+2pVdwNdQS/zv/lMBaDm/EvPs3kh6R
	 jy7dqQd6ngTFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw1-00000007oRQ-1rpa;
	Wed, 01 Apr 2026 10:36:29 +0000
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
Subject: [PATCH v2 01/16] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
Date: Wed,  1 Apr 2026 11:35:56 +0100
Message-ID: <20260401103611.357092-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
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

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
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

