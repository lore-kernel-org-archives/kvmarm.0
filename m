From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] arm64: KVM: set right LR register value for 32 bit guest when inject abort
Date: Fri, 13 Oct 2017 00:44:51 +0800
Message-ID: <1507826691-11812-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, Haibin Zhang <zhanghaibin7@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

When a exception is trapped to EL2, hardware uses  ELR_ELx to hold
the current fault instruction address. If KVM wants to inject a
abort to 32 bit guest, it needs to set the LR register for the
guest to emulate this abort  happened in the guest. Because ARM32
architecture is Multi-pipeline, so the LR value has an offset to
the fault instruction address.

The offsets applied to Link value for exceptions as shown below,
which should be added for the ARM32 link register(LR).

Exception			Offset, for PE state of:
				A32 	  T32
Undefined Instruction 		+4 	  +2
Prefetch Abort 			+4 	  +4
Data Abort 			+8 	  +8
IRQ or FIQ 			+4 	  +4

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>

---
For example, to the undefined instruction injection:

1. Guest OS call SMC(Secure Monitor Call) instruction in the address
0xc025405c, then Guest traps to hypervisor

c0254050:   e59d5028    ldr r5, [sp, #40]   ; 0x28
c0254054:   e3a03001    mov r3, #1
c0254058:   e1a01003    mov r1, r3
c025405c:   e1600070    smc 0
c0254060:   e30a0270    movw    r0, #41584  ; 0xa270
c0254064:   e34c00bf    movt    r0, #49343  ; 0xc0bf

2. KVM  injects undefined abort to guest
3. We will find the fault PC is 0xc0254058, not 0xc025405c.

[   12.348072] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[   12.349786] Modules linked in:
[   12.350563] CPU: 1 PID: 71 Comm: cat Not tainted 4.1.0-dirty #25
[   12.352061] Hardware name: Generic DT based system
[   12.353275] task: d9d08000 ti: d9cfe000 task.ti: d9cfe000
[   12.354637] PC is at proc_dointvec+0x20/0x60
[   12.355717] LR is at proc_sys_call_handler+0xb0/0xc4
[   12.356972] pc : [<c0254058>]    lr : [<c035699c>]    psr: a0060013
[   12.356972] sp : d9cffe90  ip : c0254038  fp : 00000001
[   12.359824] r10: d9cfff80  r9 : 00000004  r8 : 00000000
[   12.361132] r7 : bec21cb0  r6 : d9cffec4  r5 : d9cfff80  r4 : c0e82de0
[   12.362766] r3 : 00000001  r2 : bec21cb0  r1 : 00000001  r0 : c0e82de0
[   12.364400] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   12.366183] Control: 10c5383d  Table: 59d3406a  DAC: 00000015
[   12.367623] Process cat (pid: 71, stack limit = 0xd9cfe220)

4. After correct the LR register, it will have right value

[  125.763370] Internal error: Oops - undefined instruction: 0 [#2] SMP ARM
[  125.767010] Modules linked in:
[  125.768472] CPU: 1 PID: 74 Comm: cat Tainted: G      D         4.1.0-dirty #25
[  125.771854] Hardware name: Generic DT based system
[  125.774053] task: db0bb900 ti: d9d10000 task.ti: d9d10000
[  125.776821] PC is at proc_dointvec+0x24/0x60
[  125.778919] LR is at proc_sys_call_handler+0xb0/0xc4
[  125.781269] pc : [<c025405c>]    lr : [<c035699c>]    psr: a0060013
[  125.781269] sp : d9d11e90  ip : c0254038  fp : 00000001
[  125.786581] r10: d9d11f80  r9 : 00000004  r8 : 00000000
[  125.789673] r7 : be92ccb0  r6 : d9d11ec4  r5 : d9d11f80  r4 : c0e82de0
[  125.792828] r3 : 00000001  r2 : be92ccb0  r1 : 00000001  r0 : c0e82de0
[  125.795890] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user

For other exception injection, such as Data/Prefetch abort, also needs to correct
---
 arch/arm64/kvm/inject_fault.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cf..da93508 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -33,12 +33,11 @@
 #define LOWER_EL_AArch64_VECTOR		0x400
 #define LOWER_EL_AArch32_VECTOR		0x600
 
-static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
+static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset,
+				u32 return_offset)
 {
 	unsigned long cpsr;
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
-	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
-	u32 return_offset = (is_thumb) ? 4 : 0;
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
 	cpsr = mode | COMPAT_PSR_I_BIT;
@@ -65,7 +64,11 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 
 static void inject_undef32(struct kvm_vcpu *vcpu)
 {
-	prepare_fault32(vcpu, COMPAT_PSR_MODE_UND, 4);
+	unsigned long spsr_value = *vcpu_cpsr(vcpu);
+	bool is_thumb = (spsr_value & COMPAT_PSR_T_BIT);
+	u32 return_offset = (is_thumb) ? 2 : 4;
+
+	prepare_fault32(vcpu, COMPAT_PSR_MODE_UND, 4, return_offset);
 }
 
 /*
@@ -75,21 +78,24 @@ static void inject_undef32(struct kvm_vcpu *vcpu)
 static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 			 unsigned long addr)
 {
-	u32 vect_offset;
+	u32 vect_offset, return_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
 
 	if (is_pabt) {
 		vect_offset = 12;
+		return_offset = 4;
 		far = &vcpu_cp15(vcpu, c6_IFAR);
 		fsr = &vcpu_cp15(vcpu, c5_IFSR);
 	} else { /* !iabt */
 		vect_offset = 16;
+		return_offset = 8;
 		far = &vcpu_cp15(vcpu, c6_DFAR);
 		fsr = &vcpu_cp15(vcpu, c5_DFSR);
 	}
 
-	prepare_fault32(vcpu, COMPAT_PSR_MODE_ABT | COMPAT_PSR_A_BIT, vect_offset);
+	prepare_fault32(vcpu, COMPAT_PSR_MODE_ABT | COMPAT_PSR_A_BIT,
+		       vect_offset, return_offset);
 
 	*far = addr;
 
-- 
2.10.1
