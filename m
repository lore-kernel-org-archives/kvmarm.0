Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAECC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 15:40:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC43B4A104;
	Thu, 21 Apr 2022 11:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Q0hU6eE2tMY; Thu, 21 Apr 2022 11:40:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 947FE4A193;
	Thu, 21 Apr 2022 11:40:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A42CF4A104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 11:39:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id deThLpj66wj2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 11:39:58 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6729549F44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 11:39:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B83C261BF4;
 Thu, 21 Apr 2022 15:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B193C385A5;
 Thu, 21 Apr 2022 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650555597;
 bh=xnNDIFGmGErE9LYA+F8Mqxfij5dEJ8CYiCbCDus4rCM=;
 h=From:To:Cc:Subject:Date:From;
 b=fFfaFq+4lbUg60iP1903baEwHcLK0HONk8bCGwEKfntbSrr9q3sHmA38cyfcn6oJd
 BIztdjiDJyBTr2sDSvuN/4bNwbyiEcQeymFfGbyql+2jdkR0gf3GidJP8XSstDTD9e
 0GhhSHSpCrRqwiJ0vQ2/o0umPM93SR/cUUVXOZ1QwQOKIUgGq2l7f5OI8BKPZR9Tf9
 VOpSSvQKqMon7ShWo99ziVbHXN/8LdUdgvCsNldrh4CP2pkIdmVHOZ5XhAXEjtKm7b
 Z+CooR4j8q2WCV8Bk8GhN21XWrFPhyWUjCDRD/wzDUjtPqEEqtl/XeyLuFo9u/CTVz
 7HJ6jc3zOYhpw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nhYuQ-005vqc-Nr; Thu, 21 Apr 2022 16:39:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Inject exception on out-of-IPA-range translation
 fault
Date: Thu, 21 Apr 2022 16:39:49 +0100
Message-Id: <20220421153949.2931552-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com, qperret@google.com,
 will@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 Christoffer Dall <christoffer.dall@arm.com>
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

When taking an translation fault for an IPA that is outside of
the range defined by the hypervisor (between the HW PARange and
that exposed to the guest), we stupidly treat it as an IO and
forward the access to userspace. Of course, userspace can't do
much with it, and things end badly.

Arguably, the guest is braindead, but we should at least catch the
case and inject an exception.

Check the faulting IPA against the IPA size the VM has, and
inject an Address Size Fault at level 0 if the access fails the
check.

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 |  7 +++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7496deab025a..f71358271b71 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -40,6 +40,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
+void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index b47df73e98d7..ba20405d2dc2 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -145,6 +145,34 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 		inject_abt64(vcpu, true, addr);
 }
 
+void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
+{
+	unsigned long addr, esr;
+
+	addr  = kvm_vcpu_get_fault_ipa(vcpu);
+	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+	if (kvm_vcpu_trap_is_iabt(vcpu))
+		kvm_inject_pabt(vcpu, addr);
+	else
+		kvm_inject_dabt(vcpu, addr);
+
+	/*
+	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
+	 * Size Fault at level 0, as if exceeding PARange.
+	 *
+	 * Non-LPAE guests will only get the external abort, as there
+	 * is no way to to describe the ASF.
+	 */
+	if (vcpu_el1_is_32bit(vcpu) &&
+	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
+		return;
+
+	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
+	esr &= ~GENMASK_ULL(5, 0);
+	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+}
+
 /**
  * kvm_inject_undefined - inject an undefined instruction into the guest
  * @vcpu: The vCPU in which to inject the exception
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 53ae2c0640bc..de6c3ae4afd5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1337,6 +1337,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
+	/* Address Size Fault? */
+	if (fault_status == FSC_FAULT &&
+	    fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
+		kvm_inject_size_fault(vcpu);
+		return 1;
+	}
+
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
 		/*
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
