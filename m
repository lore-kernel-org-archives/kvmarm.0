Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05E7C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 11:11:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39FF449EDE;
	Thu,  6 Oct 2022 07:11:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bdub5MlOXlwh; Thu,  6 Oct 2022 07:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B37411BD;
	Thu,  6 Oct 2022 07:11:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC76741174
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 07:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2gr0-ZSjB98D for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2022 07:11:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1530410DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 07:11:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 594FE1042;
 Thu,  6 Oct 2022 04:11:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B36713F73B;
 Thu,  6 Oct 2022 04:11:50 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 1/3] lib/vmalloc: Treat virt_to_pte_phys() as
 returning a physical address
Date: Thu,  6 Oct 2022 12:12:39 +0100
Message-Id: <20221006111241.15083-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221006111241.15083-1-alexandru.elisei@arm.com>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: Laurent Vivier <lvivier@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

All architectures that implements virt_to_pte_phys() (s390x, x86, arm and
arm64) return a physical address from the function. Teach vmalloc to treat
it as such, instead of confusing the return value with a page table entry.
Changing things the other way around (having the function return a page
table entry instead) is not feasible, because it is possible for an
architecture to use the upper bits of the table entry to store metadata
about the page.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 572682576cc3..0696b5da8190 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -169,7 +169,7 @@ static void vm_free(void *mem)
 	/* the pointer is not page-aligned, it was a single-page allocation */
 	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
 		assert(GET_MAGIC(mem) == VM_MAGIC);
-		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
+		page = virt_to_pte_phys(page_root, mem);
 		assert(page);
 		free_page(phys_to_virt(page));
 		return;
@@ -183,7 +183,7 @@ static void vm_free(void *mem)
 	/* free all the pages including the metadata page */
 	ptr = (uintptr_t)m & PAGE_MASK;
 	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
-		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
+		page = virt_to_pte_phys(page_root, (void *)ptr);
 		assert(page);
 		free_page(phys_to_virt(page));
 	}
-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
