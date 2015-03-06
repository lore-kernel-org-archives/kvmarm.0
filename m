From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 1/6] memory: add incoherent cache flag
Date: Fri,  6 Mar 2015 13:53:33 -0500
Message-ID: <1425668018-3649-2-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F6F47F15
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V95qjJXi26zr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:37 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C551F47F0E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:37 -0500 (EST)
In-Reply-To: <1425668018-3649-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Add an incoherent cache flag, which indicates the region
needs explicit cache maintenance.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/exec/memory.h | 23 +++++++++++++++++++++++
 memory.c              | 15 +++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 06ffa1d185b93..c947b88b87241 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -158,6 +158,7 @@ struct MemoryRegion {
     bool rom_device;
     bool warning_printed; /* For reservations */
     bool flush_coalesced_mmio;
+    bool incoherent_cache;
     MemoryRegion *alias;
     hwaddr alias_offset;
     int32_t priority;
@@ -778,6 +779,28 @@ void memory_region_set_flush_coalesced(MemoryRegion *mr);
 void memory_region_clear_flush_coalesced(MemoryRegion *mr);
 
 /**
+ * memory_region_set_incoherent_cache: Flag this memory region as needing
+ *                                     explicit cache maintenance.
+ *
+ * @mr: the memory region to be updated.
+ */
+void memory_region_set_incoherent_cache(MemoryRegion *mr);
+
+/**
+ * memory_region_clear_incoherent_cache: Remove the incoherent cache flag.
+ *
+ * @mr: the memory region to be updated.
+ */
+void memory_region_clear_incoherent_cache(MemoryRegion *mr);
+
+/**
+ * memory_region_has_incoherent_cache: Return the incoherent cache flag.
+ *
+ * @mr: the memory region to check.
+ */
+bool memory_region_has_incoherent_cache(MemoryRegion *mr);
+
+/**
  * memory_region_add_eventfd: Request an eventfd to be triggered when a word
  *                            is written to a location.
  *
diff --git a/memory.c b/memory.c
index 20f6d9eeac737..fa74bcb8c1e4c 100644
--- a/memory.c
+++ b/memory.c
@@ -1549,6 +1549,21 @@ void memory_region_clear_flush_coalesced(MemoryRegion *mr)
     }
 }
 
+void memory_region_set_incoherent_cache(MemoryRegion *mr)
+{
+    mr->incoherent_cache = true;
+}
+
+void memory_region_clear_incoherent_cache(MemoryRegion *mr)
+{
+    mr->incoherent_cache = false;
+}
+
+bool memory_region_has_incoherent_cache(MemoryRegion *mr)
+{
+    return mr->incoherent_cache;
+}
+
 void memory_region_add_eventfd(MemoryRegion *mr,
                                hwaddr addr,
                                unsigned size,
-- 
1.8.3.1
