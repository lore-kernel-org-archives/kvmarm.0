Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A09130E32
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201022; cv=none; b=oZXNZ9FRIEXKoqjoEosNHQYIUIxlZzPDoIuQAEbOaxzTQIsIya+CdGyeC7aMqY8qj7t7DO3uWHasHClrEq+It+m79O1nBF20BZ0XYefGm4/bcDHVhL2OFdhW5l5N4IiX1TCs7OF4lQMvH479YuWvYKO9yGlB2TNSZPpPCsFlaDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201022; c=relaxed/simple;
	bh=0Lk/yDB2pP/0+WtYhi+H4wfG8MVkHK9WQcQ93Hxoqag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a2BHSglBW7+J3dLJaNOxDavg6ifqn8nqOKI423gpWgk74KQ6bQhBtCXuPJ0eExiumEldfWu1ZmHEmiQ2pXdXb/3bMhhIi25TkBTwT6m/i5QSu3cguqbtgPacD2nBRKN35qEBGSLZVNbxhSUBB3a6/mwgUi8b6Nc1ehPtokko1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CBA5153B;
	Thu, 25 Jan 2024 08:44:23 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DF503F5A1;
	Thu, 25 Jan 2024 08:43:33 -0800 (PST)
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
Subject: [PATCH RFC v3 09/35] mm: cma: Introduce cma_remove_mem()
Date: Thu, 25 Jan 2024 16:42:30 +0000
Message-Id: <20240125164256.4147-10-alexandru.elisei@arm.com>
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

Memory is added to CMA with cma_declare_contiguous_nid() and
cma_init_reserved_mem(). This memory is then put on the MIGRATE_CMA list in
cma_init_reserved_areas(), where the page allocator can make use of it.

If a device manages multiple CMA areas, and there's an error when one of
the areas is added to CMA, there is no mechanism for the device to prevent
the rest of the areas, which were added before the error occured, from
being later added to the MIGRATE_CMA list.

Add cma_remove_mem() which allows a previously reserved CMA area to be
removed and thus it cannot be used by the page allocator.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes since rfc v2:

* New patch.

 include/linux/cma.h |  1 +
 mm/cma.c            | 30 +++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e32559da6942..787cbec1702e 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -48,6 +48,7 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					const char *name,
 					struct cma **res_cma);
+extern void cma_remove_mem(struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern int cma_alloc_range(struct cma *cma, unsigned long start, unsigned long count,
diff --git a/mm/cma.c b/mm/cma.c
index 4a0f68b9443b..2881bab12b01 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -147,8 +147,12 @@ static int __init cma_init_reserved_areas(void)
 {
 	int i;
 
-	for (i = 0; i < cma_area_count; i++)
+	for (i = 0; i < cma_area_count; i++) {
+		/* Region was removed. */
+		if (!cma_areas[i].count)
+			continue;
 		cma_activate_area(&cma_areas[i]);
+	}
 
 	return 0;
 }
@@ -216,6 +220,30 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
+/**
+ * cma_remove_mem() - remove cma area
+ * @res_cma: Pointer to the cma region.
+ *
+ * This function removes a cma region created with cma_init_reserved_mem(). The
+ * ->count is set to 0.
+ */
+void __init cma_remove_mem(struct cma **res_cma)
+{
+	struct cma *cma;
+
+	if (WARN_ON_ONCE(!res_cma || !(*res_cma)))
+		return;
+
+	cma = *res_cma;
+	if (WARN_ON_ONCE(!cma->count))
+		return;
+
+	totalcma_pages -= cma->count;
+	cma->count = 0;
+
+	*res_cma = NULL;
+}
+
 /**
  * cma_declare_contiguous_nid() - reserve custom contiguous area
  * @base: Base address of the reserved area optional, use 0 for any
-- 
2.43.0

