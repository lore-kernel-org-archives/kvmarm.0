From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Subject: Re: [PATCH] arm64: KVM: Add 48bit PA support for EL2  translations
Date: Sat, 6 Feb 2016 22:31:38 +0000
Message-ID: <8A2DF702-D040-487F-BE38-EE94006FC3A7@caviumnetworks.com>
References: <1454700496-21221-1-git-send-email-tchalamarla@caviumnetworks.com>
 <20160206120524.09b9f893@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 106E24969A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Feb 2016 17:26:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pdqEmracnUGs for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Feb 2016 17:26:03 -0500 (EST)
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0056.outbound.protection.outlook.com [207.46.100.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20CD049616
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Feb 2016 17:26:02 -0500 (EST)
In-Reply-To: <20160206120524.09b9f893@arm.com>
Content-Language: en-US
Content-ID: <300DA7643CA50F4CB8A5E2D86375DD1D@namprd07.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu






On 2/6/16, 4:05 AM, "Marc Zyngier" <marc.zyngier@arm.com> wrote:

>Tirumalesh,
>
>On Fri, 5 Feb 2016 11:28:16 -0800
><tchalamarla@caviumnetworks.com> wrote:
>
>> From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
>> 
>> Systems where RAM is at higher address and MultiNode systems
>
>What influence a "MultiNode" (for whatever definition of node you have)
>system has on the memory map?
>
>> whith higher address RAM, 39 bit max PA for EL2 translations
>> is not sufficient.
>
>I read it as 40 bits, not 39.
My bad.
>
>> 
>> This patch sets max possible PA(48bit) for EL2 translations.
>
>From the ARM ARM:
>
>"If {I}PS is programmed to a value larger than the implemented physical
>address size, then the PE behaves as if programmed with the implemented
>physical address size, but software must not rely on this behavior.
>That is, the output address size is never larger than the implemented
>physical address size."
>
>> Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 738a95f..3fc38a4 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -98,7 +98,12 @@
>>  #define TCR_EL2_RES1	((1 << 31) | (1 << 23))
>>  #define TCR_EL2_TBI	(1 << 20)
>>  #define TCR_EL2_PS	(7 << 16)
>> +#define TCR_EL2_PS_32B	(0 << 16)
>> +#define TCR_EL2_PS_36B	(1 << 16)
>>  #define TCR_EL2_PS_40B	(2 << 16)
>> +#define TCR_EL2_PS_42B	(3 << 16)
>> +#define TCR_EL2_PS_44B	(4 << 16)
>> +#define TCR_EL2_PS_48B	(5 << 16)
>>  #define TCR_EL2_TG0	(1 << 14)
>>  #define TCR_EL2_SH0	(3 << 12)
>>  #define TCR_EL2_ORGN0	(3 << 10)
>> @@ -107,7 +112,10 @@
>>  #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
>>  			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
>>  
>> -#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
>> +/*
>> + * Assign the highest possible PS.
>> + */
>> +#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_48B)
>>  
>>  /* VTCR_EL2 Registers bits */
>>  #define VTCR_EL2_RES1		(1 << 31)
>
>So this is a NAK. If you want to address this problem, do it properly
>(hint: look at how we deal with VTCR_EL2).
Sure, will reimplement it. 
>
>Thanks,
>
>	M.
>-- 
>Jazz is not dead. It just smells funny.
