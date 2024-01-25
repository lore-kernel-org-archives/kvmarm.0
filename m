Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF0613666F
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201142; cv=none; b=VTtqrTUp+mt8bpiA7qxp3w0C7ctAzdenqq9Mj53+w9Y2Rd9IbYAgx2mqTg9Cp9kcFXnQpbCq3Ko+oz+gVVS86ueL9E5LsM6Mnzaaz5nFqcz7S/KoLdWy4pf+NHcsXEGrkHBhlnCbP1UbcH4iousn5PGq5uEsiCRySmaEqpHziHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201142; c=relaxed/simple;
	bh=g16m8hwe2c+Kqfp9b9jwBFM1C8lWUj9Vnff3BFnKf5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D58/8xObwcrTKsgkka4NAE/nhdp3i5WfNQMmtfQzWNUotdd5e/B865EKAgGmzc8+EvGlSYTYDG6t0skzR/+Wagv8p+lZap61DSInZP8oZ0bqatAn6nti1CTDNiM6faqqvYwIAcidJwcerJjev+gklKVubqoPtmrJsqfiTbWzLnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09C361713;
	Thu, 25 Jan 2024 08:46:25 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3D8E3F5A1;
	Thu, 25 Jan 2024 08:45:34 -0800 (PST)
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
Subject: [PATCH RFC v3 30/35] arm64: mte: ptrace: Handle pages with missing tag storage
Date: Thu, 25 Jan 2024 16:42:51 +0000
Message-Id: <20240125164256.4147-31-alexandru.elisei@arm.com>
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

A page can end up mapped in a MTE enabled VMA without the corresponding tag
storage block reserved. Tag accesses made by ptrace in this case can lead
to the wrong tags being read or memory corruption for the process that is
using the tag storage memory as data.

Reserve tag storage by treating ptrace accesses like a fault.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes since rfc v2:

* New patch, issue reported by Peter Collingbourne.

 arch/arm64/kernel/mte.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index faf09da3400a..b1fa02dad4fd 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -412,10 +412,13 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 	while (len) {
 		struct vm_area_struct *vma;
 		unsigned long tags, offset;
+		unsigned int fault_flags;
+		struct page *page;
+		vm_fault_t ret;
 		void *maddr;
-		struct page *page = get_user_page_vma_remote(mm, addr,
-							     gup_flags, &vma);
 
+get_page:
+		page = get_user_page_vma_remote(mm, addr, gup_flags, &vma);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			break;
@@ -433,6 +436,25 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 			put_page(page);
 			break;
 		}
+
+		if (tag_storage_enabled() && !page_tag_storage_reserved(page)) {
+			fault_flags = FAULT_FLAG_DEFAULT | \
+				      FAULT_FLAG_USER | \
+				      FAULT_FLAG_REMOTE | \
+				      FAULT_FLAG_ALLOW_RETRY | \
+				      FAULT_FLAG_RETRY_NOWAIT;
+			if (write)
+				fault_flags |= FAULT_FLAG_WRITE;
+
+			put_page(page);
+			ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+			if (ret & VM_FAULT_ERROR) {
+				err = -EFAULT;
+				break;
+			}
+			goto get_page;
+		}
+
 		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
-- 
2.43.0

