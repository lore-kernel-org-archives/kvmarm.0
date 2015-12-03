From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 1/3] KVM: arm64: Correctly handle zero register during MMIO
Date: Thu, 03 Dec 2015 12:58:40 +0300
Message-ID: <fa20bcbefc504924aca104cc1c851bd6058ce260.1449136209.git.p.fedin@samsung.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8F349973
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 04:57:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jJSWUtORWLbD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 04:57:17 -0500 (EST)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE79949988
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 04:57:17 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYS009JM11ZKZ00@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 09:58:47 +0000 (GMT)
In-reply-to: <cover.1449136209.git.p.fedin@samsung.com>
In-reply-to: <cover.1449136209.git.p.fedin@samsung.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On ARM64 register index of 31 corresponds to both zero register and SP.
However, all memory access instructions, use ZR as transfer register. SP
is used only as a base register in indirect memory addressing, or by
register-register arithmetics, which cannot be trapped here.

Correct emulation is achieved by introducing new register accessor
functions, which can do special handling for reg_num == 31. These new
accessors intentionally do not rely on old vcpu_reg() on ARM64, because
it is to be removed. Since the affected code is shared by both ARM
flavours, implementations of these accessors are also added to ARM32 code.

This patch fixes setting MMIO register to a random value (actually SP)
instead of zero by something like:

 *((volatile int *)reg) = 0;

compilers tend to generate "str wzr, [xx]" here

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++++
 arch/arm/kvm/mmio.c                  |  5 +++--
 arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index a9c80a2..b7ff32e 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -28,6 +28,18 @@
 unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
 
+static inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
+					 u8 reg_num)
+{
+	return *vcpu_reg(vcpu, reg_num);
+}
+
+static inline void vcpu_set_reg(const struct kvm_vcpu *vcpu, u8 reg_num,
+				unsigned long val)
+{
+	*vcpu_reg(vcpu, reg_num) = val;
+}
+
 bool kvm_condition_valid(struct kvm_vcpu *vcpu);
 void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 974b1c6..3a10c9f 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -115,7 +115,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		*vcpu_reg(vcpu, vcpu->arch.mmio_decode.rt) = data;
+		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
 	}
 
 	return 0;
@@ -186,7 +186,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	rt = vcpu->arch.mmio_decode.rt;
 
 	if (is_write) {
-		data = vcpu_data_guest_to_host(vcpu, *vcpu_reg(vcpu, rt), len);
+		data = vcpu_data_guest_to_host(vcpu, vcpu_get_reg(vcpu, rt),
+					       len);
 
 		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, fault_ipa, data);
 		mmio_write_buf(data_buf, len, data);
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3ca894e..5a182af 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -109,6 +109,19 @@ static inline unsigned long *vcpu_reg(const struct kvm_vcpu *vcpu, u8 reg_num)
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.regs[reg_num];
 }
 
+static inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
+					 u8 reg_num)
+{
+	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs.regs[reg_num];
+}
+
+static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
+				unsigned long val)
+{
+	if (reg_num != 31)
+		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
+}
+
 /* Get vcpu SPSR for current mode */
 static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
 {
-- 
2.4.4
