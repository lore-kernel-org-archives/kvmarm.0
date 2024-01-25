Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BDA13541D
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706200986; cv=none; b=mwWeB7+5ihPRdPSeCmsr+HQtDDg02ZEAUmDerwX31gY/MQk0hSwGqHfgz2v5kRk+o/WHbpnfzACJriF00Wlnmf220IFr0aJSiovMtuwF6/1SPoohLshlDSXMkAoCKpKQo31b4moBkWD1kAUVST2Y0LNM2eV+cOxU03I7ahGXs9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706200986; c=relaxed/simple;
	bh=D/hqHT7m4p56hZz+nSWR5TR3chuuOg75oPh3Ho54hkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=joz1iVERb9yLabO48rxmZmMjs1V1JH820rPvH5FcIyZUZmHX3RgtEgTxgzGotr/SMh9GEcryGPCyEMqV2lR/1clr/cGjet/FWkWc/7bWBPba9jXwJrRDDZ9EAkwKzX4Hbrl6w7+eDAjH53O09qW5M7/PyefeqxzsSHIxQygQxX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2B4A1477;
	Thu, 25 Jan 2024 08:43:48 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1DA43F5A1;
	Thu, 25 Jan 2024 08:42:58 -0800 (PST)
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
Subject: [PATCH RFC v3 03/35] mm: page_alloc: Add an arch hook to filter MIGRATE_CMA allocations
Date: Thu, 25 Jan 2024 16:42:24 +0000
Message-Id: <20240125164256.4147-4-alexandru.elisei@arm.com>
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

As an architecture might have specific requirements around the allocation
of CMA pages, add an arch hook that can disable allocations from
MIGRATE_CMA, if the allocation was otherwise allowed.

This will be used by arm64, which will put tag storage pages on the
MIGRATE_CMA list, and tag storage pages cannot be tagged. The filter will
be used to deny using MIGRATE_CMA for __GFP_TAGGED allocations.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/pgtable.h | 7 +++++++
 mm/page_alloc.c         | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 6d98d5fdd697..c5ddec6b5305 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -905,6 +905,13 @@ static inline void arch_do_swap_page(struct mm_struct *mm,
 static inline void arch_free_pages_prepare(struct page *page, int order) { }
 #endif
 
+#ifndef __HAVE_ARCH_ALLOC_CMA
+static inline bool arch_alloc_cma(gfp_t gfp)
+{
+	return true;
+}
+#endif
+
 #ifndef __HAVE_ARCH_UNMAP_ONE
 /*
  * Some architectures support metadata associated with a page. When a
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27282a1c82fe..a96d47a6393e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3157,7 +3157,8 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
 						  unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE &&
+	    arch_alloc_cma(gfp_mask))
 		alloc_flags |= ALLOC_CMA;
 #endif
 	return alloc_flags;
-- 
2.43.0

