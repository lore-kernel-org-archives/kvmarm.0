Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDFC417BF9
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784551081; cv=none; b=T8IYacoyKd2S7mYEvDDv0Bm6F/4qobeSXAezfWEjAK7qZvkv+8GmZZDrvWF0W4gLmMPsWZzaFDRImR8fR1j4vHURlwa2lRccve3zQipPUe8q+LirgV2hQWwHnmzhKOFLm6g2Qshtp6ckkMr1ikOvE3c0xMw+JufycOFjrM7HsfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784551081; c=relaxed/simple;
	bh=dbpOFMs5C74LI3zyshZaLrv6ZWnGUmyhI2S0k6hyyFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X28MvkFgANp/sFgpHOAzKrIOyQmZkMA+AAj+Ergku0vviag3sM8PqfvFeHbPM/jP7f5RwM/VEZ5mhEXbPr2PAZXk4TdlNN94k3zYek6p/mzW3pzdzNJ9rfHcvmz9IGH3mgN6Hlv1Qi1/XRs6R9vuMkBcGO+8JSxNekw3bDtfiPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=srLaFvII; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="srLaFvII"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3239D2B;
	Mon, 20 Jul 2026 05:37:55 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0F803F99C;
	Mon, 20 Jul 2026 05:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784551079; bh=dbpOFMs5C74LI3zyshZaLrv6ZWnGUmyhI2S0k6hyyFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srLaFvII/lOxUUq3ySkR7P12tmghDu5HtmMdZQWuAWkhMSs+6mIWWuCyiDpiwkUse
	 pjiyr6r4tNRBGOjkoiSVuGj3cZmyzIdLtqY3S7M5JK8Wkwb0/gnnxlmyV+UV16yres
	 scEQOuzK1OskHiOFdvyKPR9iWzO2uStnsWe6OPbE=
Date: Mon, 20 Jul 2026 13:37:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH] KVM: arm64: ptdump: Flush the last region
Message-ID: <al4Wn4Wb6GrOAw70@J2N7QTR9R3.cambridge.arm.com>
References: <20260717231233.2299068-1-weilin.chang@arm.com>
 <al3dtUVPxBXY0AJP@J2N7QTR9R3.cambridge.arm.com>
 <n5yni7vnama2ok2uzmhahrghrioqjbpcqui44v367rqc57qzqu@wfnio5stdmp3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n5yni7vnama2ok2uzmhahrghrioqjbpcqui44v367rqc57qzqu@wfnio5stdmp3>

On Mon, Jul 20, 2026 at 11:58:44AM +0100, Wei-Lin Chang wrote:
> On Mon, Jul 20, 2026 at 09:35:01AM +0100, Mark Rutland wrote:
> > On Sat, Jul 18, 2026 at 12:12:33AM +0100, Wei-Lin Chang wrote:
> > > @@ -155,11 +155,13 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> > >  		.seq		= m,
> > >  	};
> > >  
> > > -	write_lock(&kvm->mmu_lock);
> > > +	guard(write_lock)(&kvm->mmu_lock);
> > >  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > > -	write_unlock(&kvm->mmu_lock);
> > > +	if (ret)
> > > +		return ret;
> > > +	note_page(&st->parser_state.ptdump, BIT(mmu->pgt->ia_bits), -1, 0);
> > 
> > This can be:
> > 
> > 	note_page_flush(&st->parser_state.ptdump);
> > 
> > The level change alone should trigger the dump, so the address doesn't
> > need to be at the end of the guest IPA space.
> > 
> > Importantly, note_page_flush() will pass 0 as the address, which won't
> > trigger the checks you try to suppress below.
> > 
> > Please use note_page_flush() here, and drop the changes to
> > arch/arm64/mm/ptdump.c.
> 
> Sorry, I shouldn't have omitted this information, but I did try
> note_page_flush(). And it gives something like this in the last row:
> 
> 0x00000000ffc00000-0x0000000000000000   17592186040324M 2   R W px ux  AF BLK
> 
> The astronomical size is from (addr - st->start_address). As IA bits for
> stage-2 are not close to 64, we'll have large sizes for the last row.

Ok. That's a bug in the current implementation of note_page_flush(),
then. The *intent* is that note_page_flush() is used to terminate
output, and we should mak it work.

Do we need to pass additional information, or do we have the necessary
values in (or accessible from) struct ptdump_state?

> That's one of the reasons I chose to call note_page() with
> BIT(pgtable->ia_bits) as addr, to end the ptdump at the end of the guest
> IPA space.
> 
> Additionally, the last row is combining two ranges:
> 
> 1. 0x00000000ffc00000-0x0000000100000000   4M       2    R W px ux  AF BLK
> 2. 0x0000000100000000-0x0000000000000000   BIG_SIZE -    (empty prot)
> 
> The attributes are wrong for the large range after
> BIT(pgtable->ia_bits). This is because before dumping the last row, the
> ptdump code is waiting to be notified of the end of the final region
> with all those {R, W, px, ux, AF, BLK} attributes. Using
> note_page_flush() essentially tells it the valid range ends at 1 << 64.
> So actually using note_page() with BIT(pgtable->ia_bits) is required for
> correctness.
> 
> The kernel ptdump is not affected by this (at least from my quick test):
> 
> 0xffffffffff6fe000-0xffffffffff800000        1032K PTE
> 0xffffffffff800000-0x0000000000000000           8M PMD

Yes, it's not affected because its final VA is 0xffffffffffffffff (i.e.
2^64i - 1), and so using 0 as the next address does the right thing
modulo 64 bits.

We use ptdump for non-kernel tables today (e.g. the EFI mm), so
presumably they suffer the same problem?

Mark.
