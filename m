Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3183FD97F
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293449; cv=none; b=Sd/HhE1KIPZls2QnVpum/32ywRAru0+Js+dR8BqNWGC1kkF3+fDfCJoinVaTSlmaS36CqkeLu92xgmHw0+YfL0Hpn5RxkVt9RavViCvI8qKa62AdUg844wDtYSHTa7ina2byOheNHRLg7Z6swAlmbN7B2ZYW0T/5zWGXBJCY+KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293449; c=relaxed/simple;
	bh=cHaqF91J8k5fNTX15TBR8HD4DACMPbXOC77gjnpK65Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rCVfbfzWcFmVFyJxr+XyH6ZtF2q/k3B1UGbje0m/9ba9dp2TNpmLH8UMtRnhHYpBpF8BX2Pwihykjd8gwodILU1EGr1FWPdmjEj2wvppkVSjCHk/JP6wQVOXwTjl6AXiMeAcsVbwjDqS7XxyMo59uqqy0oCLbEPSfFHG8iWslX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EIdNAbav; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EIdNAbav"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm/R+8+SeI3EIiHJjFKMzh728Ajegh5x45TsNe4aXWo=;
	b=EIdNAbavmrb8hsL8oklMYZ0FDv2qjouLDJOhckDFY72MVYlnR9MO5TvlRGezc+9Twi9Pt9
	YC/3unfpE2iBbjMSUznTLLfeaxOrdchIdRAwZ/jEPCT2sJglIgA1PD+1iZm79bOGCVWJP6
	FAckyQGF/bhUZmvs7toO5zz0XFrCCNI=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dirty logging faults
Date: Fri, 17 Jul 2026 14:03:13 +0100
Message-Id: <20260717130317.1953574-4-fuad.tabba@linux.dev>
In-Reply-To: <20260717130317.1953574-1-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bradley Morgan <include@grrlz.net>

Dirty logging forces new stage-2 mappings to page size but does not
always split an existing block first (eager splitting is best effort
and off by default). A non-write permission fault on such a block, an
instruction fetch, still needs a page-table page to split it, but the
top-up is gated on write faults.

With the cache empty, kvm_mmu_memory_cache_alloc() hits its
guest-triggerable WARN_ON(!nobjs) and falls back to a GFP_ATOMIC
allocation under mmu_lock, with a BUG_ON() if that fails.

Top up the memcache for any permission fault while dirty logging is
active.

Fixes: 6f745f1bb5bf ("KVM: arm64: Convert user_mem_abort() to generic page-table API")
Link: https://lore.kernel.org/all/20260623165634.699011F000E9@smtp.kernel.org/
Signed-off-by: Bradley Morgan <include@grrlz.net>
[tabba: reword the commit message for the generic, non-pKVM failure mode]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4d7c9bdcef00..74e7e7f7564c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2113,14 +2113,13 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
 	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
+	 * and a fault needs to collapse a block entry into a table.
 	 * Under pKVM a permission fault can also collapse pages into a block,
 	 * which needs a fresh mapping object, and the hypervisor requires the
 	 * min-pages memcache even when the install allocates nothing.
 	 */
 	memcache = get_mmu_memcache(s2fd->vcpu);
-	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
-			    kvm_is_write_fault(s2fd->vcpu)) ||
+	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
 	    is_protected_kvm_enabled()) {
 		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
 		if (ret)
-- 
2.39.5

