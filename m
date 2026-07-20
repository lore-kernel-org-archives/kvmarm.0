Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6763ED3DA
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784545138; cv=none; b=KHfT9/ijOjBpEuoO3TpszTeHBxHPD0rwsac4Q75lminW1WU66vfqQQliLvj9G/VAQDh8nEbTj6df7Jaw531HMdHvwt2HH7UdE44ZncQ+gSGn+ycUjFKsuYlpD82E2STj7srGt9REl3U3KTB5/VmIQ5DFbHhrTCzdBwkCtNKLdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784545138; c=relaxed/simple;
	bh=PGKIiAYNDa/EGe0gKQyA2U2fbntTXVxEi8KAHrzIWRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gy2J7kuYKTuhO6XrD0x2Ve5CqFu6f3IWe9bwCCgMcYEcyIUkPcqPrFfobzwpFUEF4VYCoxetke51dTTAL2n5rPbOvSa2V40H2kRUCArKOBi8fz20ZXnS1WrY7b+uAd4Rk4ptI+pMMRlypPk1D63xvpcc2xI45elX07yHbb3ObbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mN2uDNMI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mN2uDNMI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 103B02B;
	Mon, 20 Jul 2026 03:58:51 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A752A3F99C;
	Mon, 20 Jul 2026 03:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784545135; bh=PGKIiAYNDa/EGe0gKQyA2U2fbntTXVxEi8KAHrzIWRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mN2uDNMIVdMzh0CfuP1QkIbEB3Rtpj5ewCsezOzA3q9D80YAIClqqBl1xBOVp4oLg
	 xai43SaPI5U/0WpvGlGnCtPRkSjt1u5W/18Qw9UYLEt5PFr3GGx0AhUUiHe5ryZBC4
	 XdRGShD4kdThuvPRr9QgJqfZKSeM15G313zAK6vY=
Date: Mon, 20 Jul 2026 11:58:44 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH] KVM: arm64: ptdump: Flush the last region
Message-ID: <n5yni7vnama2ok2uzmhahrghrioqjbpcqui44v367rqc57qzqu@wfnio5stdmp3>
References: <20260717231233.2299068-1-weilin.chang@arm.com>
 <al3dtUVPxBXY0AJP@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al3dtUVPxBXY0AJP@J2N7QTR9R3.cambridge.arm.com>

On Mon, Jul 20, 2026 at 09:35:01AM +0100, Mark Rutland wrote:
> On Sat, Jul 18, 2026 at 12:12:33AM +0100, Wei-Lin Chang wrote:
> > Currently the stage-2 ptdump calls note_page() at each leaf entry visit.
> > This simply misses the output of the last region, because note_page()
> > only dumps output when it detects a change in level/prot, or when the
> > walk enters a next marker section. The last region in the guest IPA
> > space with the same level/prot is not dumped since there is no change
> > after it.
> > 
> > To dump the final region, manually issue a note_page() call with address
> > BIT(ia_bits) (end of guest IPA space) and level == -1 to trigger a level
> > change after the last region. Additionally treat level == -1 as a last
> > flushing note_page() call and avoid dumping the name of the next marker
> > for this case.
> 
> I think you can use note_page_flush() rather than doing that manually.
> 
> > Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
> > Reported-by: Sashiko AI <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/kvm/ptdump.c | 8 +++++---
> >  arch/arm64/mm/ptdump.c  | 5 +++--
> >  2 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index c9140e22abcf..4096e4a92fae 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -155,11 +155,13 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> >  		.seq		= m,
> >  	};
> >  
> > -	write_lock(&kvm->mmu_lock);
> > +	guard(write_lock)(&kvm->mmu_lock);
> >  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > -	write_unlock(&kvm->mmu_lock);
> > +	if (ret)
> > +		return ret;
> > +	note_page(&st->parser_state.ptdump, BIT(mmu->pgt->ia_bits), -1, 0);
> 
> This can be:
> 
> 	note_page_flush(&st->parser_state.ptdump);
> 
> The level change alone should trigger the dump, so the address doesn't
> need to be at the end of the guest IPA space.
> 
> Importantly, note_page_flush() will pass 0 as the address, which won't
> trigger the checks you try to suppress below.
> 
> Please use note_page_flush() here, and drop the changes to
> arch/arm64/mm/ptdump.c.

Sorry, I shouldn't have omitted this information, but I did try
note_page_flush(). And it gives something like this in the last row:

0x00000000ffc00000-0x0000000000000000   17592186040324M 2   R W px ux  AF BLK

The astronomical size is from (addr - st->start_address). As IA bits for
stage-2 are not close to 64, we'll have large sizes for the last row.
That's one of the reasons I chose to call note_page() with
BIT(pgtable->ia_bits) as addr, to end the ptdump at the end of the guest
IPA space.

Additionally, the last row is combining two ranges:

1. 0x00000000ffc00000-0x0000000100000000   4M       2    R W px ux  AF BLK
2. 0x0000000100000000-0x0000000000000000   BIG_SIZE -    (empty prot)

The attributes are wrong for the large range after
BIT(pgtable->ia_bits). This is because before dumping the last row, the
ptdump code is waiting to be notified of the end of the final region
with all those {R, W, px, ux, AF, BLK} attributes. Using
note_page_flush() essentially tells it the valid range ends at 1 << 64.
So actually using note_page() with BIT(pgtable->ia_bits) is required for
correctness.

The kernel ptdump is not affected by this (at least from my quick test):

0xffffffffff6fe000-0xffffffffff800000        1032K PTE
0xffffffffff800000-0x0000000000000000           8M PMD

Because it uses addresses close to the end of the address space, and its
last leaf PTE entry is an invalid one.

Thanks,
Wei-Lin Chang

> 
> >  
> > -	return ret;
> > +	return 0;
> >  }
> >  
> >  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > index ab9899ca1e5f..fed4e4407e0e 100644
> > --- a/arch/arm64/mm/ptdump.c
> > +++ b/arch/arm64/mm/ptdump.c
> > @@ -194,6 +194,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
> >  	struct ptdump_pg_level *pg_level = st->pg_level;
> >  	static const char units[] = "KMGTPE";
> > +	bool flush = level == -1;
> >  	ptdesc_t prot = 0;
> >  
> >  	/* check if the current level has been folded dynamically */
> > @@ -234,7 +235,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  				  pg_level[st->level].num);
> >  		pt_dump_seq_puts(st->seq, "\n");
> >  
> > -		if (addr >= st->marker[1].start_address) {
> > +		if (addr >= st->marker[1].start_address && !flush) {
> >  			st->marker++;
> >  			pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> >  		}
> 
> If you use note_page_flush(), addr will be 0. As the final marker is at
> BIT(pgtable->ia_bits), this condition cannot fire.
> 
> > @@ -244,7 +245,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  		st->level = level;
> >  	}
> >  
> > -	if (addr >= st->marker[1].start_address) {
> > +	if (addr >= st->marker[1].start_address && !flush) {
> >  		st->marker++;
> >  		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> >  	}
> 
> Likewise here.
> 
> Mark.
