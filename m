From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/15] arm64: Introduce helpers for page table levels
Date: Wed, 07 Oct 2015 10:26:14 +0100
Message-ID: <5614E536.9040007@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-4-git-send-email-suzuki.poulose@arm.com>
 <20151007082652.GM9011@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9702C413E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 05:24:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogQZwl+s276L for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 05:24:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E8E412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 05:24:21 -0400 (EDT)
In-Reply-To: <20151007082652.GM9011@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/15 09:26, Christoffer Dall wrote:
> Hi Suzuki,
> 
> On Tue, Sep 15, 2015 at 04:41:12PM +0100, Suzuki K. Poulose wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>
>> Introduce helpers for finding the number of page table
>> levels required for a given VA width, shift for a particular
>> page table level.
>>
>> Convert the existing users to the new helpers. More users
>> to follow.
>>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/include/asm/pgtable-hwdef.h |   15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
>> index 24154b0..ce18389 100644
>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>> @@ -16,13 +16,21 @@
>>  #ifndef __ASM_PGTABLE_HWDEF_H
>>  #define __ASM_PGTABLE_HWDEF_H
>>  
>> +/*
>> + * Number of page-table levels required to address 'va_bits' wide
>> + * address, without section mapping
>> + */
>> +#define ARM64_HW_PGTABLE_LEVELS(va_bits) (((va_bits) - 4) / (PAGE_SHIFT - 3))
> 
> I don't understand the '(va_bits) - 4' here, can you explain it (and add a
> comment to that effect) ?

I just had a chat with Catalin, who did shed some light on this.
It all has to do with rounding up. What you would like to have here is:

#define ARM64_HW_PGTABLE_LEVELS(va_bits) DIV_ROUND_UP(va_bits - PAGE_SHIFT, PAGE_SHIFT - 3)

where (va_bits - PAGE_SHIFT) is the total number of bits we deal
with during a page table walk, and (PAGE_SHIFT - 3) is the number
of bits we deal with per level.

The clue is in how DIV_ROUND_UP is written:

#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

which gives you Suzuki's magic formula.

I'd vote for the DIV_ROUND_UP(), which will make things a lot more readable.

	M.
-- 
Jazz is not dead. It just smells funny...
