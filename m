Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793917733;
	b=HGICBxQ6zL87uHAb+/1P9FiWefdWUIrV9d8hogfn/rgQAfqmtwHexMTKPwy17qGRVDq8
	 lHW0H0ps+bPFfPQVEddebdKBBEfYDnucSSFtNSPcU2LHJzV9PmAk8frZJ26M8ySN5Orz5
	 Ojs+GOAqVwsM/9hsXhjMVUKvrYA1BRNawCRNtXqJ6QyMrshFGnjyxEFQv1DS5ybYgeE3P
	 MJLPUhfirAdepSCWNB7G9Bx1SbVIq6URb5jpqnaKFImZXtTlD3FT4qmPz793VaigtQ9D4
	 YhefSZ3s87OT7H78fLqfk4zadz7lFtsTIpJf2GGz8OGtRrKcEX5xXqTU7wioWHl9bEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917733;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	b=1ARHKzCUo5Ub7TfqzpYtio+VvfUIcWNFpSNBfO5jWyjruP1vncV0cT8FJkHF6mqYE5BW
	 9+MlU6xKcPfh+XeQpp7YHbxvLwLDCxT+c7tyUZRkUYPXbDMqRuHHSBqoWifOFn7jhs5aw
	 HD+mvq3KyvylYhd/JwWbTOq/EUwAn1YnbCFJ2EzXN7tMtx05MMRIGcAmqFB86ODxIiAiU
	 YzbaFVz85L+95pQ8OnWdp3NIMOiDK7BtYfw+bmBNSZqzvWMd3S2BWUQ02JRLpX9pKR+Op
	 s4FRg7bOY+omVKiWRGf2DgfZmC2r9ChzeK+xE9oI0ukcKtH2eDw+t9cn0C3+UjXLe6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ReWuArwn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B10606A33B;
	Thu,  5 Nov 2026 22:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ReWuArwn
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793917732;
	b=EJ5gd9UzY71FmtSTwEk+5BdYKQihEhXl/uuLVwj6kuRTivj9j3OMs+xQitSEsfBB9RvY
	 haRj6wSmBh8p1QjtrWxTAYZkMnHZYXun1I0/c1TUAMigP5lPwqbojciCY+elXJs9+lHC3
	 ARG3mCkIjZShdo1dhzPjFd8dMxKWam4E2x0yDIkkF4/NzL4vHH93zHnjd2+S2y6Jqz9bq
	 Z548eaX9N74jwmuLNxeXZR+b7IPh48wdzJsfTab0zkkatRqKHfCHwyLbT/oEFqjz/eCLM
	 f2ABECWvcOPbP8BVfGB6ZGVG70HI055JuU1pZBjJrPpGfDs3VYU6FOGso24EFq22fYA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793917732;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	b=pdr4pDxuSat+VWi4tnPYkqvRrtG2dpoqFeSWZvcjh4ahACla/IbfzRunxOxvoyRVH5xV
	 0oMCoVUChevxOcpvcl7HfgWUhMFZphdjbh7NBoAKhaAD5kwtWTgkYJ6kLqzSFQSYQhvaP
	 hWF30kHa6PNRyl/W4j6Ls2BW8ZtCCLhyQuHSdeN50Jqch5zwYMl8CuDG1E+K9c2bFXhDD
	 gXZxs025B+P7OdaFTtf8S3RWtorFtd7lNT1op2+rc/dk5QXeGQbo1fKKZWpVlooMqgAew
	 4TvqoV3TAN+Ho29BFJN29t+e40hsgPes7tvBbCBKObkOpSjJILH+P7Jo2+b3p/uVyDA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 88E161F008A3;
	Thu,  5 Nov 2026 22:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793917732;
	bh=clOx71cOsA26RUdAeVKpCY0AdtjlbFGk/TTkJ7LEcnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ReWuArwnr+EHGAIVc8HAF+mBYh2t22rclI5IhGpedr+nV2jtfAuB5ukOGGleLAkGf
	 maByrPA7bXglF6Gd8knsW6B+tA/UaS5mFwzG3fKlNmPgC9ZTeraTiVB8YDHtYbH9ik
	 JOBiCpeomVOcUYjsJCUVG7oQKLv4TlcJA2NbE8vaOmIYYCZW29MjdMFbmvzGw0U9QI
	 qR1xLuKwYF85MpCljOH1g1gI7/r7DfkiOksWKVRaw3bFZw9PlYguqE13WOCJTTbLwe
	 f0bNmC5+l3H4YYWHIVNUJNDahOJQ2QBSaFDPl9h4GdrK6nHsiWi/byk4/ar+ORwZrr
	 i/PxDxzl0d1jA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 14C5945ABF;
	Thu,  5 Nov 2026 22:28:50 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 22:28:52 +0000
Subject: [PATCH 3/3] KVM: arm64: Don't replace a valid hyp block mapping
 with a table
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-hyp-pool-and-map-v1-3-756bb5d8e067@cs.columbia.edu>
References: <20261105-hyp-pool-and-map-v1-0-756bb5d8e067@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v1-0-756bb5d8e067@cs.columbia.edu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Xuheng Li <xuheng@cs.columbia.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793917729; l=1509;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=UqwLIs4gUAaU1DFo5IEMy2L+DohqOBeFqpV1fxyeXnM=;
 b=FLN/1if17KjTwirD2Rz8VRHYWeTjz3nnWvVapf24PLDZ6KrUxmcPXokTdK/ubpqkdY/77p2E9
 1RZwNGDprENAgXH5e7C9pN2Tbjy7DQw92MVuxGaz0HR/0ceepxq2bIW
X-Developer-Key: i=xuheng@cs.columbia.edu; a=ed25519;
 pk=L1HVV+goqxYmEMO/OXakL6uf9isSpgk2QrLlFqyZ2Qs=
X-Endpoint-Received: by B4 Relay for xuheng@cs.columbia.edu/20261028 with
 auth_id=1349
X-Original-From: Xuheng Li <xuheng@cs.columbia.edu>
Reply-To: xuheng@cs.columbia.edu
Content-Transfer-Encoding: 7bit

From: Xuheng Li <xuheng@cs.columbia.edu>

When kvm_pgtable_hyp_map() is asked to map part of a range that a valid
block mapping already covers, hyp_map_walker_try_leaf() declines, as the
request cannot be a leaf at the block's level.  hyp_map_walker() then
allocates a zeroed table and stores it over the valid block entry.  The
walk descends into the new table and maps the requested pages, but the
rest of the block is now unmapped, and the valid block was replaced
without break-before-make.

No in-tree caller maps into an existing hyp block mapping today, so this
cannot be triggered in mainline.  Fail such a request with -EEXIST
instead, so that a future caller gets an error rather than silently
losing the rest of the block.

Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b1..4c731b101 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -434,6 +434,13 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
+	/*
+	 * Replacing a valid block with a table would need break-before-make,
+	 * and the new table would leave the rest of the block unmapped.
+	 */
+	if (WARN_ON(kvm_pte_valid(ctx->old)))
+		return -EEXIST;
+
 	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!childp)
 		return -ENOMEM;

-- 
2.53.0


