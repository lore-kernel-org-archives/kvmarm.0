Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAB621E097
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712199; cv=none; b=a0bxMEsxROQq9ODWRNPfrxP7PBmW49L3WJqjp/4XG1DaAw0y0pXwnXB85qmT6UfRg+OcnnJNLrr6AZdS4tfn7RFM+OiawitKMem1x2DYr1DVX5QtwIY52z4iA5a0ae7NxJp2jmy00aXpYIUI3rfiHV5P6DA/Uiv5Pd4HfVFQ8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712199; c=relaxed/simple;
	bh=m0+6PI0/4evCIFHIRHS+dp7MYBFz5vrt2WDwDlZDRYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D3iuSbNG+3htkl4JZsDnHnZMdC04STADoOP2cubZyZyyfiJBlecY1vPm4FhfOD11m/fR91JLieNdhweGotazQju/Fk2cCpJ9bqft/az34qkHtXh134WjuWhB94g99Tej8ZQJau52/3Qx50s6+C+FwOSINBm3e5YcyE5L1OPWO88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C2HyQhxj; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2HyQhxj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwqxbhVHI52dq9UVfPNYKqR485HUmjkI8HdEtZgs9xg=;
	b=C2HyQhxjuMDa+UN/aSD99um+0UUnwUyDexJD/vdCNQ/4+KydwECfLPDFt02g4S2qUs6Oak
	vLnqCHsxxGWC/uAKpRVy70ecqKHzsMz2DKfWZhn7M8rXIu/gcV5c8estzSHRN0L8oXCEDD
	rjx8O/GRhryMUtrulK1aaaGy1Vm8mHw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/11] KVM: arm64: nv: Expose FEAT_ECBHB to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:52 -0700
Message-Id: <20250912212258.407350-6-oliver.upton@linux.dev>
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

The exact wording of the restrictions on branch prediction due to
FEAT_ECBHB in DDI0487L.b is as follows:

  When FEAT_ECBHB is implemented, the branch history information created
  in a context before an exception to a higher Exception level using
  AArch64 cannot be used by code before that exception to exploitatively
  control the execution of any indirect branches in code in a different
  context after the exception.

While vEL2 and EL1 are multiplexed at EL1, they exist in different
hardware-described contexts as KVM uses different stage-2 MMUs to
represent the corresponding translation regimes. Additionally, exception
entries into vEL2 always imply a hardware exception entry into literal EL2
for the emulated regime change.

Given all of this, and the fact that FEAT_ECBHB places no limitation on
the EL of the protected context after the exception, we can claim
FEAT_ECBHB on supporting hardware.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 35fa6e00c9be..20e7b11d5d67 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1524,8 +1524,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64MMFR1_EL1:
-		val &= ~(ID_AA64MMFR1_EL1_ECBHB		|
-			 ID_AA64MMFR1_EL1_CMOW		|
+		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_TIDCP1	|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_AFP		|
-- 
2.39.5

