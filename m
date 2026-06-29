Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303463E1226;
	Mon, 29 Jun 2026 11:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731953; cv=none; b=G9REebNFNG/nERecGY5IVgAGVE2wDIxy83K21Ju+6caT/gDOIvibGb4adTmVoVVMSvvb6C6JSmNYWT3wWlQ6XTVZUHpzt3ezHY4UAKJM9pWCFv7iZe59TZKtigxSg/gZMhonU9isLSUWwg9bUpE904xNj0823EhG2hqrSRL52EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731953; c=relaxed/simple;
	bh=lJewvoJDgRAUeWkoRNdtBdiHG+qUJ6Z9V/0pehqjb+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W47/5cHG+BwxLq67ssm4ABWx6D/HdsFXeziPZeQlC/82Jb5SIzT04EXLmxDXEr8ZJ7GFqvmscf4YBLuIquvDVcJfTYlsWpJ+btVm/zySvz9oUMzgQ3ioDBSRpvL64eTmbl7ozbA6dNpWFbUG5BE9FxAP71cjlasTq+E1UhL37Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FOnapLyX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FOnapLyX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CA0E307A;
	Mon, 29 Jun 2026 04:19:07 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88C803F905;
	Mon, 29 Jun 2026 04:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731951; bh=lJewvoJDgRAUeWkoRNdtBdiHG+qUJ6Z9V/0pehqjb+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOnapLyXnduUafb9p6/sK/mgEaUYFx/HpOf5rprrqrYC6RNXz8D6JXdPFYoND85tJ
	 NzYlLyl2kUV2Z1DR4SiYipZyLM3mIEC4lXFayAI9zwaKIYbcjvO9nlicKbKBdOZ3qS
	 /w+0ti8WktYRQJOQadycSnlLT55pRkzRLIHnMnVg=
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
Subject: [PATCH v2 09/13] KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
Date: Mon, 29 Jun 2026 12:17:57 +0100
Message-ID: <20260629111820.1873540-10-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2190; i=leo.bras@arm.com; h=from:subject; bh=lJewvoJDgRAUeWkoRNdtBdiHG+qUJ6Z9V/0pehqjb+M=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhKd1zM82ekWx5uge27fZO4PZWqWDzsnNGwuSDB7w XfrtqJGRykLgxgXg6yYIovso/mreL5PyThy5ccCmDmsTCBDGLg4BWAiLbMZ/sfNnvlxg8SMUr43 Vb+rP/q3Oqz1dtW6+7/nwh7v81svSL9lZOiWnMRZH6I0faGF3qlwyWlc+5wTix7knu5V+aRxeWW lFC8A
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

If previous dirty-clean already split a block, then avoid calling the
split helper on that block again.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/dirty_bit.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index d05af3de78be..6c928677ce12 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -153,20 +153,21 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 			       bool *flush)
 {
 	int ret = 0;
 	int idx = 0;
 	unsigned long *dirty_bitmap = memslot->dirty_bitmap;
 	u64 *hw_entries;
 	const int entries_sz = PAGE_SIZE / sizeof(*hw_entries);
 	u64 ttwl;
 	u64 start, end;
 	gfn_t base_gfn;
+	gpa_t split_end = 0;
 
 	hw_entries = kmalloc_objs(u64, entries_sz, GFP_KERNEL);
 	if (!hw_entries)
 		return -ENOMEM;
 
 	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
 
 	if (log) {
 		start = log->first_page / BITS_PER_LONG;
 		end = start + DIV_ROUND_UP(log->num_pages, BITS_PER_LONG);
@@ -197,24 +198,28 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 
 			mask = xchg(&dirty_bitmap[i], 0);
 			bitmap[i] = mask;
 		}
 
 		if (!mask)
 			continue;
 
 		offset = base_gfn + i * BITS_PER_LONG;
 
-		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-			kvm_mmu_split_huge_pages(kvm,
-						 gfn_to_gpa(offset + __ffs(mask)),
-						 gfn_to_gpa(offset + __fls(mask) + 1));
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
+		    (offset + BITS_PER_LONG > split_end)) {
+			gpa_t start = gfn_to_gpa(offset + __ffs(mask));
+			gpa_t end = gfn_to_gpa(offset + __fls(mask) + 1);
+
+			kvm_mmu_split_huge_pages(kvm, start, end);
+			split_end = gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
+		}
 
 		do {
 			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
 			if (idx >= entries_sz) {
 				ret = dirty_bit_clear(kvm, hw_entries, idx);
 				*flush = *flush || ret > 0;
 				if (ret != idx) {
 					/* Save bits not converted back to bitmap */
 					atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[i]);
 					goto out_err;
-- 
2.54.0

