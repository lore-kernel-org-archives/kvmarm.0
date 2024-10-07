Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A331D2229
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323196; cv=none; b=gs2gfuW9dz/J1W8rRP3OB6S3a12F5a1FLxqop4NOwaG9xZtc/Wy7cvUvB/udQAdI4yZoHZEn0hcL4svLReKyTpoyzeAG9ggzHbCpdoVw3uaPwJuqVYlLHEqmfJxhUQNFz9rJ5hUrfqquYXBpP3v8monisD4I0a47yJseCGxhhvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323196; c=relaxed/simple;
	bh=0EFDy7RL+VdwfE6/CTbPEFiL08uhcOKdEcC6YGerOIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBEVLvI0ShJFUZHFqxiw4IoM0c6Z1soIuSn/hFoq+TxAAnahyQeOdg6CPlTHNkdq7p+r8QFPPYk5GjjidL+O4Bd9NBCrJWih34k0iYr0XmBz4hqMCy8xB9vxmWKzrevYvi87QyLi6oA8T8JGf0d+r5FP0sG2IzQ19aVWDiB89NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gOD1GwOg; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gOD1GwOg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bcs5B7GhYXxj2DmSTn50EIgI74F3+jYhoZNAot+CDAs=;
	b=gOD1GwOgV1EBBVlSE3o8Ldjk1bu9qbkK92FCbu4Zwzekc5qHFxtn7hnwlD+DxShmS0vynv
	FZzzMMeG7fV4HenW162CdmfOrKAUaAZno8a1mPicWCeDB+2kfSJoKg6aGfUeHtHSxuTcQL
	L1zdwqrfvbftXC3kuoniOK32ZrAiE7k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 10/17] KVM: arm64: nv: Advertise support for FEAT_HPMN0
Date: Mon,  7 Oct 2024 17:45:52 +0000
Message-ID: <20241007174559.1830205-11-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Everything is in place now for KVM to actually handle MDCR_EL2.HPMN. Not
only that, the emulation is capable of doing FEAT_HPMN0. Advertise
support for the feature in the VM's ID registers. It is possible to
emulate FEAT_HPMN0 on hardware that doesn't support it since KVM
currently traps all PMU registers. Having said that, let's only
advertise the feature on supporting hardware in case KVM ever provides
'direct' PMU support to VMs w/o involving host perf.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 33d85db860f3..dbb44e22bda5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -892,12 +892,13 @@ static void limit_nv_id_regs(struct kvm *kvm)
 				  ID_AA64MMFR4_EL1_E2H0_NI_NV1);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
 
-	/* Only limited support for PMU, Debug, BPs and WPs */
+	/* Only limited support for PMU, Debug, BPs, WPs, and HPMN0 */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
 	val &= (NV_FTR(DFR0, PMUVer)	|
 		NV_FTR(DFR0, WRPs)	|
 		NV_FTR(DFR0, BRPs)	|
-		NV_FTR(DFR0, DebugVer));
+		NV_FTR(DFR0, DebugVer)	|
+		NV_FTR(DFR0, HPMN0));
 
 	/* Cap Debug to ARMv8.1 */
 	tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
-- 
2.47.0.rc0.187.ge670bccf7e-goog

