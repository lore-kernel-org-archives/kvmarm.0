Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01707C43603
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B524E227BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B524E227BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA344AEEC;
	Wed, 18 Dec 2019 16:56:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id awiE1Qo+MwIT; Wed, 18 Dec 2019 16:56:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E646A4AF33;
	Wed, 18 Dec 2019 16:55:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9571F4AEF5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NENW3vQVaBvg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:55:54 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB9254A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:44 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108120"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:44 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 26/45] KVM: s390: Invoke kvm_vcpu_init() before allocating
 sie_page
Date: Wed, 18 Dec 2019 13:55:11 -0800
Message-Id: <20191218215530.2280-27-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Now that s390's implementation of kvm_arch_vcpu_init() is empty, move
the call to kvm_vcpu_init() above the allocation of the sie_page.  This
paves the way for moving vcpu allocation and initialization into common
KVM code without any associated functional change.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0049b621e56a..1f8ba074cbd6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3027,10 +3027,16 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (!vcpu)
 		goto out;
 
+	rc = kvm_vcpu_init(vcpu, kvm, id);
+	if (rc)
+		goto out_free_cpu;
+
+	rc = -ENOMEM;
+
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
 	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
 	if (!sie_page)
-		goto out_free_cpu;
+		goto out_uninit_vcpu;
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
 	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
@@ -3046,10 +3052,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
 	seqcount_init(&vcpu->arch.cputm_seqcount);
 
-	rc = kvm_vcpu_init(vcpu, kvm, id);
-	if (rc)
-		goto out_free_sie_block;
-
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
 	kvm_clear_async_pf_completion_queue(vcpu);
 	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
@@ -3078,7 +3080,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (kvm_is_ucontrol(vcpu->kvm)) {
 		rc = __kvm_ucontrol_vcpu_init(vcpu);
 		if (rc)
-			goto out_uninit_vcpu;
+			goto out_free_sie_block;
 	}
 
 	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
@@ -3086,10 +3088,10 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
 	return vcpu;
-out_uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
+out_uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 out_free_cpu:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 out:
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
