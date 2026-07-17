Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A16D3FE34E
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293451; cv=none; b=YdWAedrxTYBvQKYRpU89PJ4TOoUTkHKSb59Ws1XIxqWJx6VmT6qr+yapzG4UdZHGcuS07pyUsg8MnZdOEdj/G5tjbJMUXq0epO5Z7hWC8MNvB8s9b6bre1yf+J7FUl4lHjduZb2OPb6+NY/7+/8C2I0F6szidA+oS/HVhV9x/Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293451; c=relaxed/simple;
	bh=jmsewc0sWd3StwFaO0x1Igk4O5irp82T8pqNrTcmEQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=olQZ8QhbhFKmmZA5jK793m9Y2/sqzHgWSt1GB0EbMZ9GoetIhJ9qBm4McQa/+VnBganQlmozFx0oU3DOyiDvSjkO+pOgZoo9X9gpylA91z5+bAWP6aCV2AnlfDHCMPoLp7gL/Z7vv5uhnqyTfbwggqtwc/sczcTvP0ydq5vCmCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vqChw9zc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vqChw9zc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CI1v8eeCBLFTdJ/DMxS17nabZVLaO47wNFZpGWZf8b4=;
	b=vqChw9zcOPNplCIkodaAthFKhF9/qHUGIO8HHLx9F8lVMbcLi5gYPYL/7We5a26SbrUd9h
	qAD/apqCdmgb68x8+zjhhYHf2IA+T/cKcQv/4eXY6msQu4tBdxb8n0OLSvgtVZUBeLurIJ
	PMoBYcZ8Qpet0gmuNcGgEz7kh/BL75Q=
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
Subject: [PATCH v5 4/7] KVM: arm64: Skip pKVM stage-2 flush when FWB is enabled
Date: Fri, 17 Jul 2026 14:03:14 +0100
Message-Id: <20260717130317.1953574-5-fuad.tabba@linux.dev>
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

pkvm_pgtable_stage2_flush() cleans the D-cache for every mapping in the
range even on hardware with stage-2 Force Write-Back, where FWB keeps
guest memory coherent to the PoC and the maintenance is unnecessary. The
generic kvm_pgtable_stage2_flush() returns early in that case, but the
pKVM MMU does not, so it needlessly cleans the whole range on, e.g.,
every set/way trap.

Return early when FWB is enabled, matching the generic walker.

Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index f70c601dcf4c..ba6570e37545 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -518,6 +518,10 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct pkvm_mapping *mapping;
 
 	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		return 0;
+
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		if (!mapping->nc)
 			__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
-- 
2.39.5

