Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022E3C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B635D2075A
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B635D2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD624B0E6;
	Mon, 22 Jun 2020 16:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ZgGa0hy+LLm; Mon, 22 Jun 2020 16:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADBF4B0EE;
	Mon, 22 Jun 2020 16:09:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA95B4B0FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yjtgxbX0oWxB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 16:09:24 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 081074B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:20 -0400 (EDT)
IronPort-SDR: BJAuQwTsyBeCToCHGasufy62qCAxgFHKyOPXHBi3zkJTxFPbP3yzaw7/JYM3JN7kgsgksH4HWe
 8LfratuA5n/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142921351"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="142921351"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 13:09:20 -0700
IronPort-SDR: 9lb1mb9mxEscX1saY63XsGU3TxhVtNqdLqqSQ07jAHGDKrnhMT3aPfWkptn9OL0ez6NoddQ0V9
 KhJIP5dw8KPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="318877121"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 13:09:20 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 17/21] KVM: arm64: Use common code's approach for
 __GFP_ZERO with memory caches
Date: Mon, 22 Jun 2020 13:08:18 -0700
Message-Id: <20200622200822.4426-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622200822.4426-1-sean.j.christopherson@intel.com>
References: <20200622200822.4426-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Junaid Shahid <junaids@google.com>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Add a "gfp_zero" member to arm64's 'struct kvm_mmu_memory_cache' to make
the struct and its usage compatible with the common 'struct
kvm_mmu_memory_cache' in linux/kvm_host.h.  This will minimize code
churn when arm64 moves to the common implementation in a future patch, at
the cost of temporarily having somewhat silly code.

Note, GFP_PGTABLE_USER is equivalent to GFP_KERNEL_ACCOUNT | GFP_ZERO:

  #define GFP_PGTABLE_USER  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
  |
  -> #define GFP_PGTABLE_KERNEL        (GFP_KERNEL | __GFP_ZERO)

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

versus

  #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)

    with __GFP_ZERO explicitly OR'd in

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

No functional change intended.

Tested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/mmu.c              | 5 +++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..335170b59899 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,6 +105,7 @@ struct kvm_arch {
  */
 struct kvm_mmu_memory_cache {
 	int nobjs;
+	gfp_t gfp_zero;
 	void *objects[KVM_NR_MEM_OBJS];
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..1016635b3782 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -270,6 +270,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
+	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9398b66f8a87..688213ef34f0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -131,7 +131,8 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
+					       cache->gfp_zero);
 		if (!page)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = page;
@@ -1342,7 +1343,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	phys_addr_t addr, end;
 	int ret = 0;
 	unsigned long pfn;
-	struct kvm_mmu_memory_cache cache = { 0, };
+	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, };
 
 	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(pa);
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
