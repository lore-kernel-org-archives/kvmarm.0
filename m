Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618059;
	b=bnSyMGRKhqZ0IUryx8DHqIh07vwmmXBszmfmvErd6X2YuyXYqw70mApEdCiPBKn9xyx3
	 EbRNVKSZWH8Z4/cWo6SbdOjnUC87fAPdsOE4ldHN0iTOksFT67BYrHmJqN3oGr++06bm3
	 x/FUBg/uhOakilMiMNiBnMOFJdQwp/zYMmmuHHP2MUVYjKwhgnuX71ffEGdcT6hSQegnH
	 o5iWI1d7v3WEjjF+2oJo4FJbF/PWX9JB9U5emflRexUuezB0ttFl6WxrzS8sB5HEtu8QI
	 4KrqqDVyBEPJYiF54urW2KlDFDh9ic+oCapyw6vtDxJjWuB9MCM9tXX27N4ylQ+S65Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618059;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=DY8aia7YapKCOdz5WJ2jQHRD2zmcS7bABOsyFFtx64c=;
	b=rVJ5BacKds4W1Ahve+E2IvZcb79k7f1uENjl7MoFLYzZVP9lpFZLdbLLTWV81qQCjyJV
	 e19uR+nj94cOiu5fYevNLnqui6l4vUlQvcvb1vfqCvcM5pitItN/1DdwN9XVGcmg0klkQ
	 M1DQdm/3aWT73voPO7badyDgjoxkIajtCr58xD1997z4ovdzdSO/sW639MfF634igfQ0Y
	 jMxDMFK+lFyJbUio0P01xF4x9e7gibEQWZbnU5Er9BN9RTdj02je1Tap2Vxv1OOrQWgLy
	 e9h1UFby4bORZY7c8TgdZdZ8Z0u7afATk8lbdqQEb3thwdMFhuLgmKHWVDRiiNENj9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="l2OM/H/5";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88A4606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 14:47:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B88A4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l2OM/H/5
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D0F42F;
	Wed, 25 Nov 2026 06:47:35 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF1A03F632;
	Wed, 25 Nov 2026 06:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795618058; bh=l1JhVNA+zt4be9zTzbvNbG+uFwpdbDUm3ObDUX3MzXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2OM/H/5dfYUvk5Kf64CY6foGK+MBpOmJLMtgDjS8++vXtlWTqexr1WTiNtVFVF90
	 V/HoDVXCtSg1kxgnOdId8X/plBcaaAcOu45K3QEX8YnADJU7BFl6MG97cjx1DHKNmA
	 L7vI7p47l0lY3sbJYwhCdNwfi6NZHHKk/2Cw58N4=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Date: Wed, 25 Nov 2026 14:47:27 +0000
