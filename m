Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F413246F4
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881087; cv=none; b=ITiMjnft7aqm5FMEtHmTIpDPMVJEPAWFQGH7bQ/S0btIhWsLIyMOgCNCcwgq7vVCoX7aJC3tnAcM+tpeYC7iOWEaZvEi2RkabJIFmIA0m0nhmWhuj3u5AJY12Z/3BuDmklgyNhM6PjGUHulZI1nrCa5+sNhsvz859FzDgNBbFsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881087; c=relaxed/simple;
	bh=QHSdkAsNvmiKGwx0OzcdNwNMTDvIKLmS51RYGkQwUzw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoqnrceohT0KUjxe1jLkTbxnZ9BdCET31MzDqlr1XWgFykEexbm/PyG5utGIybweOmZHLErY+En9y6rNe4q5sp01PaFToA7YT891McBE5+ThGauA+YePJ6GDL2SJfIANEemEaVxRnkRsSrEOgDZr6ZuGKwFz0wWUVWicza2z3GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2250EFEC;
	Tue, 16 Dec 2025 02:31:16 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87A0C3F694;
	Tue, 16 Dec 2025 02:31:21 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 3/4] KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
Date: Tue, 16 Dec 2025 10:30:52 +0000
Message-ID: <20251216103053.47224-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216103053.47224-1-alexandru.elisei@arm.com>
References: <20251216103053.47224-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__pvkm_host_share_hyp() and __pkvm_host_unshare_hyp() both have one
parameter, the pfn, not two. Even though correctness isn't impacted because
the SMCCC handlers pass the first argument and ignore the second one, let's
call the functions with the proper number of arguments.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 48d7c372a4cd..124404eb208d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -497,7 +497,7 @@ static int share_pfn_hyp(u64 pfn)
 	this->count = 1;
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
@@ -523,7 +523,7 @@ static int unshare_pfn_hyp(u64 pfn)
 
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
-- 
2.52.0

