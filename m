From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 45/95] arm64: KVM: VHE: Use unified sysreg accessors for timer
Date: Wed,  9 Mar 2016 07:30:39 +0000
Message-ID: <1457508689-19672-46-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E0B4998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8MhWOU6LPajE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C73B49B36
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:52 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Switch the timer code to the unified sysreg accessors.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/timer-sr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
index 1051e5d..f276d9e 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/timer-sr.c
@@ -31,12 +31,12 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	if (kvm->arch.timer.enabled) {
-		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);
-		timer->cntv_cval = read_sysreg(cntv_cval_el0);
+		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
+		timer->cntv_cval = read_sysreg_el0(cntv_cval);
 	}
 
 	/* Disable the virtual timer */
-	write_sysreg(0, cntv_ctl_el0);
+	write_sysreg_el0(0, cntv_ctl);
 
 	/* Allow physical timer/counter access for the host */
 	val = read_sysreg(cnthctl_el2);
@@ -64,8 +64,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 
 	if (kvm->arch.timer.enabled) {
 		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
-		write_sysreg(timer->cntv_cval, cntv_cval_el0);
+		write_sysreg_el0(timer->cntv_cval, cntv_cval);
 		isb();
-		write_sysreg(timer->cntv_ctl, cntv_ctl_el0);
+		write_sysreg_el0(timer->cntv_ctl, cntv_ctl);
 	}
 }
-- 
2.1.4
