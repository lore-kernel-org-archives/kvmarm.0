Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FB2CA9EB9
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20AB921D7E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20AB921D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D048E4AA0B;
	Mon, 21 Oct 2019 21:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WZC8BmdmTWbR; Mon, 21 Oct 2019 21:59:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB084AC08;
	Mon, 21 Oct 2019 21:59:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 170344AC22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 21:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1si64sxurJTs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 21:59:46 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84F044A9F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 21:59:41 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Oct 2019 18:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; d="scan'208";a="196293799"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:40 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 13/45] KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu
 after common init
Date: Mon, 21 Oct 2019 18:58:53 -0700
Message-Id: <20191022015925.31916-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Call kvm_vcpu_init() in kvmppc_core_vcpu_create_pr() prior to allocating
the book3s and shadow_vcpu objects in preparation of moving said call to
common PPC code.  Although kvm_vcpu_init() has an arch callback, the
callback is empty for Book3S PR, i.e. barring unseen black magic, moving
the allocation has no real functional impact.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_pr.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 1e6b83908668..a933ba60bc7c 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1712,12 +1712,18 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				      unsigned int id)
 {
 	struct kvmppc_vcpu_book3s *vcpu_book3s;
-	int err = -ENOMEM;
 	unsigned long p;
+	int err;
+
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
 
 	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
-		goto out;
+		goto uninit_vcpu;
 	vcpu->arch.book3s = vcpu_book3s;
 
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
@@ -1727,14 +1733,9 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		goto free_vcpu3s;
 #endif
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_shadow_vcpu;
-
-	err = -ENOMEM;
 	p = __get_free_page(GFP_KERNEL|__GFP_ZERO);
 	if (!p)
-		goto uninit_vcpu;
+		goto free_shadow_vcpu;
 	vcpu->arch.shared = (void *)p;
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Always start the shared struct in native endian mode */
@@ -1770,15 +1771,14 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 
 free_shared_page:
 	free_page((unsigned long)vcpu->arch.shared);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 free_shadow_vcpu:
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
 free_vcpu3s:
 #endif
 	vfree(vcpu_book3s);
-out:
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 	return err;
 }
 
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
