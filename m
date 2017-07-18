From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 17/38] KVM: arm64: Trap EL1 VM register accesses in
 virtual EL2
Date: Tue, 18 Jul 2017 11:58:43 -0500
Message-ID: <1500397144-16232-18-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B210F40D29
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hfzjQQjVaZo5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:16 -0400 (EDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6F8C49C26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:15 -0400 (EDT)
Received: by mail-io0-f177.google.com with SMTP id z62so17070816ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:04 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
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
---
 arch/arm64/kvm/hyp/switch.c | 2 ++
 arch/arm64/kvm/sys_regs.c   | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c..ec91cd08 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -85,6 +85,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
+	if (vcpu_mode_el2(vcpu))
+		val |= HCR_TVM | HCR_TRVM;
 	write_sysreg(val, hcr_el2);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2b3ed70..d8b1d4b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -121,7 +121,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
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
