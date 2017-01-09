From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 15/55] KVM: arm64: Trap EL1 VM register accesses in virtual EL2
Date: Mon,  9 Jan 2017 01:24:11 -0500
Message-ID: <1483943091-1364-16-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C98D44025C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpPa1O82Gjo4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:12 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7123D407F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:11 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096P4ds017232
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:53 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 1186D83
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:53 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id E26DF80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:52 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pq4F040809
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:52 -0500
Received: by mail-qk0-f200.google.com with SMTP id 11so31129161qkl.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:52 -0800 (PST)
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

When running in virtual EL2 mode, we actually run the hardware in EL1
and therefore have to use the EL1 registers to ensure correct operation.

By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
doesn't shoot itself in the foot when setting up what it believes to be
a different mode's system register state (for example when preparing to
switch to a VM).

We can leverage the existing sysregs infrastructure to support trapped
accesses to these registers.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/hyp/switch.c | 2 ++
 arch/arm64/kvm/sys_regs.c   | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 83037cd..c05c48f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -82,6 +82,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
+	if (vcpu_mode_el2(vcpu))
+		val |= HCR_TVM | HCR_TRVM;
 	write_sysreg(val, hcr_el2);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 202f64d..b8e993a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -101,7 +101,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 {
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 
-	BUG_ON(!p->is_write);
+	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
+
+	if (!p->is_write) {
+		p->regval = vcpu_sys_reg(vcpu, r->reg);
+		return true;
+	}
 
 	if (!p->is_aarch32) {
 		vcpu_sys_reg(vcpu, r->reg) = p->regval;
-- 
1.9.1
