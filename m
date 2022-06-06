Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01227CCA47C
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 11:12:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67F6F4B32C;
	Tue,  7 Jun 2022 07:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f+fUO5c-inkx; Tue,  7 Jun 2022 07:12:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1FBF4B33A;
	Tue,  7 Jun 2022 07:12:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50C484B286
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FL+S5NjRqQkD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 18:21:11 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0D2A49ECC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:10 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 128-20020a621786000000b0051b8426c375so8390555pfx.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2022 15:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NtBA8Sqzg/ANXHqLeQc66mc9yLDuJrDnywxO48cdPTY=;
 b=lhoDjsJJivI4YcN+GY3a4UuQhdmm2LU8NrC8tdLW+iLWyVukh4+enforN2x7LeMj7E
 A6OLNAzrYEkzhYLMj5Xp0aBQHiTwBRzlNlO/CcRltbJLZGR0DMcqDFQK5qU39D2sUgPy
 368qtckFiKeUCC74FQ8sT69l61idfgROS4ca8o8w3ito6OKvJD9HlBYC3D22IZXT7pPV
 UgrnRnRk8yd1DN5zGMPAcXvjMitHOlLpt0s5OFQ+OU+Iv51tZbyZOuF/Y2l61DaRXF3+
 Ka4Py/vnc2Mm+8UUxnUR3tQCienQ0XFN4zDcDuj2WczGfWpSqQfc5X/biLm1d5tPQnGg
 mWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NtBA8Sqzg/ANXHqLeQc66mc9yLDuJrDnywxO48cdPTY=;
 b=dSVTam1fMA7KKFaLf5tHgzdd7yGvNWiGxDuEFLxG7X7vAYERvzGWJhEMY8lf0QfFFy
 fpP7MswT6kC/jB/zDqQfua9QcRTq3gUifP0nR3wKffoidR2VIcVj1ematbxnoajzbBnF
 vB6baKRbBotM+zXmC8kx5VvfYpc91m2pZJHTtcZEYkLW8GmCDQ8ddIXDtI/s6JW8wppP
 uOHZCVQQ8y/nDqB7G6YPQ4DHMACBqISq6r3BL1R+6HHby9L8XWzv05R2AvlQebymzoVJ
 IYfPB/OZcWquGxNmG1obhHo8+DReyzufhAfLADtEGfq9nuUezA0rKRNodSObwbZCon3f
 BR0g==
X-Gm-Message-State: AOAM531+q8SrZTAJSW3105Uwj3zGZ32wR24sFh7Exo3Eo8GQlddJX1ky
 oLAH1MIq1HeNG7RWKR6Ea4EXhmH02Uvq51Xf
X-Google-Smtp-Source: ABdhPJzAWBQopeJnhqeXkwVh1qlsCErBI46BZPiFkHlAwrIuk4tcQ8MC3Yvb7P9pASMQQTBKhRKJylWwS9VoO0iv
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185
 with SMTP
 id q15-20020a17090a178f00b001e303bac185mr276788pja.1.1654554068863; Mon, 06
 Jun 2022 15:21:08 -0700 (PDT)
Date: Mon,  6 Jun 2022 22:20:55 +0000
In-Reply-To: <20220606222058.86688-1-yosryahmed@google.com>
Message-Id: <20220606222058.86688-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary page
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
X-Mailman-Approved-At: Tue, 07 Jun 2022 07:12:43 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
KVM mmu. This provides more insights on the kernel memory used
by a workload.

This stat will be used by subsequent patches to count KVM mmu
memory usage.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
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
index 69d7a6983f781..307a284b99189 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
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
index 061744c436d99..894d6317f3bdc 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -973,6 +973,7 @@ You may not have all of these fields.
     SReclaimable:   159856 kB
     SUnreclaim:     124508 kB
     PageTables:      24448 kB
+    SecPageTables:	 0 kB
     NFS_Unstable:        0 kB
     Bounce:              0 kB
     WritebackTmp:        0 kB
@@ -1067,6 +1068,9 @@ SUnreclaim
 PageTables
               amount of memory dedicated to the lowest level of page
               tables.
+SecPageTables
+	      amount of memory dedicated to secondary page tables, this
+	      currently includes KVM mmu allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index ec8bb24a5a227..9fe716832546f 100644
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
index 6fa761c9cc78e..fad29024eb2e0 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -108,6 +108,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
+	show_val_kb(m, "SecPageTables:	",
+		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 46ffab808f037..81d109e6c623a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -219,6 +219,7 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 598fece89e2b7..ee1c3d464857c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1398,6 +1398,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
+	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0e42038382c12..29a7e9cd28c74 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5932,7 +5932,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" mapped:%lu shmem:%lu pagetables:%lu\n"
+		" sec_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
@@ -5949,6 +5950,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
+		global_node_page_state(NR_SECONDARY_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
@@ -5982,6 +5984,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" shadow_call_stack:%lukB"
 #endif
 			" pagetables:%lukB"
+			" sec_pagetables:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -6007,6 +6010,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
+			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b75b1a64b54cb..06eb52fe5be94 100644
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
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
