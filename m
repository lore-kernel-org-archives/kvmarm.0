From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: consult a question about 'inject_abt64()'
Date: Mon, 18 Sep 2017 21:49:25 +0800
Message-ID: <1f06664f-c60d-5551-70e7-13219210ef97@huawei.com>
References: <a9ec4c60-a1b1-9535-89a2-30db4facaf1f@huawei.com>
 <D8D110F4-5AC4-4AEF-817B-038F506B8D7D@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <D8D110F4-5AC4-4AEF-817B-038F506B8D7D@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Evans <Matt.Evans@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, marc.zyngier@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, James Morse <James.Morse@arm.com>, catalin.marinas@arm.com, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

To KVM mailing List about below question, thanks.



On 2017/9/18 21:17, Matt Evans wrote:
> Hi Gengdongjiu,
> 
> 
>> On 18 Sep 2017, at 07:39, gengdongjiu <gengdongjiu@huawei.com> wrote:
>>
>> Hi Matt,
>>   sorry to disturb you, I want to consult you a question about the function inject_abt64();
>> For this function, the abort EC can be ESR_ELx_EC_DABT_LOW or ESR_ELx_EC_DABT_CUR according to *vcpu_cpsr(vcpu);
>> why it always ESR_ELx_EC_DABT_LOW?  thanks!
>>
>> As you can see the Iabort, when injecting the Iabort, it will check the cpsr to decide to inject the ESR_ELx_EC_IABT_LOW or ESR_ELx_EC_IABT_CUR.
>> but I do not know why the Dabort will always be ESR_ELx_EC_DABT_LOW when injecting.
>>
>>        /*
>>         * Here, the guest runs in AArch64 mode when in EL1. If we get
>>         * an AArch32 fault, it means we managed to trap an EL0 fault.
>>         */
>>        if (is_aarch32 || (cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
>>                esr |= (ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
>>        else
>>                esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
> 
> I think you're right.  When I fixed that line I had noticed the lack of left-shift but didn't think about the actual ESR value.
> 
> The injected vector is calculated correctly (between current-EL or lower-EL vectors) by get_except_vector() but the EC should also correspond to current-EL or lower-EL.
> 
> It is worth following this up on the ARM KVM mailing list!  (To be fair, your question should have been sent there too :) )
> 
> Thanks,
> 
> 
> Matt
> 
> 
> 
>>
>>
>>
>> commit e4fe9e7dc3828bf6a5714eb3c55aef6260d823a2
>> Author: Matt Evans <matt.evans@arm.com>
>> Date:   Mon May 16 13:54:56 2016 +0100
>>
>>    kvm: arm64: Fix EC field in inject_abt64
>>
>>    The EC field of the constructed ESR is conditionally modified by ORing in
>>    ESR_ELx_EC_DABT_LOW for a data abort.  However, ESR_ELx_EC_SHIFT is missing
>>    from this condition.
>>
>>    Signed-off-by: Matt Evans <matt.evans@arm.com>
>>    Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>    Cc: <stable@vger.kernel.org>
>>    Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>> index 4d1ac81870d2..e9e0e6db73f6 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -162,7 +162,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>>                esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
>>
>>        if (!is_iabt)
>> -               esr |= ESR_ELx_EC_DABT_LOW;
>> +               esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>>
>>        vcpu_sys_reg(vcpu, ESR_EL1) = esr | ESR_ELx_FSC_EXTABT;
>> }
>>
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 
> 
