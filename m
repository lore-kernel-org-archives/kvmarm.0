Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B4AC433DF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBECB206FA
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBECB206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 923534B1C5;
	Fri,  5 Jun 2020 17:39:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tRNP5cR49Sqq; Fri,  5 Jun 2020 17:39:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF9C34B205;
	Fri,  5 Jun 2020 17:39:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F21A54B07F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nk3+FDfreUUm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:19 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD2044B1E0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:14 -0400 (EDT)
IronPort-SDR: HABX6guL7OgE7wU9TMlog/SSXFpZIhxn8rRdN7HxPu/K4Kb9Kn62VnARUJ8i5ejtjTiynyDmOB
 vbLWWtGO3vLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:08 -0700
IronPort-SDR: XqKHcuabHK74BbG2b4w8feUvlGlhypfvZy/rS1JT1ziK1xvV2rFgi0aW811keyz+zG+1ymHY4P
 o06uuWAI8aXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860886"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/21] KVM: x86/mmu: Topup memory caches after walking GVA->GPA
Date: Fri,  5 Jun 2020 14:38:39 -0700
Message-Id: <20200605213853.14959-8-sean.j.christopherson@intel.com>
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

Topup memory caches after walking the GVA->GPA translation during a
shadow page fault, there is no need to ensure the caches are full when
walking the GVA.  As of commit f5a1e9f89504f ("KVM: MMU: remove call
to kvm_mmu_pte_write from walk_addr"), the FNAME(walk_addr) flow no
longer add rmaps via kvm_mmu_pte_write().

This avoids allocating memory in the case that the GVA is unmapped in
the guest, and also provides a paper trail of why/when the memory caches
need to be filled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 38c576495048..3de32122f601 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -791,10 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		return r;
-
 	/*
 	 * If PFEC.RSVD is set, this is a shadow page fault.
 	 * The bit needs to be cleared before walking guest page tables.
@@ -822,6 +818,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 		return RET_PF_EMULATE;
 	}
 
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
 
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
