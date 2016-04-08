From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 07/17] kvm-arm: arm32: Introduce stage2 page table helpers
Date: Fri, 8 Apr 2016 15:39:53 +0100
Message-ID: <5707C2B9.1020000@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-8-git-send-email-suzuki.poulose@arm.com>
 <20160408124332.GL8961@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0EE409A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 10:38:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S76jTIUFbmEW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 10:38:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB904053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 10:38:29 -0400 (EDT)
In-Reply-To: <20160408124332.GL8961@cbox>
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
> On Mon, Apr 04, 2016 at 05:26:07PM +0100, Suzuki K Poulose wrote:
>> Define the page table helpers for walking the stage2 pagetable
>> for arm. Since both hyp and stage2 have the same number of levels,
>> as that of the host we reuse the host helpers.
>>
>> The exceptions are the p.d_addr_end routines which have to deal
>> with IPA > 32bit, hence we use the open coded version of their host helpers
>> which supports 64bit.
>>


>> +#ifndef __ARM_S2_PGTABLE_H_
>> +#define __ARM_S2_PGTABLE_H_
>> +
>> +#define stage2_pgd_none(pgd)				pgd_none(pgd)
>> +#define stage2_pgd_clear(pgd)				pgd_clear(pgd)
>> +#define stage2_pgd_present(pgd)				pgd_present(pgd)
>> +#define stage2_pgd_populate(mm, pgd, pud)		pgd_populate(mm, pgd, pud)
>> +#define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
>> +#define stage2_pud_free(mm, pud)			pud_free(mm, pud)
>> +
>> +#define stage2_pud_none(pud)				pud_none(pud)
>> +#define stage2_pud_clear(pud)				pud_clear(pud)
>> +#define stage2_pud_present(pud)				pud_present(pud)
>> +#define stage2_pud_populate(mm, pud, pmd)		pud_populate(mm, pud, pmd)
>> +#define stage2_pmd_offset(pud, address)			pmd_offset(pud, address)
>> +#define stage2_pmd_free(mm, pmd)			pmd_free(mm, pmd)
>> +
>> +#define stage2_pud_huge(pud)				pud_huge(pud)
>
> could we get rid of the mm parameter to all these stage2_ versions above
> and simply implement them with the generic functions passing NULL in the
> definitions instead?

We could, I retained it just to match the corresponding host version. Will change
it in the next version.

>
> Otherwise:
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>


Thanks
Suzuki
