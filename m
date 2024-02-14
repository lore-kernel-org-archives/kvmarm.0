Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BF53800
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916717; cv=none; b=pS1xCG3Q82tLwNNwkkZzNNUiNFT2dQMP+ILBpOjN7cmpw407MPjLJDQgmhJnPK0x3SbqkIp9HcX1g5CppI1BeJzoaByJIWR4yEk7kTQLNBTuOnAma5YHkySGGkfmSr9G6CazsEi2iUTvm2zUmbglwPFrqI4UdDr1GLLmNZ71keQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916717; c=relaxed/simple;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EwRWlI++whhqIfBHRQUIaspMKB7CLv8KeQCqV3js8MfBmnxsPQcT8Y25L3VXcqsubpuCB7xF25K/iHfK3iaye2lCwpU904bxU3Na+evNv/5B/1+Ln/MtsLUo6ed3Ejw+NAasfCajyx8JYScQ7Vk7yyH3Qqsi/+8qE0R1ic/omnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o6jAYNc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6jAYNc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58157C433C7;
	Wed, 14 Feb 2024 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916717;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6jAYNc03KQx5iRwjo/wQ9iEgiHkyK3IkKifSWlvzaZEar7gPsgAsk2tASbXwmRyz
	 sBPMhc8WCBM60GdWK5nedOyN/vBDKL5d7zGD2kFfmt6NltVN9myeRyvi/6vm0d+aOs
	 CTrP3AhZFAGGHPDA9CfLgbXs6EmqRvRdtQ4nQJn3EQ/F+ZR7TRoFRXYwpqraGFwJSE
	 r5yz/zRtpcpc/+TNfCNxCHGKFGzVFHSdQxw3UD42m5yBoiVz5bkVXmXAES4TZuPQRG
	 NJ2xn0uiwFMcyXpOaJaEueJg0ALSOBb6OLYrBrBMyotnIQ2y9WHssLyT56JOmM9X/l
	 OBlNhGllt9yrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9n-00394l-EA;
	Wed, 14 Feb 2024 13:18:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 23/26] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
Date: Wed, 14 Feb 2024 13:18:24 +0000
Message-Id: <20240214131827.2856277-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

No AMU? No AMU! IF we see an AMU-related trap, let's turn it into
an UNDEF!

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index da9db99c77e7..38ed47bd29db 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3998,6 +3998,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
+		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
+						  HAFGRTR_EL2_RES1);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

