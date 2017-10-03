From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 06/31] KVM: arm64: Invalidate virtual EL2 TLB entries
 when needed
Date: Mon,  2 Oct 2017 22:10:48 -0500
Message-ID: <1507000273-3735-4-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA06A4060C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zmgba+TeANlB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:24 -0400 (EDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com
 [209.85.214.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D43E49D13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:24 -0400 (EDT)
Received: by mail-it0-f43.google.com with SMTP id c195so9756169itb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:43 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Sometimes when we are invalidating the TLB for a certain S2 MMU
context, this context can also have EL2 context associated with it and
we have to invalidate this too.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 virt/kvm/arm/arm.c |  5 +++++
 virt/kvm/arm/mmu.c | 23 ++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 41e0654..63dd897 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -362,6 +362,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
+
+		if (mmu->el2_vmid.vmid) {
+			vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+			kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
+		}
 		*last_ran = vcpu->vcpu_id;
 	}
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0edcf23..184cdc9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -64,7 +64,21 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
-	kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+	if (!mmu->el2_vmid.vmid) {
+		/*
+		 * For a normal (i.e. non-nested) guest, flush entries for the
+		 * given VMID *
+		 */
+		kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+	} else {
+		/*
+		 * When supporting nested virtualization, we can have multiple
+		 * VMIDs in play for each VCPU in the VM, so it's really not
+		 * worth it to try to quiesce the system and flush all the
+		 * VMIDs that may be in use, instead just nuke the whole thing.
+		 */
+		kvm_call_hyp(__kvm_flush_vm_context);
+	}
 }
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
@@ -72,6 +86,13 @@ static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, ipa);
+
+	if (!mmu->el2_vmid.vmid) {
+		/* Nothing to do more for a non-nested guest */
+		return;
+	}
+	vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, ipa);
 }
 
 /*
-- 
1.9.1
