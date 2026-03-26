Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972D40F8D3;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=fd8VrRXdAd3cWar6dnTB8qVh8rzZFMjQf/qLKVDB+ijSMUeLbme+QSPCVae0sMIkp9WPF+jhZ8r0e24athv4ljnoJ67R+YZNB2ECFQ9izWkrr0Xz+hJtofaCXlMNyazmqk8OMHcaBub76sZ1CG6RnZLUt2u+SLJwRa9o55gx/FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=2fYqiw6OHmz+dB7/Hu1w+XYzk0VxCs/creDSwdedOIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgxzKlwzjYPdgF8o80C+AKN33nC+JP8HO40WK1UnXIDblG3TteyNfXYUaOnWIWGiHf6OK3u3RVMOBBVSOqcS/yIMOh7YGilxRt22Stdh6nD1mRRJgXCi2eF28HL50kHkBIbVw39iRV/ITOezh7knvh+PqhqCyouWlaGht/l712c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sq+JQyyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sq+JQyyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC68CC19423;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539338;
	bh=2fYqiw6OHmz+dB7/Hu1w+XYzk0VxCs/creDSwdedOIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sq+JQyyLJC6FhrALSKJJgwYNXXxmlQBGU43NDO8+lIs5W9eE2pTR69hH4HKhzHIck
	 kzTZK4D0HmKFlPnbshBFaFPAYy5JGAxM40p0tD4WqoLcIHNHhtME/XSaoZOm4VIKPJ
	 NljiNAVLnTRAqJpNkjdma3F2bXkzqDCcjnydHtGsd5St5Kmio8B90vdqF75qqCI98t
	 sSSNL/ZTlncHCx/go69cKHNOrvY1IQMBOEnueqhDf/5HI4jsoPRveDnFHMSnYePhKb
	 lprjaq0Vm3z/Zx2py0b4CCszPME5fQNVRL/hrFlIVRAaP2LKeOqFrZSh+XqtHkvm8O
	 uDWztHBzXf3gA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkD-000000060II-0F6r;
	Thu, 26 Mar 2026 15:35:37 +0000
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
Subject: [PATCH 13/15] KVM: arm64: Move GICv5 timer PPI validation into timer_irqs_are_valid()
Date: Thu, 26 Mar 2026 15:35:28 +0000
Message-ID: <20260326153530.3981879-14-maz@kernel.org>
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

Userspace can set the timer PPI numbers way before a GIC has been
created, leading to odd behaviours on GICv5 as we'd accept non
architectural PPI numbers.

Move the v5 check into timer_irqs_are_valid(), which aligns the
behaviour with the pre-v5 GICs, and is also guaranteed to run
only once a GIC has been configured.

Fixes: 9491c63b6cd7b ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6608c47d1f628..cbea4d9ee9552 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1543,6 +1543,10 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 		if (kvm_vgic_set_owner(vcpu, irq, ctx))
 			break;
 
+		/* With GICv5, the default PPI is what you get -- nothing else */
+		if (vgic_is_v5(vcpu->kvm) && irq != get_vgic_ppi(vcpu->kvm, default_ppi[i]))
+			break;
+
 		/*
 		 * We know by construction that we only have PPIs, so all values
 		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
@@ -1678,13 +1682,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return -ENXIO;
 	}
 
-	/*
-	 * The PPIs for the Arch Timers are architecturally defined for
-	 * GICv5. Reject anything that changes them from the specified value.
-	 */
-	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] != irq)
-		return -EINVAL;
-
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
-- 
2.47.3

