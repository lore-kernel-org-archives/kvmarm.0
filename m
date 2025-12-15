Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADC0332EB9
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799072; cv=none; b=a8FK8lddi6NzkA1h0siOmCJh0OjruNQx0/lL9W81UBK5EPry4aImTac2kHv/nj4qJnENzjpCfJ9t19KaCU95EiJShHCK0FZ4HR0KC+2hINcdKoIwtXbUKhZWDo+A6JH9DS0pOBKOyhZIeJNrm9Tufx4h8WD4rZQBDQLKOEtf0fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799072; c=relaxed/simple;
	bh=1wkQFxaxJKW8Mb1LMqr+Ms8D9iWVehVG4KCV9s0e1dk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcIKAnV3gF6Si3ouk6+38IosnR+xMINPagur5maA7KrPGmhyE30knGIb4uO+fpiTOHIlq2jrV3i1LyHKrjfVp2i5fmSBjCA9jqJHAU5G1g37l0dm4R13zrbTvY6VkFrkVD2hNwKHDMTqZOogdClDUlbkoiT+PynY9LY73dtEeyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C06AC165C;
	Mon, 15 Dec 2025 03:44:23 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D1EB3F73B;
	Mon, 15 Dec 2025 03:44:28 -0800 (PST)
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
Subject: [PATCH v2 3/4] KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
Date: Mon, 15 Dec 2025 11:44:08 +0000
Message-ID: <20251215114409.212512-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215114409.212512-1-alexandru.elisei@arm.com>
References: <20251215114409.212512-1-alexandru.elisei@arm.com>
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

