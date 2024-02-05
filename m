Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76E171B6
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129291; cv=none; b=m72qGEu5r4S5PTqZJxKy1YvZWEIysGVFc4Qx8T/r3BwDqDluzdsibH623gLijxygVNKgtxiPV2vp9Ca/E3kcj3qBq2+faaosGez+SzMzh97eMEKo09DwsrMfBx2NNL4cQBVy7Hk3wkTbFv3tcmu/q7QI7dGzrtb/ywPfaodCe9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129291; c=relaxed/simple;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MQidhni7+rsL7e+Hn0+Om1JqVxzcmxskSkvsfdVZ84UVlkQS35XVyw9N1pJIFpTh0MCzIB8gZzkEVh2MAjRMAGQ+4Z8fLQGbjNz2OuV+J/s4515Pqy3dxXtb2L1Ygr7jPXuTVoqlTl3bfbgNVFxLCYa8rDgO9ULYrHW/OQEWIgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er17CJti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er17CJti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A02C433F1;
	Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129291;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Er17CJtiVMWFa5j0zYBY8uMo4KBboyJZKnzNV/OuqkJSabLZ8dca0dPXbo6sAwSun
	 MEqX4dT6M8gikHpcLWWsoZmBl4v+LkwF8Fw1NU6D6BXShSOPTvvrTWixbERQAQ3To9
	 ipgBvDQECgDFHHEjgVACPg0vTcb74D7CgPpTabUum4YOXvYL6sfm6e+u5++QbVDhzO
	 7X0s2NcuOobJ5wv4enmDyWRgzCGEsvorQRaKzq7LmtW0I+/t1KLUS+38qjTwy3b6ug
	 gvJgIcWahBn4Sulxuj7sb+Z0YJhv9omaUeB4z4vHwZX7BTX1f+q6JEIFn/sCvyQDaL
	 VsetO1nOMbduw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJN-000Nc3-L0;
	Mon, 05 Feb 2024 10:34:49 +0000
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
Subject: [PATCH v3 23/26] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
Date: Mon,  5 Feb 2024 10:34:28 +0000
Message-Id: <20240205103431.1104133-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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

