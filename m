From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH RESEND v2] arm/arm64: KVM: set right LR register value
 for 32 bit guest when inject abort
Date: Wed, 18 Oct 2017 13:39:32 +0200
Message-ID: <20171018113932.GB8900@cbox>
References: <1508250229-17895-1-git-send-email-gengdongjiu@huawei.com>
 <76baaa48-2a38-6deb-f11f-53361e3d7936@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D3D40A74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 07:38:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EPYn+7DDnG9k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 07:38:30 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3516405F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 07:38:29 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id u138so9450007wmu.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 04:39:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <76baaa48-2a38-6deb-f11f-53361e3d7936@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, zhanghaibin7@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 11:19:30AM +0100, Marc Zyngier wrote:
> On 17/10/17 15:23, Dongjiu Geng wrote:
> > When a exception is trapped to EL2, hardware uses  ELR_ELx to hold
> > the current fault instruction address. If KVM wants to inject a
> > abort to 32 bit guest, it needs to set the LR register for the
> > guest to emulate this abort happened in the guest. Because ARM32
> > architecture is pipelined execution, so the LR value has an offset to
> > the fault instruction address.
> > 
> > The offsets applied to Link value for exceptions as shown below,
> > which should be added for the ARM32 link register(LR).
> > 
> > Table taken from ARMv8 ARM DDI0487B-B, table G1-10:
> > Exception			Offset, for PE state of:
> > 				A32 	  T32
> > Undefined Instruction 		+4 	  +2
> > Prefetch Abort 			+4 	  +4
> > Data Abort 			+8 	  +8
> > IRQ or FIQ 			+4 	  +4
> > 
> > Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> > Tested-by: Haibin Zhang <zhanghaibin7@huawei.com>
> 
> Cc: stable@vger.kernel.org
> 
> > 
> > ---
> > Have tested in both arm32 and arm64
> > 
> > For example, in the arm64 platform, to the undefined instruction injection:
> > 
> > 1. Guest OS call SMC(Secure Monitor Call) instruction in the address
> > 0xc025405c, then Guest traps to hypervisor
> > 
> > c0254050:   e59d5028    ldr r5, [sp, #40]   ; 0x28
> > c0254054:   e3a03001    mov r3, #1
> > c0254058:   e1a01003    mov r1, r3
> > c025405c:   e1600070    smc 0
> > c0254060:   e30a0270    movw    r0, #41584  ; 0xa270
> > c0254064:   e34c00bf    movt    r0, #49343  ; 0xc0bf
> > 
> > 2. KVM  injects undefined abort to guest
> > 3. We will find the fault PC is 0xc0254058, not 0xc025405c.
> > 
> > [   12.348072] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
> > [   12.349786] Modules linked in:
> > [   12.350563] CPU: 1 PID: 71 Comm: cat Not tainted 4.1.0-dirty #25
> > [   12.352061] Hardware name: Generic DT based system
> > [   12.353275] task: d9d08000 ti: d9cfe000 task.ti: d9cfe000
> > [   12.354637] PC is at proc_dointvec+0x20/0x60
> > [   12.355717] LR is at proc_sys_call_handler+0xb0/0xc4
> > [   12.356972] pc : [<c0254058>]    lr : [<c035699c>]    psr: a0060013
> > [   12.356972] sp : d9cffe90  ip : c0254038  fp : 00000001
> > [   12.359824] r10: d9cfff80  r9 : 00000004  r8 : 00000000
> > [   12.361132] r7 : bec21cb0  r6 : d9cffec4  r5 : d9cfff80  r4 : c0e82de0
> > [   12.362766] r3 : 00000001  r2 : bec21cb0  r1 : 00000001  r0 : c0e82de0
> > [   12.364400] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> > [   12.366183] Control: 10c5383d  Table: 59d3406a  DAC: 00000015
> > [   12.367623] Process cat (pid: 71, stack limit = 0xd9cfe220)
> > 
> > 4. After correct the LR register, it will have right value
> > 
> > [  125.763370] Internal error: Oops - undefined instruction: 0 [#2] SMP ARM
> > [  125.767010] Modules linked in:
> > [  125.768472] CPU: 1 PID: 74 Comm: cat Tainted: G      D         4.1.0-dirty #25
> > [  125.771854] Hardware name: Generic DT based system
> > [  125.774053] task: db0bb900 ti: d9d10000 task.ti: d9d10000
> > [  125.776821] PC is at proc_dointvec+0x24/0x60
> > [  125.778919] LR is at proc_sys_call_handler+0xb0/0xc4
> > [  125.781269] pc : [<c025405c>]    lr : [<c035699c>]    psr: a0060013
> > [  125.781269] sp : d9d11e90  ip : c0254038  fp : 00000001
> > [  125.786581] r10: d9d11f80  r9 : 00000004  r8 : 00000000
> > [  125.789673] r7 : be92ccb0  r6 : d9d11ec4  r5 : d9d11f80  r4 : c0e82de0
> > [  125.792828] r3 : 00000001  r2 : be92ccb0  r1 : 00000001  r0 : c0e82de0
> > [  125.795890] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> > 
> > For other exception injection, such as Data/Prefetch abort, also needs to correct
> > ---
> >  arch/arm/kvm/emulate.c        |  4 ++--
> >  arch/arm64/kvm/inject_fault.c | 16 +++++++++++++++-
> >  2 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
> > index 0064b86..2419328 100644
> > --- a/arch/arm/kvm/emulate.c
> > +++ b/arch/arm/kvm/emulate.c
> > @@ -227,7 +227,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
> >  	u32 return_offset = (is_thumb) ? 2 : 4;
> >  
> >  	kvm_update_psr(vcpu, UND_MODE);
> > -	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) - return_offset;
> > +	*vcpu_reg(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
> >  
> >  	/* Branch to exception vector */
> >  	*vcpu_pc(vcpu) = exc_vector_base(vcpu) + vect_offset;
> > @@ -242,7 +242,7 @@ static void inject_abt(struct kvm_vcpu *vcpu, bool is_pabt, unsigned long addr)
> >  	unsigned long cpsr = *vcpu_cpsr(vcpu);
> >  	bool is_thumb = (cpsr & PSR_T_BIT);
> >  	u32 vect_offset;
> > -	u32 return_offset = (is_thumb) ? 4 : 0;
> > +	u32 return_offset = (is_pabt) ? 4 : 8;
> >  	bool is_lpae;
> >  
> >  	kvm_update_psr(vcpu, ABT_MODE);
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > index da6a8cf..0416f18 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -33,12 +33,26 @@
> >  #define LOWER_EL_AArch64_VECTOR		0x400
> >  #define LOWER_EL_AArch32_VECTOR		0x600
> >  
> > +/*
> > + * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
> > + */
> > +static u8 return_offsets[8][2] = {
> 
> static const
> 
> > +	[0] = { 0, 0 },		/* Reset, unused */
> > +	[1] = { 4, 2 },		/* Undefined */
> > +	[2] = { 0, 0 },		/* SVC, unused */
> > +	[3] = { 4, 4 },		/* Prefetch abort */
> > +	[4] = { 8, 8 },		/* Data abort */
> > +	[5] = { 0, 0 },		/* HVC, unused */
> > +	[6] = { 4, 4 },		/* IRQ, unused */
> > +	[7] = { 4, 4 },		/* FIQ, unused */
> > +};
> > +
> >  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> >  {
> >  	unsigned long cpsr;
> >  	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
> >  	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
> > -	u32 return_offset = (is_thumb) ? 4 : 0;
> > +	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
> >  	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
> >  
> >  	cpsr = mode | COMPAT_PSR_I_BIT;
> > 
> 
> Otherwise:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

I fixed up the const and applied cc stable.

Thanks,
-Christoffer
