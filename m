Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3C9223DD5
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115190; cv=none; b=g2G9CDX5sr1amNKqL/CJTwxOD+OIN0aR3Xxm4MQFddwDwo499h19ORVJLKSIWnTu8e+Z+RTpQRDQgaIj6m2JdV55fsTEeh/OiH0JkwdlcXkRwGUPJuMFs81lg5Bv815rVGGBAtd7VuxnHLkTQT+93gBiG3aFh2yTvhbjQ5g6ZHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115190; c=relaxed/simple;
	bh=tcxJrBQThmJXpzrxEP1b0alQaWlChu5xzeKdJB4B078=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ozh0GLu1DVSEvt1+Z5HoIOGS4VLfcN7Pk/hy6SckAF/+KeLAJtawXJjM8MS/OhiuZYMN7YaujGH4oJab7RbCP7S9tW8PUZbnI4Njazii0+dPbEB6rVTZVE8BOef50WpnBG/KhNFfNQp2r3T8tJiqeGyc15gclVWgcr2/8iLJ0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FSHL3ijw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FSHL3ijw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5l6UQN67gdtTgOANxxhIo1cbeQBSAgTDOgoJBDvC88U=;
	b=FSHL3ijwZYHiyda2aPBpVFQcX+axMWTMbJA5wePlmF04sNYTqUuf4ewijj3IqWSo14HZKO
	ksr9JCbvIov6UkAmPR3odMTYGRZzVJeBoh6//LWJLGTKx+m7E32zmmo2yPl330zY2INqA5
	hkKLrW9zykOVY7PLUnxlZ/0Ga7Df+WY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 22/27] KVM: arm64: Advertise support for FEAT_DoubleFault2
Date: Mon, 16 Jun 2025 16:03:03 -0700
Message-Id: <20250616230308.1192565-23-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM's external abort injection now respects the exception routing
wreckage due to FEAT_DoubleFault2. Advertise the feature.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b3e6a7034b64..9d4fe892e8b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1613,7 +1613,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_GCS);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_THE);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_DF2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
 		break;
@@ -2884,7 +2883,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		      ID_AA64PFR0_EL1_FP)),
 	ID_FILTERED(ID_AA64PFR1_EL1, id_aa64pfr1_el1,
 				     ~(ID_AA64PFR1_EL1_PFAR |
-				       ID_AA64PFR1_EL1_DF2 |
 				       ID_AA64PFR1_EL1_MTEX |
 				       ID_AA64PFR1_EL1_THE |
 				       ID_AA64PFR1_EL1_GCS |
-- 
2.39.5

