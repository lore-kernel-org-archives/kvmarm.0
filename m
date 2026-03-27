Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E5722F177
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620117; cv=none; b=UwPUPegrs85Vgrj0xyhv/gFoaaaTq8txpFdonvdvby5AGk+z59pQSbu9yr44vhmaiji/vd8nQexCT1rT2QnFpf7hCFp3uJoFz+rjittxkQRuPib4hSxk0828YBPrJQ8zsmB5watmiTXhwlv63c/4H2cgfvwH4k507S6rKVh1JLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620117; c=relaxed/simple;
	bh=7j8yBkqQI9cz054zxle+5jUI341HVt5dkS3HCJOIz8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r873C0bLnBeZKYKBiBSd6BYrMWjRarAlzf1aSeVdh0jXQQK7kof1GLBSsLP4+neOSHR9ChDmjXLvb+bPDZpu3gnRubR/TvinMgCzkiM3FmuGFn8VvXx7GBynpa+J9e2j1qNA+AJdHY0kwyNtv5vi+mrlElrBOad6wkMgUFqqPoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoGtmbwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoGtmbwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E30C19423;
	Fri, 27 Mar 2026 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620116;
	bh=7j8yBkqQI9cz054zxle+5jUI341HVt5dkS3HCJOIz8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoGtmbwWDPYp8gMtlRWdRhatYc36K1f2e7ChAeTFigVTLUdCc+Lu9c8sJm+GuDcZ2
	 /gsI2jPsL+ecPOG8qj3LnB/movfydj5uX9PScwW/m0ngTFBR3FWHoNoQIIWnW+aM9e
	 9VZV9EUnYSdJSy8NLSGFCKWDQAJkvHjvVqDIY1fyy//nj8jUVpYseDR02w1CUdwOVe
	 h1Ad2/VIYPj05rfUk3mStRwdl3e6Kx89lhkpxtRmRtGKsZUIGEH9dxRzdx5rWRFiLe
	 GbKMe5eZ3ww2d9tQ2GVq3nVSidI8IEw70YBwjyNK2vgq4SoCAJTtsqzH0eSg3sqz5A
	 AOfJBiz3xyjeA==
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
Subject: [PATCH v4 20/38] KVM: arm64: Avoid pointless annotation when mapping host-owned pages
Date: Fri, 27 Mar 2026 14:00:19 +0000
Message-ID: <20260327140039.21228-21-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

