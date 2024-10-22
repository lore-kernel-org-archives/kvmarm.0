Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB7E19F105
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608025; cv=none; b=IiSZQps9ab2iWLuk2Dcvhaawr3Y2EBOLvnXIbc5EEwGS9Q3EXtlOat76BKx9DmFmG5ikPB1jJZRf+a+Tx11c95xwtF5XsicLTyXaC4PcWO+RXsuVz/4FqfUl8CH5zf1gFMj/ONpPnslpSoflJPQSB7kDUuDPeRxY5vvQ3/b7A+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608025; c=relaxed/simple;
	bh=Alv9dWrIr7MfCsksp8/aH8Z898+iDvie7akcrAqRG+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fRzWbeBlry7MghmKjJrRDC9zHykb5AbeWOeY/yCAiXez3JmwN7/7rah5sNv6s/FJ9RLZsfbVj3K40lWpZiaH3IpTUrJHKxtDdkfmLfp/vWhYY83a6vvZQMzj776Z2Es3A4Y2QwhYTu9Zh1zmNoYC+Fd4OYI4jmGNOJ18jZwDsuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fX28e2+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fX28e2+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB93AC4CEC7;
	Tue, 22 Oct 2024 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729608025;
	bh=Alv9dWrIr7MfCsksp8/aH8Z898+iDvie7akcrAqRG+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fX28e2+JJqYbWXSriya9TLncm0MwdS7FDoH26Og2tXBerGEmDAtwfVPC9X1FRvoqc
	 qg46ih8q92cQo2005+D9nQxu0gM2PUx5AO3gYG8XfuUpsFy0wPT1hYFr4ILgLwIomn
	 Pge+ftB+jUta0GKA8I9MrHVHkc0/ntJZrIxbSyh8Il7413aiyW1uHlzmmA0Jhk31RP
	 MqTAuW/KHxcDMLzVwKd8njy+rUl3SccKw6R7teC9QgZbv/9aLzIqQj9YsNa8h3WzKr
	 W3RYv1f3AxWPvGxEvYYzbUkuMvl1bMc7AUzsu/P+4P++wAeBdnG/OdM+venLAzg7RJ
	 1vgJoEjIfgzkA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 2/2] KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM
Date: Tue, 22 Oct 2024 15:40:16 +0100
Message-Id: <20241022144016.27350-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241022144016.27350-1-will@kernel.org>
References: <20241022144016.27350-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that 'kvm_vgic_global_state' is no longer needed for ICC_CTLR_EL1
emulation on machines with a broken SEIS implementation, drop the
pKVM hypervisor mapping of the page.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 174007f3fadd..8fec099c2775 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -95,7 +95,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 {
 	void *start, *end, *virt = hyp_phys_to_virt(phys);
 	unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
-	enum kvm_pgtable_prot prot;
 	int ret, i;
 
 	/* Recreate the hyp page-table using the early page allocator */
@@ -148,22 +147,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	}
 
 	pkvm_create_host_sve_mappings();
-
-	/*
-	 * Map the host sections RO in the hypervisor, but transfer the
-	 * ownership from the host to the hypervisor itself to make sure they
-	 * can't be donated or shared with another entity.
-	 *
-	 * The ownership transition requires matching changes in the host
-	 * stage-2. This will be done later (see finalize_host_mappings()) once
-	 * the hyp_vmemmap is addressable.
-	 */
-	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
-	ret = pkvm_create_mappings(&kvm_vgic_global_state,
-				   &kvm_vgic_global_state + 1, prot);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
-- 
2.47.0.105.g07ac214952-goog

