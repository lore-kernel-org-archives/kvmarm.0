Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893A3D411D
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271330; cv=none; b=aZyy0lV8UNu7QYWKb79H+gu1MYUuwt1x6DVvwUFfqoULyp6YxlI/TxJkk9vsmR+4OQlqgV9Oz3k0cAwO46H31rGXrjUiHip+5aFmxpWuK8J8IzxlHgIuOKOL7wkC8yep77yWSs5NlRj5/ya5RuYtrz0gTQhuK9f3KRlB82NMeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271330; c=relaxed/simple;
	bh=zmTHRbqvdO6YgFMCB1EjlqeWTJtdKLUjBdbO9zAJeJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Ixoq/3hdUrkxFZlAVqPHsVMuTmVP2VdJEWZ/4IKwJuang6z3kxyRaHfxioMpv50PcZFtKcU2G9IWPV4HiWLhLqOOdkur2+Duqgb0ZtX8exRwFb1A4GN1fzS6tXciLCcjukRH5rFoPzYAfIu1YooL1gLDHWkYnxSMzY9jb3SD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDdglb5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDdglb5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8BD1F00898;
	Wed, 20 May 2026 10:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271328;
	bh=7qDdgNw3wr59AMPU8l8T1ufu00uEQQhbsgv+u5LQwMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDdglb5FMkREUIUuC5ulzHP5LkovcZ0CMp2WDgvGOBEw7S1OB/TZ53E3dyT2BN6sz
	 1XXeweotQbOtJiwgFeAKrcTvZZzlmq7ywk5TDISLtdYIZfL82gmJ0RhcsVP1l7v0zA
	 GmqgtknJXbULTJdueyevhqwlUiGkvWtZ6cEY69NHDCyBCmumm7+GFCH1UF3Hx9mX+5
	 /+ANckf3ZfV8l5ufpKt7KR629iwpHPxmvJQ4BSx9Zjf6uovRX41R986OrNoxymjinI
	 8JkGuQlaZaoa1JK0KZaz4iWCIq7NqvCLId82wgp6Zuj8gUZRA4i3+OlElrpRKaq/PP
	 U3XZPnuhYnz+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkc-00000004Jio-15Vo;
	Wed, 20 May 2026 10:02:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 4/6] KVM: arm64: pmu: Kill the PMU interrupt level cache
Date: Wed, 20 May 2026 11:01:58 +0100
Message-ID: <20260520100200.543845-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like the timer, the PMU has an interrupt cache that serves little
purpose. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 13 +++----------
 include/kvm/arm_pmu.h     |  1 -
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 31a472a2c4881..edb21239478a9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -396,19 +396,12 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	bool overflow;
 
-	overflow = kvm_pmu_overflow_status(vcpu);
-	if (pmu->irq_level == overflow)
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		return;
 
-	pmu->irq_level = overflow;
-
-	if (likely(irqchip_in_kernel(vcpu->kvm))) {
-		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
-					      pmu->irq_num, overflow, pmu);
-		WARN_ON(ret);
-	}
+	WARN_ON(kvm_vgic_inject_irq(vcpu->kvm, vcpu, pmu->irq_num,
+				    kvm_pmu_overflow_status(vcpu), pmu));
 }
 
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3e844c5ee9174..b5e5942204fc6 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -32,7 +32,6 @@ struct kvm_pmu {
 	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
 	int irq_num;
 	bool created;
-	bool irq_level;
 };
 
 struct arm_pmu_entry {
-- 
2.47.3

