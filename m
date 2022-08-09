Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDA8C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27C3D4C4E2;
	Tue,  9 Aug 2022 05:15:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v0466Wath-hu; Tue,  9 Aug 2022 05:15:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 118BC4CA20;
	Tue,  9 Aug 2022 05:15:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A6F4C991
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e4Nt+c3CdbaR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 732D94C4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA09C143D;
 Tue,  9 Aug 2022 02:15:37 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2FF3F67D;
 Tue,  9 Aug 2022 02:15:35 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end
 parameter as unused in setup_mmu()
Date: Tue,  9 Aug 2022 10:15:46 +0100
Message-Id: <20220809091558.14379-8-alexandru.elisei@arm.com>
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

phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
room for the vmalloc area to grown down. This was made useless in commit
c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
setup_mmu() was changed to map all the detected memory regions without
changing their limits.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe4941f..8f936acafe8b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	}
 }
 
-void *setup_mmu(phys_addr_t phys_end, void *unused)
+void *setup_mmu(phys_addr_t unused0, void *unused1)
 {
 	struct mem_region *r;
 
-	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
-	if (phys_end > (3ul << 30))
-		phys_end = 3ul << 30;
-
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
