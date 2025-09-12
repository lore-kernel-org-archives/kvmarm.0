Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D457F2253EB
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712197; cv=none; b=msZ1yDjFjybUHBevci4/Y+DtbxWNxf68JplHzttYF3UvxxWhEl5yZAV5uhkb5gyu0qWcwa8xFPrQWDAz3rte7XEUOl8DmQm3jRykwtAWiNvu6wUPcX2OmcJw1y+v07c0O4nGiEpYbQHBLvcQ0YLEmfRJqua20pAx5xOK1+2gBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712197; c=relaxed/simple;
	bh=Jd4ub9LJLQ+YBiRlu5xvQTYM31oRKRZ11D87viwXnvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oWLZ6orvb4pq+YQ3ComkylF7PKTTUs1D8+h4UZJspSQe3hp/JOikLIXNBNBbNao6B6oGQJ5H3H38VOdWo+rtMGQ1xRBjEM6aRUS1LBjALHIN9q4U4A3FAmuSHFy82nf0aOn1aL2eh55Q3DcrAIlzSuP8CnItWxg8dv3pWnpliEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=asfS/Mls; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="asfS/Mls"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r6WUPLEzT5eu1R3DjBcac0n9MIWT68vUyNgUjEBL9Hg=;
	b=asfS/MlsSJXUX5BIqDrz1xOLAWXB1IvUe0JetpWOdp9IgfrciGvp2sd7PRjzodQlk5Pejs
	YVbww2JBcFJZ2/hyvLdnyxFTOaQWRoAQvSvW8HacLd4o/W0h95y4fGekGq35MOlUgZ53JS
	RIa+qRQiL03GsysHGEiCJEugsNFnh0g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 04/11] KVM: arm64: nv: Expose FEAT_RASv1p1 via RAS_frac
Date: Fri, 12 Sep 2025 14:22:51 -0700
Message-Id: <20250912212258.407350-5-oliver.upton@linux.dev>
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

KVM already supports FEAT_RASv1p1 for NV-enabled VMs but only when
advertised through the canonical field. Stop masking the silly frac
field to expose the feature on systems without FEAT_DF.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5e46e95e2684..35fa6e00c9be 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1471,7 +1471,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			 ID_AA64PFR1_EL1_SME		|
 			 ID_AA64PFR1_EL1_RES0		|
 			 ID_AA64PFR1_EL1_MPAM_frac	|
-			 ID_AA64PFR1_EL1_RAS_frac	|
 			 ID_AA64PFR1_EL1_MTE);
 		break;
 
-- 
2.39.5

