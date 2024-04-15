Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F9317BAA
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 03:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713152187; cv=none; b=CQPsslTtmQ4k8XIYScNgIBA5RIUOhcA/0IcfSxFkKTL6lljpiTdF/s5OYKHjjB66IEp7N+ZWDxrdDg9PCOsryneBffNnsEylkABBBObzntq1V+dmktGcqMGGVbdP0Lab+JRi2rCjeAp86x9oEC+lrWXjV0hHVDqMJ7eRDRgeRSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713152187; c=relaxed/simple;
	bh=Cnj0XF6P/Fug2iGXpx4NSraFI6OHqlkPBxUCsdkBZjQ=;
	h=From:To:Cc:Subject:Date:Message-Id; b=HpHJutRjQCeZc7SIiNjoHgLvC3srZ2buiRWvYMEpGTcinqv9cqRHNyyqzI7n0Bty7NnSwHcfX321CZxbX6x86yYL86eN/MBI+oH95nswBH1aGwZIZJXx81I37DL1AEq4qLbf5csO4CMYh6QqldH/Y7YXOl9tGGftk1b2jmCUzBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id C0BEB7F00044;
	Mon, 15 Apr 2024 11:36:16 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: arm64: Consider NUMA affinity when allocating per-CPU stack_page
Date: Mon, 15 Apr 2024 11:36:14 +0800
Message-Id: <20240415033614.43518-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

per-CPU stack_page are dominantly accessed from their own local CPUs,
so allocate them node-local to improve performance.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/arm64/kvm/arm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35..d745d01 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2330,15 +2330,15 @@ static int __init init_hyp_mode(void)
 	 * Allocate stack pages for Hypervisor-mode
 	 */
 	for_each_possible_cpu(cpu) {
-		unsigned long stack_page;
+		struct page *page;
 
-		stack_page = __get_free_page(GFP_KERNEL);
-		if (!stack_page) {
+		page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+		if (!page) {
 			err = -ENOMEM;
 			goto out_err;
 		}
 
-		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
+		per_cpu(kvm_arm_hyp_stack_page, cpu) = page_address(page);
 	}
 
 	/*
-- 
2.9.4

