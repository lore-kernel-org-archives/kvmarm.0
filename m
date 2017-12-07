From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 14/36] KVM: arm64: Remove noop calls to timer save/restore
 from VHE switch
Date: Thu,  7 Dec 2017 18:06:08 +0100
Message-ID: <20171207170630.592-15-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C49FB49DC9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XiZQQzAjNP2v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:48 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 625E049DC8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:48 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id 9so14261291wme.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:04 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c |  2 --
 virt/kvm/arm/hyp/timer-sr.c | 36 ++++++++++++++----------------------
 2 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index e783e2371b7c..09aafa0470f7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -358,7 +358,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_vm(vcpu->kvm);
 
 	__vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -377,7 +376,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index f24404b3c8df..752b37f9133c 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -29,32 +29,24 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
 
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
