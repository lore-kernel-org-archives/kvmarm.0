Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02953C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8AE32082F
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8AE32082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 733204B12F;
	Mon, 22 Jun 2020 16:09:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BE29P3N1wSQF; Mon, 22 Jun 2020 16:09:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C72D4B133;
	Mon, 22 Jun 2020 16:09:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A50B4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f+VEhE9tnbp4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 16:09:16 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B14D04B10D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:13 -0400 (EDT)
IronPort-SDR: pfthw1m7SemyHjCR4rllIT5+T1V6x0/Yb6LEEyzM66PYvecefMWyLa1nMbiA02p0OH2T0X/hja
 9mLe8iA5Np2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142921290"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="142921290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 13:09:13 -0700
IronPort-SDR: 6Ia5uhwjctHaySi317F/9+WvPSn+PS6/FHFQk8LIOAcfpdbtUdcjR0PTwaH7efYNEMCOJi2STg
 cTr2KOvriHeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="318877076"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 13:09:12 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 08/21] KVM: x86/mmu: Clean up the gorilla math in
 mmu_topup_memory_caches()
Date: Mon, 22 Jun 2020 13:08:09 -0700
Message-Id: <20200622200822.4426-9-sean.j.christopherson@intel.com>
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

Clean up the minimums in mmu_topup_memory_caches() to document the
driving mechanisms behind the minimums.  Now that encountering an empty
cache is unlikely to trigger BUG_ON(), it is less dangerous to be more
precise when defining the minimums.

For rmaps, the logic is 1 parent PTE per level, plus a single rmap, and
prefetched rmaps.  The extra objects in the current '8 + PREFETCH'
minimum came about due to an abundance of paranoia in commit
c41ef344de212 ("KVM: MMU: increase per-vcpu rmap cache alloc size"),
i.e. it could have increased the minimum to 2 rmaps.  Furthermore, the
unexpected extra rmap case was killed off entirely by commits
f759e2b4c728c ("KVM: MMU: avoid pte_list_desc running out in
kvm_mmu_pte_write") and f5a1e9f89504f ("KVM: MMU: remove call to
kvm_mmu_pte_write from walk_addr").

For the so called page cache, replace '8' with 2*PT64_ROOT_MAX_LEVEL.
The 2x multiplier is needed because the cache is used for both shadow
pages and gfn arrays for indirect MMUs.

And finally, for page headers, replace '4' with PT64_ROOT_MAX_LEVEL.

Note, KVM now supports 5-level paging, i.e. the old minimums that used a
baseline derived from 4-level paging were technically wrong.  But, KVM
always allocates roots in a separate flow, e.g. it's impossible in the
current implementation to actually need 5 new shadow pages in a single
flow.  Use PT64_ROOT_MAX_LEVEL unmodified instead of subtracting 1, as
the direct usage is likely more intuitive to uninformed readers, and the
inflated minimum is unlikely to affect functionality in practice.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4b4c3234d623..451e0365e5dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1103,14 +1103,17 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   8 + PTE_PREFETCH_NUM);
+				   1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+				   2 * PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
-	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
+	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+				      PT64_ROOT_MAX_LEVEL);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
