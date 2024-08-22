Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6BA13C812
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724311049; cv=none; b=csoHoAj+XzYPoCSbInbRKH+CsWmQwq309VH/cqZD0zoGQBEFgWhCweNLXRvrZw5D0TsDvribiTSyBIDmG5ho7qSZJoumqoKeYaMVe/rRRsRv4TsNLtFYfCSkhVHioipU9381fGuGYDj3t9o3I9VGR73pePgBpg4wxSganj+GPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724311049; c=relaxed/simple;
	bh=77R7uaT9mS3hojp6gWvtApxLLheRAob9j0COv1xQaT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6Yuqgb5LNhOiwJjG8Qwrijn9XSN+d8dNPOHRHpD98S8CTU0spq53s8TJx6nae/7hJpK5fz/nVwI7ivM1kPUOcgjK0vhN2sv3CPfv7BX0sz3xlCL5rmCdHkpAwxa+M2emxS75XM8QiteZf7zLgw8ko+V4lzEsdpHTFa4UCqAR+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rRfG0zNS; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRfG0zNS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724311044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FnLLd5M1D77n+pJN+MTD2wtdFElejvau40OY+cqjY5A=;
	b=rRfG0zNSv1gzy0gQ0Bl2tjsBKBbtGS4KUaKd7EvFxevgmoeXykSzV/NeEnG2eD28x4Zgs5
	u5aQHLjKOtOwmFQxf7Wzy2TK1mqvzv2FjUYES1lfqQOtnIhizqp1zJFYFMwviOGPrfHiMg
	dhqJb+1J2NLO8p/XJom9E7FbstVnZoI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Ensure canonical IPA is hugepage-aligned when handling fault
Date: Thu, 22 Aug 2024 07:17:09 +0000
Message-ID: <20240822071710.2291690-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Zenghui reports that VMs backed by hugetlb pages are no longer booting
after commit fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page
faults").

Support for shadow stage-2 MMUs introduced the concept of a fault IPA
and canonical IPA to stage-2 fault handling. These are identical in the
non-nested case, as the hardware stage-2 context is always that of the
canonical IPA space.

Both addresses need to be hugepage-aligned when preparing to install a
hugepage mapping to ensure that KVM uses the correct GFN->PFN translation
and installs that at the correct IPA for the current stage-2.

And now I'm feeling thirsty after all this talk of IPAs...

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Tested w/ non-nested and nested (well, protected mode) VMs backed
using hugepages.

 arch/arm64/kvm/mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..a509b63bd4dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1540,8 +1540,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_pagesize = min(vma_pagesize, (long)max_map_size);
 	}
 
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
+	/*
+	 * Both the canonical IPA and fault IPA must be hugepage-aligned to
+	 * ensure we find the right PFN and lay down the mapping in the right
+	 * place.
+	 */
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
 		fault_ipa &= ~(vma_pagesize - 1);
+		ipa &= ~(vma_pagesize - 1);
+	}
 
 	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
-- 
2.46.0.295.g3b9ea8a38a-goog

