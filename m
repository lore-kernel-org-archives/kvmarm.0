Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C18C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C638B4B475;
	Thu, 19 May 2022 09:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ej17kFsWdcfV; Thu, 19 May 2022 09:46:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5BF14B44E;
	Thu, 19 May 2022 09:46:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DAF34B413
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0V2wUyVQcBdN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:45 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DE674B3B3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:45 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4858CB824AF;
 Thu, 19 May 2022 13:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EACC34116;
 Thu, 19 May 2022 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968003;
 bh=kgENcXfDAe+sx9c87Cb7w5AnDvemeP3zb9MSHnnKeBg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SjfvBwcxc0CDVBgdK0cyBAv6bmGMIHmagBvNXm4nsCVvV/4S9A2KI2m7z8GSuMvpQ
 Rc0VMktQzoYDV2sZiXyyXBlvnNtvx0cTN9efsjsu+nYGxV8jcIjHQHNqHajcYYiSFE
 WC314ABABqOrRIxHdLjedC9YyaWuZGddgKjG+iYk1Au0rUd5ylD3sePHHk37X3poMC
 vubMdvlScVWTH8KodKsajSjSqb1BUxqMnCoV9EIE/MDUU43Ky7S62wEvMoRJUrLnrL
 qib+yVWT4mkisVq6/govseqNN4Pw+B4/ftWZkhR+b9CJv9iOJqDLwxLGSbMBGKWma/
 Zmzh2pZGRGCPw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 65/89] KVM: arm64: Force injection of a data abort on NISV
 MMIO exit
Date: Thu, 19 May 2022 14:41:40 +0100
Message-Id: <20220519134204.5379-66-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

If a vcpu exits for a data abort with an invalid syndrome, the
expectations are that userspace has a chance to save the day if
it has requested to see such exits.

However, this is completely futile in the case of a protected VM,
as none of the state is available. In this particular case, inject
a data abort directly into the vcpu, consistent with what userspace
could do.

This also helps with pKVM, which discards all syndrome information when
forwarding data aborts that are not known to be MMIO.

Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
protected VMs, and document this tweak to the API.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 arch/arm64/kvm/arm.c           | 14 ++++++++++----
 arch/arm64/kvm/mmio.c          |  9 +++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa6600467..207706260f67 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6115,6 +6115,13 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+This feature isn't available to protected VMs, as userspace does not
+have access to the state that is required to perform the emulation.
+Instead, a data abort exception is directly injected in the guest.
+Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
+queried outside of a protected VM context, the feature will not be
+exposed if queried on a protected VM file descriptor.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 65af1757e73a..9c5a935a9a73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -84,9 +84,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
-		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
-			&kvm->arch.flags);
+		if (kvm_vm_is_protected(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+				&kvm->arch.flags);
+		}
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -217,13 +221,15 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = !kvm || !kvm_vm_is_protected(kvm);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..db6630c70f8b 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,8 +133,17 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
+	 *
+	 * In the protected VM case, there isn't much userspace can do
+	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+		if (is_protected_kvm_enabled() &&
+		    kvm_vm_is_protected(vcpu->kvm)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
