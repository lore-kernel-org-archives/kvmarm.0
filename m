Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C883B9DBB;
	Mon, 29 Jun 2026 11:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731922; cv=none; b=a7aNLjAzSwGzNDiTjWOE9BxjhMKbwwMyPXMxNR12+6BDA72+J1BKgKPrEYLKtxaXci6dz5y8NINidOTf5AzeCbW9jNgVOiMzJZ94hwOuM9QZ8p/h6fV/Ta8hbsMciNae6LxxWMbxVFOwR0WOftt8Y03q/Cs301D2mIKQcFrsJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731922; c=relaxed/simple;
	bh=vqEhf/sbRP1rwv44a6q+3NurUky3BY41N3vWulsb12Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGpxRyzfgClV7Bypvo6jMvRUXdWOmF/ECy/eJmpXSed6djoV1TydqaBjdIV0fJyQ9uzkfzSxpLhaQhsBsX4+W28zya5IT4QryCNwh7goJxf0zdqtdRCFEOMcopxqf1O7E5smyL63Voi8XwBjZFUwhZ9SU4yNj483wzXBuViEVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FLm+FqS7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FLm+FqS7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2135169C;
	Mon, 29 Jun 2026 04:18:35 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC86B3F905;
	Mon, 29 Jun 2026 04:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731920; bh=vqEhf/sbRP1rwv44a6q+3NurUky3BY41N3vWulsb12Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLm+FqS71GHRVQHXLN9WA3unnz7568EYd+GK/o/HBTHi68mRSblD+pEscg6QKDMxJ
	 7BfSvAKGYCSsQXjjCFHXc98hzLpu9xEFRwN9pg2MPW1p1riBLkJNZeC6jgxg5KQmui
	 C9xjBL8kIRmEyzFG5SWN4VLCjoQF+hqUTHgb+GvY=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Mon, 29 Jun 2026 12:17:50 +0100
Message-ID: <20260629111820.1873540-3-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1690; i=leo.bras@arm.com; h=from:subject; bh=vqEhf/sbRP1rwv44a6q+3NurUky3BY41N3vWulsb12Y=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhLKefvY5ySct37OvpL1ydd7z8wtd8XMVfVb/JiPU Uyu9ZpORykLgxgXg6yYIovso/mreL5PyThy5ccCmDmsTCBDGLg4BWAi25MZGb7UHnK1YDn0SvLV 9wcrXZfpGD0WnxC4tKugc/GrFVFP5qUw/E9k2X1jZl1zov/vd1zn5lruXX10lruv9ucL3HW7POv bUjkA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

FEAT_HDBSS speeds up guest memory dirty tracking by avoiding a page fault
and saving the entry in a tracking structure.

That may be a problem when we have guest memory backed by hugepages or
transparent huge pages, as it's not possible to do on-demand hugepage
splitting, relying only on eager hugepage splitting.

So, at stage2 initialization, enable eager hugepage splitting with
chunk = 256K * PAGE_SIZE if the system supports HDBSS.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..e086c01a9325 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1020,22 +1020,26 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
 	if (!mmu->last_vcpu_ran) {
 		err = -ENOMEM;
 		goto out_destroy_pgtable;
 	}
 
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
-	 /* The eager page splitting is disabled by default */
-	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+	 /* The eager page splitting is disabled by default if system has no HDBSS */
+	if (system_supports_hdbss())
+		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
+	else
+		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
 
 	mmu->pgd_phys = __pa(pgt->pgd);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
 	return 0;
 
 out_destroy_pgtable:
-- 
2.54.0

