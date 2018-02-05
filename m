From: Julien Grall <julien.grall@linaro.org>
Subject: Re: [PATCH v3 04/41] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Mon, 5 Feb 2018 18:10:00 +0000
Message-ID: <908db9b3-87a7-51bf-6c96-16488c0c827d@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-5-christoffer.dall@linaro.org>
 <be470bdb-258e-6b4d-b409-e230d2d90888@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <be470bdb-258e-6b4d-b409-e230d2d90888@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 05/02/18 18:04, Julien Grall wrote:
> On 12/01/18 12:07, Christoffer Dall wrote:
>> @@ -436,37 +446,31 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 
>> spsr, u64 elr, u64 par,
>>                  read_sysreg(hpfar_el2), par, vcpu);
>>   }
>> -static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
>> -                        struct kvm_vcpu *vcpu)
>> +static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
>> +                 struct kvm_cpu_context *host_ctxt)
>>   {
>> +    struct kvm_vcpu *vcpu;
>> +    vcpu = host_ctxt->__hyp_running_vcpu;
>> +
>> +    __deactivate_traps(vcpu);
>> +    __sysreg_restore_host_state(host_ctxt);
> 
> I was about to ask why you keep this function around as it does nothing 
> in VHE case. But I see that this will actually restore some values in a 
> later patch.

Actually, I just misread the code. Sorry for the noise.

Cheers,

-- 
Julien Grall
