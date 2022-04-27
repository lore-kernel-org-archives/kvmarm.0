Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD498C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 22:04:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23EE240C0A;
	Wed, 27 Apr 2022 18:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HKj8ByunuiWg; Wed, 27 Apr 2022 18:04:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1BB41049;
	Wed, 27 Apr 2022 18:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024BB40BE7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 18:04:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mgr1vPQlKQE2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 18:04:46 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD45B40BA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 18:04:46 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CDBBA61E13;
 Wed, 27 Apr 2022 22:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061F1C385A9;
 Wed, 27 Apr 2022 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651097085;
 bh=pd+ppBS4AMOOPk2OjVc3EDZ0y0+9s9EffkC7oPOrVaA=;
 h=From:To:Cc:Subject:Date:From;
 b=bNd0y9GXq5k/qn0mRLOX7NDrArqeGsR6IzOkgOvtveIcb8irWHjo6I8JXX7U6wfyF
 lSrhzyx70dySogcKsWMtoVQq6oIOmNNbCICS6dDL+/oZOdMfw6v5Mk8YKjwLBZuwpY
 6S6KEf99Zgjmx7/E0G7xXPQ0UcSzp7GrviE+cej2UfIYUzShMMV7wHSCxU5f9lcDzj
 iXESud4NQi2xXHC36GuAS80f/ZCigDGqxr4GR1wDf1L/9LKCPpni4Yni/OFOslwkrd
 dPpD919UPz2vAnTUBWgdNUsJ3qj6Z7xcNzzc2IxImlr1bqM8rvg1NlY4ft29WNSogB
 AzQErIphDSG5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1njpm6-007U5C-Ix; Wed, 27 Apr 2022 23:04:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: Inject exception on out-of-IPA-range
 translation fault
Date: Wed, 27 Apr 2022 23:04:34 +0100
Message-Id: <20220427220434.3097449-1-maz@kernel.org>
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

When taking a translation fault for an IPA that is outside of
the range defined by the hypervisor (between the HW PARange and
the IPA range), we stupidly treat it as an IO and forward the access
to userspace. Of course, userspace can't do much with it, and things
end badly.

Arguably, the guest is braindead, but we should at least catch the
case and inject an exception.

Check the faulting IPA against:
- the sanitised PARange: inject an address size fault
- the IPA size: inject an abort

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
 3 files changed, 48 insertions(+)

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
index 53ae2c0640bc..5400fc020164 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1337,6 +1337,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
+	if (fault_status == FSC_FAULT) {
+		/* Beyond sanitised PARange (which is the IPA limit) */
+		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
+			kvm_inject_size_fault(vcpu);
+			return 1;
+		}
+
+		/* Falls between the IPA range and the PARange? */
+		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
+			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+			if (is_iabt)
+				kvm_inject_pabt(vcpu, fault_ipa);
+			else
+				kvm_inject_dabt(vcpu, fault_ipa);
+			return 1;
+		}
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
