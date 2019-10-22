Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4546CA9EB0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 02:00:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6CFD21783
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 02:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6CFD21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62EF24AC38;
	Mon, 21 Oct 2019 22:00:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZD7VaFIFZccH; Mon, 21 Oct 2019 22:00:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 490074ACAC;
	Mon, 21 Oct 2019 22:00:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52FC64AC91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 22:00:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4s8xDwFFyX9p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 22:00:16 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 621814AC7C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 22:00:05 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Oct 2019 19:00:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; d="scan'208";a="196294026"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 19:00:04 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 45/45] KVM: Move vcpu->run page allocation out of
 kvm_vcpu_init()
Date: Mon, 21 Oct 2019 18:59:25 -0700
Message-Id: <20191022015925.31916-46-sean.j.christopherson@intel.com>
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

Open code the allocation and freeing of the vcpu->run page in
kvm_vm_ioctl_create_vcpu() and kvm_vcpu_destroy() respectively.  Doing
so allows kvm_vcpu_init() to be a pure init function and eliminates
kvm_vcpu_uninit() entirely.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c079b22032fa..e532c6e606c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -287,10 +287,8 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
-static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-	struct page *page;
-
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
@@ -302,23 +300,11 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->pre_pcpu = -1;
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
-		return -ENOMEM;
-	vcpu->run = page_address(page);
-
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
-
-	return 0;
-}
-
-static void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-	free_page((unsigned long)vcpu->run);
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -332,7 +318,7 @@ void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 */
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
 
-	kvm_vcpu_uninit(vcpu);
+	free_page((unsigned long)vcpu->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
@@ -2636,6 +2622,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
+	struct page *page;
 
 	if (id >= KVM_MAX_VCPU_ID)
 		return -EINVAL;
@@ -2659,13 +2646,18 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto vcpu_decrement;
 	}
 
-	r = kvm_vcpu_init(vcpu, kvm, id);
-	if (r)
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page) {
+		r = -ENOMEM;
 		goto vcpu_free;
+	}
+	vcpu->run = page_address(page);
+
+	kvm_vcpu_init(vcpu, kvm, id);
 
 	r = kvm_arch_vcpu_create(vcpu);
 	if (r)
-		goto vcpu_uninit;
+		goto vcpu_free_run_page;
 
 	kvm_create_vcpu_debugfs(vcpu);
 
@@ -2702,8 +2694,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	mutex_unlock(&kvm->lock);
 	debugfs_remove_recursive(vcpu->debugfs_dentry);
 	kvm_arch_vcpu_destroy(vcpu);
-vcpu_uninit:
-	kvm_vcpu_uninit(vcpu);
+vcpu_free_run_page:
+	free_page((unsigned long)vcpu->run);
 vcpu_free:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
