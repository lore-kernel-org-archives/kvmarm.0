From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: set right LR register value for 32 bit guest
 when inject abort
Date: Fri, 13 Oct 2017 16:12:44 +0100
Message-ID: <b2bac33a-329e-05e6-b31b-ffd8abaed512@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F20168D7DA@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 426A049D39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 11:12:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8X5Tu3IYQIT7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 11:12:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D4549D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 11:12:01 -0400 (EDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F20168D7DA@DGGEMA503-MBS.china.huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Huangshaoyu <huangshaoyu@huawei.com>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/10/17 15:29, gengdongjiu wrote:
> Hi Marc,
>     Thank you very much for your time to review it.
> 
>> On 12/10/17 17:44, Dongjiu Geng wrote:
>>> When a exception is trapped to EL2, hardware uses  ELR_ELx to hold the
>>> current fault instruction address. If KVM wants to inject a abort to
>>> 32 bit guest, it needs to set the LR register for the guest to emulate
>>> this abort  happened in the guest. Because ARM32 architecture is
>>> Multi-pipeline, so the LR value has an offset to
>>
>> What does "Multi-pipeline" mean?
> 
> I mean the ARM's single-cycle instruction 3-stage pipeline operation, as shown below:
> 
> fetch   decode   execute
>         fetch    decode   execute
>                  fetch    decode   execute
> 
> when CPU finish instructions fetch,  PC=PC + 4
> when CPU finish instructions decode, PC=PC + 8
> when CPU finish instructions execution, PC=PC+12

Yeah, and that's called pipelined execution. "Multi-pipeline" doesn't 
mean anything. Also, that's an artefact of the original ARM1 
implementation, and not how modern CPUs work anymore.

> 
> that is to say, when happen data abort, 
> the PC = fault instruction address + 12, LR_abt = fault instruction address + 8
> 
> In order to emulate this abort for KVM, LR_abt needs to add an offset 8 when inject data abort. 
> 
>>
>>> the fault instruction address.
>>>
>>> The offsets applied to Link value for exceptions as shown below, which
>>> should be added for the ARM32 link register(LR).
>>>
>>> Exception			Offset, for PE state of:
>>> 				A32 	  T32
>>> Undefined Instruction 		+4 	  +2
>>> Prefetch Abort 			+4 	  +4
>>> Data Abort 			+8 	  +8
>>> IRQ or FIQ 			+4 	  +4
>>
>> Please document where this table is coming from.
> 
> 
> Thanks for pointing out. Will add it.
> It come from:  DDI0487A_k_armv8_arm_iss10775, "G1.12.3 Overview of exception entry", Table G1-10 Offsets applied to Link value for exceptions taken to non-EL2 modes
> 
>>
>>>
>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>> Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>
>>>
>>> ---
>>> For example, to the undefined instruction injection:
>>>
>>> 1. Guest OS call SMC(Secure Monitor Call) instruction in the address
>>> 0xc025405c, then Guest traps to hypervisor
>>>
>>> c0254050:   e59d5028    ldr r5, [sp, #40]   ; 0x28
>>> c0254054:   e3a03001    mov r3, #1
>>> c0254058:   e1a01003    mov r1, r3
>>> c025405c:   e1600070    smc 0
>>> c0254060:   e30a0270    movw    r0, #41584  ; 0xa270
>>> c0254064:   e34c00bf    movt    r0, #49343  ; 0xc0bf
>>>
>>> 2. KVM  injects undefined abort to guest 3. We will find the fault PC
>>> is 0xc0254058, not 0xc025405c.
>>>
>>> [   12.348072] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
>>> [   12.349786] Modules linked in:
>>> [   12.350563] CPU: 1 PID: 71 Comm: cat Not tainted 4.1.0-dirty #25
>>> [   12.352061] Hardware name: Generic DT based system
>>> [   12.353275] task: d9d08000 ti: d9cfe000 task.ti: d9cfe000
>>> [   12.354637] PC is at proc_dointvec+0x20/0x60
>>> [   12.355717] LR is at proc_sys_call_handler+0xb0/0xc4
>>> [   12.356972] pc : [<c0254058>]    lr : [<c035699c>]    psr: a0060013
>>> [   12.356972] sp : d9cffe90  ip : c0254038  fp : 00000001
>>> [   12.359824] r10: d9cfff80  r9 : 00000004  r8 : 00000000
>>> [   12.361132] r7 : bec21cb0  r6 : d9cffec4  r5 : d9cfff80  r4 : c0e82de0
>>> [   12.362766] r3 : 00000001  r2 : bec21cb0  r1 : 00000001  r0 : c0e82de0
>>> [   12.364400] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>>> [   12.366183] Control: 10c5383d  Table: 59d3406a  DAC: 00000015
>>> [   12.367623] Process cat (pid: 71, stack limit = 0xd9cfe220)
>>>
>>> 4. After correct the LR register, it will have right value
>>>
>>> [  125.763370] Internal error: Oops - undefined instruction: 0 [#2]
>>> SMP ARM [  125.767010] Modules linked in:
>>> [  125.768472] CPU: 1 PID: 74 Comm: cat Tainted: G      D         4.1.0-dirty #25
>>> [  125.771854] Hardware name: Generic DT based system [  125.774053]
>>> task: db0bb900 ti: d9d10000 task.ti: d9d10000 [  125.776821] PC is at
>>> proc_dointvec+0x24/0x60 [  125.778919] LR is at
>>> proc_sys_call_handler+0xb0/0xc4
>>> [  125.781269] pc : [<c025405c>]    lr : [<c035699c>]    psr: a0060013
>>> [  125.781269] sp : d9d11e90  ip : c0254038  fp : 00000001 [
>>> 125.786581] r10: d9d11f80  r9 : 00000004  r8 : 00000000 [  125.789673]
>>> r7 : be92ccb0  r6 : d9d11ec4  r5 : d9d11f80  r4 : c0e82de0 [
>>> 125.792828] r3 : 00000001  r2 : be92ccb0  r1 : 00000001  r0 : c0e82de0
>>> [  125.795890] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
>>> Segment user
>>>
>>> For other exception injection, such as Data/Prefetch abort, also needs
>>> to correct
>>> ---
>>>  arch/arm64/kvm/inject_fault.c | 18 ++++++++++++------
>>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/inject_fault.c
>>> b/arch/arm64/kvm/inject_fault.c index da6a8cf..da93508 100644
>>> --- a/arch/arm64/kvm/inject_fault.c
>>> +++ b/arch/arm64/kvm/inject_fault.c
>>> @@ -33,12 +33,11 @@
>>>  #define LOWER_EL_AArch64_VECTOR		0x400
>>>  #define LOWER_EL_AArch32_VECTOR		0x600
>>>
>>> -static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32
>>> vect_offset)
>>> +static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset,
>>> +				u32 return_offset)
>>>  {
>>>  	unsigned long cpsr;
>>>  	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
>>> -	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
>>> -	u32 return_offset = (is_thumb) ? 4 : 0;
>>>  	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
>>>
>>>  	cpsr = mode | COMPAT_PSR_I_BIT;
>>> @@ -65,7 +64,11 @@ static void prepare_fault32(struct kvm_vcpu *vcpu,
>>> u32 mode, u32 vect_offset)
>>>
>>>  static void inject_undef32(struct kvm_vcpu *vcpu)  {
>>> -	prepare_fault32(vcpu, COMPAT_PSR_MODE_UND, 4);
>>> +	unsigned long spsr_value = *vcpu_cpsr(vcpu);
>>> +	bool is_thumb = (spsr_value & COMPAT_PSR_T_BIT);
>>> +	u32 return_offset = (is_thumb) ? 2 : 4;
>>> +
>>> +	prepare_fault32(vcpu, COMPAT_PSR_MODE_UND, 4, return_offset);
>>>  }
>>>
>>>  /*
>>> @@ -75,21 +78,24 @@ static void inject_undef32(struct kvm_vcpu *vcpu)
>>> static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>>>  			 unsigned long addr)
>>>  {
>>> -	u32 vect_offset;
>>> +	u32 vect_offset, return_offset;
>>>  	u32 *far, *fsr;
>>>  	bool is_lpae;
>>>
>>>  	if (is_pabt) {
>>>  		vect_offset = 12;
>>> +		return_offset = 4;
>>>  		far = &vcpu_cp15(vcpu, c6_IFAR);
>>>  		fsr = &vcpu_cp15(vcpu, c5_IFSR);
>>>  	} else { /* !iabt */
>>>  		vect_offset = 16;
>>> +		return_offset = 8;
>>>  		far = &vcpu_cp15(vcpu, c6_DFAR);
>>>  		fsr = &vcpu_cp15(vcpu, c5_DFSR);
>>>  	}
>>>
>>> -	prepare_fault32(vcpu, COMPAT_PSR_MODE_ABT | COMPAT_PSR_A_BIT, vect_offset);
>>> +	prepare_fault32(vcpu, COMPAT_PSR_MODE_ABT | COMPAT_PSR_A_BIT,
>>> +		       vect_offset, return_offset);
>>>
>>>  	*far = addr;
>>>
>>>
>>
>> So instead of adding this extra parameter and littering the code with random constants, why don't you actually implement the table you've
>> put in the commit log and compute the offset in a single place (which is likely to be prepare_fault32)?
> 
> Marc,
>   It because multiple abort(Undefined Abort/Prefetch Abort/Data Abort) call the prepare_fault32(), if adding to a single place in prepare_fault32(),prepare_fault32() will 
> not know whether the Abort injection is for Prefetch Abort or Data Abort or Undefined Abort, then will be confused for the value of "return_offset"
> 
> For example:
> inject_abt32() is used to inject prefetch Abort or Data Abort, it passes same parameters to call prepare_fault32() for the two Abort. If adding and computing the offset in a prepare_fault32(),
> it will be confused to compute the offset, because it does not know whether this function call is for prefetch Abort or Data Abort. [1]
> 
> If computing the offset in a single place, do you have better idea for that?

Yes. Realise that vect_offset uniquely identify the type of fault we're 
trying to inject:

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cfa54a0..0416f1857c68 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -33,12 +33,26 @@
 #define LOWER_EL_AArch64_VECTOR		0x400
 #define LOWER_EL_AArch32_VECTOR		0x600
 
+/*
+ * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
+ */
+static u8 return_offsets[8][2] = {
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

Please also update the 32bit code accordingly, as it looks broken too.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
