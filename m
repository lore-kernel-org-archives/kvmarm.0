Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D0A35E555
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826871; cv=none; b=DL00FasIxgiRYpDWYR6+6FTZVG9a7kRbh6ly2v0yMdUb6RlvHgO0IkpTKFFWoU5Hx9SEmM6mkmkD+dnb3FbGkeQM20B6ZG94pA6Fa4ztd/7vLR7CuK+xPEMGDMr3eaDN2lbF4hsxqMNtZwYXbRiIgTct5tjxceu0qxG5TwSk46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826871; c=relaxed/simple;
	bh=dho1o9707vRIbiqjbtmi+2dtTxVC+p5ANdKHPSqzL+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3IHGT/B3AFNzljET6WqPYVrkhx6gaXhW4hNja5OQaCCdWJFfnrB3QRprBa3YiNYGE6Zb71dK6r5R5psVb80DLT6CEcOk2oo8PqXGV+1yTIo9+q/Ia+WqS7E4kZHwfrLWKG5CDRTp9R6fOmoWfmE0gYB8jQdZB+RgjC0E+0gfLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CClp33LS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CClp33LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3797BC19423;
	Mon, 19 Jan 2026 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826871;
	bh=dho1o9707vRIbiqjbtmi+2dtTxVC+p5ANdKHPSqzL+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CClp33LSTps8j+f3Zl6NBnYjMGl87VUUMqOB7iCOIg5HrkkQib4Mo1KFjwphK12Ig
	 m5KXk6XVnnxlw/Y7x7Rsr+6JrSf/MdHsSOHZl3VftR0dnJsIpFi72yxgLbIlwKm5+k
	 w3g6M6NYitHCz6OnxAdmCE8JQvhtUW7NoTOdmH7tXJYccDzWHxOI+XecHpePgLGYJp
	 StHpiLFYqt8gVSxGwUGZw6ApoGLU0nM1GoAlpJ69FVUi0hjIS6cYEkZLirRwGmjbNI
	 VllbEloDQPr0x1zgUZi0RhWgClm+FiV9oiQyLCyBMREtySQsAaPlwNvMs3XC/Unzp/
	 VkfrP8iD07pqg==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 19/35] KVM: arm64: Avoid pointless annotation when mapping host-owned pages
Date: Mon, 19 Jan 2026 12:46:12 +0000
Message-ID: <20260119124629.2563-20-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 41469df46e09..55df0c45b0f2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -548,23 +548,27 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 
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
2.52.0.457.g6b5491de43-goog

