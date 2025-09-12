Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8C2253EB
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712202; cv=none; b=S0xNT5ixkr4BpNJ4uFqIXCR5aKsqSbzmyN4+6M9rBCZHTdzhFdBQ1s/3eic0IlNYU8ofWfeA4+wfany6H7Cs8VvmpnVqebZXMIOITxZSYI9h1321c+WjxxfT0bvYt587kQmOiF266IZ0g82quAaCufZs2Q/nYNgq/Y3pVhOj5zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712202; c=relaxed/simple;
	bh=K2ERdH6J4yIlXYPi4WScd6FI3pm7aJgXtFx0lBoVIeg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kpyGFwggFVFWA4WoA+jBt+XwuUts/kXoKFFRg8lZFOf2xp/9GAxnYpEl2C/1eEZgGefU7bzo8yjPjVzIbXcQkP35iVQrNf6LMH6fahTP3HsaNBqz23/+mcI2ByGEK0HmBrOx0ilkwPTmkQs565GJ35X+WP/+Hb+AaA6TY2nEqS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=isScjWvq; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="isScjWvq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgxSGh/+NflmnOMlroOB9bQeQNQVlwf1b6Vd7DkZdHE=;
	b=isScjWvqzAXqy1VvHojkDm2WmV1z2tfSmoGTifawMl416fnMm5B212aY031CXkTE/N4wKO
	cMOE9MBGcgCNywlPECz7yrM1R8YE0N88CeGomTe7wpnf5xyBXdiPgj73ccU6/BMhnwHODE
	nM+VWj2oXgSO8PiXMscYwUxDilbWCrk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 06/11] KVM: arm64: nv: Expose FEAT_AFP to NV-enabled VMs
Date: Fri, 12 Sep 2025 14:22:53 -0700
Message-Id: <20250912212258.407350-7-oliver.upton@linux.dev>
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

FEAT_AFP doesn't intersect with any EL2 trap behavior, expose to
NV-enabled VMs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 20e7b11d5d67..4e70b4908c99 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1527,7 +1527,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_TIDCP1	|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
-			 ID_AA64MMFR1_EL1_AFP		|
 			 ID_AA64MMFR1_EL1_ETS		|
 			 ID_AA64MMFR1_EL1_TWED		|
 			 ID_AA64MMFR1_EL1_XNX		|
-- 
2.39.5

