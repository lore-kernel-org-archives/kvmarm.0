Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733E0C3F68F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E87E2469F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E87E2469F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6AE34AED7;
	Wed, 18 Dec 2019 16:55:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vdoOhZhd7ulx; Wed, 18 Dec 2019 16:55:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC8D4AEE4;
	Wed, 18 Dec 2019 16:55:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3DA44A418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PEXdafho6LBX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:55:39 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8086D4A7F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:36 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108039"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:35 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 08/45] KVM: x86: Move FPU allocation to common x86 code
Date: Wed, 18 Dec 2019 13:54:53 -0800
Message-Id: <20191218215530.2280-9-sean.j.christopherson@intel.com>
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
index 4a979278abba..1a5ead23e84b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2157,25 +2157,9 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
@@ -2231,11 +2215,6 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
 
@@ -2263,8 +2242,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44166309b66c..fd688b16e688 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6673,8 +6673,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 }
 
 static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
@@ -6687,25 +6685,9 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
 
@@ -6822,11 +6804,6 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
index b7f565a43ad7..e3f122dca5f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9096,6 +9096,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_free(vcpu);
 
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
@@ -9453,6 +9455,21 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
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
@@ -9471,6 +9488,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+free_wbinvd_dirty_mask:
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 fail_free_lapic:
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
