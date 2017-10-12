From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 23/37] KVM: arm64: Prepare to handle traps on deferred VM
 sysregs
Date: Thu, 12 Oct 2017 12:41:27 +0200
Message-ID: <20171012104141.26902-24-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9EFC49D96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9amGLccfecF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:30 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2107449D9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:30 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id b189so11865774wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:14 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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

When we defer the save/restore of system registers to vcpu_load and
vcpu_put, we need to take care of the emulation code that handles traps
to these registers, since simply reading the memory array will return
stale data.

Therefore, introduce two functions to directly read/write the registers
from the physical CPU when we're on a VHE system that has loaded the
system registers onto the physical CPU.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++
 arch/arm64/kvm/sys_regs.c         | 54 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9f5761f..dcded44 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -278,6 +278,10 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* True when deferrable sysregs are loaded on the physical CPU,
+	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
+	bool sysregs_loaded_on_cpu;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dbe35fd..f7887dd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/perf_event.h>
 #include <asm/sysreg.h>
@@ -110,8 +111,57 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u64 read_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		switch (reg) {
+		case SCTLR_EL1:		return read_sysreg_el1(sctlr);
+		case TTBR0_EL1:		return read_sysreg_el1(ttbr0);
+		case TTBR1_EL1:		return read_sysreg_el1(ttbr1);
+		case TCR_EL1:		return read_sysreg_el1(tcr);
+		case ESR_EL1:		return read_sysreg_el1(esr);
+		case FAR_EL1:		return read_sysreg_el1(far);
+		case AFSR0_EL1:		return read_sysreg_el1(afsr0);
+		case AFSR1_EL1:		return read_sysreg_el1(afsr1);
+		case MAIR_EL1:		return read_sysreg_el1(mair);
+		case AMAIR_EL1:		return read_sysreg_el1(amair);
+		case CONTEXTIDR_EL1:	return read_sysreg_el1(contextidr);
+		case DACR32_EL2:	return read_sysreg(dacr32_el2);
+		case IFSR32_EL2:	return read_sysreg(ifsr32_el2);
+		default:		BUG();
+		}
+	}
+
+	return vcpu_sys_reg(vcpu, reg);
+}
+
+static void write_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		switch (reg) {
+		case SCTLR_EL1:		write_sysreg_el1(val, sctlr);	return;
+		case TTBR0_EL1:		write_sysreg_el1(val, ttbr0);	return;
+		case TTBR1_EL1:		write_sysreg_el1(val, ttbr1);	return;
+		case TCR_EL1:		write_sysreg_el1(val, tcr);	return;
+		case ESR_EL1:		write_sysreg_el1(val, esr);	return;
+		case FAR_EL1:		write_sysreg_el1(val, far);	return;
+		case AFSR0_EL1:		write_sysreg_el1(val, afsr0);	return;
+		case AFSR1_EL1:		write_sysreg_el1(val, afsr1);	return;
+		case MAIR_EL1:		write_sysreg_el1(val, mair);	return;
+		case AMAIR_EL1:		write_sysreg_el1(val, amair);	return;
+		case CONTEXTIDR_EL1:	write_sysreg_el1(val, contextidr); return;
+		case DACR32_EL2:	write_sysreg(val, dacr32_el2); return;
+		case IFSR32_EL2:	write_sysreg(val, ifsr32_el2); return;
+		default:		BUG();
+		}
+	}
+
+	vcpu_sys_reg(vcpu, reg) = val;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
+ *
  * is set. If the guest enables the MMU, we stop trapping the VM
  * sys_regs and leave it in complete control of the caches.
  */
@@ -132,14 +182,14 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (!p->is_aarch32 || !p->is_32bit) {
 		val = p->regval;
 	} else {
-		val = vcpu_sys_reg(vcpu, reg);
+		val = read_deferrable_vm_reg(vcpu, reg);
 		if (r->reg % 2)
 			val = (p->regval << 32) | (u64)lower_32_bits(val);
 		else
 			val = ((u64)upper_32_bits(val) << 32) |
 				(u64)lower_32_bits(p->regval);
 	}
-	vcpu_sys_reg(vcpu, reg) = val;
+	write_deferrable_vm_reg(vcpu, reg, val);
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
-- 
2.9.0
