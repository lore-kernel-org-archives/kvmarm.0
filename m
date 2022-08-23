Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45B8C32793
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 00:46:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5256C4CF24;
	Mon, 22 Aug 2022 20:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RDQOOlCEE33P; Mon, 22 Aug 2022 20:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D18984CF16;
	Mon, 22 Aug 2022 20:46:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12E84CF1E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i4soUSwhZdsb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 20:46:46 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FF1F4CF0F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:46 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 c142-20020a621c94000000b005324991c5b8so5240111pfc.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 17:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=aTqOOrhDjNGrczvh75CpWoUm/AlvC3yVYYZPgju1gz4=;
 b=pXpZT++K8DSh8CrpE88bDd2s9QCwpXUmdC8Q71nbMw/fdS3P100RroWtZApbjDzm91
 5GFWWL/WWAznOCH5txVbs/Fo9NJquBLuvicIqga0F5b5FQkQ4DSDKnSt76CCoJuOgZx8
 RD7F4h2OwduHtLpQoYAsHPXRAb9CsZQV9Ttqwfrt4I2kLL7OxZ6AvVL8pLhZNrh7ovev
 aGdq2g5Qv9ZdGaWE2sySW/kYgYOOxfMhsstH1ApFSbJzSXnMux7XmMPGoSdnQ94+Blg2
 j5bQcCj+oTyevUftRoLGIelQL9gvFcjyGfy/JDZ00apDy8Yf4Iw2ghXF94RQGJiZV97D
 yu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=aTqOOrhDjNGrczvh75CpWoUm/AlvC3yVYYZPgju1gz4=;
 b=KQhgbIkwLiBbHmtEakcXTGZS3eTf46eALwYg7GaoVUs8+E1QaTpClj94R2oGnZU7Qm
 lBWm4pI3zGafJMpd8K8xoVgL8sTHXeaLVHajkpzgQjr2Pe88dc13lP/QLz35qoBy2G96
 LBwA+pB3EcrcujQLI2XPUopSjCrcPknnzF74I93dzwplWR9zgDJlQh734WfzX2PIGXVH
 Yo0ZXvwEg07LVwkbzwzEP2DLe1CbiuKvz0hq+VvMn2ULZByqVR2ykXEqVjbXGQffz91Z
 p1b9POyVr9XhmE9O34rwvtGCYUIK3vFFhihJAVNu4tasZyhJJw7RQmMHbsOkKmxaZOka
 lp7A==
X-Gm-Message-State: ACgBeo0kRRZ+o2RIOIehx4W+nCuDZnw/0z5F6AiYahTJ/iia82S8RlF2
 CbXwuurMt9yyrv5m6Vd8i6ancH9ZhclwnZGc
X-Google-Smtp-Source: AA6agR4p28DPzj9ExsS2Do4KRWnzMXTkFyALmrLotL9MAVApSZ2yKp+uFsrbdItqJaP/8HP8tjX/f3YbvvKwPZui
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:90b:3d90:b0:1fb:151b:b5cb with SMTP
 id pq16-20020a17090b3d9000b001fb151bb5cbmr878886pjb.210.1661215605157; Mon,
 22 Aug 2022 17:46:45 -0700 (PDT)
Date: Tue, 23 Aug 2022 00:46:36 +0000
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
Message-Id: <20220823004639.2387269-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary page
 table uses.
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Huang@google.com,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

We keep track of several kernel memory stats (total kernel memory, page
tables, stack, vmalloc, etc) on multiple levels (global, per-node,
per-memcg, etc). These stats give insights to users to how much memory
is used by the kernel and for what purposes.

Currently, memory used by KVM mmu is not accounted in any of those
kernel memory stats. This patch series accounts the memory pages
used by KVM for page tables in those stats in a new
NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
for other types of secondary pages tables (e.g. iommu page tables).

KVM has a decent number of large allocations that aren't for page
tables, but for most of them, the number/size of those allocations
scales linearly with either the number of vCPUs or the amount of memory
assigned to the VM. KVM's secondary page table allocations do not scale
linearly, especially when nested virtualization is in use.

From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
forced to allocate a large number of page tables even though the guest
isn't accessing that much memory). However, someone would need to either
understand how KVM works to make that connection, or know (or be told) to
go look at KVM's stats if they're running VMs to better decipher the stats.

Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
is informative. For example, when backing a VM with THP vs. HugeTLB,
NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
of magnitude higher with THP. So having this stat will at the very least
prove to be useful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

The original discussion with more details about the rationale:
https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org

This stat will be used by subsequent patches to count KVM mmu
memory usage.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++++
 Documentation/filesystems/proc.rst      | 4 ++++
 drivers/base/node.c                     | 2 ++
 fs/proc/meminfo.c                       | 2 ++
 include/linux/mmzone.h                  | 1 +
 mm/memcontrol.c                         | 1 +
 mm/page_alloc.c                         | 6 +++++-
 mm/vmstat.c                             | 1 +
 8 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index be4a77baf784..7ce8130a8924 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1355,6 +1355,11 @@ PAGE_SIZE multiple when read back.
 	  pagetables
                 Amount of memory allocated for page tables.
 
+	  sec_pagetables
+		Amount of memory allocated for secondary page tables,
+		this currently includes KVM mmu allocations on x86
+		and arm64.
+
 	  percpu (npn)
 		Amount of memory used for storing per-cpu kernel
 		data structures.
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index e7aafc82be99..898c99eae8e4 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
     SUnreclaim:       142336 kB
     KernelStack:       11168 kB
     PageTables:        20540 kB
+    SecPageTables:         0 kB
     NFS_Unstable:          0 kB
     Bounce:                0 kB
     WritebackTmp:          0 kB
@@ -1090,6 +1091,9 @@ KernelStack
               Memory consumed by the kernel stacks of all tasks
 PageTables
               Memory consumed by userspace page tables
+SecPageTables
+              Memory consumed by secondary page tables, this currently
+              currently includes KVM mmu allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index eb0f43784c2b..432d40a5f910 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -433,6 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     "Node %d ShadowCallStack:%8lu kB\n"
 #endif
 			     "Node %d PageTables:     %8lu kB\n"
+			     "Node %d SecPageTables:  %8lu kB\n"
 			     "Node %d NFS_Unstable:   %8lu kB\n"
 			     "Node %d Bounce:         %8lu kB\n"
 			     "Node %d WritebackTmp:   %8lu kB\n"
@@ -459,6 +460,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
+			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			     nid, 0UL,
 			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 6e89f0e2fd20..208efd4fa52c 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -115,6 +115,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
+	show_val_kb(m, "SecPageTables:	",
+		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e24b40c52468..355d842d2731 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -216,6 +216,7 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. KVM pagetables */
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..9d054e3767ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1401,6 +1401,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
+	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e5486d47406e..90461bd94744 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6039,7 +6039,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" mapped:%lu shmem:%lu pagetables:%lu\n"
+		" sec_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
@@ -6056,6 +6057,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
+		global_node_page_state(NR_SECONDARY_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
@@ -6089,6 +6091,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" shadow_call_stack:%lukB"
 #endif
 			" pagetables:%lukB"
+			" sec_pagetables:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -6114,6 +6117,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
+			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 373d2730fcf2..b937eba681d1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
 	"nr_shadow_call_stack",
 #endif
 	"nr_page_table_pages",
+	"nr_sec_page_table_pages",
 #ifdef CONFIG_SWAP
 	"nr_swapcached",
 #endif
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
