From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 33/38] KVM: arm64: Emulate appropriate VM control
 system registers
Date: Tue, 18 Jul 2017 11:58:59 -0500
Message-ID: <1500397144-16232-34-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4710049C01
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G-YfiVZIlVK8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:46 -0400 (EDT)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com
 [209.85.214.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B15340CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:46 -0400 (EDT)
Received: by mail-it0-f51.google.com with SMTP id v205so2303665itf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:35 -0700 (PDT)
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

Now that the virtual EL2 can access EL2 register states via EL1
registers, we need to consider it when selecting the register to
emulate.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 79980be..910b50d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -110,6 +110,31 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+struct el1_el2_map {
+	int	el1;
+	int	el2;
+};
+
+static const struct el1_el2_map vm_map[] = {
+	{SCTLR_EL1, SCTLR_EL2},
+	{TTBR0_EL1, TTBR0_EL2},
+	{TTBR1_EL1, TTBR1_EL2},
+	{TCR_EL1, TCR_EL2},
+	{ESR_EL1, ESR_EL2},
+	{FAR_EL1, FAR_EL2},
+	{AFSR0_EL1, AFSR0_EL2},
+	{AFSR1_EL1, AFSR1_EL2},
+	{MAIR_EL1, MAIR_EL2},
+	{AMAIR_EL1, AMAIR_EL2},
+	{CONTEXTIDR_EL1, CONTEXTIDR_EL2},
+};
+
+static inline bool el12_reg(struct sys_reg_params *p)
+{
+	/* All *_EL12 registers have Op1=5. */
+	return (p->Op1 == 5);
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
@@ -120,16 +145,33 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
+	u64 *sysreg = &vcpu_sys_reg(vcpu, r->reg);
+	int i;
+	const struct el1_el2_map *map;
+
+	/*
+	 * Redirect EL1 register accesses to the corresponding EL2 registers if
+	 * they are meant to access EL2 registers.
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && !el12_reg(p)) {
+		for (i = 0; i < ARRAY_SIZE(vm_map); i++) {
+			map = &vm_map[i];
+			if (map->el1 == r->reg) {
+				sysreg = &vcpu_sys_reg(vcpu, map->el2);
+				break;
+			}
+		}
+	}
 
 	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
 
 	if (!p->is_write) {
-		p->regval = vcpu_sys_reg(vcpu, r->reg);
+		p->regval = *sysreg;
 		return true;
 	}
 
 	if (!p->is_aarch32) {
-		vcpu_sys_reg(vcpu, r->reg) = p->regval;
+		*sysreg = p->regval;
 	} else {
 		if (!p->is_32bit)
 			vcpu_cp15_64_high(vcpu, r->reg) = upper_32_bits(p->regval);
-- 
1.9.1
