Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C183F823E
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326989; cv=none; b=EjuARV+yuIpxKjzbLaufvP4PMI/dNeXYkwHWVkG3AfrY4md7SJBUJ9DvIgB+x0Bd553N+nWrkutDKC0HuVBBTecNxY/rM87ZeEIn8LIACd27divWY/v2XVT7Xqm/RwZ8aKjkCjOYRPlt5EaHIap7kVJYcjFboNf05RclJp7gcp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326989; c=relaxed/simple;
	bh=6QNOkdhCbS1zSrynkcrf4iXWNtn7FlSJMHDEznG+FJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mn1EIZ08mKFCLP6b3utqCVTeh+lFR4Zogo9vQEucBl7wXjeshJuKvs21094hpXV2SMGXLjjBpisB4bKVj/x+V4o4GQ/nNT0bzJm76sjJudqvNUU5fg/Eo6AN4Ipq8xHkdQ8copyFu7E6k074i7chEjglkXmZlc1zig3MNFqp+ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pzVzDhSg; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pzVzDhSg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783326967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GmUXCwO/YG7npJOqJHZit2JMx0cXqLbuiAg6odak188=;
	b=pzVzDhSgA0xpQdAxxZ2elsTdy8cuTrApGdOjkCnx1qcInWTSiQSRqCk1gD398w9Kt1EZFG
	Src1NEPCOx8to4MKUfB+fVWB/42LMV0PjIlM/Aw+GEnZagZCN9MH4mJooSogrhMIOYUxp1
	/5WNGmP6mv8swCiEJReG4rHRYviHz/4=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v1 1/5] Initialize the return value in kvm__for_each_mem_bank()
Date: Mon,  6 Jul 2026 09:35:51 +0100
Message-Id: <20260706083555.302972-2-fuad.tabba@linux.dev>
In-Reply-To: <20260706083555.302972-1-fuad.tabba@linux.dev>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If none of the bank types match, the function would return an
uninitialized value.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index 7a52c6a..95ccfcb 100644
--- a/kvm.c
+++ b/kvm.c
@@ -383,14 +383,15 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr)
  * their type.
  *
  * If one call to @fun returns a non-zero value, stop iterating and return the
- * value. Otherwise, return zero.
+ * value. If none of the bank types match, return -ENODEV. Otherwise, return
+ * zero.
  */
 int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
 			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
 			   void *data)
 {
-	int ret;
 	struct kvm_mem_bank *bank;
+	int ret = -ENODEV;
 
 	list_for_each_entry(bank, &kvm->mem_banks, list) {
 		if (type != KVM_MEM_TYPE_ALL && !(bank->type & type))
-- 
2.39.5

