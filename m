From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 36/55] KVM: arm64: Invalidate virtual EL2 TLB entries when needed
Date: Mon,  9 Jan 2017 01:24:32 -0500
Message-ID: <1483943091-1364-37-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7A2403FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rs2r7kvHLuDZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:37 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8B874027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:36 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Od0t005146
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:18 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 7061685
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:18 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 370437E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:18 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QIi5042672
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:18 -0500
Received: by mail-qt0-f199.google.com with SMTP id k15so94308596qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:18 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Sometimes when we are invalidating the TLB for a certain S2 MMU
context, this context can also have EL2 context associated with it and
we have to invalidate this too.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/arm.c |  6 ++++++
 arch/arm/kvm/mmu.c | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index aa8771d..371b38e7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -350,6 +350,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
+#ifndef CONFIG_KVM_ARM_NESTED_HYP
+		if (mmu->el2_vmid.vmid) {
+			vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+			kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
+		}
+#endif
 		*last_ran = vcpu->vcpu_id;
 	}
 
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 5ca3a04..56358fa 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -60,10 +60,20 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+#ifndef CONFIG_KVM_ARM_NESTED_HYP
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 	kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+#else
+	/*
+	 * When supporting nested virtualization, we can have multiple VMIDs
+	 * in play for each VCPU in the VM, so it's really not worth it to try
+	 * to quiesce the system and flush all the VMIDs that may be in use,
+	 * instead just nuke the whole thing.
+	 */
+	kvm_call_hyp(__kvm_flush_vm_context);
+#endif
 }
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
@@ -71,6 +81,12 @@ static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, ipa);
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+	if (!mmu->el2_vmid.vmid)
+		return; /* only if this mmu has el2 context */
+	vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, ipa);
+#endif
 }
 
 /*
-- 
1.9.1
