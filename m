From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 08/55] KVM: arm64: Set virtual EL2 context depending on the
 guest exception level
Date: Mon,  9 Jan 2017 01:24:04 -0500
Message-ID: <1483943091-1364-9-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 020DE401F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5j6jFEuFbBHL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:01 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3038E40798
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:00 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWsn005289
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:41 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id BAB796D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:41 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 936A06D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:41 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pfcl056603
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:41 -0500
Received: by mail-qk0-f199.google.com with SMTP id x64so109012967qkb.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:41 -0800 (PST)
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

Set up virutal EL2 context to hardware if the guest exception level is
EL2.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 320afc6..acb4b1e 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -25,10 +25,25 @@
 void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	if (unlikely(vcpu_mode_el2(vcpu))) {
+		ctxt->hw_pstate = *vcpu_cpsr(vcpu) & ~PSR_MODE_MASK;
 
-	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
-	ctxt->hw_sys_regs = ctxt->sys_regs;
-	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
+		/*
+		 * We emulate virtual EL2 mode in hardware EL1 mode using the
+		 * same stack pointer mode as the guest expects.
+		 */
+		if ((*vcpu_cpsr(vcpu) & PSR_MODE_MASK) == PSR_MODE_EL2h)
+			ctxt->hw_pstate |= PSR_MODE_EL1h;
+		else
+			ctxt->hw_pstate |= PSR_MODE_EL1t;
+
+		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
+		ctxt->hw_sp_el1 = ctxt->el2_regs[SP_EL2];
+	} else {
+		ctxt->hw_pstate = *vcpu_cpsr(vcpu);
+		ctxt->hw_sys_regs = ctxt->sys_regs;
+		ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
+	}
 }
 
 /**
@@ -38,9 +53,14 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
-
-	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
-	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
+	if (unlikely(vcpu_mode_el2(vcpu))) {
+		*vcpu_cpsr(vcpu) &= PSR_MODE_MASK;
+		*vcpu_cpsr(vcpu) |= ctxt->hw_pstate & ~PSR_MODE_MASK;
+		ctxt->el2_regs[SP_EL2] = ctxt->hw_sp_el1;
+	} else {
+		*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
+		ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
+	}
 }
 
 void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
-- 
1.9.1
