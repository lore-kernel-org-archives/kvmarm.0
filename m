From: Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Don't report clear pmds and puds as huge
Date: Wed, 1 Jul 2015 14:56:36 +0100
Message-ID: <CAPvkgC3y0jEbQBOYdB1xztiFq3b6+6QrWJKF=3rHjr7fP38gDg@mail.gmail.com>
References: <1435752511-7079-1-git-send-email-christoffer.dall@linaro.org>
	<20150701131831.GD21981@e104818-lin.cambridge.arm.com>
	<20150701132838.GE21981@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150701132838.GE21981@e104818-lin.cambridge.arm.com>
Sender: stable-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?B?RGlyayBNw7xsbGVy?= <dirk@dmllr.de>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 July 2015 at 14:28, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Jul 01, 2015 at 02:18:31PM +0100, Catalin Marinas wrote:
>> On Wed, Jul 01, 2015 at 02:08:31PM +0200, Christoffer Dall wrote:
>> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>> > index 2de9d2e..0eeb4f09 100644
>> > --- a/arch/arm64/mm/hugetlbpage.c
>> > +++ b/arch/arm64/mm/hugetlbpage.c
>> > @@ -40,13 +40,13 @@ int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
>> >
>> >  int pmd_huge(pmd_t pmd)
>> >  {
>> > -   return !(pmd_val(pmd) & PMD_TABLE_BIT);
>> > +   return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
>> >  }
>> >
>> >  int pud_huge(pud_t pud)
>> >  {
>> >  #ifndef __PAGETABLE_PMD_FOLDED
>> > -   return !(pud_val(pud) & PUD_TABLE_BIT);
>> > +   return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
>> >  #else
>> >     return 0;
>> >  #endif
>>
>> Thanks for the patch, I'll add the acks/reviews and Fixes: tags.
>>
>> (and I think I'll change pmd_val to pmd_present, same for pud; no
>> functional difference)
>
> A related question - can we ever have PROT_NONE on a huge pmd? I'll
> leave this patch with pmd_val for now, it matches pmd_trans_huge().

Yes PROT_NONE can be used. I have a test case for it in libhugetlbfs
(for HugeTLB) and for THP at:
https://git.linaro.org/people/steve.capper/memory-tests.git

They worked last time I touched them ;-).

Cheers,
--
Steve

>
> --
> Catalin
