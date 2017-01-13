From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Fri, 13 Jan 2017 14:04:37 -0500
Message-ID: <CAHyh4xgkjqYtuAAgSAQz=1bc4szpjkcqH_k6_YskobOv3B=ehg@mail.gmail.com>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox>
 <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
 <e0d1473f-0cf9-a801-585b-4385bc5b35ab@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 756BC40539
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:02:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PmKGQYyKLZFB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 14:02:53 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B66C403FB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:02:53 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0DJ08sH063192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:04:40 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id AEEE188
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:04:40 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 8541183
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:04:40 -0500 (EST)
Received: from mail-oi0-f70.google.com (mail-oi0-f70.google.com
 [209.85.218.70])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0DJ4e3v012503
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 14:04:40 -0500
Received: by mail-oi0-f70.google.com with SMTP id w144so103132407oiw.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 11:04:40 -0800 (PST)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com.
 [209.85.218.44])
 by smtp.gmail.com with ESMTPSA id z131sm6349625oig.17.2017.01.13.11.04.38
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 13 Jan 2017 11:04:38 -0800 (PST)
Received: by mail-oi0-f44.google.com with SMTP id u143so66617507oif.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 11:04:38 -0800 (PST)
In-Reply-To: <e0d1473f-0cf9-a801-585b-4385bc5b35ab@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 13, 2017 at 9:56 AM, Suzuki K Poulose
<Suzuki.Poulose@arm.com> wrote:
> On 13/01/17 13:30, Marc Zyngier wrote:
>>
>> [+ Suzuki, who wrote the whole cpus_have_const_cap thing]
>>
>> On 13/01/17 12:36, Christoffer Dall wrote:
>>>
>>> On Fri, Jan 13, 2017 at 11:31:32AM +0000, Marc Zyngier wrote:
>>>>
>>>> From: Jintack Lim <jintack@cs.columbia.edu>
>>>>
> ...
>
>
>>>>  /*
>>>>   * __boot_cpu_mode records what mode CPUs were booted in.
>>>> @@ -80,6 +81,14 @@ static inline bool is_kernel_in_hyp_mode(void)
>>>>         return read_sysreg(CurrentEL) == CurrentEL_EL2;
>>>>  }
>>>>
>>>> +static inline bool has_vhe(void)
>>>> +{
>>>> +       if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
>>>> +               return true;
>>>> +
>>>> +       return false;
>>>> +}
>>>> +
>>>
>>>
>>> I was experimenting with using has_vhe for some of the optimization code
>>> I was writing, and I saw a hyp crash as a result.  That made me wonder
>>> if this is really safe in Hyp mode?
>>>
>>> Specifically, there is no guarantee that this will actually be inlined
>>> in the caller, right?  At least that's what I can gather from trying to
>>> understand the semantics of the inline keyword in the GCC manual.
>>
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
>>
>> Here's the disassembly:
>>
>> ffff000008ad01d0 <__timer_restore_state>:
>> ffff000008ad01d0:       f9400001        ldr     x1, [x0]
>> ffff000008ad01d4:       9240bc21        and     x1, x1, #0xffffffffffff
>> ffff000008ad01d8:       d503201f        nop
>> ffff000008ad01dc:       d503201f        nop
>> ffff000008ad01e0:       d53ce102        mrs     x2, cnthctl_el2
>> ffff000008ad01e4:       927ef842        and     x2, x2,
>> #0xfffffffffffffffd
>> ffff000008ad01e8:       b2400042        orr     x2, x2, #0x1
>> ffff000008ad01ec:       d51ce102        msr     cnthctl_el2, x2
>> ffff000008ad01f0:       d2834002        mov     x2, #0x1a00
>> // #6656
>> ffff000008ad01f4:       8b020000        add     x0, x0, x2
>> ffff000008ad01f8:       91038002        add     x2, x0, #0xe0
>> ffff000008ad01fc:       39425443        ldrb    w3, [x2,#149]
>> ffff000008ad0200:       34000103        cbz     w3, ffff000008ad0220
>> <__timer_restore_state+0x50>
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
>> ffff000008ad01dc:       d503201f        b       ffff000008ad01f0
>> ffff000008ad01e0:       d53ce102        mrs     x2, cnthctl_el2
>> [...]
>>
>> That's using a toolchain that supports the "asm goto" feature that is used
>> to implement static branches (and that's guaranteed not to generate any
>> memory access other than the code patching itself).
>>
>> Now, with a toolchain that doesn't support this, such as gcc 4.8:
>>
>> ffff000008aa5168 <__timer_restore_state>:
>> ffff000008aa5168:       f9400001        ldr     x1, [x0]
>> ffff000008aa516c:       9240bc21        and     x1, x1, #0xffffffffffff
>> ffff000008aa5170:       d503201f        nop
>> ffff000008aa5174:       f00038a2        adrp    x2, ffff0000091bc000
>> <reset_devices>
>> ffff000008aa5178:       9113e042        add     x2, x2, #0x4f8
>> ffff000008aa517c:       b9402c42        ldr     w2, [x2,#44]
>> ffff000008aa5180:       6b1f005f        cmp     w2, wzr
>> ffff000008aa5184:       540000ac        b.gt    ffff000008aa5198
>> <__timer_restore_state+0x30>
>> ffff000008aa5188:       d53ce102        mrs     x2, cnthctl_el2
>> ffff000008aa518c:       927ef842        and     x2, x2,
>> #0xfffffffffffffffd
>> ffff000008aa5190:       b2400042        orr     x2, x2, #0x1
>> ffff000008aa5194:       d51ce102        msr     cnthctl_el2, x2
>> ffff000008aa5198:       91400402        add     x2, x0, #0x1, lsl #12
>> ffff000008aa519c:       396dd443        ldrb    w3, [x2,#2933]
>> ffff000008aa51a0:       34000103        cbz     w3, ffff000008aa51c0
>> <__timer_restore_state+0x58>
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
>> Idx Name          Size      VMA               LMA               File off
>> Algn
>> [...]
>>  23 .bss          000da348  ffff0000091b8000  ffff0000091b8000  01147a00
>> 2**12
>>                   ALLOC
>>
>> That's the BSS, which we do map in HYP (fairly recent).
>>
>> But maybe we should have have some stronger guarantees that we'll
>> always get things inlined, and that the "const" side is enforced:
>
>
> Agreed.
>
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h
>> b/arch/arm64/include/asm/cpufeature.h
>> index b4989df..4710469 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -105,10 +105,11 @@ static inline bool cpu_have_feature(unsigned int
>> num)
>>  }
>>
>>  /* System capability check for constant caps */
>> -static inline bool cpus_have_const_cap(int num)
>> +static __always_inline bool cpus_have_const_cap(int num)
>
>
> I think we should have the above change and make it inline always.
>
>>  {
>> -       if (num >= ARM64_NCAPS)
>> -               return false;
>> +       BUILD_BUG_ON(!__builtin_constant_p(num));
>
>
> This is not needed, as the compilation would fail if num is not a constant
> with
> static key code.
>
>> +       BUILD_BUG_ON(num >= ARM64_NCAPS);
>> +
>
>
> Also, I think it would be good to return false for caps > the ARM64_NCAPS,
> in sync
> with the non-const version.
>
>
>>         return static_branch_unlikely(&cpu_hwcap_keys[num]);
>>  }
>>
>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>> index 439f6b5..1257701 100644
>> --- a/arch/arm64/include/asm/virt.h
>> +++ b/arch/arm64/include/asm/virt.h
>> @@ -81,7 +81,7 @@ static inline bool is_kernel_in_hyp_mode(void)
>>         return read_sysreg(CurrentEL) == CurrentEL_EL2;
>>  }
>>
>> -static inline bool has_vhe(void)
>> +static __always_inline bool has_vhe(void)
>>  {
>>         if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
>>                 return true;
>>

I'm fine with the above change.

Thanks,
Jintack

>>
>> But that's probably another patch or two. Thoughts?
>
>
> With the above changes, please feel free to add :
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>
>
