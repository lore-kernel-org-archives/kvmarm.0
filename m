Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7BD130E3B
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706200992; cv=none; b=a78oNqJXRc182exg5yMUKBepxx8u0EHE13WBmL7K0Xltk9a/VPjTjoKXfjXJezbpzQQh1mtO3WbIgjR83Zepvj5lfnahSJ3bLIhWA5ba27zOm3w4LpImCAATY7h580ktIExdyRHrlTRPhsHpbMpYx6QhxqLZd7GX7JvlR4RU6Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706200992; c=relaxed/simple;
	bh=L8FwdsU6xsMs5YX7ltLK2e5AAE0XBTlL9IKmoi9QVAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H/QriXzFqIUR0HCjag7M1W6+HgFltoyisKY60Tssl6n1aOpue7jsFAOj4QmT5lJ8wMm+EYmyrEZhgCjLvyPU2yuwHeJRJt1wn1qD9lvfYn/KPXBZvZUqyoXonmwALNlLW9K5WY5P1xI5aCg8SOSEe8Zm+3cDk+U+PtlS5hBFEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2D5A1480;
	Thu, 25 Jan 2024 08:43:54 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADAA33F5A1;
	Thu, 25 Jan 2024 08:43:04 -0800 (PST)
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
Subject: [PATCH RFC v3 04/35] mm: page_alloc: Partially revert "mm: page_alloc: remove stale CMA guard code"
Date: Thu, 25 Jan 2024 16:42:25 +0000
Message-Id: <20240125164256.4147-5-alexandru.elisei@arm.com>
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

The patch f945116e4e19 ("mm: page_alloc: remove stale CMA guard code")
removed the CMA filter when allocating from the MIGRATE_MOVABLE pcp list
because CMA is always allowed when __GFP_MOVABLE is set.

With the introduction of the arch_alloc_cma() function, the above is not
true anymore, so bring back the filter.

This is a partially revert because the stale comment remains removed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 mm/page_alloc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a96d47a6393e..0fa34bcfb1af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2897,10 +2897,17 @@ struct page *rmqueue(struct zone *preferred_zone,
 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 
 	if (likely(pcp_allowed_order(order))) {
-		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
-		if (likely(page))
-			goto out;
+		/*
+		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
+		 * we need to skip it when CMA area isn't allowed.
+		 */
+		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
+				migratetype != MIGRATE_MOVABLE) {
+			page = rmqueue_pcplist(preferred_zone, zone, order,
+					migratetype, alloc_flags);
+			if (likely(page))
+				goto out;
+		}
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-- 
2.43.0

