Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D322E091B
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882197; cv=none; b=FeeJd+oizXriM2Q2JrUBar0gM1q5xqFrTvwYC6oO8jjx9doz8W9HBZTi/YW6QWJcO/3zoiOpc6dHDnY6qJHvcu0Usy+lMnQahyIMCUXfLMRUrNADLzeBXxezLhfL0zGBMH+T6b87MUOFKTdJA6hG71NQ4FDBQiirCx9eoDGwl+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882197; c=relaxed/simple;
	bh=7j8yBkqQI9cz054zxle+5jUI341HVt5dkS3HCJOIz8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT4bvnHqdk1xK3XI2aTiUXSRSRGibgesBjCA6KgZcexv79RefrUc5PYDDO6t+FYm2JEFRQ32dg9gZWn5wfRZTFaNgSndO19knWyFf2ylvG2JlgYXCm5pR48nJAK8JxybScAl5xxd8NgnzaLxQaZ+cTwWOyh4vDKs8Sz+RDJdIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cT9sizgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cT9sizgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E669C4CEF7;
	Mon, 30 Mar 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882197;
	bh=7j8yBkqQI9cz054zxle+5jUI341HVt5dkS3HCJOIz8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT9sizgJPQ7mSotul7kpay4TCwtpMTyPnHuUMuiStrLo4qefSP+6OCi+hrXnlx6iK
	 +n2qYmCRxmEQY7Dk7NUV/xTPUxiF+cYDsPLh3wM++0/snpEeZJ+NKJVMI6AAX+JUhb
	 JxlHOt4rPJl4nvhu6xvHImkIxgwYe3xD1QP7tTdiSythrdElBILgAp1PsWnCV4Z4LW
	 SY4vejQSa1ll4jRx96whcEphreAidj5KN9U8iYwgWrY5dVkjaEBzRss727kX4MP3nJ
	 KQaObQXZoDeaKBrLJ8S/0rgZzdMdw4wfksd78nv5JmScuWH3uMq5Ju5AHuCzHk+STq
	 7X3+vaWQAr22w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 20/38] KVM: arm64: Avoid pointless annotation when mapping host-owned pages
Date: Mon, 30 Mar 2026 15:48:21 +0100
Message-ID: <20260330144841.26181-21-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a page is transitioned to host ownership, we can eagerly map it
into the host stage-2 page-table rather than going via the convoluted
step of a faulting annotation to trigger the mapping.

Call host_stage2_idmap_locked() directly when transitioning a page to
be owned by the host.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0e57dc1881e0..bf5102594fc8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -551,23 +551,27 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
-	int ret;
+	int ret = -EINVAL;
 
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
-	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-			      addr, size, &host_s2_pool, owner_id);
-	if (ret)
-		return ret;
+	switch (owner_id) {
+	case PKVM_ID_HOST:
+		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
+		if (!ret)
+			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		break;
+	case PKVM_ID_GUEST:
+	case PKVM_ID_HYP:
+		ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
+				      addr, size, &host_s2_pool, owner_id);
+		if (!ret)
+			__host_update_page_state(addr, size, PKVM_NOPAGE);
+		break;
+	}
 
-	/* Don't forget to update the vmemmap tracking for the host */
-	if (owner_id == PKVM_ID_HOST)
-		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
-	else
-		__host_update_page_state(addr, size, PKVM_NOPAGE);
-
-	return 0;
+	return ret;
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
-- 
2.53.0.1018.g2bb0e51243-goog

