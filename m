Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F34CA9EB0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9969322459
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9969322459
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 551D84A9EA;
	Mon, 21 Oct 2019 21:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EZMay2rKz2Y2; Mon, 21 Oct 2019 21:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F06D34AC0B;
	Mon, 21 Oct 2019 21:59:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C434A5ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 21:59:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNx15pI9bAN9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 21:59:38 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C104C4A9B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 21:59:37 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Oct 2019 18:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; d="scan'208";a="196293773"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:36 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 08/45] KVM: x86: Move FPU allocation to common x86 code
Date: Mon, 21 Oct 2019 18:58:48 -0700
Message-Id: <20191022015925.31916-9-sean.j.christopherson@intel.com>
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

The allocation of FPU structs is identical across VMX and SVM, move it
to common x86 code.  Somewhat arbitrarily place the allocation so that
it resides directly above the associated initialization via fx_init(),
e.g. instead of retaining its position with respect to the overall vcpu
creation flow.  Although the names names kvm_arch_vcpu_create() and
kvm_arch_vcpu_init() might suggest otherwise, x86 does not have a clean
split between 'create' and 'init'.  Allocating the struct immediately
prior to the first use arguably improves readability *now*, and will
yield even bigger improvements when kvm_arch_vcpu_init() is removed in
a future patch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 25 +------------------------
 arch/x86/kvm/vmx/vmx.c | 25 +------------------------
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bbc5dac9d400..dc4e835f7d46 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2151,25 +2151,9 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
 	svm = to_svm(vcpu);
 
-	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
-		goto out;
-	}
-
-	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						 GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
-		goto free_user_fpu;
-	}
-
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_guest_fpu;
+		return err;
 
 	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL_ACCOUNT);
@@ -2225,11 +2209,6 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	__free_page(page);
 uninit:
 	kvm_vcpu_uninit(vcpu);
-free_guest_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-out:
 	return err;
 }
 
@@ -2257,8 +2236,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 832d8e38acd4..1973029c5c77 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6691,8 +6691,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 }
 
 static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
@@ -6705,25 +6703,9 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
-	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.user_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
-		goto out;
-	}
-
-	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						 GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.guest_fpu) {
-		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
-		goto free_user_fpu;
-	}
-
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_vcpu;
+		return err;
 
 	err = -ENOMEM;
 
@@ -6819,11 +6801,6 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
 	free_vpid(vmx->vpid);
-free_vcpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-out:
 	return err;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45b296a9fdbb..777a29b3c38b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9017,6 +9017,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_free(vcpu);
 
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
@@ -9371,6 +9373,21 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_mce_banks;
 	}
 
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
+		pr_err("kvm: failed to allocate userspace's fpu\n");
+		r = -ENOMEM;
+		goto free_wbinvd_dirty_mask;
+	}
+
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						 GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
+		pr_err("kvm: failed to allocate vcpu's fpu\n");
+		r = -ENOMEM;
+		goto free_user_fpu;
+	}
 	fx_init(vcpu);
 
 	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
@@ -9389,6 +9406,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+free_wbinvd_dirty_mask:
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 fail_free_lapic:
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
