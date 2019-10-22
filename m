Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C11CA9EB0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 02:00:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 158472084C
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 02:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 158472084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56BC4AC82;
	Mon, 21 Oct 2019 22:00:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ddRBX+niLBmZ; Mon, 21 Oct 2019 22:00:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3133C4AC73;
	Mon, 21 Oct 2019 22:00:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0701F4AC57
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 22:00:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lw1lnZiDzaM5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 22:00:07 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA72B4AC55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 21:59:58 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Oct 2019 18:59:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; d="scan'208";a="196293894"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:57 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 36/45] KVM: PPC: BookE: Setup vcpu during
 kvmppc_core_vcpu_create()
Date: Mon, 21 Oct 2019 18:59:16 -0700
Message-Id: <20191022015925.31916-37-sean.j.christopherson@intel.com>
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

Fold setup() into create() now that the two are called back-to-back by
common KVM code.  This paves the way for removing kvm_arch_vcpu_setup().
Note, BookE directly implements kvm_arch_vcpu_setup() and PPC's common
kvm_arch_vcpu_create() is responsible for its own cleanup, thus the only
cleanup required when directly invoking kvmppc_core_vcpu_setup() is to
call .vcpu_free(), which is the BookE specific portion of PPC's
kvm_arch_vcpu_destroy() by way of kvmppc_core_vcpu_free().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/booke.c | 60 ++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index dd7440e50c7a..b1b5073a22b1 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1377,34 +1377,9 @@ static void kvmppc_set_tsr(struct kvm_vcpu *vcpu, u32 new_tsr)
 	update_timer_ints(vcpu);
 }
 
-/* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	int i;
-	int r;
-
-	vcpu->arch.regs.nip = 0;
-	vcpu->arch.shared->pir = vcpu->vcpu_id;
-	kvmppc_set_gpr(vcpu, 1, (16<<20) - 8); /* -8 for the callee-save LR slot */
-	kvmppc_set_msr(vcpu, 0);
-
-#ifndef CONFIG_KVM_BOOKE_HV
-	vcpu->arch.shadow_msr = MSR_USER | MSR_IS | MSR_DS;
-	vcpu->arch.shadow_pid = 1;
-	vcpu->arch.shared->msr = 0;
-#endif
-
-	/* Eye-catching numbers so we know if the guest takes an interrupt
-	 * before it's programmed its own IVPR/IVORs. */
-	vcpu->arch.ivpr = 0x55550000;
-	for (i = 0; i < BOOKE_IRQPRIO_MAX; i++)
-		vcpu->arch.ivor[i] = 0x7700 | i * 4;
-
-	kvmppc_init_timing_stats(vcpu);
-
-	r = kvmppc_core_vcpu_setup(vcpu);
-	kvmppc_sanity_check(vcpu);
-	return r;
+	return 0;
 }
 
 int kvmppc_subarch_vcpu_init(struct kvm_vcpu *vcpu)
@@ -2116,7 +2091,38 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 
 int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.kvm_ops->vcpu_create(vcpu);
+	int i;
+	int r;
+
+	r = kvm->arch.kvm_ops->vcpu_create(vcpu);
+	if (r)
+		return r;
+
+	/* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
+	vcpu->arch.regs.nip = 0;
+	vcpu->arch.shared->pir = vcpu->vcpu_id;
+	kvmppc_set_gpr(vcpu, 1, (16<<20) - 8); /* -8 for the callee-save LR slot */
+	kvmppc_set_msr(vcpu, 0);
+
+#ifndef CONFIG_KVM_BOOKE_HV
+	vcpu->arch.shadow_msr = MSR_USER | MSR_IS | MSR_DS;
+	vcpu->arch.shadow_pid = 1;
+	vcpu->arch.shared->msr = 0;
+#endif
+
+	/* Eye-catching numbers so we know if the guest takes an interrupt
+	 * before it's programmed its own IVPR/IVORs. */
+	vcpu->arch.ivpr = 0x55550000;
+	for (i = 0; i < BOOKE_IRQPRIO_MAX; i++)
+		vcpu->arch.ivor[i] = 0x7700 | i * 4;
+
+	kvmppc_init_timing_stats(vcpu);
+
+	r = kvmppc_core_vcpu_setup(vcpu);
+	if (r)
+		vcpu->kvm->arch.kvm_ops->vcpu_free(vcpu);
+	kvmppc_sanity_check(vcpu);
+	return r;
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
