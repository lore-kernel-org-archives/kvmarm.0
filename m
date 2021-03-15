Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C02C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6802664E81
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6802664E81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130A74B599;
	Mon, 15 Mar 2021 07:31:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5LEtdGL9nfDh; Mon, 15 Mar 2021 07:31:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B907D4B503;
	Mon, 15 Mar 2021 07:31:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EAF4B37C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MTHE82+LoA2L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 07:31:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C32204B36B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:31:36 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C45E64E20;
 Mon, 15 Mar 2021 11:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1615807896;
 bh=Tp/8cxPYy6uoZjugqW4LEVvFCf4bhLADbMlG345LuZ4=;
 h=Subject:To:Cc:From:Date:In-Reply-To:From;
 b=2HaIKzJRRK65kgMoHEvvSUOPHPBVM4MjyhUx9JrTzIVeBuSeiiNzjUEVBKQ9mZRDg
 TeramdTm7KT78MDCNkWta+x9CL6YFKJl2cmt9JnpFKHPby+1p3etDcihasZNIsPhKb
 1mwY1o2x9rxJtIlixealq326Jj3ZPeXa4gq+bIgQ=
Subject: Patch "KVM: arm64: Reject VM creation when the default IPA size is
 unsupported" has been added to the 5.4-stable tree
To: drjones@redhat.com, eric.auger@redhat.com, gregkh@linuxfoundation.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, maz@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Mon, 15 Mar 2021 12:31:25 +0100
In-Reply-To: <20210315110952.4136142-1-maz@kernel.org>
Message-ID: <161580788522249@kroah.com>
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

    KVM: arm64: Reject VM creation when the default IPA size is unsupported

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-reject-vm-creation-when-the-default-ipa-size-is-unsupported.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From foo@baz Mon Mar 15 12:27:54 PM CET 2021
From: Marc Zyngier <maz@kernel.org>
Date: Mon, 15 Mar 2021 11:09:52 +0000
Subject: KVM: arm64: Reject VM creation when the default IPA size is unsupported
To: gregkh@linuxfoundation.org
Cc: kvmarm@lists.cs.columbia.edu, kernel-team@android.com, stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Eric Auger <eric.auger@redhat.com>
Message-ID: <20210315110952.4136142-1-maz@kernel.org>

From: Marc Zyngier <maz@kernel.org>

Commit 7d717558dd5ef10d28866750d5c24ff892ea3778 upstream.

KVM/arm64 has forever used a 40bit default IPA space, partially
due to its 32bit heritage (where the only choice is 40bit).

However, there are implementations in the wild that have a *cough*
much smaller *cough* IPA space, which leads to a misprogramming of
VTCR_EL2, and a guest that is stuck on its first memory access
if userspace dares to ask for the default IPA setting (which most
VMMs do).

Instead, blundly reject the creation of such VM, as we can't
satisfy the requirements from userspace (with a one-off warning).
Also clarify the boot warning, and document that the VM creation
will fail when an unsupported IPA size is provided.

Although this is an ABI change, it doesn't really change much
for userspace:

- the guest couldn't run before this change, but no error was
  returned. At least userspace knows what is happening.

- a memory slot that was accepted because it did fit the default
  IPA space now doesn't even get a chance to be registered.

The other thing that is left doing is to convince userspace to
actually use the IPA space setting instead of relying on the
antiquated default.

Fixes: 233a7cb23531 ("kvm: arm64: Allow tuning the physical address size for VM")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20210311100016.3830038-2-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.txt |    3 +++
 arch/arm64/kvm/reset.c         |   11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -172,6 +172,9 @@ is dependent on the CPU capability and t
 be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
 ioctl() at run-time.
 
+Creation of the VM will fail if the requested IPA size (whether it is
+implicit or explicit) is unsupported on the host.
+
 Please note that configuring the IPA size does not affect the capability
 exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
 size of the address translated by the stage2 level (guest physical to
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -378,10 +378,10 @@ void kvm_set_ipa_limit(void)
 		pr_info("kvm: Limiting the IPA size due to kernel %s Address limit\n",
 			(va_max < pa_max) ? "Virtual" : "Physical");
 
-	WARN(ipa_max < KVM_PHYS_SHIFT,
-	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
 	kvm_ipa_limit = ipa_max;
-	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
+		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
+		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
 }
 
 /*
@@ -408,6 +408,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
 	}
 
 	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;


Patches currently in stable-queue which might be from maz@kernel.org are

queue-5.4/kvm-arm64-reject-vm-creation-when-the-default-ipa-size-is-unsupported.patch
queue-5.4/kvm-arm64-ensure-i-cache-isolation-between-vcpus-of-a-same-vm.patch
queue-5.4/kvm-arm64-fix-exclusive-limit-for-ipa-size.patch
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
