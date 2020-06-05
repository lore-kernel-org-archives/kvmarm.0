Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A60C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB5D2206FA
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB5D2206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A44DD4B213;
	Fri,  5 Jun 2020 17:39:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aZBtLcE9flGd; Fri,  5 Jun 2020 17:39:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD5E4B1E2;
	Fri,  5 Jun 2020 17:39:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A34DB4B1DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DlXYiOEbKmCW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:19 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 343984B1E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:15 -0400 (EDT)
IronPort-SDR: G9oDv4Z/T7Ei+B9c+tCKklKD+NzStqKvaNFM4OY4RegXrD5V3Pfpmqx4ZyWlZwkuT89ADli2UU
 2BF0azTMeYIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:08 -0700
IronPort-SDR: I7BwiRnb6qWgFO7BpcC5Xe5lAqmxnRsI1qmZGEZxMZw6goAYfu74oYxKINf/llsyqxunF210uj
 a9IwlvttJxJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860895"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 10/21] KVM: x86/mmu: Make __GFP_ZERO a property of the memory
 cache
Date: Fri,  5 Jun 2020 14:38:42 -0700
Message-Id: <20200605213853.14959-11-sean.j.christopherson@intel.com>
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

Add a gfp_zero flag to 'struct kvm_mmu_memory_cache' and use it to
control __GFP_ZERO instead of hardcoding a call to kmem_cache_zalloc().
A future patch needs such a flag for the __get_free_page() path, as
gfn arrays do not need/want the allocator to zero the memory.  Convert
the kmem_cache paths to __GFP_ZERO now so as to avoid a weird and
inconsistent API in the future.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e7a427547557..fb99e6776e27 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
  */
 struct kvm_mmu_memory_cache {
 	int nobjs;
+	gfp_t gfp_zero;
 	struct kmem_cache *kmem_cache;
 	void *objects[KVM_NR_MEM_OBJS];
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d245acece3cd..6b0ec9060786 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1063,8 +1063,10 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
+	gfp_flags |= mc->gfp_zero;
+
 	if (mc->kmem_cache)
-		return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
+		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
 	else
 		return (void *)__get_free_page(gfp_flags);
 }
@@ -5680,7 +5682,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	int ret;
 
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
+	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
+
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
+	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
