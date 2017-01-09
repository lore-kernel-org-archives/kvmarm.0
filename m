From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 18/55] KVM: arm64: Forward traps due to HCR_EL2.NV1 bit to the
 guest hypervisor
Date: Mon,  9 Jan 2017 01:24:14 -0500
Message-ID: <1483943091-1364-19-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69ACF40674
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mBku24fdXR2J for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:18 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4384C404E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:15 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXnZ005357
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:56 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id CFFD582
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:56 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id A27B387
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:56 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PuqJ042101
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:56 -0500
Received: by mail-qk0-f197.google.com with SMTP id a195so63260263qkg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:56 -0800 (PST)
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

Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the guest hypervisor if
it has set the NV1 bit to the virtual HCR_EL2. The guest hypervisor
would set this NV1 bit to run a hypervisor in its VM (i.e. another level
of nested hypervisor).

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 2a2752b..feded61 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_NV1		(UL(1) << 43)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 19d6a6e..59f9cc6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -906,10 +906,21 @@ static inline void access_rw(struct sys_reg_params *p, u64 *sysreg)
 		*sysreg = p->regval;
 }
 
+static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	if (!vcpu_mode_el2(vcpu) && (vcpu_el2_reg(vcpu, HCR_EL2) & HCR_NV1))
+		return true;
+
+	return false;
+}
+
 static bool access_elr(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
+	if (forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu->arch.ctxt.gp_regs.elr_el1);
 	return true;
 }
@@ -918,6 +929,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
+	if (forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1]);
 	return true;
 }
@@ -926,6 +940,9 @@ static bool access_vbar(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
+	if (forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
 	return true;
 }
-- 
1.9.1
