From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH 02/12] arm64: kvm: Fix {V}TCR_EL2_TG0 mask
Date: Wed, 16 Mar 2016 15:35:20 +0000
Message-ID: <56E97D38.2010409@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-3-git-send-email-suzuki.poulose@arm.com>
 <56E973A6.7020004@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56E973A6.7020004@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/16 14:54, Marc Zyngier wrote:
> On 14/03/16 16:53, Suzuki K Poulose wrote:
>> {V}TCR_EL2_TG0 is a 2bit wide field, where:
>>
>>   00 - 4K
>>   01 - 64K
>>   10 - 16K
>>
>> But we use only 1 bit, which has worked well so far since
>> we never cared about 16K. Fix it for 16K support.


>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -99,7 +99,7 @@
>>   #define TCR_EL2_TBI	(1 << 20)
>>   #define TCR_EL2_PS	(7 << 16)
>>   #define TCR_EL2_PS_40B	(2 << 16)
>> -#define TCR_EL2_TG0	(1 << 14)
>> +#define TCR_EL2_TG0	(3 << 14)
>>   #define TCR_EL2_SH0	(3 << 12)
>>   #define TCR_EL2_ORGN0	(3 << 10)
>>   #define TCR_EL2_IRGN0	(3 << 8)
>> @@ -110,7 +110,7 @@
>>   /* VTCR_EL2 Registers bits */
>>   #define VTCR_EL2_RES1		(1 << 31)
>>   #define VTCR_EL2_PS_MASK	(7 << 16)
>> -#define VTCR_EL2_TG0_MASK	(1 << 14)
>> +#define VTCR_EL2_TG0_MASK	(3 << 14)
>>   #define VTCR_EL2_TG0_4K		(0 << 14)
>>   #define VTCR_EL2_TG0_64K	(1 << 14)
>>   #define VTCR_EL2_SH0_MASK	(3 << 12)
>>
>
> As we already have arch/arm64/include/asm/pgtable-hwdef.h defining
> TCR_TG0_{4,16,64}K, would it make sense to reuse those and drop the
> locally defined values? Something like:
>
> #define TCR_EL2_TG0_4K	TCR_TG0_4K
>
> ?

We could do that for both TCR_EL2 and VTCR_EL2.

Btw, since this patch doesn't touch any of those fields and fixes an issue,
I will keep that change separate. I can squash it to the following cleanup
patch in this series.

Cheers
Suzuki


