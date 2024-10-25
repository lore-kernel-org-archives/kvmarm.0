Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740120F3F1
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880663; cv=none; b=EV/5+LYz4vOd4H9qp3GqbhwEpDGfY5LYO6shm7/8+3xkkXSbziRtgey/TESBCXgVx8Hk+t4cpHLYR5h5+WEZJEMvBf3zVl5knIiFLOvVCD8XGZ3v//B2Z+l/gpuqhLbBhdZUKot/sE2WqiR10RNFGFAOk9c6oj69+Xr0tVN+d0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880663; c=relaxed/simple;
	bh=d9/iMdqKv+XLG6+WmqeIMg4S4oZiommor9qaH5XHqAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW5X4hlbUayoK4wlnkbUXRG8VkNTzO94b1l90ewxZ+pC38B9wM4rR3WLWWjQ+NYVIDlgINxiqGFp7zwhvQVlJ1tCXMIN2RqOix1mxkHF+ak2TyWiS4PXCo1BvNR9SP7pwNVHyW9jUZObueKe1lxxCv4v62V2RUEUjedAL51JUMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xAAF1zES; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xAAF1zES"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm9klPokIaTyW3+rN5LwBgShYgrwmCrkRkYvLTHZaEA=;
	b=xAAF1zESpqxl1al57F1z2eSH8ygVVG+N3KSq01OZtIqfAMMSELrvox0sC+4RDq+b9SYJq3
	MdECuMdcFKZZeXmfrvw2ReJZEt2Xhj5DRyrQ+E9c1sKn6HWz7kRsEq+SA4iui5q7WCxFQR
	6/i4BWazmfpCJnUoc5vmnA7L1o61H2g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 06/18] KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
Date: Fri, 25 Oct 2024 18:23:41 +0000
Message-ID: <20241025182354.3364124-7-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM uses a sanity-check to avoid infinite recursion in trap combinations
that could potentially depend on itself. Narrow the scope of this sanity
check to the exact CGT IDs that correspond w/ trap combos, opening the
door to using 'complex' traps as part of a combination.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05b6435d02a9..da7ab14e036d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2021,7 +2021,8 @@ int __init populate_nv_trap_config(void)
 		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
 
 		for (int i = 0; cgids[i] != __RESERVED__; i++) {
-			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__) {
+			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__ &&
+			    cgids[i] < __COMPLEX_CONDITIONS__) {
 				kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
 				ret = -EINVAL;
 			}
-- 
2.47.0.163.g1226f6d8fa-goog

