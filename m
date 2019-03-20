From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm: Fix handling of stage2 huge mappings
Date: Wed, 20 Mar 2019 17:24:17 +0000
Message-ID: <20190320172417.6e769373@why.wild-wind.fr.eu.org>
References: <25971fd5-3774-3389-a82a-04707480c1e0@huawei.com>
        <1553004668-23296-1-git-send-email-suzuki.poulose@arm.com>
        <86d0mmynaz.wl-marc.zyngier@arm.com>
        <5e7e40b4-7983-4440-179a-6f107cee5994@arm.com>
        <20190320101126.11ff63af@why.wild-wind.fr.eu.org>
        <4daf0783-fc50-3346-0732-1e3f53c8ccbc@arm.com>
        <20190320103511.11d777b9@why.wild-wind.fr.eu.org>
        <c27d5828-3924-e209-82b6-c9168007867b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c27d5828-3924-e209-82b6-c9168007867b@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry@arm.com, wanghaibin.wang@huawei.com, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, zhengxiang9@huawei.com, yuzenghui@huawei.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 20 Mar 2019 11:12:47 +0000
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Marc,
> 
> On 20/03/2019 10:35, Marc Zyngier wrote:
> > On Wed, 20 Mar 2019 10:23:39 +0000
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> > 
> > Hi Suzuki,
> >   
> >> Marc,
> >>
> >> On 20/03/2019 10:11, Marc Zyngier wrote:  
> >>> On Wed, 20 Mar 2019 09:44:38 +0000
> >>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:  
> >>>    >>>> Hi Marc,  
> >>>>
> >>>> On 20/03/2019 08:15, Marc Zyngier wrote:  
> >>>>> Hi Suzuki,
> >>>>>
> >>>>> On Tue, 19 Mar 2019 14:11:08 +0000,
> >>>>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:  
> 
> ...
> 
> >>>>>> +		if (!pmd_thp_or_huge(old_pmd)) {
> >>>>>> +			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
> >>>>>> +			goto retry;  
> >>>>>   >>  
> >>>>>> +		if (!stage2_pud_huge(kvm, old_pud)) {
> >>>>>> +			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);  
> >>>>>   >>  
> >>>> We should really get rid of the S2_P{U/M}D_* definitions, as they are
> >>>> always the same as the host. The only thing that changes is the PGD size
> >>>> which varies according to the IPA and the concatenation.  
> >>>>   >>  
> >> Also what do you think about using  P{M,U}D_* instead of S2_P{M,U}D_*
> >> above ? I could make that change with the respin.  
> > 
> > Given that this is a fix, I'd like it to be as small as obvious as
> > possible, making it easier to backport.
> > 
> > I'm happy to take another patch for 5.2 that will drop the whole S2_P*
> > if we still think that this should be the case (though what I'd really
> > like is to have architectural levels instead of these arbitrary
> > definitions).  
> 
> I only meant the two new instances added above in the patch. Of course, I
> could send something to fix the existing ones.

I'd rather be consistent, and use the same names all over the code.
Once we decide to change, we do it all in one go.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
