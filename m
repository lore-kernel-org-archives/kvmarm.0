From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 18/23] arm64: KVM: VHE: Add alternative panic handling
Date: Thu, 11 Feb 2016 18:39:59 +0000
Message-ID: <1455216004-19499-19-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C1A49AD4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zizwh0Ej1JaO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DEA49C02
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:42 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As the kernel fully runs in HYP when VHE is enabled, we can
directly branch to the kernel's panic() implementation, and
not perform an exception return.

Add the alternative code to deal with this.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index e609942..731f0a2 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -210,11 +210,34 @@ __alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
-void __hyp_text __noreturn __hyp_panic(void)
+static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
 {
 	unsigned long str_va = (unsigned long)__hyp_panic_string;
-	u64 spsr = read_sysreg(spsr_el2);
-	u64 elr = read_sysreg(elr_el2);
+
+	__hyp_do_panic(hyp_kern_va(str_va),
+		       spsr,  elr,
+		       read_sysreg(esr_el2),   read_sysreg_el2(far),
+		       read_sysreg(hpfar_el2), par,
+		       (void *)read_sysreg(tpidr_el2));
+}
+
+static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par)
+{
+	panic(__hyp_panic_string,
+	      spsr,  elr,
+	      read_sysreg_el2(esr),   read_sysreg_el2(far),
+	      read_sysreg(hpfar_el2), par,
+	      (void *)read_sysreg(tpidr_el2));
+}
+
+static hyp_alternate_select(__hyp_call_panic,
+			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+void __hyp_text __noreturn __hyp_panic(void)
+{
+	u64 spsr = read_sysreg_el2(spsr);
+	u64 elr = read_sysreg_el2(elr);
 	u64 par = read_sysreg(par_el1);
 
 	if (read_sysreg(vttbr_el2)) {
@@ -229,11 +252,7 @@ void __hyp_text __noreturn __hyp_panic(void)
 	}
 
 	/* Call panic for real */
-	__hyp_do_panic(hyp_kern_va(str_va),
-		       spsr,  elr,
-		       read_sysreg(esr_el2),   read_sysreg(far_el2),
-		       read_sysreg(hpfar_el2), par,
-		       (void *)read_sysreg(tpidr_el2));
+	__hyp_call_panic()(spsr, elr, par);
 
 	unreachable();
 }
-- 
2.1.4
