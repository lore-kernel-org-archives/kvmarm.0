From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/8] arm/arm64: KVM: set right LR register value for 32 bit
 guest when inject abort
Date: Mon, 30 Oct 2017 03:55:57 +0100
Message-ID: <20171030025603.23550-3-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B143749D1A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AIwrhGUbv2eX for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:39 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFF9E49D13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:39 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id z3so13443769wme.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:11 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Dongjiu Geng <gengdongjiu@huawei.com>

When a exception is trapped to EL2, hardware uses  ELR_ELx to hold
the current fault instruction address. If KVM wants to inject a
abort to 32 bit guest, it needs to set the LR register for the
guest to emulate this abort happened in the guest. Because ARM32
architecture is pipelined execution, so the LR value has an offset to
the fault instruction address.

The offsets applied to Link value for exceptions as shown below,
which should be added for the ARM32 link register(LR).

Table taken from ARMv8 ARM DDI0487B-B, table G1-10:
Exception			Offset, for PE state of:
				A32 	  T32
Undefined Instruction 		+4 	  +2
Prefetch Abort 			+4 	  +4
Data Abort 			+8 	  +8
IRQ or FIQ 			+4 	  +4

  [ Removed unused variables in inject_abt to avoid compile warnings.
    -- Christoffer ]

Cc: <stable@vger.kernel.org>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Tested-by: Haibin Zhang <zhanghaibin7@huawei.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/emulate.c        |  6 ++----
 arch/arm64/kvm/inject_fault.c | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 0064b86a2c87..30a13647c54c 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -227,7 +227,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 	u32 return_offset = (is_thumb) ? 2 : 4;
 
 	kvm_update_psr(vcpu, UND_MODE);
-	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) - return_offset;
+	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */
 	*vcpu_pc(vcpu) = exc_vector_base(vcpu) + vect_offset;
@@ -239,10 +239,8 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
  */
 static void inject_abt(struct kvm_vcpu *vcpu, bool is_pabt, unsigned long addr)
 {
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
-	bool is_thumb = (cpsr & PSR_T_BIT);
 	u32 vect_offset;
-	u32 return_offset = (is_thumb) ? 4 : 0;
+	u32 return_offset = (is_pabt) ? 4 : 8;
 	bool is_lpae;
 
 	kvm_update_psr(vcpu, ABT_MODE);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cfa54a0..3556715a774e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -33,12 +33,26 @@
 #define LOWER_EL_AArch64_VECTOR		0x400
 #define LOWER_EL_AArch32_VECTOR		0x600
 
+/*
+ * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
+ */
+static const u8 return_offsets[8][2] = {
+	[0] = { 0, 0 },		/* Reset, unused */
+	[1] = { 4, 2 },		/* Undefined */
+	[2] = { 0, 0 },		/* SVC, unused */
+	[3] = { 4, 4 },		/* Prefetch abort */
+	[4] = { 8, 8 },		/* Data abort */
+	[5] = { 0, 0 },		/* HVC, unused */
+	[6] = { 4, 4 },		/* IRQ, unused */
+	[7] = { 4, 4 },		/* FIQ, unused */
+};
+
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
 	unsigned long cpsr;
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
 	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
-	u32 return_offset = (is_thumb) ? 4 : 0;
+	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
 	cpsr = mode | COMPAT_PSR_I_BIT;
-- 
2.14.2
