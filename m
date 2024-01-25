Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E903812FF9F
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201038; cv=none; b=fGfT656KfTG0oc0s/wmsMr2wMYqdkyXE/GKP80fXv8CHhaSb3shgBIoAvut4CVxGLBhoB/iPtZHQDBB1/77DBY6121vqrYVLrl90YLQGOhVs2cbE0fgOF5W3BaOLzw+73llMfQ6sm/7L6Mb4MZ2rlQMyrFHp7hsHs3KXiDTpz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201038; c=relaxed/simple;
	bh=eSQaWCc2Px+2vbM1RKkbkoXSqzbcobRpPRCxEZJPC24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RfzKNDADIOZC2gzA3z6xV8PAzJDi62NBI88mT4ZtXTOCnqiSOgdkOmMFiIKP1i92FmkfosTHcklsVqHJ53i+5e0otgg0mN4sXTdabFu7WNlmshOHNnQgZWr+lp6HgPDi6b1mrLH02Ze1f1Qk5Xu/KDPp4nswYsokeyY8+WLg25Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDDEF1576;
	Thu, 25 Jan 2024 08:44:40 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE15E3F5A1;
	Thu, 25 Jan 2024 08:43:50 -0800 (PST)
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
Subject: [PATCH RFC v3 12/35] mm: Call arch_swap_prepare_to_restore() before arch_swap_restore()
Date: Thu, 25 Jan 2024 16:42:33 +0000
Message-Id: <20240125164256.4147-13-alexandru.elisei@arm.com>
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

arm64 uses arch_swap_restore() to restore saved tags before the page is
swapped in and it's called in atomic context (with the ptl lock held).

Introduce arch_swap_prepare_to_restore() that will allow an architecture to
perform extra work during swap in and outside of a critical section.
This will be used by arm64 to allocate a buffer in memory where to
temporarily save tags if tag storage is not available for the page being
swapped in.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/pgtable.h | 7 +++++++
 mm/memory.c             | 4 ++++
 mm/shmem.c              | 9 +++++++++
 mm/swapfile.c           | 5 +++++
 4 files changed, 25 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 98f81ca08cbe..2d0f04042f62 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -959,6 +959,13 @@ static inline void arch_swap_invalidate_area(int type)
 }
 #endif
 
+#ifndef __HAVE_ARCH_SWAP_PREPARE_TO_RESTORE
+static inline vm_fault_t arch_swap_prepare_to_restore(swp_entry_t entry, struct folio *folio)
+{
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_SWAP_RESTORE
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 7e1f4849463a..8a421e168b57 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3975,6 +3975,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
+	ret = arch_swap_prepare_to_restore(entry, folio);
+	if (ret)
+		goto out_page;
+
 	/*
 	 * Back out if somebody else already faulted in this pte.
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 14427e9982f9..621fabc3b8c6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1855,6 +1855,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
+	vm_fault_t ret;
 	int error;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
@@ -1903,6 +1904,14 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 	folio_wait_writeback(folio);
 
+	ret = arch_swap_prepare_to_restore(swap, folio);
+	if (ret) {
+		if (fault_type)
+			*fault_type = ret;
+		error = -EINVAL;
+		goto unlock;
+	}
+
 	/*
 	 * Some architectures may have to restore extra metadata to the
 	 * folio after reading from swap.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 556ff7347d5f..49425598f778 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1785,6 +1785,11 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		goto setpte;
 	}
 
+	if (arch_swap_prepare_to_restore(entry, folio)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Some architectures may have to restore extra metadata to the page
 	 * when reading from swap. This metadata may be indexed by swap entry
-- 
2.43.0

