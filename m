Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEE928DAD
	for <kvmarm@lists.linux.dev>; Thu,  4 Jan 2024 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aD8vQWN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2596C433C8;
	Thu,  4 Jan 2024 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704386548;
	bh=TnR23CGpf7NN8xYdZnwypKVjpHPjNqKbCrUSesLYtJ8=;
	h=From:To:Cc:Subject:Date:From;
	b=aD8vQWN8vtXKKNG5FO292zvDvXwyAlKV6gbS3I5VoOWICqFL+QodJ5SzY4d6u3QxD
	 S3BhyDsQNaNhGPYOOOl3nd9sEav7e5zPpqU0yCA4Ja2N/QwwpUk25ARYkezk22bTOm
	 KV50p+1DmgylF+0/xOAPl5TNs0mcEvfBL9BAtjRzwP4Cbghruk/e+/+jkxsy1qy5/q
	 3vJDe/KxNxP1Zt93v/ytaeFIkJsqtCVjMS7c1cFeoX+9GFVKbV+GUzkCtFNhS2KAOW
	 cPgL5dotzIrVNbBOmX8w3UPBOvgMP0NLxonrC+Cih6NriO8A5Vzn1dzMcJxPhATAfO
	 HAwqbf5iAC/IA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	keirf@google.com,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH] KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd
Date: Thu,  4 Jan 2024 16:42:20 +0000
Message-Id: <20240104164220.7968-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit f320bc742bc23 ("KVM: arm64: Prepare the creation of s1
mappings at EL2"), pKVM switches from a temporary host-provided
page-table to its own page-table at EL2. Since there is only a single
TTBR for the nVHE hypervisor, this involves disabling and re-enabling
the MMU in __pkvm_init_switch_pgd().

Unfortunately, the memory barriers here are not quite correct.
Specifically:

  - A DSB is required to complete the TLB invalidation executed while
    the MMU is disabled.

  - An ISB is required to make the new TTBR value visible to the
    page-table walker before the MMU is enabled in the SCTLR.

An earlier version of the patch actually got this correct:

  https://lore.kernel.org/lkml/20210304184717.GB21795@willie-the-truck/

but thanks to some badly worded review comments from yours truly, these
were dropped for the version that was eventually merged.

Bring back the barriers and fix the potential issue (but note that this
was found by code inspection).

Cc: Quentin Perret <qperret@google.com>
Fixes: f320bc742bc23 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 1cc06e6797bd..9205e95f8529 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -292,6 +292,8 @@ alternative_else_nop_endif
 	mov	sp, x0
 
 	/* And turn the MMU back on! */
+	dsb	nsh
+	isb
 	set_sctlr_el2	x2
 	ret	x1
 SYM_FUNC_END(__pkvm_init_switch_pgd)
-- 
2.43.0.472.g3155946c3a-goog

