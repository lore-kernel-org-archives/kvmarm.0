From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 02/17] arm64: Cleanup VTCR_EL2 and VTTBR field values
Date: Fri, 8 Apr 2016 13:45:41 +0100
Message-ID: <5707A7F5.1010104@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-3-git-send-email-suzuki.poulose@arm.com>
 <20160408124346.GN8961@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA80540B58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:44:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jTvjp7kGYyef for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 08:44:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91A914053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:44:18 -0400 (EDT)
In-Reply-To: <20160408124346.GN8961@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/04/16 13:43, Christoffer Dall wrote:
>> +#define VTCR_EL2_T0SZ_IPA	VTCR_EL2_T0SZ_40B
>> +#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
>> +				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_SL0_LVL1 | \
>> +				 VTCR_EL2_RES1 | VTCR_EL2_T0SZ_IPA)
>>   #ifdef CONFIG_ARM64_64K_PAGES
>>   /*
>>    * Stage2 translation configuration:
>> - * 40bits input  (T0SZ = 24)
>>    * 64kB pages (TG0 = 1)
>>    * 2 level page tables (SL = 1)
>>    */
>> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
>> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
>> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
>> -				 VTCR_EL2_RES1)
>> -#define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
>> +#define VTCR_EL2_TGRAN_FLAGS	(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
>> +#define VTTBR_X_TGRAN_MAGIC		38
>>   #else
>>   /*
>>    * Stage2 translation configuration:
>> - * 40bits input  (T0SZ = 24)
>>    * 4kB pages (TG0 = 0)
>>    * 3 level page tables (SL = 1)
>>    */
>> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
>> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
>> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
>> -				 VTCR_EL2_RES1)
>> -#define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
>> +#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
>> +#define VTTBR_X_TGRAN_MAGIC		37
>>   #endif
>
> why do we add VTCR_EL2_SL0_LVL1 in both the common bits and TGRAN_FLAGS
> define?

Oops! It should only be part of TGRAN_FLAGS. Thanks for spotting, will fix it.


> Otherwise:
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>


Thanks
Suzuki
