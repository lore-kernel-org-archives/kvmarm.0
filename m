Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160C41386AC
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201009; cv=none; b=uLnXXLTx7KYhbRLm2YDjCEofxCVg1xeEtRs81l6bqDFPC2WLFN5ellaQ0JPHPF2IQsquCXrBVM+grmMA3oYepvb3J45P4b3MtHp6OBaV20PBh+43RVY1DiDaNzhYbo5Zb6m9LIwhgeRux1IoTDB3398TKeVMJLcCgEVtUhcyBXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201009; c=relaxed/simple;
	bh=iJY2JnHpfOobyLxdsi5Dz0+NbwyQF3jtod656QDsJqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uSXnRyjAcNRvWlXWIbfBcFcU1FZxXiiGrIG1HOCNVa0zZrOxN1i6h7DwPKxO8qptmRU0YCDi8lTeRPLCLKe1Qp8i9XgmH2TsDunaWAyFDCNYFoU8h0cah50wS9q0DXduIMsl48/VdhNnW4dmCZdgUrmX0k5Pjb+hQi2H3NYbOq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9A0F1515;
	Thu, 25 Jan 2024 08:44:11 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 053093F5A1;
	Thu, 25 Jan 2024 08:43:21 -0800 (PST)
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
Subject: [PATCH RFC v3 07/35] mm: cma: Add CMA_RELEASE_{SUCCESS,FAIL} events
Date: Thu, 25 Jan 2024 16:42:28 +0000
Message-Id: <20240125164256.4147-8-alexandru.elisei@arm.com>
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

Similar to the two events that relate to CMA allocations, add the
CMA_RELEASE_SUCCESS and CMA_RELEASE_FAIL events that count when CMA pages
are freed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes since rfc v2:

* New patch.

 include/linux/vm_event_item.h | 2 ++
 mm/cma.c                      | 6 +++++-
 mm/vmstat.c                   | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 747943bc8cc2..aba5c5bf8127 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -83,6 +83,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 #ifdef CONFIG_CMA
 		CMA_ALLOC_SUCCESS,
 		CMA_ALLOC_FAIL,
+		CMA_RELEASE_SUCCESS,
+		CMA_RELEASE_FAIL,
 #endif
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
diff --git a/mm/cma.c b/mm/cma.c
index dbf7fe8cb1bd..543bb6b3be8e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -562,8 +562,10 @@ bool cma_release(struct cma *cma, const struct page *pages,
 {
 	unsigned long pfn;
 
-	if (!cma_pages_valid(cma, pages, count))
+	if (!cma_pages_valid(cma, pages, count)) {
+		count_vm_events(CMA_RELEASE_FAIL, count);
 		return false;
+	}
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
@@ -575,6 +577,8 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	cma_clear_bitmap(cma, pfn, count);
 	trace_cma_release(cma->name, pfn, pages, count);
 
+	count_vm_events(CMA_RELEASE_SUCCESS, count);
+
 	return true;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index db79935e4a54..eebfd5c6c723 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1340,6 +1340,8 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_CMA
 	"cma_alloc_success",
 	"cma_alloc_fail",
+	"cma_release_success",
+	"cma_release_fail",
 #endif
 	"unevictable_pgs_culled",
 	"unevictable_pgs_scanned",
-- 
2.43.0

