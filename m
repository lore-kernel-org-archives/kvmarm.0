Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793981579;
	b=OOk0T7m+VIBBEjL4nK24xCjiLeyQXq0sA30r5uaoI1CQHxP+IXp4Aq+ujraERBZULP6V
	 gmObCuwMv82ZlPdLBCqwTlWh20/4lqBhBnpQa6dYsEnbnzd7/u8yvAfSw+x/Ez6FhqdUJ
	 iJRUWjhdkc2fl5rFvBdGo1rqzU749Km+Zu3kHoub3m2hDvqB66lzzqlG7iRMy80GQ0e6v
	 Utj5g3TUnzWOYAWuoU3teQAnejpG37KHwmPVKVAIB0zNNavoRRO6LRon9dNpHSkLM8erF
	 zwcPdWKf03lwvJD3PukJs2Ch976J0yc1O07YIXjKjK4E7NSg507EerPhv27RFnjuyVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793981579;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=IUG0dDHj/Zm5K5qiyoTo+dRTmDhIG43OjUhDi38YRoU=;
	b=oBTmexLFYCovjFDS2xnPhVRFUAa6tGNfFudKZBCcc6GIiAvH11jlgq1dsLuKIcgb5V71
	 dY++lY85I7b287XcCPJqnstiI9ztwryIpAxYqQr9Vtb0bBeWu23FKY9nCNceGbuduVWxO
	 gGJNMy/NbIfxgODLX/yNZG8vE4nwee7IgiQWFMTc5IhoDHPUF5s7758KxaviZs5RD7tLm
	 jZVta9+Gfd4eYBUL6s/VWMWe+BxiSAKgi7uj35yFtsCciqWmZ1Ky7hahdh0TOgA3TJckQ
	 4flwjHMcTZDhqipxJJsxUosSzmP4rf6PcCaurwlNTId/UhSeCO3vAIhoxn8qv9OUU+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fdUE5Vpd;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90669606BF87
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 16:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90669606BF87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fdUE5Vpd
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF23D143D;
	Fri,  6 Nov 2026 08:12:54 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22A913F673;
	Fri,  6 Nov 2026 08:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793981578; bh=Hl+8S3N2mqoCQjLHJajTSd+0DIMoIu1+UBhREoQ7E5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdUE5VpdaBYyeZvbjF77BnX40+05r2+gHOZ2gF5nxxwtnjdGCfA88LWUgwsTBIyco
	 Rd7DYlbOZtZYSNtDSR5tuf2PW6rm7sZXAzlb7/jXBYjApE+5aws3LF7VHgs93d842H
	 Xiy9eiiO6qt/AUbV6nyYY3sTMly4az30BW2MYzc4=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v4 3/3] KVM: arm64: Make stage2_split_walker() skip unnecessary walks
Date: Fri,  6 Nov 2026 16:12:38 +0000
Message-ID: <20261106161240.1345126-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106161240.1345126-1-leo.bras@arm.com>
References: <20261106161240.1345126-1-leo.bras@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=leo.bras@arm.com; h=from:subject; bh=Hl+8S3N2mqoCQjLHJajTSd+0DIMoIu1+UBhREoQ7E5E=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLe/ilTv+wk3vxgW8skn89LuiSUZWMfvgt2rDxp/XxRa tCV0hyVjlIWBjEuBlkxRRbZR/NX8XyfknHkyo8FMHNYmUCGMHBxCsBE0ncwMrz2LGpq32RUkXKN ++b6nElLfnlHKGldTZjFaSZbzqQ29zjD//K3Oj8K3Ra9Sq11mvxq7batm4zEI+7HLlq94NXDaSG WBfwA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Currently, when splitting, all the child nodes will be walked, with the
walker just returning earlier if there is nothing to do. This means all
pagetable entries in the splitting range get a callback from the walker
function, even if it was a level-3 entry.

Optimize splitting by skipping all level-3 entries, as they are already the
smallest block size and can't be split any further.
(i.e. set flag KVM_PGTABLE_WALK_SKIP_LEVEL3)

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 80744478c810..f75cb666a103 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1565,21 +1565,22 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
 	return 0;
 }
 
 int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			     struct kvm_mmu_memory_cache *mc)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_split_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_SKIP_LEVEL3,
 		.arg	= mc,
 	};
 	int ret;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
 	dsb(ishst);
 	return ret;
 }
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
-- 
2.55.0

