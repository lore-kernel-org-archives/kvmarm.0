Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDDE25228D
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712205; cv=none; b=JYrn0w8kG620RnthB3ZehsUGz2ASozvj4oyoMT03iUxx8Rhm/pqlnHxQuO4UYrSzI/87pb3IJr57+QViFCaFqe9SNKWC9kCEF0pNckCTkjbblEhUDLR2BPcyunlhnAWQS//D2XGuFWP1Q4Z+MmriO5jypu38M/8PZ+f6WbkSIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712205; c=relaxed/simple;
	bh=DRkW1GBc326DQ0KCZrk+8lv1aGfxRd99fMr0cMY+lko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=idfrB18s87pUgsCtMOAHgjFyaM4Wdd1Ld9g8B/aeqsxws3HtsJw9rqAqW5qANSTIGnBS2CYMTJoJDjjn8RLh/7cx3W4yqoaYyz4bG/813onKu0fOU8aHF8m6tmwDP72bhxSOoclOWAWTQW1IYB3xLuddkhTpi2guQkYCNO1KZ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pWeqDpxZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pWeqDpxZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rfEkupZeH/H0o3Ms557T2RHtlTa0sszXDba59KxXvkg=;
	b=pWeqDpxZfXc9Mzyi6rtx/J0xnrepOmfMKB0QStVCrj8RdKdj92zSP0aHjeHDN0Qok52coF
	MHi5RQHLk2DsTNSRHiKzTk8muUHu2mzFzNGChMvPMYypuJ+vy0Nq5kvIfZGzQyosCLYdRF
	lridIwq82zhKZDh9RvLZ5IqehHqV4YQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/11] KVM: arm64: nv: Expose FEAT_TWED to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:55 -0700
Message-Id: <20250912212258.407350-9-oliver.upton@linux.dev>
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

KVM now handles HCR_EL2.{TWEDEn,TWEDEL} correctly when computing the
effective HCR for a nested context. Advertise the feature.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4e70b4908c99..a5e1a3de2742 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1528,7 +1528,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			 ID_AA64MMFR1_EL1_TIDCP1	|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_TWED		|
 			 ID_AA64MMFR1_EL1_XNX		|
 			 ID_AA64MMFR1_EL1_SpecSEI	|
 			 ID_AA64MMFR1_EL1_HAFDBS);
-- 
2.39.5

