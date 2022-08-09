Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9CDC25B0D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D35DD4C462;
	Tue,  9 Aug 2022 05:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SzAh6luQAEM5; Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BCB64C969;
	Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA82A4C411
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OqP7LbeFBwvm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E5F4C460
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C02C143D;
 Tue,  9 Aug 2022 02:15:30 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ABD03F67D;
 Tue,  9 Aug 2022 02:15:28 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 02/19] lib/alloc_phys: Initialize align_min
Date: Tue,  9 Aug 2022 10:15:41 +0100
Message-Id: <20220809091558.14379-3-alexandru.elisei@arm.com>
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

Commit 11c4715fbf87 ("alloc: implement free") changed align_min from a
static variable to a field for the alloc_ops struct and carried over the
initializer value of DEFAULT_MINIMUM_ALIGNMENT.

Commit 7e3e823b78c0 ("lib/alloc.h: remove align_min from struct
alloc_ops") removed the align_min field and changed it back to a static
variable, but missed initializing it.

Initialize align_min to DEFAULT_MINIMUM_ALIGNMENT, as it was intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 7 +++----
 lib/alloc_phys.h | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index a4d2bf23c1bc..3a78d0acd718 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -13,8 +13,6 @@
 
 #define PHYS_ALLOC_NR_REGIONS	256
 
-#define DEFAULT_MINIMUM_ALIGNMENT	32
-
 struct phys_alloc_region {
 	phys_addr_t base;
 	phys_addr_t size;
@@ -26,12 +24,13 @@ static int nr_regions;
 static struct spinlock lock;
 static phys_addr_t base, top;
 
+#define DEFAULT_MINIMUM_ALIGNMENT	32
+static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
+
 static void *early_memalign(size_t alignment, size_t size);
 static struct alloc_ops early_alloc_ops = {
 	.memalign = early_memalign,
 };
-static size_t align_min;
-
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
 void phys_alloc_show(void)
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 611aa70d2041..8049c340818d 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,8 +15,6 @@
  */
 #include "libcflat.h"
 
-#define DEFAULT_MINIMUM_ALIGNMENT 32
-
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
