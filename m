Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CE14718F7;
	Sun, 20 Sep 2026 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939772; cv=none; b=UP8t2MnXX6KREULMQFK8RZQZPzybj8kfUKWApy2RK/DmhYht6AVHalvMwP6fyjTT/QTydwisEjJNtA4ReqbI7+C3HMMmFCLEzYz+LsM1PaAGbz0TP8o2VPZSIV0Kjw+RLCksYWoTc22usm4zJD1ukFJA1yxfFR9AtSSeGqm/h8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939772; c=relaxed/simple;
	bh=xWBRQ2iZnL1JYRZR7SER1/+fXiX3ZfT1xA7aqCXLF9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2eCPy1qu7H8B/WBXChCatMxbCM+swl6trSbgzUdnzxcGCVuy7uj6IKpEsORsZVM9w7H3nrgzd2Zq8ghHpu2AHfl32lgQW+uEmHlXufN+DAzm4QpTTxJ4SF1F6UQkFqNadUghKnvL1ozvSllQn4GLG9pM4O5Al2P1Id1xCsKUNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QjGhEq1C; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QjGhEq1C"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB60C1596;
	Sun, 20 Sep 2026 14:29:23 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5591C3F632;
	Sun, 20 Sep 2026 14:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939767; bh=xWBRQ2iZnL1JYRZR7SER1/+fXiX3ZfT1xA7aqCXLF9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjGhEq1CcR8oyElFmpjIHT/xx5we7EOOqmzmwwei/jCpyg10QAI8WQmns+VA7zOGf
	 8KOvMB+ImofXDqZR2bjIXqRkDi7fY4XfYogIMtc3mDJI/bx5wxxqe3qgcZJaOBiPv7
	 +iTXgBJlRiM8ojV5CEfqCRZb0JDP/bEyuDVuOFMw=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v19 08/20] KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
Date: Sun, 20 Sep 2026 22:28:33 +0100
Message-ID: <20260920212845.707-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding VM specific backends for stage2 operation,
switch to kvm_stage2_unmap_range() instead of __unmap_stage2_range()
from the kvm_unmap_gfn_range(). Drop the bail out check for protected
VMs and defer that to the one in kvm_stage2_unmap_range(). Later we
would replace the logic in kvm_stage2_unmap_range() with VM specific
backends.

No functional changes intended.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0f4e8b71fa85d..03f2017a7404a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2436,12 +2436,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
+	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
+				(range->end - range->start) << PAGE_SHIFT,
+				range->may_block);
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
-- 
2.43.0

