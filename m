Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C134E1C89
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416079; cv=none; b=e2QMR2pwrxkM3+6SHzoq/yDmw45FyAp/rM9tAIzJEovmyDXNHKNbG+najRmzjLx4uXyxdZJsfCW8Ek3c7qtKz2ANFMvTWcU/GvX7mdE9+KtJzZQbMTGFMa9/Q5OPgtHmJRAipzS/mlkrV49YG9rxOOLrwa7Qj2ZFADfKqhFJ+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416079; c=relaxed/simple;
	bh=Ww+r+o4/7dyPQTMz8pAy9hMNzw+4oyPYtc7UMkTUyD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epJ4iSmTXqohS9p24L9N+D9gHpuGSoKZHEUxfosGsJF8w2hZ649gJ56d6M9BO0XNZL93ZUrmZg+ljEHixLHbnd483A/XdMt6i+VdbUz610OObQ7JnM0lgt7VhXsQVq8IBTGh360torXNNMbVrHsoHGmnt373tm6isCir0xodwjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TK3YWf0j; arc=none smtp.client-ip=91.218.175.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TK3YWf0j"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ww+r+o4/7dyPQTMz8pAy9hMNzw+4oyPYtc7UMkTUyD8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792416076; v=1; x=1793020876;
 b=TK3YWf0jkioYFAtNlIsw71RiN7/dj33Vpy5fc28k21OiXX8ihe1nBZ2WqIS59xzWdw0uoGyX
 Nu/vSD1iF+t6Mh3JnYsgDpleATOasp0uYcgmeU/cjgnAt6DkHNEdQIIm/KzvuBqnb7RYYFvLdw7
 Bt87F3oOn1BjQOMtxvBmTv4w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 409a3763f14ff9d2;
	Mon, 19 Oct 2026 13:21:16 +0000
X-Mizu-Trace-ID: 409a3763f14ff9d2
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
Date: Mon, 19 Oct 2026 14:21:02 +0100
Message-ID: <20261019132103.3836646-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019132103.3836646-1-fuad.tabba@linux.dev>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM_ARM_MTE_COPY_TAGS copies tags into a page, it marks the page as
tagged. For a hugetlb folio the flag covers every page in the folio. If
the folio wasn't tagged yet, its other pages are marked as tagged with
their previous owner's tags still in place. The stage-2 fault path then
maps them into the guest without clearing them. The ioctl's read side
also copies them out to the VMM.

Clear the whole folio on its first tagging, before copying in this
page's tags.

Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/guest.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b01d6622b8720..cda655fbff657 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1012,6 +1012,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		void *maddr;
 		unsigned long num_tags;
 		struct folio *folio;
+		unsigned long i;
 
 		if (!page) {
 			ret = -EFAULT;
@@ -1042,12 +1043,14 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			/*
 			 * Only locking to serialise with a concurrent
 			 * __set_ptes() in the VMM but still overriding the
-			 * tags, hence ignoring the return value.
+			 * tags. A hugetlb folio is marked tagged as a whole,
+			 * so its first tagging clears every page.
 			 */
-			if (folio_test_hugetlb(folio))
-				folio_try_hugetlb_mte_tagging(folio);
-			else
+			if (!folio_test_hugetlb(folio))
 				try_page_mte_tagging(page);
+			else if (folio_try_hugetlb_mte_tagging(folio))
+				for (i = 0; i < folio_nr_pages(folio); i++)
+					mte_clear_page_tags(page_address(folio_page(folio, i)));
 			num_tags = mte_copy_tags_from_user(maddr, tags,
 							MTE_GRANULES_PER_PAGE);
 
-- 
2.47.3

