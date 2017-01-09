From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 45/55] KVM: arm64: KVM: Inject stage-2 page faults
Date: Mon,  9 Jan 2017 01:24:41 -0500
Message-ID: <1483943091-1364-46-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB4A40669
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1MvqFGfWAP2G for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:51 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D8D040838
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:47 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5Cd017975
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:29 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 2192281
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:29 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id E8F7B86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:28 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QSof042946
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:28 -0500
Received: by mail-qt0-f200.google.com with SMTP id k15so94310237qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:28 -0800 (PST)
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

Inject stage-2 page faults to the guest hypervisor.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/esr.h |  1 +
 arch/arm64/kvm/mmu-nested.c  | 30 ++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index f32e3a7..6104e31 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -107,6 +107,7 @@
 #define ESR_ELx_CM 		(UL(1) << 8)
 
 /* ISS field definitions for exceptions taken in to Hyp */
+#define ESR_ELx_FSC_ADDRSZ	(0x00)
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index a2fab41..b161b55 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -55,22 +55,40 @@ static unsigned int pa_max(void)
 static int vcpu_inject_s2_trans_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
 				      int level)
 {
-	/* TODO: Implement */
-	return -EFAULT;
+	u32 esr;
+
+	vcpu->arch.ctxt.el2_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
+	vcpu->arch.ctxt.el2_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
+	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
+	esr |= ESR_ELx_FSC_FAULT;
+	esr |= level & 0x3;
+	return kvm_inject_nested_sync(vcpu, esr);
 }
 
 static int vcpu_inject_s2_addr_sz_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
 					int level)
 {
-	/* TODO: Implement */
-	return -EFAULT;
+	u32 esr;
+
+	vcpu->arch.ctxt.el2_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
+	vcpu->arch.ctxt.el2_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
+	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
+	esr |= ESR_ELx_FSC_ADDRSZ;
+	esr |= level & 0x3;
+	return kvm_inject_nested_sync(vcpu, esr);
 }
 
 static int vcpu_inject_s2_access_flag_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
 					    int level)
 {
-	/* TODO: Implement */
-	return -EFAULT;
+	u32 esr;
+
+	vcpu->arch.ctxt.el2_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
+	vcpu->arch.ctxt.el2_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
+	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
+	esr |= ESR_ELx_FSC_ACCESS;
+	esr |= level & 0x3;
+	return kvm_inject_nested_sync(vcpu, esr);
 }
 
 static int check_base_s2_limits(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
-- 
1.9.1
