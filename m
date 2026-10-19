Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB24E80BD
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416075; cv=none; b=RWNorEOJiNBhlrn7bOyKhbUIK8WaGCVDowx/2OR1+WmGAFoEKwPWv+HDfu+B1CApWRpk3J4gezNAX0CTJjOtPnG7JOvIMFs4sQP9GAMy87Sy3SPtxrAANyTBh2DiziXP5US+FvWrlk3Dj7aQJMnjtpuTvHOeyF6jnn3Xky40C/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416075; c=relaxed/simple;
	bh=5fJGL4C4mMNi8vcFoFABt8pOi03qIUjPdJtacS8L23s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqZUeWVtn+DE40/09NkVdasGCXu14Bb1Z+dzJBh/uKOXhSlwf/1mr+QE32zXE3xhV/0eI/QZanTfCRY/ohfMwd0O5ciH+VuKPbA3aoiDO0Ab2TvbOMSzizAF4CgCp0sBaHtmbrAmQ78fXAcZjUuUjD/im4f/dfLPYKVb/sq/8r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C6MXiTZ2; arc=none smtp.client-ip=95.215.58.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C6MXiTZ2"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5fJGL4C4mMNi8vcFoFABt8pOi03qIUjPdJtacS8L23s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792416071; v=1; x=1793020871;
 b=C6MXiTZ2RIKcR4M0KOxR0qb5p/hnqWSTNcd7WWQwqdEt6paMSjAL32qaZu4665ERJD9e0zWU
 7ltWn81gDKFRu9ovoQrHrFtTEqi+F5XcQTACOgEZDgphPNXkPRLEI8gKG6bfutCoWj1xeXvuITM
 GpfMHmDbCpnnpBnEfCcaeig4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e803656b720e69e6;
	Mon, 19 Oct 2026 13:21:11 +0000
X-Mizu-Trace-ID: e803656b720e69e6
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
Subject: [PATCH 1/3] KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
Date: Mon, 19 Oct 2026 14:21:01 +0100
Message-ID: <20261019132103.3836646-2-fuad.tabba@linux.dev>
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

sanitise_mte_tags() clears the tags of the pages about to be mapped at
stage-2 before marking them tagged. For a hugetlb folio the flag covers
every page in the folio, but the loop only covers the mapping being
installed. Stage-2 maps a folio in pieces for the contiguous hugetlb
sizes, and for any size under dirty logging. The first fault then marks
the whole folio after clearing only its own piece, and the rest keeps
its previous owner's tags for the guest to read.

Clear the whole folio, as mte_sync_tags() does.

Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..48a08b608ea72 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1514,7 +1514,8 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	if (folio_test_hugetlb(folio)) {
 		/* Hugetlb has MTE flags set on head page only */
 		if (folio_try_hugetlb_mte_tagging(folio)) {
-			for (i = 0; i < nr_pages; i++, page++)
+			page = folio_page(folio, 0);
+			for (i = 0; i < folio_nr_pages(folio); i++, page++)
 				mte_clear_page_tags(page_address(page));
 			folio_set_hugetlb_mte_tagged(folio);
 		}
-- 
2.47.3

