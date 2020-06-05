Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490D5C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEEB7206DC
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEEB7206DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1001D4A4E5;
	Fri,  5 Jun 2020 17:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K55i+RRDcl4N; Fri,  5 Jun 2020 17:39:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A904B11D;
	Fri,  5 Jun 2020 17:39:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C71BD4B139
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jDVYAJAXLLH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:10 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6865C4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:10 -0400 (EDT)
IronPort-SDR: fdPFvGJ6z0Ig6Qk8F3DSDxDcZmh485QJeSl6X8g0Rlwh2zufNdltUMy3SMe1NXOuvlJuuzUJnu
 H+puPFovVKyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:08 -0700
IronPort-SDR: ZZaZ6F/6BihmuvqApCfYZnPy0xhRSZJVb+TdFXwVrCd9yEoEPD+XPiqtGxrIPcIEmkPWmu+182
 4NUl5HJGXo4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860898"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/21] KVM: x86/mmu: Zero allocate shadow pages (outside of
 mmu_lock)
Date: Fri,  5 Jun 2020 14:38:43 -0700
Message-Id: <20200605213853.14959-12-sean.j.christopherson@intel.com>
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

Set __GFP_ZERO for the shadow page memory cache and drop the explicit
clear_page() from kvm_mmu_get_page().  This moves the cost of zeroing a
page to the allocation time of the physical page, i.e. when topping up
the memory caches, and thus avoids having to zero out an entire page
while holding mmu_lock.

Cc: Peter Feiner <pfeiner@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Junaid Shahid <junaids@google.com>
Cc: Jim Mattson <jmattson@google.com>
Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b0ec9060786..a8f8eebf67df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2545,7 +2545,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PG_LEVEL_4K && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
@@ -5687,6 +5686,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
