From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 23/40] KVM: arm64: Change 32-bit handling of VM system registers
Date: Thu, 15 Feb 2018 22:03:15 +0100
Message-ID: <20180215210332.8648-24-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently handle 32-bit accesses to trapped VM system registers using
the 32-bit index into the coproc array on the vcpu structure, which is a
union of the coproc array and the sysreg array.

Since all the 32-bit coproc indices are created to correspond to the
architectural mapping between 64-bit system registers and 32-bit
coprocessor registers, and because the AArch64 system registers are the
double in size of the AArch32 coprocessor registers, we can always find
the system register entry that we must update by dividing the 32-bit
coproc index by 2.

This is going to make our lives much easier when we have to start
accessing system registers that use deferred save/restore and might
have to be read directly from the physical CPU.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 --------
 arch/arm64/kvm/sys_regs.c         | 20 +++++++++++++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c30fc96992df..f2a6f39aec87 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -295,14 +295,6 @@ struct kvm_vcpu_arch {
 #define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
 #define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
 
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r))
-#define vcpu_cp15_64_low(v,r)	vcpu_cp15((v),(r) + 1)
-#else
-#define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r) + 1)
-#define vcpu_cp15_64_low(v,r)	vcpu_cp15((v),(r))
-#endif
-
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50a43c7b97ca..b48af790615e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -121,16 +121,26 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
+	u64 val;
+	int reg = r->reg;
 
 	BUG_ON(!p->is_write);
 
-	if (!p->is_aarch32) {
-		vcpu_sys_reg(vcpu, r->reg) = p->regval;
+	/* See the 32bit mapping in kvm_host.h */
+	if (p->is_aarch32)
+		reg = r->reg / 2;
+
+	if (!p->is_aarch32 || !p->is_32bit) {
+		val = p->regval;
 	} else {
-		if (!p->is_32bit)
-			vcpu_cp15_64_high(vcpu, r->reg) = upper_32_bits(p->regval);
-		vcpu_cp15_64_low(vcpu, r->reg) = lower_32_bits(p->regval);
+		val = vcpu_sys_reg(vcpu, reg);
+		if (r->reg % 2)
+			val = (p->regval << 32) | (u64)lower_32_bits(val);
+		else
+			val = ((u64)upper_32_bits(val) << 32) |
+				lower_32_bits(p->regval);
 	}
+	vcpu_sys_reg(vcpu, reg) = val;
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
-- 
2.14.2
