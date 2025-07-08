Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967872E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995722; cv=none; b=HHhN8OYRW/kehESRwtbXJissWLJEyzUDnEHCgPHM1gNAy0uF6B4graEJMBvMoe5TjYwfpznLiok8HL+UBdz4JOYPA7Q87Gu8BN3v3nHvEuwYWea8k3P4EhOAWbW5xFCfOaluUDYGsu876aIaxvdHZVm3IwzmFtxa6omg3ZCpqt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995722; c=relaxed/simple;
	bh=QheMwnznWli8OqkoW1kdJ0fBH3R9pUzhy59wVQ1AF0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ux9SVAE2hRLCKBNk74MbvFnDNziTQ2pNbLi3E+OKm0a+tdwIi7uVRe35+Q9LbRzq9R47RuL21Waqn33qemd2x0SoHnxCBQMTa/ByjgMfyBflgY2qh4UN1nF0r94TeRJbBY3aX8RByz7ek9n1oD+2IxCgyl1p53iQ1Y+jk9jIRs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i+gZhhum; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i+gZhhum"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dj4GuwK3IourS7PP26O4lfyav4yZVv2l+bSKMq4ELAo=;
	b=i+gZhhumuYB/suNLPlQAUaMkyDrl/nuzjObbAvROFCE+n8dF+8IR1dhkNcHN8L8VUqpRmU
	/h56IUL0CRDZ+hEOQlHUgGJwuKZAbDbqenx1/OQ/EagDaV5Nx8USQz3Dq1d/HNir2ufH33
	/hy4cQXlR9AHD1a/b6hEzxAX3K+mA0M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 22/27] KVM: arm64: Advertise support for FEAT_DoubleFault2
Date: Tue,  8 Jul 2025 10:25:27 -0700
Message-Id: <20250708172532.1699409-23-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
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

