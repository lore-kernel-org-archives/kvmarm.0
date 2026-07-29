Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D84A448CF4
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322009; cv=none; b=KJ47e34pnZuulZHBTNlm3ufsOFCjVa1qyeBZrqQQyyk+2skZMflSAlqThYYTrRKWcoNlJYrvwxTucplilU55AY9h148XeI6Trw2tgI/z5I3k99wVkgzOTVo9SdRVpW+ZDRyFLIkpo5xNeDCDRkkySdyKIyA15XCm6UBLM3/I6Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322009; c=relaxed/simple;
	bh=ixb/OphbVvSlJT0SHXkOzrFLDyYiSyXRPu+hqyd0RzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNlsiRCMZz3R7hN7N/FYPB6LzXM2gDVcUVZk5DYnA9YzbOKihtm3L1+AClcxIrHzV8wKH5yyjvCBoLQ7uaPIgTzrbQuScNrsx3Xh/PImyAUTJ89c0teW7o3qQdEy+loiNED1J8Jz6f72j7sz/S0/dLXJPXBhByHwx6jN+WLbTLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kSmc8s/R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kSmc8s/R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DB7F202C;
	Wed, 29 Jul 2026 03:46:43 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE0183F66F;
	Wed, 29 Jul 2026 03:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785322007; bh=ixb/OphbVvSlJT0SHXkOzrFLDyYiSyXRPu+hqyd0RzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSmc8s/RTdHvHQr3CJPgIkV9yYejP995Mbp6z8hIW6SR3nAh8saksnYlZoQ0gKFXg
	 gYGzYrl8Jz0pRi7f6XFksW1FDr5armllNEE7R/0Am4czeDXvWTII9PQ1htvMcia0MN
	 eVcQRrkWBvAppABZw/ydIeAhb3IwBg45y/8OPSmw=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 07/11] KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
Date: Wed, 29 Jul 2026 11:45:42 +0100
Message-ID: <20260729104548.3439958-8-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2203; i=leo.bras@arm.com; h=from:subject; bh=ixb/OphbVvSlJT0SHXkOzrFLDyYiSyXRPu+hqyd0RzQ=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb17beorjxT2HxuDzKg3uP6PXnU6+qnB3X1eUY0JRd peXu3lbRykLgxgXg6yYIovso/mreL5PyThy5ccCmDmsTCBDGLg4BWAi838zMjQyuTGb9W084fdh 44Y5WzcrlHnM3LX58MWKa70ftXu2v5nJyLBIqe9gg/yM/b6zYvl6dpZodnEc7zrPlDrVpkrhhMk UbQYA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

If previous dirty-clean already split a block, then avoid calling the
split helper on that block again.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/dirty_bit.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 5a6266205295..d7e624f9b630 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -244,20 +244,21 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
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
+	gpa_t last_split = 0;
 
 	hw_entries = kmalloc_objs(u64, entries_sz, GFP_KERNEL);
 	if (!hw_entries)
 		return -ENOMEM;
 
 	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
 
 	if (log) {
 		start = log->first_page / BITS_PER_LONG;
 		end = start + DIV_ROUND_UP(log->num_pages, BITS_PER_LONG);
@@ -288,24 +289,29 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 
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
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
+			gpa_t split_start = gfn_to_gpa(offset + __ffs(mask));
+			gpa_t split_end =  gfn_to_gpa(offset + __fls(mask) + 1);
+
+			if (split_end > last_split) {
+				kvm_mmu_split_huge_pages(kvm, split_start, split_end);
+				last_split = ALIGN_DOWN(split_end - 1, PMD_SIZE) + PMD_SIZE;
+			}
+		}
 
 		do {
 			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
 			if (idx >= entries_sz) {
 				ret = dirty_bit_clear(kvm, hw_entries, idx);
 				*flush = *flush || ret > 0;
 				if (ret != idx) {
 					/* Restore mask as before processing */
 					atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[i]);
 					end = i + 1;
-- 
2.55.0

