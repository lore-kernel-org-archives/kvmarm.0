From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH 06/12] kvm-arm: Pass kvm parameter for pagetable
 helpers
Date: Tue, 22 Mar 2016 10:15:11 +0000
Message-ID: <56F11B2F.2080007@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-7-git-send-email-suzuki.poulose@arm.com>
 <20160322093037.GD21047@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160322093037.GD21047@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/03/16 09:30, Christoffer Dall wrote:
> On Mon, Mar 14, 2016 at 04:53:05PM +0000, Suzuki K Poulose wrote:
>> Pass 'kvm' to existing kvm_p.d_* page table wrappers to prepare
>> them to choose between hyp and stage2 page table. No functional
>> changes yet. Also while at it, convert them to static inline
>> functions.
>
> I have to say that I'm not really crazy about the idea of having common
> hyp and stage2 code and having the pgtable macros change behavior
> depending on the type.
>
> Is it not so that that host pgtable macros will always be valid for the
> hyp mappings, because we have the same VA space available etc.?  It's
> just a matter of different page table entry attributes.

Yes, host pgtable macros are still used for hyp mappings, when kvm == NULL.
and we do use explicit accessors (stage2_xxx wherever possible with this series).

>
> Looking at arch/arm/kvm/mmu.c, it looks to me like we would get the
> cleanest separation by separating stuff that touches hyp page tables
> from stuff that touches stage2 page tables.

OK. Here are the routines which deal with both types:

unmap_range, unmap_p{u,m}ds, unmap_ptes, clear_p{g,u,m}_entry

Duplicating them won't be that much of trouble.

> Then you can get rid of the whole kvm_ prefix and directly use stage2
> accessors (which you may want to consider renaming to s2_) directly.

Right.

>
> I think we've seen in the past that the confusion from functions
> potentially touching both hyp and stage2 page tables is a bad thing and
> we should seek to avoid it.

OK, I will respin the series with the proposed changes.


Thanks
Suzuki
