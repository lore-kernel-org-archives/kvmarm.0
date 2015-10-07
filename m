From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 11/15] arm64: Cleanup VTCR_EL2 computation
Date: Wed, 7 Oct 2015 11:23:04 +0100
Message-ID: <5614F288.6000901@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-12-git-send-email-suzuki.poulose@arm.com>
 <5614EFD0.20709@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4584155B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 06:21:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wbt9yAVCKKec for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 06:21:10 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20CE0412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 06:21:09 -0400 (EDT)
In-Reply-To: <5614EFD0.20709@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Catalin.Marinas@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/15 11:11, Marc Zyngier wrote:
> On 15/09/15 16:41, Suzuki K. Poulose wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>

>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index bdf139e..699554d 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -138,6 +138,9 @@
>>    * The magic numbers used for VTTBR_X in this patch can be found in Tables
>>    * D4-23 and D4-25 in ARM DDI 0487A.b.
>>    */
>> +#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
>> +				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_T0SZ_40B)
>> +
>>   #ifdef CONFIG_ARM64_64K_PAGES
>>   /*
>>    * Stage2 translation configuration:
>> @@ -145,9 +148,8 @@
>>    * 64kB pages (TG0 = 1)
>>    * 2 level page tables (SL = 1)
>>    */
>> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
>> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
>> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
>> +#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1 | \
>> +				 VTCR_EL2_COMMON_BITS)
>>   #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
>>   #else
>>   /*
>> @@ -156,9 +158,8 @@
>>    * 4kB pages (TG0 = 0)
>>    * 3 level page tables (SL = 1)
>>    */
>> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
>> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
>> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
>> +#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1 | \
>> +				 VTCR_EL2_COMMON_BITS)
>>   #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
>>   #endif
>>
>>
>
> This looks OK, but is going to clash badly with 857d1a9 ("arm64: KVM:
> set {v,}TCR_EL2 RES1 bits"). Nothing we can't fix though.
>

As discussed, I will rebase my series on top of 4.3-rc4 to avoid this.

Thanks
Suzuki
