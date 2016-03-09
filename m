From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 47/95] arm64: KVM: VHE: Add alternative panic handling
Date: Wed,  9 Mar 2016 07:30:41 +0000
Message-ID: <1457508689-19672-48-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

