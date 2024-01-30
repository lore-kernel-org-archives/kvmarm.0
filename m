Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9A71B5C
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647551; cv=none; b=ov5sPsclAkWG/RxvCVhZwdCem9FuWq66Cp16q4rf3y8eezVIZNdjbR6iVPeAI3z64ocyMrYjMMyGtaPlSDBcJSPAGKo2Du8qUiQ1eeQ/wZejzltku8Nd1e1nw8TeFsWYy2WIfTsjj3Z51z9tJLOt/thrbHnAMs4/TK5E3FSjq2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647551; c=relaxed/simple;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BtZMdCDv6+g/XcSj5uLg0G1IOtitGTo9d6Bc3iJ25zDbACPSK8CzDlqDdkCZlfkfiyLS9NFI4YywBGo0BYPpfWV8a1NdqWZJ3NtkePMVOObsfmeYraRT+oWKO2enBoG1B46uKjQ+fWTrakkU2FU5a6sSwZ5Cws09heLmfVPIhWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G++wS60w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G++wS60w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1B8C433F1;
	Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647551;
	bh=dIJkF1mYYrrWiIgVuWE1ahoSVnnmnY+7OH6lcrJJCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G++wS60wzc6tAIeMVWhUer2z/p2lWUeob29VegsrVe2pSZjoWZr1OZtBI8XKtK4Sp
	 KNdhSnB0pd2IKMPXN8QAb473mzaQk+xck/mxUQyT+dwjAD+UkN6UylMn7Cw3qC8h4U
	 S3vkniQ5QZr74/QMwqwTQFn9jaiu6mgeUSUC2PI0YIrGfDpgsr9ImoDRqiq01M1idZ
	 K1Ih4CW6lRY5a4rF191npahY5hpNrZWfO9rOZDo2zgPP+U9uJbFZeD0IFSkNikvfyu
	 nOfWVy5Gl5x+375nJPX1nL/ZEeq172k93WHsMmTF3HT0G6hjadvk5ioyuDEHC0xgEL
	 sm5OmRVAONo5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzN-00GNsE-GE;
	Tue, 30 Jan 2024 20:45:49 +0000
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
Subject: [PATCH v2 23/25] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
Date: Tue, 30 Jan 2024 20:45:30 +0000
Message-Id: <20240130204533.693853-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
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

