From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 04/41] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Fri, 12 Jan 2018 13:07:10 +0100
Message-ID: <20180112120747.27999-5-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB7B49DA2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwhrMjsM8G6B for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:07 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53EE949DB4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:07 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id t8so11608508wmc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:07:57 -0800 (PST)
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

VHE actually doesn't rely on clearing the VTTBR when returning to the
host kernel, and that is the current key mechanism of hyp_panic to
figure out how to attempt to return to a state good enough to print a
panic statement.

Therefore, we split the hyp_panic function into two functions, a VHE and
a non-VHE, keeping the non-VHE version intact, but changing the VHE
behavior.

The vttbr_el2 check on VHE doesn't really make that much sense, because
the only situation where we can get here on VHE is when the hypervisor
assembly code actually called into hyp_panic, which only happens when
VBAR_EL2 has been set to the KVM exception vectors.  On VHE, we can
always safely disable the traps and restore the host registers at this
point, so we simply do that unconditionally and call into the panic
function directly.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 6fcb37e220b5..71700ecee308 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -419,10 +419,20 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
 static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
-					     struct kvm_vcpu *vcpu)
+					     struct kvm_cpu_context *__host_ctxt)
 {
+	struct kvm_vcpu *vcpu;
 	unsigned long str_va;
 
+	vcpu = __host_ctxt->__hyp_running_vcpu;
+
+	if (read_sysreg(vttbr_el2)) {
+		__timer_disable_traps(vcpu);
+		__deactivate_traps(vcpu);
+		__deactivate_vm(vcpu);
+		__sysreg_restore_host_state(__host_ctxt);
+	}
+
 	/*
 	 * Force the panic string to be loaded from the literal pool,
 	 * making sure it is a kernel address and not a PC-relative
@@ -436,37 +446,31 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		       read_sysreg(hpfar_el2), par, vcpu);
 }
 
-static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
-					    struct kvm_vcpu *vcpu)
+static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
+				 struct kvm_cpu_context *host_ctxt)
 {
+	struct kvm_vcpu *vcpu;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
+	__deactivate_traps(vcpu);
+	__sysreg_restore_host_state(host_ctxt);
+
 	panic(__hyp_panic_string,
 	      spsr,  elr,
 	      read_sysreg_el2(esr),   read_sysreg_el2(far),
 	      read_sysreg(hpfar_el2), par, vcpu);
 }
 
-static hyp_alternate_select(__hyp_call_panic,
-			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 {
-	struct kvm_vcpu *vcpu = NULL;
-
 	u64 spsr = read_sysreg_el2(spsr);
 	u64 elr = read_sysreg_el2(elr);
 	u64 par = read_sysreg(par_el1);
 
-	if (read_sysreg(vttbr_el2)) {
-		vcpu = host_ctxt->__hyp_running_vcpu;
-		__timer_disable_traps(vcpu);
-		__deactivate_traps(vcpu);
-		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state(host_ctxt);
-	}
-
-	/* Call panic for real */
-	__hyp_call_panic()(spsr, elr, par, vcpu);
+	if (!has_vhe())
+		__hyp_call_panic_nvhe(spsr, elr, par, host_ctxt);
+	else
+		__hyp_call_panic_vhe(spsr, elr, par, host_ctxt);
 
 	unreachable();
 }
-- 
2.14.2
