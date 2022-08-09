Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD0EC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:16:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDCD04C9FA;
	Tue,  9 Aug 2022 05:16:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I+Bco2980JtV; Tue,  9 Aug 2022 05:16:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1AB4CB00;
	Tue,  9 Aug 2022 05:15:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5567C4C974
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcWqI68EaDKr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFAC04CA0A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 128E623A;
 Tue,  9 Aug 2022 02:15:49 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 319B03F67D;
 Tue,  9 Aug 2022 02:15:47 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 15/19] lib/alloc_phys: Add callback to
 perform cache maintenance
Date: Tue,  9 Aug 2022 10:15:54 +0100
Message-Id: <20220809091558.14379-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Some architectures, like arm and arm64, require explicit cache
maintenance to maintain the caches in sync with memory when toggling the
caches. Add the function to do the required maintenance on the internal
structures that the allocator maintains.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 8 ++++++++
 lib/alloc_phys.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 1e1fc179f108..5872d2c6e38f 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -45,6 +45,14 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	align_min = align;
 }
 
+void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn)
+{
+	maint_fn((unsigned long)&base);
+	maint_fn((unsigned long)&used);
+	maint_fn((unsigned long)&top);
+	maint_fn((unsigned long)&align_min);
+}
+
 static void *memalign_early(size_t alignment, size_t sz)
 {
 	phys_addr_t align = (phys_addr_t)alignment;
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 4d350f010031..86b3d0215d49 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,6 +15,8 @@
  */
 #include "libcflat.h"
 
+typedef void (*cache_maint_fn)(unsigned long addr);
+
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
@@ -27,6 +29,12 @@ extern void phys_alloc_init(phys_addr_t base, phys_addr_t size);
  */
 extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
+/*
+ * Perform cache maintenance on the internal structures that the physical
+ * allocator maintains.
+ */
+extern void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn);
+
 /*
  * phys_alloc_show outputs all currently allocated regions with the
  * following format, where <end_addr> is non-inclusive:
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
