Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF8EBE64
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 13:14:53 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6AC91595;
	Wed, 23 Aug 2023 06:15:33 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51AF33F740;
	Wed, 23 Aug 2023 06:14:47 -0700 (PDT)
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
Subject: [PATCH RFC 07/37] mm: page_alloc: Bypass pcp when freeing MIGRATE_METADATA pages
Date: Wed, 23 Aug 2023 14:13:20 +0100
Message-Id: <20230823131350.114942-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230823131350.114942-1-alexandru.elisei@arm.com>
References: <20230823131350.114942-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a metadata page is returned to the page allocator because all the
associated pages with metadata were freed, the page will be returned to the
pcp list, which makes it very likely that it will be used to satisfy an
allocation request.

This is not optimal, because metadata pages should be used as a last
resort, to increase the chances they are not in use when they are needed,
to avoid costly page migration. Bypass the pcp lists when freeing metadata
pages.

Note that metadata pages can still end up on the pcp lists when a list is
refilled, but this should only happen when memory is running low, which is
as intended

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a693e23c4733..bbb49b489230 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2478,7 +2478,8 @@ void free_unref_page(struct page *page, unsigned int order)
 	 */
 	migratetype = get_pcppage_migratetype(page);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (unlikely(is_migrate_isolate(migratetype) ||
+			     is_migrate_metadata(migratetype))) {
 			free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
 			return;
 		}
@@ -2522,7 +2523,8 @@ void free_unref_page_list(struct list_head *list)
 		 * comment in free_unref_page.
 		 */
 		migratetype = get_pcppage_migratetype(page);
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (unlikely(is_migrate_isolate(migratetype) ||
+			     is_migrate_metadata(migratetype))) {
 			list_del(&page->lru);
 			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
 			continue;
-- 
2.41.0

