Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230ADC433C1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 10:30:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6666F619A6
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 10:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6666F619A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A314B2DF;
	Tue, 30 Mar 2021 06:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 16QE5ZpPUTmg; Tue, 30 Mar 2021 06:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 977F74B29C;
	Tue, 30 Mar 2021 06:30:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A7F4B281
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:30:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ViwU8skV+o5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 06:30:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0C114B23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:30:22 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F15E76195C;
 Tue, 30 Mar 2021 10:30:17 +0000 (UTC)
Date: Tue, 30 Mar 2021 11:30:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210330103013.GD18075@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Mar 29, 2021 at 05:06:51PM +0100, Steven Price wrote:
> On 28/03/2021 13:21, Catalin Marinas wrote:
> > On Sat, Mar 27, 2021 at 03:23:24PM +0000, Catalin Marinas wrote:
> > > On Fri, Mar 12, 2021 at 03:18:58PM +0000, Steven Price wrote:
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 77cb2d28f2a4..b31b7a821f90 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >   	if (vma_pagesize == PAGE_SIZE && !force_pte)
> > > >   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> > > >   							   &pfn, &fault_ipa);
> > > > +
> > > > +	if (fault_status != FSC_PERM && kvm_has_mte(kvm) && pfn_valid(pfn)) {
> > > > +		/*
> > > > +		 * VM will be able to see the page's tags, so we must ensure
> > > > +		 * they have been initialised. if PG_mte_tagged is set, tags
> > > > +		 * have already been initialised.
> > > > +		 */
> > > > +		struct page *page = pfn_to_page(pfn);
> > > > +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
> > > > +
> > > > +		for (i = 0; i < nr_pages; i++, page++) {
> > > > +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> > > > +				mte_clear_page_tags(page_address(page));
> > > > +		}
> > > > +	}
> > > 
> > > This pfn_valid() check may be problematic. Following commit eeb0753ba27b
> > > ("arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory"), it returns
> > > true for ZONE_DEVICE memory but such memory is allowed not to support
> > > MTE.
> > 
> > Some more thinking, this should be safe as any ZONE_DEVICE would be
> > mapped as untagged memory in the kernel linear map. It could be slightly
> > inefficient if it unnecessarily tries to clear tags in ZONE_DEVICE,
> > untagged memory. Another overhead is pfn_valid() which will likely end
> > up calling memblock_is_map_memory().
> > 
> > However, the bigger issue is that Stage 2 cannot disable tagging for
> > Stage 1 unless the memory is Non-cacheable or Device at S2. Is there a
> > way to detect what gets mapped in the guest as Normal Cacheable memory
> > and make sure it's only early memory or hotplug but no ZONE_DEVICE (or
> > something else like on-chip memory)?  If we can't guarantee that all
> > Cacheable memory given to a guest supports tags, we should disable the
> > feature altogether.
> 
> In stage 2 I believe we only have two types of mapping - 'normal' or
> DEVICE_nGnRE (see stage2_map_set_prot_attr()). Filtering out the latter is a
> case of checking the 'device' variable, and makes sense to avoid the
> overhead you describe.
> 
> This should also guarantee that all stage-2 cacheable memory supports tags,
> as kvm_is_device_pfn() is simply !pfn_valid(), and pfn_valid() should only
> be true for memory that Linux considers "normal".

That's the problem. With Anshuman's commit I mentioned above,
pfn_valid() returns true for ZONE_DEVICE mappings (e.g. persistent
memory, not talking about some I/O mapping that requires Device_nGnRE).
So kvm_is_device_pfn() is false for such memory and it may be mapped as
Normal but it is not guaranteed to support tagging.

For user MTE, we get away with this as the MAP_ANONYMOUS requirement
would filter it out while arch_add_memory() will ensure it's mapped as
untagged in the linear map. See another recent fix for hotplugged
memory: d15dfd31384b ("arm64: mte: Map hotplugged memory as Normal
Tagged"). We needed to ensure that ZONE_DEVICE doesn't end up as tagged,
only hoplugged memory. Both handled via arch_add_memory() in the arch
code with ZONE_DEVICE starting at devm_memremap_pages().

> > > I now wonder if we can get a MAP_ANONYMOUS mapping of ZONE_DEVICE pfn
> > > even without virtualisation.
> > 
> > I haven't checked all the code paths but I don't think we can get a
> > MAP_ANONYMOUS mapping of ZONE_DEVICE memory as we normally need a file
> > descriptor.
> 
> I certainly hope this is the case - it's the weird corner cases of device
> drivers that worry me. E.g. I know i915 has a "hidden" mmap behind an ioctl
> (see i915_gem_mmap_ioctl(), although this case is fine - it's MAP_SHARED).
> Mali's kbase did something similar in the past.

I think this should be fine since it's not a MAP_ANONYMOUS (we do allow
MAP_SHARED to be tagged).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
