Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6592C2D0BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 767BB2146E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 767BB2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B1D4AEAB;
	Wed, 18 Dec 2019 16:56:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aZPf-1bNnoXU; Wed, 18 Dec 2019 16:56:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FD64AF50;
	Wed, 18 Dec 2019 16:56:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5818C4AEBD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:56:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ut4HiUvSUrHg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:56:04 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F9124AECA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:53 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108201"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:52 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 45/45] KVM: Move vcpu->run page allocation out of
 kvm_vcpu_init()
Date: Wed, 18 Dec 2019 13:55:30 -0800
Message-Id: <20191218215530.2280-46-sean.j.christopherson@intel.com>
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

Open code the allocation and freeing of the vcpu->run page in
kvm_vm_ioctl_create_vcpu() and kvm_vcpu_destroy() respectively.  Doing
so allows kvm_vcpu_init() to be a pure init function and eliminates
kvm_vcpu_uninit() entirely.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6912d81ca32d..220dce38cf79 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -321,10 +321,8 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
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
@@ -336,23 +334,11 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
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
@@ -366,7 +352,7 @@ void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 */
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
 
-	kvm_vcpu_uninit(vcpu);
+	free_page((unsigned long)vcpu->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
@@ -2711,6 +2697,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
+	struct page *page;
 
 	if (id >= KVM_MAX_VCPU_ID)
 		return -EINVAL;
@@ -2734,13 +2721,18 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
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
 
@@ -2778,8 +2770,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
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
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
