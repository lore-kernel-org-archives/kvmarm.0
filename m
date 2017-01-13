From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Fri, 13 Jan 2017 13:57:23 +0000
Message-ID: <d591944f-8c12-afb9-e6c2-bce1bf526f56@arm.com>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox> <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
 <20170113134640.GB31994@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7526403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 08:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQpY3CV11Koa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 08:55:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA1240354
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 08:55:39 -0500 (EST)
In-Reply-To: <20170113134640.GB31994@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/01/17 13:46, Christoffer Dall wrote:
> On Fri, Jan 13, 2017 at 01:30:29PM +0000, Marc Zyngier wrote:
>> [+ Suzuki, who wrote the whole cpus_have_const_cap thing]
>>
>> On 13/01/17 12:36, Christoffer Dall wrote:
>>> On Fri, Jan 13, 2017 at 11:31:32AM +0000, Marc Zyngier wrote:
>>>> From: Jintack Lim <jintack@cs.columbia.edu>
>>>>
>>>> Current KVM world switch code is unintentionally setting wrong bits to
>>>> CNTHCTL_EL2 when E2H == 1, which may allow guest OS to access physical
>>>> timer.  Bit positions of CNTHCTL_EL2 are changing depending on
>>>> HCR_EL2.E2H bit.  EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is
>>>> not set, but they are 11th and 10th bits respectively when E2H is set.
>>>>
>>>> In fact, on VHE we only need to set those bits once, not for every world
>>>> switch. This is because the host kernel runs in EL2 with HCR_EL2.TGE ==
>>>> 1, which makes those bits have no effect for the host kernel execution.
>>>> So we just set those bits once for guests, and that's it.
>>>>
>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm/include/asm/virt.h   |  5 +++++
>>>>  arch/arm/kvm/arm.c            |  3 +++
>>>>  arch/arm64/include/asm/virt.h |  9 +++++++++
>>>>  include/kvm/arm_arch_timer.h  |  1 +
>>>>  virt/kvm/arm/arch_timer.c     | 23 +++++++++++++++++++++++
>>>>  virt/kvm/arm/hyp/timer-sr.c   | 33 +++++++++++++++++++++------------
>>>>  6 files changed, 62 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
>>>> index a2e75b8..6dae195 100644
>>>> --- a/arch/arm/include/asm/virt.h
>>>> +++ b/arch/arm/include/asm/virt.h
>>>> @@ -80,6 +80,11 @@ static inline bool is_kernel_in_hyp_mode(void)
>>>>  	return false;
>>>>  }
>>>>  
>>>> +static inline bool has_vhe(void)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +
>>>>  /* The section containing the hypervisor idmap text */
>>>>  extern char __hyp_idmap_text_start[];
>>>>  extern char __hyp_idmap_text_end[];
>>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>>> index 1167678..9d74464 100644
>>>> --- a/arch/arm/kvm/arm.c
>>>> +++ b/arch/arm/kvm/arm.c
>>>> @@ -1099,6 +1099,9 @@ static void cpu_init_hyp_mode(void *dummy)
>>>>  	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
>>>>  	__cpu_init_stage2();
>>>>  
>>>> +	if (is_kernel_in_hyp_mode())
>>>> +		kvm_timer_init_vhe();
>>>> +
>>>>  	kvm_arm_init_debug();
>>>>  }
>>>>  
>>>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>>>> index fea1073..439f6b5 100644
>>>> --- a/arch/arm64/include/asm/virt.h
>>>> +++ b/arch/arm64/include/asm/virt.h
>>>> @@ -47,6 +47,7 @@
>>>>  #include <asm/ptrace.h>
>>>>  #include <asm/sections.h>
>>>>  #include <asm/sysreg.h>
>>>> +#include <asm/cpufeature.h>
>>>>  
>>>>  /*
>>>>   * __boot_cpu_mode records what mode CPUs were booted in.
>>>> @@ -80,6 +81,14 @@ static inline bool is_kernel_in_hyp_mode(void)
>>>>  	return read_sysreg(CurrentEL) == CurrentEL_EL2;
>>>>  }
>>>>  
>>>> +static inline bool has_vhe(void)
>>>> +{
>>>> +	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
>>>> +		return true;
>>>> +
>>>> +	return false;
>>>> +}
>>>> +
>>>
>>> I was experimenting with using has_vhe for some of the optimization code
>>> I was writing, and I saw a hyp crash as a result.  That made me wonder
>>> if this is really safe in Hyp mode?
>>>
>>> Specifically, there is no guarantee that this will actually be inlined
>>> in the caller, right?  At least that's what I can gather from trying to
>>> understand the semantics of the inline keyword in the GCC manual.
>>
>> Indeed, there is no strict guarantee that this is enforced. We should
>> probably have __always_inline instead. But having checked the generated
>> code for __timer_restore_state, the function is definitely inlined
>> (gcc 6.2). Happy to queue an extra patch changing that.
>>
>>> Further, are we guaranteed that the static branch gets compiled into
>>> something that doesn't actually look at cpu_hwcap_keys, which is not
>>> mapped in hyp mode?
>>
>> Here's the disassembly:
>>
>> ffff000008ad01d0 <__timer_restore_state>:
>> ffff000008ad01d0:       f9400001        ldr     x1, [x0]
>> ffff000008ad01d4:       9240bc21        and     x1, x1, #0xffffffffffff
>> ffff000008ad01d8:       d503201f        nop
>> ffff000008ad01dc:       d503201f        nop
>> ffff000008ad01e0:       d53ce102        mrs     x2, cnthctl_el2
>> ffff000008ad01e4:       927ef842        and     x2, x2, #0xfffffffffffffffd
>> ffff000008ad01e8:       b2400042        orr     x2, x2, #0x1
>> ffff000008ad01ec:       d51ce102        msr     cnthctl_el2, x2
>> ffff000008ad01f0:       d2834002        mov     x2, #0x1a00                     // #6656
>> ffff000008ad01f4:       8b020000        add     x0, x0, x2
>> ffff000008ad01f8:       91038002        add     x2, x0, #0xe0
>> ffff000008ad01fc:       39425443        ldrb    w3, [x2,#149]
>> ffff000008ad0200:       34000103        cbz     w3, ffff000008ad0220 <__timer_restore_state+0x50>
>> ffff000008ad0204:       f945a821        ldr     x1, [x1,#2896]
>> ffff000008ad0208:       d51ce061        msr     cntvoff_el2, x1
>> ffff000008ad020c:       f9400441        ldr     x1, [x2,#8]
>> ffff000008ad0210:       d51be341        msr     cntv_cval_el0, x1
>> ffff000008ad0214:       d5033fdf        isb
>> ffff000008ad0218:       b940e000        ldr     w0, [x0,#224]
>> ffff000008ad021c:       d51be320        msr     cntv_ctl_el0, x0
>> ffff000008ad0220:       d65f03c0        ret
>>
>> The static branch resolves as such when VHE is enabled (taken from
>> a running model):
>>
>> ffff000008ad01d0 <__timer_restore_state>:
>> ffff000008ad01d0:       f9400001        ldr     x1, [x0]
>> ffff000008ad01d4:       9240bc21        nop
>> ffff000008ad01d8:       d503201f        nop
>> ffff000008ad01dc:       d503201f        b	ffff000008ad01f0
>> ffff000008ad01e0:       d53ce102        mrs     x2, cnthctl_el2
>> [...]
>>
>> That's using a toolchain that supports the "asm goto" feature that is used
>> to implement static branches (and that's guaranteed not to generate any
>> memory access other than the code patching itself).
>>
>> Now, with a toolchain that doesn't support this, such as gcc 4.8:
> 
> Hmm, I saw the error with 5.4.1, but perhaps I messed something else up,
> because I cannot seem to reproduce this at the moment.
> 
>>
>> ffff000008aa5168 <__timer_restore_state>:
>> ffff000008aa5168:       f9400001        ldr     x1, [x0]
>> ffff000008aa516c:       9240bc21        and     x1, x1, #0xffffffffffff
>> ffff000008aa5170:       d503201f        nop
>> ffff000008aa5174:       f00038a2        adrp    x2, ffff0000091bc000 <reset_devices>
>> ffff000008aa5178:       9113e042        add     x2, x2, #0x4f8
>> ffff000008aa517c:       b9402c42        ldr     w2, [x2,#44]
>> ffff000008aa5180:       6b1f005f        cmp     w2, wzr
>> ffff000008aa5184:       540000ac        b.gt    ffff000008aa5198 <__timer_restore_state+0x30>
>> ffff000008aa5188:       d53ce102        mrs     x2, cnthctl_el2
>> ffff000008aa518c:       927ef842        and     x2, x2, #0xfffffffffffffffd
>> ffff000008aa5190:       b2400042        orr     x2, x2, #0x1
>> ffff000008aa5194:       d51ce102        msr     cnthctl_el2, x2
>> ffff000008aa5198:       91400402        add     x2, x0, #0x1, lsl #12
>> ffff000008aa519c:       396dd443        ldrb    w3, [x2,#2933]
>> ffff000008aa51a0:       34000103        cbz     w3, ffff000008aa51c0 <__timer_restore_state+0x58>
>> ffff000008aa51a4:       f945a821        ldr     x1, [x1,#2896]
>> ffff000008aa51a8:       d51ce061        msr     cntvoff_el2, x1
>> ffff000008aa51ac:       f9457441        ldr     x1, [x2,#2792]
>> ffff000008aa51b0:       d51be341        msr     cntv_cval_el0, x1
>> ffff000008aa51b4:       d5033fdf        isb
>> ffff000008aa51b8:       b95ae000        ldr     w0, [x0,#6880]
>> ffff000008aa51bc:       d51be320        msr     cntv_ctl_el0, x0
>> ffff000008aa51c0:       d65f03c0        ret
>>
>> This is now controlled by some date located at FFFF0000091BC524:
>>
>> maz@approximate:~/Work/arm-platforms$ aarch64-linux-gnu-objdump -h vmlinux
>>
>> vmlinux:     file format elf64-littleaarch64
>>
>> Sections:
>> Idx Name          Size      VMA               LMA               File off  Algn
>> [...]
>>  23 .bss          000da348  ffff0000091b8000  ffff0000091b8000  01147a00  2**12
>>                   ALLOC
>>
>> That's the BSS, which we do map in HYP (fairly recent).
> 
> But we cannot map the BSS at the same address though, right?  So
> wouldn't this actually fail?

We map it at the same relative offset, and use adrp to get the base
address (PC relative). So whatever context we're in, we should be OK.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
