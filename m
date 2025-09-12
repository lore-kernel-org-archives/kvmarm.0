Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC85F22256B
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712192; cv=none; b=dAW9HVaNoKGpTWkbXwMNEOh0zSXt7vOAIzF5iZveOHBYhODl6dYJA9eu20p67nDmIaie+NkyZvtktAH/JHfn8nYa+UcziyAx34WZEI7tuyJow4D+uVz/bLR87qvwDhnRyrvTg5qesRYdA62VRz8Ewk3uFV/IczQoOuZ+b/d36w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712192; c=relaxed/simple;
	bh=jUo3UfeImENKPytUlr9tjnzIUNTsr20zNFwgGifmYrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HudGlIW1yvmwRg1dmCgBgyoJFYJ0mfwSuGwpfyaZCQue4R0Arksw8mQ9enFklqvcuWs+hCIB2suJDD4JtfD0Uv87mbfBbdMN1kGZJiQhqgtPpzQd7e15rbX6bxK5b3xcKLhQ5J8OcCcfrb7rHUuu/1fqqT8nA5IWvTcjuZHDqz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GOLRPSIC; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GOLRPSIC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dGo1JHenVupsKv0cBlxICyVc6ZosvpNnpRBAKuBeyc=;
	b=GOLRPSICPmcbz2gVjTvJv70caf+EDYETHqOKXiztieLckfNR5aCF/3TVXXKF+ZjEGd0vjT
	6CD7ie472Ob4N+whrpso+ljWOTPmsnBobuFVHgWS3jvbPRoOHsbE4qPiXsEDM49XsFi20D
	JcsR0DFbseLkyAhUfFjF4/q7z23KmJA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 01/11] KVM: arm64: nv: Convert masks to denylists in limit_nv_id_reg()
Date: Fri, 12 Sep 2025 14:22:48 -0700
Message-Id: <20250912212258.407350-2-oliver.upton@linux.dev>
In-Reply-To: <20250912212258.407350-1-oliver.upton@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Consistently use denylisting of features such that the limitations of
KVM's nested implementation are explicitly documented (rather than
implied).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 47 +++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..53c57d105c93 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1462,9 +1462,18 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 
 	case SYS_ID_AA64PFR1_EL1:
 		/* Only support BTI, SSBS, CSV2_frac */
-		val &= (ID_AA64PFR1_EL1_BT	|
-			ID_AA64PFR1_EL1_SSBS	|
-			ID_AA64PFR1_EL1_CSV2_frac);
+		val &= ~(ID_AA64PFR1_EL1_PFAR		|
+			 ID_AA64PFR1_EL1_DF2		|
+			 ID_AA64PFR1_EL1_MTEX		|
+			 ID_AA64PFR1_EL1_THE		|
+			 ID_AA64PFR1_EL1_GCS		|
+			 ID_AA64PFR1_EL1_MTE_frac	|
+			 ID_AA64PFR1_EL1_NMI		|
+			 ID_AA64PFR1_EL1_SME		|
+			 ID_AA64PFR1_EL1_RES0		|
+			 ID_AA64PFR1_EL1_MPAM_frac	|
+			 ID_AA64PFR1_EL1_RAS_frac	|
+			 ID_AA64PFR1_EL1_MTE);
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
@@ -1517,12 +1526,16 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64MMFR1_EL1:
-		val &= (ID_AA64MMFR1_EL1_HCX	|
-			ID_AA64MMFR1_EL1_PAN	|
-			ID_AA64MMFR1_EL1_LO	|
-			ID_AA64MMFR1_EL1_HPDS	|
-			ID_AA64MMFR1_EL1_VH	|
-			ID_AA64MMFR1_EL1_VMIDBits);
+		val &= ~(ID_AA64MMFR1_EL1_ECBHB		|
+			 ID_AA64MMFR1_EL1_CMOW		|
+			 ID_AA64MMFR1_EL1_TIDCP1	|
+			 ID_AA64MMFR1_EL1_nTLBPA	|
+			 ID_AA64MMFR1_EL1_AFP		|
+			 ID_AA64MMFR1_EL1_ETS		|
+			 ID_AA64MMFR1_EL1_TWED		|
+			 ID_AA64MMFR1_EL1_XNX		|
+			 ID_AA64MMFR1_EL1_SpecSEI	|
+			 ID_AA64MMFR1_EL1_HAFDBS);
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
@@ -1564,11 +1577,17 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 
 	case SYS_ID_AA64DFR0_EL1:
 		/* Only limited support for PMU, Debug, BPs, WPs, and HPMN0 */
-		val &= (ID_AA64DFR0_EL1_PMUVer	|
-			ID_AA64DFR0_EL1_WRPs	|
-			ID_AA64DFR0_EL1_BRPs	|
-			ID_AA64DFR0_EL1_DebugVer|
-			ID_AA64DFR0_EL1_HPMN0);
+		val &= ~(ID_AA64DFR0_EL1_ExtTrcBuff	|
+			 ID_AA64DFR0_EL1_BRBE		|
+			 ID_AA64DFR0_EL1_MTPMU		|
+			 ID_AA64DFR0_EL1_TraceBuffer	|
+			 ID_AA64DFR0_EL1_TraceFilt	|
+			 ID_AA64DFR0_EL1_DoubleLock	|
+			 ID_AA64DFR0_EL1_PMSVer		|
+			 ID_AA64DFR0_EL1_CTX_CMPs	|
+			 ID_AA64DFR0_EL1_SEBEP		|
+			 ID_AA64DFR0_EL1_PMSS		|
+			 ID_AA64DFR0_EL1_TraceVer);
 
 		/* Cap Debug to ARMv8.1 */
 		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, VHE);
-- 
2.39.5

