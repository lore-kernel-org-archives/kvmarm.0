From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 21/36] KVM: arm64: Change 32-bit handling of VM system
 registers
Date: Thu,  7 Dec 2017 18:06:15 +0100
Message-ID: <20171207170630.592-22-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27AB349DBE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tkbH4YUp5A9d for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:59 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33A7E49DD5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:59 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id t8so14269800wmc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:15 -0800 (PST)
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

We currently handle 32-bit accesses to trapped VM system registers using
the 32-bit index into the coproc array on the vcpu structure, which is a
union of the coproc array and the sysreg array.

Since all the 32-bit coproc indicies are created to correspond to the
architectural mapping between 64-bit system registers and 32-bit
coprocessor registers, and because the AArch64 system registers are the
double in size of the AArch32 coprocessor registers, we can always find
the system register entry that we must update by dividing the 32-bit
coproc index by 2.

This is going to make our lives much easier when we have to start
accessing system registers that use deferred save/restore and might
have to be read directly from the physical CPU.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 --------
 arch/arm64/kvm/sys_regs.c         | 20 +++++++++++++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c841eeeeb5c5..de0d55b30b61 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -290,14 +290,6 @@ struct kvm_vcpu_arch {
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
index 1830ebc227d1..62c12ab9e6c4 100644
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
+				(u64)lower_32_bits(p->regval);
 	}
+	vcpu_sys_reg(vcpu, reg) = val;
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
-- 
2.14.2
