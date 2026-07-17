Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16FD3FE375
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293453; cv=none; b=MkNqIlr9d5MR24nZGt5qPFgg72MJT3av3XHRap4N9hmaWvi9vTpyZLXS8LUPMZdTMuCVLt90VcoUK7KkZ25OeVwWcTrZUP2xe8vrSMt510mbGDKYZhO3UEiz0c1FKrMd+yC6pbRUnzbiAe8qazUqMhMco6h7IZSkcV4HDSxf0ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293453; c=relaxed/simple;
	bh=5KMMgT2ETpoNaISeUolCEGWZMQWe/wTHmfcqBE87/tE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g4dEfRhGC+0+dplyQmi4KfDm8U+govfwncp3hMZHyZKrA7z3MDxtn3ASf5fLN28hteuKjJTy7wq2/b7RprPyge0rP8dLZcV26JBFDch+urDt32ljqfEahsOTm/Fc/iFT7a7fbl3zlOkFBsL6r/chNJrWalGVwH44b1FZ8iYZmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OdKlhYzO; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OdKlhYzO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t62BgL8MjPLp/vMP9DZbVtXwp29HVKeCqzhIx8Pz0Y8=;
	b=OdKlhYzO5z90QIvAtZFzdTuaTThgKal3zbR5ENagrtMDYVyYo2JEhmsSEYG61sVy6mDvmo
	Z0okoOfILrcrBo0mAl6Q3WfUGSPkrvRhx9xRaDkeTjOQoJJt86SMhyH2k0Szb1qdZIWXTy
	64WfrqN30uGScUnE1fiVvhfe/YokMHY=
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
Subject: [PATCH v5 5/7] KVM: arm64: Don't WARN on pKVM stage-2 map failures
Date: Fri, 17 Jul 2026 14:03:15 +0100
Message-Id: <20260717130317.1953574-6-fuad.tabba@linux.dev>
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

pkvm_pgtable_stage2_map() wraps the __pkvm_host_share_guest() and
__pkvm_host_donate_guest() return in WARN_ON(), but those hypercalls
fail for reasons that are not EL1 invariant violations: -EINVAL for a
pfn that is not memblock RAM (check_range_allowed_memory() rejects a
device page mapped into a non-protected guest) and -ENOMEM under
memcache pressure. Both are reachable from a guest fault, so the WARN
splats on host input.

Return the error without warning. The unshare and write-protect WARNs
stay, since a failure there does signal a broken EL1 invariant.

Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index ba6570e37545..1212a2c5613d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -466,7 +466,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 					size / PAGE_SIZE, prot);
 	}
 
-	if (WARN_ON(ret))
+	if (ret)
 		return ret;
 
 	swap(mapping, cache->mapping);
-- 
2.39.5

