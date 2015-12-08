From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Tue, 08 Dec 2015 09:02:59 +0000
Message-ID: <56669CC3.80601@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
 <1449123091-20252-4-git-send-email-zhaoshenglong@huawei.com>
 <56659276.6060403@arm.com> <5665984F.30102@linaro.org>
 <56659DD8.6050109@arm.com> <56669036.9090606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 361F540F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 04:01:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P6Tw1T8XpUiT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 04:01:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E942407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 04:01:14 -0500 (EST)
In-Reply-To: <56669036.9090606@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 08:09, Shannon Zhao wrote:
> Hi Marc,
> 
> On 2015/12/7 22:55, Marc Zyngier wrote:
>> On 07/12/15 14:31, Shannon Zhao wrote:
>>>>
>>>>
>>>> On 2015/12/7 22:06, Marc Zyngier wrote:
>>>>>> On 03/12/15 06:11, Shannon Zhao wrote:
>>>>>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>>>>
>>>>>>>> We are about to trap and emulate acccesses to each PMU register
>>>>>>
>>>>>> s/acccesses/accesses/
>>>>>>
>>>>>>>> individually. This adds the context offsets for the AArch64 PMU
>>>>>>>> registers and their AArch32 counterparts.
>>>>>>>>
>>>>>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>>>> ---
>>>>>>>>   arch/arm64/include/asm/kvm_asm.h | 55 ++++++++++++++++++++++++++++++++++++----
>>>>>>>>   1 file changed, 50 insertions(+), 5 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>>>>>>> index 5e37710..4f804c1 100644
>>>>>>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>>>>>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>>>>>>> @@ -48,12 +48,34 @@
>>>>>>>>   #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>>>>>>>>   #define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>>>>>>>>
>>>>>>
>>>>>> Coming back to this patch, it gives a clear view of where you have state
>>>>>> duplication.
>>>>>>
>>>>>>>> +/* Performance Monitors Registers */
>>>>>>>> +#define PMCR_EL0	24	/* Control Register */
>>>>>>>> +#define PMOVSSET_EL0	25	/* Overflow Flag Status Set Register */
>>>>>>>> +#define PMOVSCLR_EL0	26	/* Overflow Flag Status Clear Register */
>>>>>>
>>>>>> This should only be a single state. You don't even have to represent it
>>>>>> in the sysreg array, to be honest.
>>>>>>
> 
> Re-think about this. Since there are different operates to SET/CLR
> registers, maybe it should keep both of them while only storing the
> state in one of them.
> 
> To SET:
> 	vcpu_sys_reg(vcpu, r->reg) |= val;
> To CLR:
> 	vcpu_sys_reg(vcpu, r->reg) &= ~val;

There is really no point keeping both, because they are two views of the
same state. They perform different action on the same data, so the way
to look at it is to have different functions/methods that modify the
same state.

> Or keep one of them and within the access handler, according to the
> operates encoding value to judge whether it's SET or CLR.

That's indeed the way it should be. You just have to register different
functions in the trap table. You could even move the register outside of
the sys_reg array into the kvm_pmu structure.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
