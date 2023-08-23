Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC38BE64
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 13:14:47 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 919B61576;
	Wed, 23 Aug 2023 06:15:27 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 415F23F740;
	Wed, 23 Aug 2023 06:14:41 -0700 (PDT)
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
Subject: [PATCH RFC 06/37] mm: page_alloc: Allocate from movable pcp lists only if ALLOC_FROM_METADATA
Date: Wed, 23 Aug 2023 14:13:19 +0100
Message-Id: <20230823131350.114942-7-alexandru.elisei@arm.com>
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

pcp lists keep MIGRATE_METADATA pages on the MIGRATE_MOVABLE list. Make
sure pages from the movable list are allocated only when the
ALLOC_FROM_METADATA alloc flag is set, as otherwise the page allocator
could end up allocating a metadata page when that page cannot be used.

__alloc_pages_bulk() sidesteps rmqueue() and calls __rmqueue_pcplist()
directly. Add a check for the flag before calling __rmqueue_pcplist(), and
fallback to __alloc_pages() if the check is false.

Note that CMA isn't a problem for __alloc_pages_bulk(): an allocation can
always use CMA pages if the requested migratetype is MIGRATE_MOVABLE, which
is not the case with MIGRATE_METADATA pages.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 mm/page_alloc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 829134a4dfa8..a693e23c4733 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2845,11 +2845,16 @@ struct page *rmqueue(struct zone *preferred_zone,
 
 	if (likely(pcp_allowed_order(order))) {
 		/*
-		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
-		 * we need to skip it when CMA area isn't allowed.
+		 * PCP lists keep MIGRATE_CMA/MIGRATE_METADATA pages on the same
+		 * movable list. Make sure it's allowed to allocate both type of
+		 * pages before allocating from the movable list.
 		 */
-		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
-				migratetype != MIGRATE_MOVABLE) {
+		bool movable_allowed = (!IS_ENABLED(CONFIG_CMA) ||
+					(alloc_flags & ALLOC_CMA)) &&
+				       (!IS_ENABLED(CONFIG_MEMORY_METADATA) ||
+					(alloc_flags & ALLOC_FROM_METADATA));
+
+		if (migratetype != MIGRATE_MOVABLE || movable_allowed) {
 			page = rmqueue_pcplist(preferred_zone, zone, order,
 					migratetype, alloc_flags);
 			if (likely(page))
@@ -4388,6 +4393,14 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		goto out;
 	gfp = alloc_gfp;
 
+	/*
+	 * pcp lists puts MIGRATE_METADATA on the MIGRATE_MOVABLE list, don't
+	 * use pcp if allocating metadata pages is not allowed.
+	 */
+	if (metadata_storage_enabled() && ac.migratetype == MIGRATE_MOVABLE &&
+	    !(alloc_flags & ALLOC_FROM_METADATA))
+		goto failed;
+
 	/* Find an allowed local zone that meets the low watermark. */
 	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
-- 
2.41.0

