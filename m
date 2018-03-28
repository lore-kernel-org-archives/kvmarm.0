From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 36/85] KVM: arm64: Change 32-bit handling of VM system
 registers
Date: Wed, 28 Mar 2018 13:52:05 +0100
Message-ID: <20180328125254.31380-37-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F244A0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2GzHWadskjP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:50:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDAF14A007
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:24 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  8 --------
 arch/arm64/kvm/sys_regs.c         | 20 +++++++++++++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 87abc94fb591..9001fd0890c9 100644
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
index 6feb4a2215cb..691f81c31018 100644
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
