From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v6 1/6] arm/arm64: KVM: Introduce armv7 fp/simd vcpu fields
 and helpers
Date: Wed, 20 Jan 2016 18:29:00 -0800
Message-ID: <56A0426C.6010100@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
 <1451166900-3711-2-git-send-email-m.smarduch@samsung.com>
 <20160110163204.GD30867@cbox> <56943D29.3000002@samsung.com>
 <20160112141207.GF15554@cbox> <5695A0EB.5020609@samsung.com>
 <56970FE8.4020805@samsung.com> <20160114132718.GA4329@cbox>
 <5698531E.1090606@samsung.com> <5698B5C9.4030404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8166849680
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2016 21:24:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WRVefh92gExl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2016 21:24:28 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60CC448531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2016 21:24:27 -0500 (EST)
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0O1A003XW6WD9510@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 20 Jan 2016 21:29:01 -0500 (EST)
In-reply-to: <5698B5C9.4030404@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Russell King - ARM Linux <linux@arm.linux.org.uk>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 1/15/2016 1:03 AM, Marc Zyngier wrote:
> On 15/01/16 02:02, Mario Smarduch wrote:
>>
>>
>> On 1/14/2016 5:27 AM, Christoffer Dall wrote:
>>> On Wed, Jan 13, 2016 at 07:03:04PM -0800, Mario Smarduch wrote:
>>>>
>>>>
>>>> On 1/12/2016 4:57 PM, Mario Smarduch wrote:
>>>>>
>>>>>
>>>>> On 1/12/2016 6:12 AM, Christoffer Dall wrote:
>>>>>> On Mon, Jan 11, 2016 at 03:39:21PM -0800, Mario Smarduch wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 1/10/2016 8:32 AM, Christoffer Dall wrote:
>>>>>>>> Hi Mario,
>>>>>>>>
>>>>>>>> I spotted one more potential issue...
>>>>>>>>
>>>>>>>> On Sat, Dec 26, 2015 at 01:54:55PM -0800, Mario Smarduch wrote:
>>>>>>>>> Add helper functions to enable access to fp/smid on guest entry and save host
>>>>>>>>> fpexc on vcpu put, check if fp/simd registers are dirty and add new vcpu
>>>>>>>>> fields.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>>>>>>>>> ---
>>>>>>>>>  arch/arm/include/asm/kvm_emulate.h   | 42 ++++++++++++++++++++++++++++++++++++
>>>>>>>>>  arch/arm/include/asm/kvm_host.h      |  6 ++++++
>>>>>>>>>  arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
>>>>>>>>>  3 files changed, 56 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
>>>>>>>>> index 3095df0..d4d9da1 100644
>>>>>>>>> --- a/arch/arm/include/asm/kvm_emulate.h
>>>>>>>>> +++ b/arch/arm/include/asm/kvm_emulate.h
>>>>>>>>> @@ -24,6 +24,8 @@
>>>>>>>>>  #include <asm/kvm_mmio.h>
>>>>>>>>>  #include <asm/kvm_arm.h>
>>>>>>>>>  #include <asm/cputype.h>
>>>>>>>>> +#include <asm/vfp.h>
>>>>>>>>> +#include "../vfp/vfpinstr.h"
>>>>>>>>>  
>>>>>>>>>  unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
>>>>>>>>>  unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
>>>>>>>>> @@ -255,4 +257,44 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>>>>>>>>  	}
>>>>>>>>>  }
>>>>>>>>>  
>>>>>>>>> +#ifdef CONFIG_VFPv3
>>>>>>>>> +/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
>>>>>>>>> +static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
>>>>>>>>> +{
>>>>>>>>> +	u32 fpexc;
>>>>>>>>> +
>>>>>>>>> +	/* Save host fpexc, and enable guest access to fp unit */
>>>>>>>>> +	fpexc = fmrx(FPEXC);
>>>>>>>>> +	vcpu->arch.host_fpexc = fpexc;
>>>>>>>>> +	fpexc |= FPEXC_EN;
>>>>>>>>> +	fmxr(FPEXC, fpexc);
>>>>>>>>> +
>>>>>>>>> +	/* Configure HCPTR to trap on tracing and fp/simd access */
>>>>>>>>> +	vcpu->arch.hcptr = HCPTR_TTA | HCPTR_TCP(10)  | HCPTR_TCP(11);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +/* Called from vcpu_put - restore host fpexc */
>>>>>>>>> +static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu)
>>>>>>>>> +{
>>>>>>>>> +	fmxr(FPEXC, vcpu->arch.host_fpexc);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +/* If trap bits are reset then fp/simd registers are dirty */
>>>>>>>>> +static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>>>>>>>>> +{
>>>>>>>>> +	return !(vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
>>>>>>>>> +}
>>>>>>>>> +#else
>>>>>>>>> +static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
>>>>>>>>> +{
>>>>>>>>> +	vcpu->arch.hcptr = HCPTR_TTA;
>>>>>>>>
>>>>>>>> Is it correct not to trap VFP registers when the host kernel does not
>>>>>>>> have CONFIG_VFPv3?  I think this is a change in functionality compared
>>>>>>>> to the current kernels is it not?
>>>>>>>
>>>>>>> With CPU_V7 VFPv3 gets selected, without it fp should be emulated,
>>>>>>> with exceptions taken in guest kernel. I don't see a reason why
>>>>>>> fp hcptr access should be enabled in that case.
>>>>>>>
>>>>>>
>>>>>> If you have to guests with CONFIG_VFPV3 but your host doesn't have
>>>>>> CONFIG_VFPV3, you will never context-switch the VFP registers between
>>>>>> the two VMs, and mayhem will ensue.
>>>>>>
>>>>>> Unless I'm missing something very obvious?
>>>>
>>>> Did more testing on this enabling OABI_COMPAT and selecting
>>>> NWFPE/FastFPE breaks the boot. So far can't find a way to boot host
>>>> without VFP/VFPv3 enabled on ARMv7. CPU_V7 defaults to VFPv3
>>>> selection. I'm wondering if !VFPv3 path should be removed from
>>>> the patches?
>>>>
>>> I think this is related to your particular choice of userspace. 
>>
>> It appears like there are two soft float implementations.
>>
>> FastFPE - but that's missing arch/arm/fastfpe directory, the option
>> can still be selected but nothing is built.
>>
>> And the Netwidner FPE arch/arm/nwfpe, that doesn't appear to be
>> hooked into the kernel. The hook nwfpe_enter is not referenced
>> anywhere.
> 
> It is:
> 
> arch/arm/nwfpe/entry.S: .globl  nwfpe_enter
> arch/arm/nwfpe/entry.S:nwfpe_enter:
> arch/arm/nwfpe/fpmodule.c:extern void nwfpe_enter(void);
> arch/arm/nwfpe/fpmodule.c:      kern_fp_enter = nwfpe_enter;
> 
>> I could make this change but have no way to bring the host up to
>> test it.

I investigated VFP and virtualiztion. Came up with few
hw/sw configurations, some of it tested other not so
it may be full of holes.

1. CONFIG_VFP set and VFP not implemented on all CPUs
vfp_init() - discovers VFP is not supported via vfp_vector
and bails out. A guest should be able to boot successfully
going through the same check. And obviously there is no
need to lazy switch vfp registers, vcpu_put/get should know
about this. This would be softfloat/softfloat.

2. CONFIG_VFP set and platform calls vfp_disable() which I believe
the platform is saying not all cpus have a VFP. Some guests may
detect a VFP others not. Doesn't appear like a workable configuration
with virtualization enabled.

3. CONFIG_VFP not set and VFP impl/not impl host using softfloat.
To get this to work code from vfp_init is needed.
- Enable coproc for cp10, 11 on cpus
- Test for vfp support  allow platform to set vfp_disable.

in vput_load()
- if all CPUs have a VFP set FPEXC.EN, set hcptr vfp trapping
- Here guest gets an undefined instruction on fmrx(FPSID), but if
  vfp traps are not set the guest boots just fine, don't know
  what the problem is.

4. CONFIG_VFP set VFP implemented on all CPUs
- This works fine, Guest VFP no exception on FPSIMD access
  like in 3. Appears like full host VFP initialization
  does something to make the guest with hcptr traps work.

Unfortunately my priorities have been changed and need to move to
other work. I could complete 4 per Christoffers last comments.

- Mario


> 
> None of these are relevant - they are emulation for the FPA (Floating
> Point Accelerator). Most of the time, nobody uses this but instead a
> userspace softfloat implementation, which saves the trap to kernel space
> for emulation.
> 
> You can try Debian armel (as opposed to armhf, which mandates VFP) for
> example, which is a softfloat-based distribution.
> 
> Thanks,
> 
> 	M.
> 
