Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63441A707A
	for <kvmarm@lists.linux.dev>; Thu, 27 Mar 2025 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743093497; cv=none; b=gYkeiHXWGEZritb0DlZ6dNhq8q/0+coeJRVBzuMBiONxgnbiCfLDIVv4fMXiqu3bEBqLAnAxL+pTdRgfkd4fXFvzbjukVdI3ODN0UX0wY6qESZ27IuB6jw7NKvxcozmQc4BE1YxD2RUk7B9q++0rBWDStu1Itjpe35CHwMph9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743093497; c=relaxed/simple;
	bh=ESzt2enLXYt23xY8ttSN/ZcELiO4gL9UAIgPB3r5q/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TLt+bMuKRZ9H9KYOylUHCek5Yh/7VLlVy2vcETaAHPiOXePrKY79wVR+jlA01/VMhoEBIxgzNsQ0RA/AfE1BMHkFCzON8kwqn2z5rI/+JXHWOM+oBvv878Dz8Lgh+UHXn1DaQoEvlqWbHyW2en7+BQzfeyMwWIH6qxG0qnX22eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gOi6g9wK; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gOi6g9wK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743093482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z51hX2ubcFhMKJ5by2u7YjCKZ3Nzr1b3Lq1PylQ9GKA=;
	b=gOi6g9wKrGSV5UH/x54wg6WFP3jRV9kCC53qdcKuyEwOYsTNbTvmY/kgEf70GSTgtes9jT
	RMIMsSF91b+mRVbfbms+jIBn14Dhmv3Skw6Jkb1GSznvz7Zm9v/3dJkyHjEwThs4pylu3s
	DUepdIINJzrmUGd3pr5cqru3B+DW/LM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH] smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
Date: Thu, 27 Mar 2025 09:36:15 -0700
Message-Id: <20250327163613.2516073-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The ABI of the hypercall requires that R2 and R3 are 0. Explicitly pass
0 for these parameters.

Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 drivers/firmware/smccc/kvm_guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
index 5767aed25cdc..ac2d3cf8a776 100644
--- a/drivers/firmware/smccc/kvm_guest.c
+++ b/drivers/firmware/smccc/kvm_guest.c
@@ -95,7 +95,7 @@ void  __init kvm_arm_target_impl_cpu_init(void)
 
 	for (i = 0; i < max_cpus; i++) {
 		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID,
-				     i, &res);
+				     i, 0, 0, &res);
 		if (res.a0 != SMCCC_RET_SUCCESS) {
 			pr_warn("Discovering target implementation CPUs failed\n");
 			goto mem_free;

base-commit: 369c0122682c4468a69f2454614eded71c5348f3
-- 
2.39.5

