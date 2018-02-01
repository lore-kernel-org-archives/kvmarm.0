From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 15/18] arm/arm64: smccc: Make function identifiers an
 unsigned quantity
Date: Thu, 1 Feb 2018 12:44:03 +0000
Message-ID: <CAKv+Gu_JMj-JmzhjxbnguR5o9SUAoAL=L3OYAGPLy7t6aS8GWg@mail.gmail.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com> <20180201114657.7323-16-marc.zyngier@arm.com>
 <1c07ecaa-0a60-284d-1b85-0b4ea4522c48@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1c07ecaa-0a60-284d-1b85-0b4ea4522c48@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 February 2018 at 12:40, Robin Murphy <robin.murphy@arm.com> wrote:
> On 01/02/18 11:46, Marc Zyngier wrote:
>>
>> Function identifiers are a 32bit, unsigned quantity. But we never
>> tell so to the compiler, resulting in the following:
>>
>>   4ac:   b26187e0        mov     x0, #0xffffffff80000001
>>
>> We thus rely on the firmware narrowing it for us, which is not
>> always a reasonable expectation.
>
>
> I think technically it might be OK, since SMCCC states "A Function
> Identifier is passed in register W0.", which implies that a conforming
> implementation should also read w0, not x0, but it's certainly far easier to
> be completely right than to justify being possibly wrong.
>
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
>

In my case, the function identifier wasn't the issue, but the
argument, which, for SMCCC_ARCH_FEATURES is also defined as uint32_t,
but did end up being interpreted incorrectly by the SMCCCv1.1
implementation that is now upstream in ARM-TF



>
>> Cc: stable@vger.kernel.org
>> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   include/linux/arm-smccc.h | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index e1ef944ef1da..dd44d8458c04 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -14,14 +14,16 @@
>>   #ifndef __LINUX_ARM_SMCCC_H
>>   #define __LINUX_ARM_SMCCC_H
>>   +#include <uapi/linux/const.h>
>> +
>>   /*
>>    * This file provides common defines for ARM SMC Calling Convention as
>>    * specified in
>>    * http://infocenter.arm.com/help/topic/com.arm.doc.den0028a/index.html
>>    */
>>   -#define ARM_SMCCC_STD_CALL           0
>> -#define ARM_SMCCC_FAST_CALL            1
>> +#define ARM_SMCCC_STD_CALL             _AC(0,U)
>> +#define ARM_SMCCC_FAST_CALL            _AC(1,U)
>>   #define ARM_SMCCC_TYPE_SHIFT          31
>>     #define ARM_SMCCC_SMC_32            0
>>
>
