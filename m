Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89525144608
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201137; cv=none; b=qa1sDgjrfWgpNcU5NTW33iaQofFoa/Wuo290OmAj0cKmLaRZJUylbHUQO2OwCktRbXTSLzGB4Noum1LSKNJIV0sW3jDWI1lvg2p4yh09pJ+sZhJG2fHPTW6MD3REm+MaFSaT1xO6XmJ0ZTVA1JllFeha/Ed2eiFtOvMqXJ8N+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201137; c=relaxed/simple;
	bh=bKe4q9E3h296O12M5Ghi6NQYQfbP48hS2WvtPTdyhHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RKke1A8/FxZxJWa4DZW44jcDrnXBZmSZbjiSdT/oRAPg3DXIVjWfLoNFLTkK/fdRy+M2VQxDUJnD92obUnyixGo7uz2FQhyOisUlUb+weZ+5jNBYADtvthY4reQxkw/bMHad+8eePwbz2dWdL9dFBBeu0zG1a+IcXllT3u5Vz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0743516F3;
	Thu, 25 Jan 2024 08:46:19 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E2EF3F5A1;
	Thu, 25 Jan 2024 08:45:28 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	bristot@redhat.com,
	vschneid@redhat.com,
	mhiramat@kernel.org,
	rppt@kernel.org,
	hughd@google.com
Cc: pcc@google.com,
	steven.price@arm.com,
	anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com,
	david@redhat.com,
	eugenis@google.com,
	kcc@google.com,
	hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC v3 29/35] arm64: mte: copypage: Handle tag restoring when missing tag storage
Date: Thu, 25 Jan 2024 16:42:50 +0000
Message-Id: <20240125164256.4147-30-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125164256.4147-1-alexandru.elisei@arm.com>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are several situations where copy_highpage() can end up copying
tags to a page which doesn't have its tag storage reserved.

One situation involves migration racing with mprotect(PROT_MTE): VMA is
initially untagged, migration starts and destination page is allocated
as untagged, mprotect(PROT_MTE) changes the VMA to tagged and userspace
accesses the source page, thus making it tagged.  The migration code
then calls copy_highpage(), which will copy the tags from the source
page (now tagged) to the destination page (allocated as untagged).

Yes another situation can happen during THP collapse. The huge page that
will replace the HPAGE_PMD_NR contiguous mapped pages is allocated with
__GFP_TAGGED not set. copy_highpage() will copy the tags from the pages
being replaced to the huge page which doesn't have tag storage reserved.

The situation gets even more complicated when the replacement huge page
is a tag storage page. The tag storage huge page will be migrated after
a fault on access, but the tags from the original pages must be copied
over to the huge page that will be replacing the tag storage huge page.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/mm/copypage.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index a7bb20055ce0..e991ccb43fb7 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -13,6 +13,59 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/mte.h>
+#include <asm/mte_tag_storage.h>
+
+#ifdef CONFIG_ARM64_MTE_TAG_STORAGE
+static inline bool try_transfer_saved_tags(struct page *from, struct page *to)
+{
+	void *tags;
+	bool saved;
+
+	VM_WARN_ON_ONCE(!preemptible());
+
+	if (page_mte_tagged(from)) {
+		if (page_tag_storage_reserved(to))
+			return false;
+
+		tags = mte_allocate_tag_buf();
+		if (WARN_ON(!tags))
+			return true;
+
+		mte_copy_page_tags_to_buf(page_address(from), tags);
+		saved = mte_save_tags_for_pfn(tags, page_to_pfn(to));
+		if (!saved)
+			mte_free_tag_buf(tags);
+
+		return saved;
+	}
+
+	tags_by_pfn_lock();
+	tags = mte_erase_tags_for_pfn(page_to_pfn(from));
+	tags_by_pfn_unlock();
+
+	if (likely(!tags))
+		return false;
+
+	if (page_tag_storage_reserved(to)) {
+		WARN_ON_ONCE(!try_page_mte_tagging(to));
+		mte_copy_page_tags_from_buf(page_address(to), tags);
+		set_page_mte_tagged(to);
+		mte_free_tag_buf(tags);
+		return true;
+	}
+
+	saved = mte_save_tags_for_pfn(tags, page_to_pfn(to));
+	if (!saved)
+		mte_free_tag_buf(tags);
+
+	return saved;
+}
+#else
+static inline bool try_transfer_saved_tags(struct page *from, struct page *to)
+{
+	return false;
+}
+#endif
 
 void copy_highpage(struct page *to, struct page *from)
 {
@@ -24,6 +77,9 @@ void copy_highpage(struct page *to, struct page *from)
 	if (kasan_hw_tags_enabled())
 		page_kasan_tag_reset(to);
 
+	if (tag_storage_enabled() && try_transfer_saved_tags(from, to))
+		return;
+
 	if (system_supports_mte() && page_mte_tagged(from)) {
 		/* It's a new page, shouldn't have been tagged yet */
 		WARN_ON_ONCE(!try_page_mte_tagging(to));
-- 
2.43.0

