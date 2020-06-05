Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF28C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFA23206DC
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFA23206DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 888C74B0FD;
	Fri,  5 Jun 2020 17:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VKbDcTiapYSk; Fri,  5 Jun 2020 17:39:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D82F14B1CE;
	Fri,  5 Jun 2020 17:39:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93CF84B13B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTEmvYxKbB-1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:14 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FF584B153
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:13 -0400 (EDT)
IronPort-SDR: K80FIG19oPneQkB8Goa5wcQK4Dbq6i6Gv7MNbffGWLL8cisz+V7ydgK4nzlDwOaW/UR7586y+u
 /2Q0COyUuLXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:07 -0700
IronPort-SDR: kUB4EaD9pBY+TwwSYxybFG3rI29fqgwbISoJ3DAUxWFW4zz+0j67lNNk6bsc8yImoZHZt5pcsT
 yNUu2OllTXSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860868"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:07 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/21] KVM: x86/mmu: Track the associated kmem_cache in the
 MMU caches
Date: Fri,  5 Jun 2020 14:38:33 -0700
Message-Id: <20200605213853.14959-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Ben Gardon <bgardon@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Track the kmem_cache used for non-page KVM MMU memory caches instead of
passing in the associated kmem_cache when filling the cache.  This will
allow consolidating code and other cleanups.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++-------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1da5858501ca..16347b050754 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
  */
 struct kvm_mmu_memory_cache {
 	int nobjs;
+	struct kmem_cache *kmem_cache;
 	void *objects[KVM_NR_MEM_OBJS];
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..0830c195c9ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1060,15 +1060,14 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
+static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
+		obj = kmem_cache_zalloc(cache->kmem_cache, GFP_KERNEL_ACCOUNT);
 		if (!obj)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -1081,11 +1080,10 @@ static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
 	return cache->nobjs;
 }
 
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
-				  struct kmem_cache *cache)
+static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
 	while (mc->nobjs)
-		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
+		kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
 }
 
 static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
@@ -1115,25 +1113,22 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
+				   8 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
-				   mmu_page_header_cache, 4);
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
 out:
 	return r;
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				pte_list_desc_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
-				mmu_page_header_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
 static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
@@ -5684,6 +5679,9 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	uint i;
 	int ret;
 
+	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
+	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