Message-ID: <awb0_2zqPUQYdrTZ@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <auONmOc-nYsQwCnG@LeoBrasDK>
References: <20261026144413.441566-1-leo.bras@arm.com> <at-lSy7H-K60LhCB@kernel.org> <auCOj9dgk42AE1WX@LeoBrasDK> <auExh5laWQbUKmUY@kernel.org> <auONmOc-nYsQwCnG@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 29, 2026 at 06:20:05PM +0000, Leonardo Bras wrote:
> On Tue, Oct 27, 2026 at 04:19:35PM -0700, Oliver Upton wrote:
> > On Tue, Oct 27, 2026 at 11:44:15AM +0000, Leonardo Bras wrote:
> > > > I'm pretty sure I shared this feedback before, but patches that enable
> > > > DBM do not make sense in isolation. We need a single series that
> > > > contains the DBM enablement as well as the corresponding HDBSS support.
> > > >
> > > 
> > > Right, 
> > > My reasoning is that we can discuss this new version, and make the needed 
> > > changes, so Tian could pick this for his own patch series for the next 
> > > version. I do not intend to get this merged by itself.
> > > 
> > > Next time I will make sure to state this in the cover letter so it's clear.
> > 
> > Can you just work this out off-list? Let's keep the on-list dialogue
> > consolidated to a single series to review.
> 
> Sure, will try to reduce this noise in kvmarm.
> 
> > 
> > > > The abstract permission flags need to have a WRITE an DIRTY state, which
> > > > we then map to hardware based on the capabilities of the system.
> > > > 
> > > > !FEAT_HAFDBS:
> > > > 
> > > > 	DIRTY	=> S2AP[1]
> > > > 	WRITE	=> S2AP[1]
> > > > 
> > > > FEAT_HAFDBS:
> > > > 
> > > > 	DIRTY	=> S2AP[1]
> > > > 	WRITE	=> DBM
> > > > 
> > > 
> > > I agree that it could work, and my first version was based on that.
> > > 
> > > But looks weird to me that we have to decide the writable bit based on 
> > > having a feature enabled.
> > > 
> > > Take in account that we can only have DBM being the writable bit while 
> > > HAFDBS is enabled (not only present), and that it is just enabled during 
> > > dirty-tracking. 
> > > 
> > > It means we would need to convert the whole pagetable between DIRTY=S2AP[1] 
> > > and DIRTY=DBM every time we enable or disable dirty-tracking.
> > > 
> > > My suggestion with this series is to have WRITE=DIRTY=S2AP[1] at all 
> > > times, and have DBM to act as a "can be promoted to writable on write" bit.
> > > This way we don't actually need to convert between encodings, and it still 
> > > works and complies with the architecture.
> > 
> > There's no such "can be promoted to writable on write" in the indirect
> > permission model.
> 
> Well, IIUC it's kind of the default behavior, right?
> Direct - DBM means HW can promote that page RO->RW, with HAFDBS=on
> S2PIE  - All pages can be promoted RO->RW, as long as HAFDBS=on
> 
> > This is why I'm suggesting that we align the abstract
> > permission bits (i.e. KVM_PGTABLE_PROT_*) with the architecture's own
> > abstracted permissions (e.g. uX, pX, RO, RW).
> > 
> 
> I think the approach you suggest makes sense, and it makes it simpler to 
> deal with permission indirection in the future. In order to do like that, 
> while keeping a single encoding for direct permission, I suggest we have:
> 
> -	KVM_PGTABLE_PROT_W			= BIT(2),
> +	KVM_PGTABLE_PROT_DIRTY			= BIT(2),
> ...
> +	KVM_PGTABLE_PROT_DBM			= BIT(6),
> ...
> 
> +#define KVM_PGTABLE_PROT_W	(KVM_PGTABLE_PROT_DBM | 
> +				 KVM_PGTABLE_PROT_DIRTY)
> 
> (Rationale is: it's writable if it's either dirty, or can be made dirty by 
> hardware on a write)
> 
> And then replacing by PROT_DIRTY the uses of PROT_W which were only 
> tracking the fact it's dirty. I tracked just a couple of those.
> 
> When detecting the PROT_* based in PTE encoding, we track PROT_DIRTY, and 
> PROT_DBM individually. The same can be done in nested, as we can just 
> ignore the PROT_DBM for shadow pagetables, given we want, IIUC, to fault 
> and update the original pagetables.
> 
> That would avoid switching between encodings while toggling HACDBS, and 
> while making use of the DBM without directly associating it with the write 
> permission.
> 
> What do you think?
> 
> > That composes nicely with nested virt as it is unambiguous what
> > permissions we're trying to represent in a shadow stage-2. And in the
> > non-nested case you can just lay down writable-dirty translations for
> > most things and use writable-clean when necessary for HDBSS.
> > 
> > > > Beyond making the whole HAFDBS easy to reason about, I want this for
> > > > FEAT_S2PIE which reimagines bit 7 as a literal dirty bit that can be
> > > > managed by software or hardware.
> > > 
> > > Humm, and would not that work with the above suggested approach?
> > > I mean, bit 7 (Dirty, S2AP[1]) will both mean WRITE/DIRTY, but it will be 
> > > able to get promoted (nonW->W, or clean->dirty) based on the indirect 
> > > permissions.
> > 
> > There's a bit more though. We need to have an entry in S2PIR_EL2 that
> > encodes write permission and select that with PIIndex. So then we wind
> > up mapping the abstract WRITE permission bit to two fields into the
> > descriptor rather than 1.
> 
> Makes sense to me now.
> 
> Sorry I took long to reply your message, I was reading the docs for S2PIE 
> and thinking on a solution that would make sense for it in the future as 
> well.
> 
> I hope it's enough, but if it's not, let me know of any suggestions or 
> requisites.
> 

Friendly ping :)


