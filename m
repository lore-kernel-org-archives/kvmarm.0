From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 12/18] kvm: arm64: Configure VTCR_EL2.SL0 per VM
Date: Thu, 20 Sep 2018 16:25:52 +0100
Message-ID: <d6314798-d81c-e65a-3e56-f8bc4d6f977b@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-13-suzuki.poulose@arm.com>
 <dcc855e4-eb78-ea1b-9456-8efa36deda4e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0BE4A216
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 11:26:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H8G7Fy+PQocJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Sep 2018 11:26:01 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50070.outbound.protection.outlook.com [40.107.5.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3826A4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 11:26:01 -0400 (EDT)
In-Reply-To: <dcc855e4-eb78-ea1b-9456-8efa36deda4e@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 20/09/18 15:25, Auger Eric wrote:
> Hi Suzuki,
> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>> VTCR_EL2 holds the following key stage2 translation table
>> parameters:
>>    SL0  - Entry level in the page table lookup.
>>    T0SZ - Denotes the size of the memory addressed by the table.
>>
>> We have been using fixed values for the SL0 depending on the
>> page size as we have a fixed IPA size. But since we are about
>> to make it dynamic, we need to calculate the SL0 at runtime
>> per VM. This patch adds a helper to compute the value of SL0
>> for a VM based on the IPA size.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v3:
>>   - Update reference to latest ARM ARM.
>>   - Update per-vm VTCR value of SL0.
>>   - Add helpers to decode levels from SL0.
>>   - Didn't pick up Reviewed-by tag from Eric, as there
>>     are some new changes in this version


(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 3fb1d440be6e..5c1487dc5dca 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -121,7 +121,6 @@
>>   #define VTCR_EL2_IRGN0_WBWA        TCR_IRGN0_WBWA
>>   #define VTCR_EL2_SL0_SHIFT 6
>>   #define VTCR_EL2_SL0_MASK  (3 << VTCR_EL2_SL0_SHIFT)
>> -#define VTCR_EL2_SL0_LVL1   (1 << VTCR_EL2_SL0_SHIFT)
>>   #define VTCR_EL2_T0SZ_MASK 0x3f
>>   #define VTCR_EL2_VS_SHIFT  19
>>   #define VTCR_EL2_VS_8BIT   (0 << VTCR_EL2_VS_SHIFT)
>> @@ -148,29 +147,59 @@
>>   /*
>>    * Stage2 translation configuration:
>>    * 64kB pages (TG0 = 1)
>> - * 2 level page tables (SL = 1)
>>    */
>> -#define VTCR_EL2_TGRAN_FLAGS                (VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
>> -#define VTTBR_X_TGRAN_MAGIC         38
>> +#define VTCR_EL2_TGRAN                      VTCR_EL2_TG0_64K
>> +#define VTCR_EL2_TGRAN_SL0_BASE             3UL
> the name if not obvious. I understand this is yet another magic number
> used in the formulae below:
> SL0(PAGE_SIZE, Entry_level) = SL0_BASE(PAGE_SIZE) - Entry_Level
> I first tried to map this onto some spec fields. May be worth a comment?

Sure, I will make that clear.


>
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks
Suzuki
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
