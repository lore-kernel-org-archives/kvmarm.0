Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3331C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E0EB64E81
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E0EB64E81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 424D34B599;
	Mon, 15 Mar 2021 07:31:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7aCpho3KTZRR; Mon, 15 Mar 2021 07:31:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E100F4B58E;
	Mon, 15 Mar 2021 07:31:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98AC24B503
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id POtl9+GCBFd7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 07:31:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 196C04B37C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:45 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4BF164E20;
 Mon, 15 Mar 2021 11:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1615807904;
 bh=8RFKLy71jl2pEUsc0sBXhll5suL94CI9oeNXK+2ifYk=;
 h=Subject:To:Cc:From:Date:In-Reply-To:From;
 b=pxc+uYieT+7RKaFaQ8wpShuSNnW9KHtdcSRgbfkxb0+bPdxQk4ABZTEWgvV9VlGLI
 2HWyHZB58N35X5M1Lni18+fgBZxC7VafrWRdopRGapZCoRg+BrRJYISKxfyZJUtQy3
 mAMftLrR2DYOgSEHliENxMnPWT7/fw6tCmmYO5KA=
Subject: Patch "KVM: arm64: Ensure I-cache isolation between vcpus of a same
 VM" has been added to the 5.10-stable tree
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 will@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Mon, 15 Mar 2021 12:31:42 +0100
In-Reply-To: <20210315111111.4136402-1-maz@kernel.org>
Message-ID: <161580790264124@kroah.com>
MIME-Version: 1.0
X-stable: commit
X-Patchwork-Hint: ignore 
Cc: stable-commits@vger.kernel.org
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


This is a note to let you know that I've just added the patch titled

    KVM: arm64: Ensure I-cache isolation between vcpus of a same VM

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-ensure-i-cache-isolation-between-vcpus-of-a-same-vm.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From foo@baz Mon Mar 15 12:27:09 PM CET 2021
From: Marc Zyngier <maz@kernel.org>
Date: Mon, 15 Mar 2021 11:11:11 +0000
Subject: KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
To: gregkh@linuxfoundation.org
Cc: kvmarm@lists.cs.columbia.edu, kernel-team@android.com, stable@vger.kernel.org, Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20210315111111.4136402-1-maz@kernel.org>

From: Marc Zyngier <maz@kernel.org>

Commit 01dc9262ff5797b675c32c0c6bc682777d23de05 upstream.

It recently became apparent that the ARMv8 architecture has interesting
rules regarding attributes being used when fetching instructions
if the MMU is off at Stage-1.

In this situation, the CPU is allowed to fetch from the PoC and
allocate into the I-cache (unless the memory is mapped with
the XN attribute at Stage-2).

If we transpose this to vcpus sharing a single physical CPU,
it is possible for a vcpu running with its MMU off to influence
another vcpu running with its MMU on, as the latter is expected to
fetch from the PoU (and self-patching code doesn't flush below that
level).

In order to solve this, reuse the vcpu-private TLB invalidation
code to apply the same policy to the I-cache, nuking it every time
the vcpu runs on a physical CPU that ran another vcpu of the same
VM in the past.

This involve renaming __kvm_tlb_flush_local_vmid() to
__kvm_flush_cpu_context(), and inserting a local i-cache invalidation
there.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210303164505.68492-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h   |    4 ++--
 arch/arm64/kvm/arm.c               |    7 ++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    4 ++--
 arch/arm64/kvm/hyp/nvhe/tlb.c      |    3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c       |    3 ++-
 5 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -49,7 +49,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	5
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
 #define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
 #define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
@@ -180,10 +180,10 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
 extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -352,11 +352,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
+		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -46,11 +46,11 @@ static void handle_host_hcall(unsigned l
 		__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 		break;
 	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
+	case KVM_HOST_SMCCC_FUNC(__kvm_flush_cpu_context): {
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
 
-		__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+		__kvm_flush_cpu_context(kern_hyp_va(mmu));
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -123,7 +123,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -131,6 +131,7 @@ void __kvm_tlb_flush_local_vmid(struct k
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -127,7 +127,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -135,6 +135,7 @@ void __kvm_tlb_flush_local_vmid(struct k
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 


Patches currently in stable-queue which might be from maz@kernel.org are

queue-5.10/kvm-arm64-fix-range-alignment-when-walking-page-tables.patch
queue-5.10/kvm-arm64-nvhe-save-the-spe-context-early.patch
queue-5.10/kvm-arm64-reject-vm-creation-when-the-default-ipa-size-is-unsupported.patch
queue-5.10/kvm-arm64-ensure-i-cache-isolation-between-vcpus-of-a-same-vm.patch
queue-5.10/kvm-arm64-fix-exclusive-limit-for-ipa-size.patch
queue-5.10/kvm-arm64-avoid-corrupting-vcpu-context-register-in-guest-exit.patch
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
