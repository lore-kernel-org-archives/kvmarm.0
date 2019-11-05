Return-Path: <SRS0=uMsW=Y5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02687C47E49
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73ED121929
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73ED121929
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 345BE4AEBE;
	Tue,  5 Nov 2019 15:30:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W3RFacRkOaSh; Tue,  5 Nov 2019 15:29:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5F404AC93;
	Tue,  5 Nov 2019 15:29:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 679184AE89
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nrHUEZKqhSsG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9514AC89
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9213468D;
 Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0018D3FE49;
 Tue,  5 Nov 2019 03:04:02 -0800 (PST)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvm@vger.kernel.org
Subject: [PATCH v4 1/5] KVM: x86: Move memcache allocation to GFP_PGTABLE_USER
Date: Tue,  5 Nov 2019 12:03:53 +0100
Message-Id: <20191105110357.8607-2-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191105110357.8607-1-christoffer.dall@arm.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Recent commit 50f11a8a4620eee6b6831e69ab5d42456546d7d8 moved page table
allocations for both KVM and normal user page table allocations to
GFP_PGTABLE_USER in order to get __GFP_ACCOUNT for the page tables.

However, while KVM on other architectures such as arm64 were included in
this change, curiously KVM on x86 was not.

Currently, KVM on x86 uses kmem_cache_zalloc(GFP_KERNEL_ACCOUNT) for
kmem_cache-based allocations, which expands in the following way:
  kmem_cache_zalloc(..., GFP_KERNEL_ACCOUNT) =>
  kmem_cache_alloc(..., GFP_KERNEL_ACCOUNT | __GFP_ZERO) =>
  kmem_cache_alloc(..., GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)

It so happens that GFP_PGTABLE_USER expands as:
  GFP_PGTABLE_USER =>
  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT) =>
  ((GFP_KERNEL | __GFP_ZERO) | __GFP_ACCOUNT) =>
  (GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO)

Which means that we can replace the current KVM on x86 call as:
-  obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
+  obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);

For the single page cache topup allocation, KVM on x86 currently uses
__get_free_page(GFP_KERNEL_ACCOUNT).  It seems to me that is equivalent
to the above, except that the allocated page is not guaranteed to be
zero (unless I missed the place where __get_free_page(!__GFP_ZERO) is
still guaranteed to be zeroed.  It seems natural (and in fact desired)
to have both topup functions implement the same expectations towards the
caller, and we therefore move to GFP_PGTABLE_USER here as well.

This will make it easier to unify the memchace implementation between
architectures.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/x86/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..540190cee3cb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -40,6 +40,7 @@
 
 #include <asm/page.h>
 #include <asm/pat.h>
+#include <asm/pgalloc.h>
 #include <asm/cmpxchg.h>
 #include <asm/e820/api.h>
 #include <asm/io.h>
@@ -1025,7 +1026,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
+		obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
 		if (!obj)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -1053,7 +1054,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		page = (void *)__get_free_page(GFP_PGTABLE_USER);
 		if (!page)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = page;
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
