From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 16:19:28 +0100
Message-ID: <ee3bbb0d-0403-5719-bacf-93c4e654509d@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2015EA4DE@DGGEMA503-MBX.china.huawei.com>
 <79163d5d-90cf-9a94-457e-80cfffc0415f@arm.com>
 <etPan.59b00f79.2fe72a3.4a29@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <etPan.59b00f79.2fe72a3.4a29@localhost>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>, "marc.zyngier" <marc.zyngier@arm.com>, "christoffer.dall" <christoffer.dall@linaro.org>, pbonzini <pbonzini@redhat.com>, rkrcmar <rkrcmar@redhat.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "suzuki.poulose" <suzuki.poulose@arm.com>, "mark.rutland" <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: "James.Morse" <James.Morse@arm.com>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/09/17 16:08, gengdongjiu wrote:
> It is similar with the PAN，when the guest traps to el2，it will reset the pstate.PAN <http://pstate.PAN> to 0, and continue run。In fact the host pstate.UAO <http://pstate.UAO> can be 1, but guest change it to 0 when trap to EL2。so after swich to host，need to check whether set pstate.UAO <http://pstate.UAO> again。

What negative effect do you see with change UAO to 0 (i.e. do not override)?

P. S.
Please, avoid HTML and top posting

Vladimir

> *发件人：*Vladimir Murzin
> *收件人：*耿东久,marc.zyngier,christoffer.dall@linaro.org,pbonzini@redhat.com,rkrcmar@redhat.com,linux-arm-kernel@lists.infradead.org,kvmarm@lists.cs.columbia.edu,kvm@vger.kernel.org,linux-kernel,suzuki.poulose@arm.com,mark.rutland@arm.com,Catalin Marinas
> *抄送：*James Morse,张海斌,黄韶宇
> *时间：*2017-09-06 22:41:09
> *主题:*Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
> 
> On 06/09/17 15:10, gengdongjiu wrote:
>> Hi, Vladimir
>> 
>>>>> Do you see effect of "PAN is unexpectedly enabled"?
>>>> In fact I did not encounter this case, but I think it can exist.
>>>> I think if host OS dynamically disable PAN, it wants the host kernel access the user space address space not through copy_to/from_user
>>> API.
>>>> Now if it is unexpectedly enabled, when host kernel still accesses the user space address,  it will happen MMU fault exception.
>>>
>>> And this is expected! The only allowed channel for kernel <-> user is uaccess API.
>>>
>>> I guess that you have test (and that great!) which violates that rule (for testing purpose, why not?) and now you are trying to fit kernel into
>>> it...
>> 
>> 
>> If you think that makes sense for it, we do not consider the paste.PAN in the world-switch.
>> For the pstate.UAO issue, do you agree my fixing or you have other suggestion?  Also to other reviewer. Thanks.
> 
> It would help if you give precise description on "pstate.UAO issue".
> 
> Thanks
> Vladimir
> 
>> 
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
>> index 9341376..c3dd761 100644
>> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
>> @@ -21,6 +21,8 @@
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_hyp.h>
>> 
>> +#include <asm/exec.h>
>> 
>>  /* Yes, this does nothing, on purpose */
>>  static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
>> 
>> @@ -121,8 +123,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>>         write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
>>  }
>> 
>> +static void __hyp_text __sysreg_restore_state_vhe(struct kvm_cpu_context *ctxt)
>> +{
>> +    uao_thread_switch(current);
>> +}
>> +
>>  static hyp_alternate_select(__sysreg_call_restore_host_state,
>> -                           __sysreg_restore_state, __sysreg_do_nothing,
>> +                           __sysreg_restore_state, __sysreg_restore_state_vhe,
>>                             ARM64_HAS_VIRT_HOST_EXTN);
>> 
>>  void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
>> 
>> 
>>>
>>> Cheers
>>> Vladimir
>>>
>>>>
>>>>
>>>>>
>>>>> Cheers
>>>>> Vladimir
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Cheers
>>>>>>> Vladimir
>>>>>>>
>>>>>>> .
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>> .
>>>>>
>>>>
>>>>
>> 
> 
