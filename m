Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09741C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 22:35:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BC816135D
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 22:35:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BC816135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5CE84B0CC;
	Mon, 26 Apr 2021 18:35:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uPl7TtFimxFR; Mon, 26 Apr 2021 18:35:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A24D64B0C4;
	Mon, 26 Apr 2021 18:35:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 544D84B09F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 18:35:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cXxhMzVrp117 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 18:35:01 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61E8B4AEF8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 18:35:01 -0400 (EDT)
IronPort-SDR: iOvLFO+OaN292twiGqxfrxnC9YYUZXaQ1GIG2lIAuHUS3R4NvGETv07XEiH0oa6whozsFeHWky
 Hvr/MhzbCFYA==
X-IronPort-AV: E=McAfee;i="6200,9189,9966"; a="176530924"
X-IronPort-AV: E=Sophos;i="5.82,252,1613462400"; d="scan'208";a="176530924"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 Apr 2021 15:35:00 -0700
IronPort-SDR: glz5M3bhXJfAfhYfOLxT+2LJtg7bRd8Vznq38dITWWUlvVHfw0xPX9Vbt17Lk4Z2SHtlPJiHGV
 BFQFKWUxVa1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,252,1613462400"; d="scan'208";a="615500898"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
 by fmsmga006.fm.intel.com with ESMTP; 26 Apr 2021 15:34:56 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1lb9od-00068S-Jk; Mon, 26 Apr 2021 22:34:55 +0000
Date: Tue, 27 Apr 2021 06:33:57 +0800
From: kernel test robot <lkp@intel.com>
To: Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: arm64: fix boolreturn.cocci warnings
Message-ID: <20210426223357.GA45871@cd4295a34ed8>
References: <202104270655.gBGhIPdZ-lkp@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <202104270655.gBGhIPdZ-lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Farrah Chen <farrah.chen@intel.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Robert Hu <robert.hu@intel.com>, Danmei Wei <danmei.wei@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

From: kernel test robot <lkp@intel.com>

arch/arm64/kvm/mmu.c:1114:9-10: WARNING: return of 0/1 in function 'kvm_age_gfn' with return type bool
arch/arm64/kvm/mmu.c:1084:9-10: WARNING: return of 0/1 in function 'kvm_set_spte_gfn' with return type bool
arch/arm64/kvm/mmu.c:1127:9-10: WARNING: return of 0/1 in function 'kvm_test_age_gfn' with return type bool
arch/arm64/kvm/mmu.c:1070:9-10: WARNING: return of 0/1 in function 'kvm_unmap_gfn_range' with return type bool

 Return statements in functions returning bool should use
 true/false instead of 1/0.
Generated by: scripts/coccinelle/misc/boolreturn.cocci

Fixes: cd4c71835228 ("KVM: arm64: Convert to the gfn-based MMU notifier callbacks")
CC: Sean Christopherson <seanjc@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   9f242010c3b46e63bc62f08fff42cef992d3801b
commit: cd4c7183522817087278b3e000b8a888f9f91b5c [134/252] KVM: arm64: Convert to the gfn-based MMU notifier callbacks

 mmu.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1067,13 +1067,13 @@ out_unlock:
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
-		return 0;
+		return false;
 
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
 
-	return 0;
+	return false;
 }
 
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1081,7 +1081,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, s
 	kvm_pfn_t pfn = pte_pfn(range->pte);
 
 	if (!kvm->arch.mmu.pgt)
-		return 0;
+		return false;
 
 	WARN_ON(range->end - range->start != 1);
 
@@ -1101,7 +1101,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, s
 			       PAGE_SIZE, __pfn_to_phys(pfn),
 			       KVM_PGTABLE_PROT_R, NULL);
 
-	return 0;
+	return false;
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1111,7 +1111,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct
 	pte_t pte;
 
 	if (!kvm->arch.mmu.pgt)
-		return 0;
+		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
@@ -1124,7 +1124,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
-		return 0;
+		return false;
 
 	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
 					   range->start << PAGE_SHIFT);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
