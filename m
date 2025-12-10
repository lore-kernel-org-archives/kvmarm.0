Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348B02FE59B
	for <kvmarm@lists.linux.dev>; Wed, 10 Dec 2025 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372879; cv=none; b=qjfY2Tn/ipUrPJ6Z5y2SFTlBbwjQvzlmfCAwmpSBvGXFSOG0PezgcNN8lE5LYGnU1dVXe1zycsMbjaXRcYBM05rbS3wP0pFEVzG6XJ00q6uWXzA407h+SWXpqwabWGAYQuGkBux8eOvt7h+uUJQMFhIhsh6GFd6lqu8OZh+Q3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372879; c=relaxed/simple;
	bh=Nh9fHJY5CALZZIofm510EihlGHO1B2GuNJy//F5H7QQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p87iw/ebSmdgXCQ/4K/L9IKxQmpCE9z9+Ywt9FcTVtY4XpSYEUe+zxhH4eqLkoSzj1v+DvEf6Bl1cRnpEqJOmcJkZnlyCUwuwMSBiaTTulIAc2hxjJKtUCBladtjhNqw9llGQfIN9bBwbomr1pj03eY98OKZJYMpwmX3TZdTzYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35CCC1762;
	Wed, 10 Dec 2025 05:21:10 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF36D3F762;
	Wed, 10 Dec 2025 05:21:15 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 2/2] KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
Date: Wed, 10 Dec 2025 13:21:02 +0000
Message-ID: <20251210132102.137631-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210132102.137631-1-alexandru.elisei@arm.com>
References: <20251210132102.137631-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..6c6abcd8e89e 100644
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
 
-- 
2.52.0

