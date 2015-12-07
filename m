From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Mon, 07 Dec 2015 14:55:20 +0000
Message-ID: <56659DD8.6050109@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-4-git-send-email-zhaoshenglong@huawei.com> <56659276.6060403@arm.com> <5665984F.30102@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5665984F.30102@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/15 14:31, Shannon Zhao wrote:
> 
> 
> On 2015/12/7 22:06, Marc Zyngier wrote:
>> On 03/12/15 06:11, Shannon Zhao wrote:
>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>
>>> We are about to trap and emulate acccesses to each PMU register
>>
>> s/acccesses/accesses/
>>
>>> individually. This adds the context offsets for the AArch64 PMU
>>> registers and their AArch32 counterparts.
>>>
>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>> ---
>>>   arch/arm64/include/asm/kvm_asm.h | 55 ++++++++++++++++++++++++++++++++++++----
>>>   1 file changed, 50 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>> index 5e37710..4f804c1 100644
>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>> @@ -48,12 +48,34 @@
>>>   #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>>>   #define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>>>
>>
>> Coming back to this patch, it gives a clear view of where you have state
>> duplication.
>>
>>> +/* Performance Monitors Registers */
>>> +#define PMCR_EL0	24	/* Control Register */
>>> +#define PMOVSSET_EL0	25	/* Overflow Flag Status Set Register */
>>> +#define PMOVSCLR_EL0	26	/* Overflow Flag Status Clear Register */
>>
>> This should only be a single state. You don't even have to represent it
>> in the sysreg array, to be honest.
>>
> Yeah, I could store the state in one of them and drop one of them here.

Indeed.

>>> +#define PMSELR_EL0	27	/* Event Counter Selection Register */
>>> +#define PMCEID0_EL0	28	/* Common Event Identification Register 0 */
>>> +#define PMCEID1_EL0	29	/* Common Event Identification Register 1 */
>>> +#define PMEVCNTR0_EL0	30	/* Event Counter Register (0-30) */
>>> +#define PMEVCNTR30_EL0	60
>>> +#define PMCCNTR_EL0	61	/* Cycle Counter Register */
>>> +#define PMEVTYPER0_EL0	62	/* Event Type Register (0-30) */
>>> +#define PMEVTYPER30_EL0	92
>>> +#define PMCCFILTR_EL0	93	/* Cycle Count Filter Register */
>>> +#define PMXEVCNTR_EL0	94	/* Selected Event Count Register */
>>> +#define PMXEVTYPER_EL0	95	/* Selected Event Type Register */
>>
>> These "select" registers aren't real ones, but just a way to pick the
>> real register. They should be removed.
>>
> I think these two could be retained, since it's convenient to handle the 
> guest accessing by using "case PMXEVCNTR_EL0"

Not really. This is just occupying pointless space is the register file,
and it would be clearer to have a couple of helpers called directly from
the sys_reg trap table.

Please get rid of it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
