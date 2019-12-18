Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44837C2D0D1
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00D28227BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00D28227BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E0B4ACDB;
	Wed, 18 Dec 2019 16:56:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YNAzpeYrxpU2; Wed, 18 Dec 2019 16:56:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2930D4AF4B;
	Wed, 18 Dec 2019 16:56:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564044A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:56:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zwgeIPrsx-m2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:56:03 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B783C4AF0E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:50 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222108172"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:50 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 39/45] KVM: MIPS: Move all vcpu init code into
 kvm_arch_vcpu_create()
Date: Wed, 18 Dec 2019 13:55:24 -0800
Message-Id: <20191218215530.2280-40-sean.j.christopherson@intel.com>
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

Fold init() into create() now that the two are called back-to-back by
common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
immediately thereafter).  Rinse and repeat for kvm_arch_vcpu_uninit()
and kvm_arch_vcpu_destroy().  This paves the way for removing
kvm_arch_vcpu_{un}init() entirely.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 06366e2415a6..879a7cbd5b54 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -294,6 +294,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_debug("kvm @ %p: create cpu %d at %p\n",
 		  vcpu->kvm, vcpu->vcpu_id, vcpu);
 
+	err = kvm_mips_callbacks->vcpu_init(vcpu);
+	if (err)
+		return err;
+
+	hrtimer_init(&vcpu->arch.comparecount_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
+	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
+
 	/*
 	 * Allocate space for host mode exception handlers that handle
 	 * guest mode exits
@@ -307,7 +315,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	if (!gebase) {
 		err = -ENOMEM;
-		goto out;
+		goto out_uninit_vcpu;
 	}
 	kvm_debug("Allocated %d bytes for KVM Exception Handlers @ %p\n",
 		  ALIGN(size, PAGE_SIZE), gebase);
@@ -397,7 +405,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.kseg0_commpage);
 out_free_gebase:
 	kfree(gebase);
-out:
+out_uninit_vcpu:
+	kvm_mips_callbacks->vcpu_uninit(vcpu);
 	return err;
 }
 
@@ -410,6 +419,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
+
+	kvm_mips_callbacks->vcpu_uninit(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
@@ -1221,21 +1232,12 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	int err;
-
-	err = kvm_mips_callbacks->vcpu_init(vcpu);
-	if (err)
-		return err;
-
-	hrtimer_init(&vcpu->arch.comparecount_timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_REL);
-	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
 	return 0;
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	kvm_mips_callbacks->vcpu_uninit(vcpu);
+
 }
 
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
