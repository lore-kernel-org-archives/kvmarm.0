From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 17/41] KVM: arm64: Remove noop calls to timer save/restore
 from VHE switch
Date: Fri, 12 Jan 2018 13:07:23 +0100
Message-ID: <20180112120747.27999-18-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3766749DE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rNvG0YrdoHN3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:28 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3CEB49DE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:27 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id r78so11483759wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:18 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The VHE switch function calls __timer_enable_traps and
__timer_disable_traps which don't do anything on VHE systems.
Therefore, simply remove these calls from the VHE switch function and
make the functions non-conditional as they are now only called from the
non-VHE switch path.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c |  2 --
 virt/kvm/arm/hyp/timer-sr.c | 44 ++++++++++++++++++++++----------------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9aadef6966bf..6175fcb33ed2 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -354,7 +354,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_vm(vcpu->kvm);
 
 	__vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -373,7 +372,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index f24404b3c8df..77754a62eb0c 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -27,34 +27,34 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
+/*
+ * Should only be called on non-VHE systems.
+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
+ */
 void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * We don't need to do this for VHE since the host kernel runs in EL2
-	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
-	 */
-	if (!has_vhe()) {
-		u64 val;
+	u64 val;
 
-		/* Allow physical timer/counter access for the host */
-		val = read_sysreg(cnthctl_el2);
-		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-		write_sysreg(val, cnthctl_el2);
-	}
+	/* Allow physical timer/counter access for the host */
+	val = read_sysreg(cnthctl_el2);
+	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	write_sysreg(val, cnthctl_el2);
 }
 
+/*
+ * Should only be called on non-VHE systems.
+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
+ */
 void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
-	if (!has_vhe()) {
-		u64 val;
+	u64 val;
 
-		/*
-		 * Disallow physical timer access for the guest
-		 * Physical counter access is allowed
-		 */
-		val = read_sysreg(cnthctl_el2);
-		val &= ~CNTHCTL_EL1PCEN;
-		val |= CNTHCTL_EL1PCTEN;
-		write_sysreg(val, cnthctl_el2);
-	}
+	/*
+	 * Disallow physical timer access for the guest
+	 * Physical counter access is allowed
+	 */
+	val = read_sysreg(cnthctl_el2);
+	val &= ~CNTHCTL_EL1PCEN;
+	val |= CNTHCTL_EL1PCTEN;
+	write_sysreg(val, cnthctl_el2);
 }
-- 
2.14.2
