Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1211D54F7
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214483; cv=none; b=XlbhjLU+mt0N0ViB6j/LVDXacdRz9eGePsYwxXeK9fBMBLsHTPNPbMKMS2sIpngtKXsW2z8f/tVgD2HEFx2ThBjTFJyhdPDbpow8lsk+C718/zwcz5J6Gz2CY7A0iAkBV0kHTOkWodAE/xVlO43CxlIqIuVSDpmPHZaO5GsWQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214483; c=relaxed/simple;
	bh=rYySAFkrUl3rwkTZVsA1ukPFpQ8n71LCbrbnKAflhS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GtcHhE3hfVch+H3BC/mTtCNxih05HwqJR9M9E3lGQPU4M6OebiAShCGQnC3BDcA5kTrhWAVcaCTzFEZ7UEFwgqry9pB2UFCSAQzBALcbyHXVLUiiJrB+iHqmyAT954RYDRiTAXppLJYvPrIJ6eSSwPOhWAdXjnHZPeyTBAmu7gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igF6mfnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igF6mfnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FE3C4CEE2;
	Wed,  9 Apr 2025 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214483;
	bh=rYySAFkrUl3rwkTZVsA1ukPFpQ8n71LCbrbnKAflhS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igF6mfntyVeu9ndFC0ATZNSViG9A+1J9Oryak/8aIUQmx+yWfdJFJzEUnmdzyEUPz
	 mA2jxM0Q1D0TEt+iGJKaqMnqX6esuR+ek/DiY6ZrSfEl1R3WTFuBX3XA1oIaDlFVZR
	 Sjm9ALCsG0jJ0GG6Zjq1khMnEGDuiTHLJ8Op5Q5qSUh4+fRLFzQrmhtseO/LperUZc
	 lIDBo7nErKGjuDSqbYkKJAdb686T0Lm5KgqAuowccdxXlLgyI19Qju/hey4hjZuMjG
	 e+j0iGEiYU/AZv5rhVauXE2KcxmuiPWI2VMKXpF/2Z0L3xa0IFXl5Yl5iqoO8pQky+
	 +BP5pHtqxVWUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrd-003vQT-7f;
	Wed, 09 Apr 2025 17:01:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 6/6] KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N
Date: Wed,  9 Apr 2025 17:01:06 +0100
Message-Id: <20250409160106.6445-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When EL2 is present, PMCR_EL0.N is the effective value of MDCR_EL2.HPMN
when accessed from EL1 or EL0.

Make sure we honor this requirement.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 01fda19b0c825..f9edd0a2427c2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1295,8 +1295,12 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 n = vcpu->kvm->arch.pmcr_n;
 
-	return u64_replace_bits(pmcr, vcpu->kvm->arch.pmcr_n, ARMV8_PMU_PMCR_N);
+	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
+		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+
+	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
 
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
-- 
2.39.2

