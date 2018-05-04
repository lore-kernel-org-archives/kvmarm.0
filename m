From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 2/4] KVM: arm/arm64: Introduce helpers to manupulate
 page table entries
Date: Fri, 4 May 2018 13:40:23 +0200
Message-ID: <20180504114023.GF10191@C02W217FHV2R.local>
References: <20180501102659.13188-1-punit.agrawal@arm.com>
 <20180501102659.13188-3-punit.agrawal@arm.com>
 <3eab5997-30b2-c51a-ca8e-5545bbadffc0@arm.com>
 <871sevr0n8.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sevr0n8.fsf@e105922-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 01, 2018 at 02:00:43PM +0100, Punit Agrawal wrote:
> Hi Suzuki,
> 
> Thanks for having a look.
> 
> Suzuki K Poulose <Suzuki.Poulose@arm.com> writes:
> 
> > On 01/05/18 11:26, Punit Agrawal wrote:
> >> Introduce helpers to abstract architectural handling of the conversion
> >> of pfn to page table entries and marking a PMD page table entry as a
> >> block entry.
> >>
> >> The helpers are introduced in preparation for supporting PUD hugepages
> >> at stage 2 - which are supported on arm64 but do not exist on arm.
> >
> > Punit,
> >
> > The change are fine by me. However, we usually do not define kvm_*
> > accessors for something which we know matches with the host variant.
> > i.e, PMD and PTE helpers, which are always present and we make use
> > of them directly. (see unmap_stage2_pmds for e.g)
> 
> In general, I agree - it makes sense to avoid duplication.
> 
> Having said that, the helpers here allow following a common pattern for
> handling the various page sizes - pte, pmd and pud - during stage 2
> fault handling (see patch 4).
> 
> As you've said you're OK with this change, I'd prefer to keep this patch
> but will drop it if any others reviewers are concerned about the
> duplication as well.

There are arguments for both keeping the kvm_ wrappers and not having
them.  I see no big harm or increase in complexity by keeping them
though.

Thanks,
-Christoffer
