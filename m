Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51719C2D0BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 108C024650
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 108C024650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE69D4A959;
	Wed, 18 Dec 2019 16:55:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CiSFrjNOgCqX; Wed, 18 Dec 2019 16:55:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5124AED0;
	Wed, 18 Dec 2019 16:55:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7AA4AC80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ARwZ9u4zvzvW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:55:39 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB5134ACD6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:36 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108043"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:35 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 09/45] KVM: x86: Move allocation of pio_data page down a
 few lines
Date: Wed, 18 Dec 2019 13:54:54 -0800
Message-Id: <20191218215530.2280-10-sean.j.christopherson@intel.com>
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

Allocate the pio_data page after creating the MMU and local APIC so that
all direct memory allocations are grouped together.  This allows setting
the return value to -ENOMEM prior to starting the allocations instead of
setting it in the fail path for every allocation.

The pio_data page is only consumed when KVM_RUN is invoked, i.e. moving
its allocation has no real functional impact.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3f122dca5f8..b3e367963b08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9420,18 +9420,11 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
-		goto fail;
-	}
-	vcpu->arch.pio_data = page_address(page);
-
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
-		goto fail_free_pio_data;
+		return r;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
@@ -9441,25 +9434,27 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	} else
 		static_key_slow_inc(&kvm_no_apic_vcpu);
 
+	r = -ENOMEM;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto fail_free_lapic;
+	vcpu->arch.pio_data = page_address(page);
+
 	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks) {
-		r = -ENOMEM;
-		goto fail_free_lapic;
-	}
+	if (!vcpu->arch.mce_banks)
+		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
-				GFP_KERNEL_ACCOUNT)) {
-		r = -ENOMEM;
+				GFP_KERNEL_ACCOUNT))
 		goto fail_free_mce_banks;
-	}
 
 	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.user_fpu) {
 		pr_err("kvm: failed to allocate userspace's fpu\n");
-		r = -ENOMEM;
 		goto free_wbinvd_dirty_mask;
 	}
 
@@ -9467,7 +9462,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 						 GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.guest_fpu) {
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
-		r = -ENOMEM;
 		goto free_user_fpu;
 	}
 	fx_init(vcpu);
@@ -9494,13 +9488,12 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
 	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
-fail_free_pio_data:
-	free_page((unsigned long)vcpu->arch.pio_data);
-fail:
 	return r;
 }
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
