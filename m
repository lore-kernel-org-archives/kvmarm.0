Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FC7C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07CAC64E20
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07CAC64E20
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB084B503;
	Mon, 15 Mar 2021 07:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TbihQX+JGr0T; Mon, 15 Mar 2021 07:31:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 932BA4B4F4;
	Mon, 15 Mar 2021 07:31:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BCCE4B4F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z+QM95qepoBv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 07:31:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DFD64B4DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:28 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D0F64E20;
 Mon, 15 Mar 2021 11:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1615807887;
 bh=Xtcz6Cdi80C8BslFptWm9BjYu079ITJ4g1hVWoqHe/g=;
 h=Subject:To:Cc:From:Date:In-Reply-To:From;
 b=lDDKfcHmaFWclmqOjpLWZU9Q8BjvuSsWs0+FSxTj6T0qIsERQNAtjaZ2wbqnZq9bZ
 fHls0/0Q+CtgTZgPlqbPvHqyTcHyBwVHKT8+hXdvElSPDndyzAcwX0i5qXMwoZuNJU
 4t0JPfIDq2iZSh6EpzXY4JDkwfry0kjJUEywVoPE=
Subject: Patch "KVM: arm64: Ensure I-cache isolation between vcpus of a same
 VM" has been added to the 5.4-stable tree
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 will@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Mon, 15 Mar 2021 12:31:25 +0100
In-Reply-To: <20210315111000.4136196-1-maz@kernel.org>
Message-ID: <1615807885173250@kroah.com>
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

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-ensure-i-cache-isolation-between-vcpus-of-a-same-vm.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From foo@baz Mon Mar 15 12:27:33 PM CET 2021
From: Marc Zyngier <maz@kernel.org>
Date: Mon, 15 Mar 2021 11:10:00 +0000
Subject: KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
To: gregkh@linuxfoundation.org
Cc: kvmarm@lists.cs.columbia.edu, kernel-team@android.com, stable@vger.kernel.org, Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20210315111000.4136196-1-maz@kernel.org>

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
[maz: added 32bit ARM support]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/kvm_asm.h   |    2 +-
 arch/arm/kvm/hyp/tlb.c           |    3 ++-
 arch/arm64/include/asm/kvm_asm.h |    2 +-
 arch/arm64/kvm/hyp/tlb.c         |    3 ++-
 virt/kvm/arm/arm.c               |    8 +++++++-
 5 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -56,7 +56,7 @@ extern char __kvm_hyp_init_end[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_flush_cpu_context(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -45,7 +45,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa
 	__kvm_tlb_flush_vmid(kvm);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_flush_cpu_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 
@@ -54,6 +54,7 @@ void __hyp_text __kvm_tlb_flush_local_vm
 	isb();
 
 	write_sysreg(0, TLBIALL);
+	write_sysreg(0, ICIALLU);
 	dsb(nsh);
 	isb();
 
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,7 +60,7 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_flush_cpu_context(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -182,7 +182,7 @@ void __hyp_text __kvm_tlb_flush_vmid(str
 	__tlb_switch_to_host(kvm, &cxt);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_flush_cpu_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 	struct tlb_inv_context cxt;
@@ -191,6 +191,7 @@ void __hyp_text __kvm_tlb_flush_local_vm
 	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -373,11 +373,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	cpu_data = this_cpu_ptr(&kvm_host_data);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
+         * We might get preempted before the vCPU actually runs, but
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
+		kvm_call_hyp(__kvm_flush_cpu_context, vcpu);
 		*last_ran = vcpu->vcpu_id;
 	}
 


Patches currently in stable-queue which might be from maz@kernel.org are

queue-5.4/kvm-arm64-reject-vm-creation-when-the-default-ipa-size-is-unsupported.patch
queue-5.4/kvm-arm64-ensure-i-cache-isolation-between-vcpus-of-a-same-vm.patch
queue-5.4/kvm-arm64-fix-exclusive-limit-for-ipa-size.patch
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
