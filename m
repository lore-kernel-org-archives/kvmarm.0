Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502211;
	b=3zj/2peB5dGSuvLBc6SZgY5gXvNnvkV/91GYyX+AU4VttFKMk2fjouqgv4TnZWvmzaVD
	 6rvxtxINgmPuYVyG53Gx7x5xuWRDWlyKzmfAlaCCgW56F+t43Rq03GqBlMaqduizTCi0z
	 iGL18unwNoqgk/sJgtu++S/3Q5glC9gAYkjiznuCEHXAYSqVoMwzP8vhI3TxsJLoAAwCn
	 tEbADc+PoQBZBJJE85CiNrskCD5q3ukqdVI26QuyrR2JDGmCRPvbzZHqUW8tsYUCn2Wvr
	 KHWcrq0P0WHeN0eCcMbp0vtziaM0OUnWF6O2mua7/TRqt17lLvDMhVTuAirJ0j0PrSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502211;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I/lKKMbBLG1C3ERfK2T/2BuXrkJjvJM7GnohfMS18Rk=;
	b=e38ObY/YbHQ0tDrB0/V7zHMgbmn49ZSG9EjdQblYchXNe92xj64gLm3TjN7TVSX/jSHB
	 KolnviCYFOLdWOtK0M22Hsdt/Us4u+FdNT7rmgSbzkGVPS/jZos/wGyMg7YhRCR98koe+
	 WgwMU1RDyAFChxq4d6ILv3bY+uoMcucIWoqFZORZZQWxC3GovWmngZnlGwp80B4uv4FU+
	 24TXw5QvzTpQxWZ3X+pJdlCKjpfPaj9ZAsjiBMgsU16CLiMfg7gfgD+SmZ2thrXaDp65K
	 KW4mPgU4BUqrJYz9R8Urw3Sqz+kuwQaMIbjBlbaHSR6KSrmFWLcMXysG30qvV2SYc3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLVK4c85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20D606A31B;
	Tue, 20 Oct 2026 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLVK4c85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16301F000C4;
	Tue, 20 Oct 2026 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502211;
	bh=I/lKKMbBLG1C3ERfK2T/2BuXrkJjvJM7GnohfMS18Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BLVK4c85jEpKcBasUz9BxREf/MNa9QY55Ld7dqoCHZl6DnHhQhhQYw0KIrGl5qVL5
	 /TSml8VG2zattBjDFMfQ7wZ/zQP5ycJjLH/5LIlK7vJcmg9FkRNRNNN+O9knSI877l
	 YeJ0rEr7MWFVBpVsy3PBM4whHdUAf9nMUgr3EYiEEzkjMtRy3jHyp1v7wsGZrlJkWZ
	 tGE+oASF13ed3kA7O1bJsmNe0sMvoFmpyFxj9M7l/fR2STdGQB00eVz6qAAEqVjI5J
	 6rXhZM7+PwMlQ2/e6LQgWVhUxqymtohoEeeXgrv8YYtN/jjVFIWV4L6T9E63s5wnxL
	 DBMNhMz1mEutw==
Date: Tue, 20 Oct 2026 14:16:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Clear the whole hugetlb folio when
 sanitising MTE tags
Message-ID: <atdoknSMviv1xdqd@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-2-fuad.tabba@linux.dev>
 <atdUzfOA1Obd7Mir@gremlin>
 <CA+EHjTykGoHmDt82Cz=eEeBoqpjDRnhKEVGnOhTprn4dLxLZKQ@mail.gmail.com>
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
In-Reply-To: <CA+EHjTykGoHmDt82Cz=eEeBoqpjDRnhKEVGnOhTprn4dLxLZKQ@mail.gmail.com>

On Tue, Oct 20, 2026 at 02:09:45PM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 20 Oct 2026 12:52:54 +0100, Lorenzo Stoakes (ARM)
> <ljs@kernel.org> wrote:
> [...]
> > On Mon, Oct 19, 2026 at 02:21:01PM +0100, Fuad Tabba wrote:
> > > sanitise_mte_tags() clears the tags of the pages about to be mapped at
> > > stage-2 before marking them tagged. For a hugetlb folio the flag covers
> > > every page in the folio, but the loop only covers the mapping being
> > > installed. Stage-2 maps a folio in pieces for the contiguous hugetlb
> > > sizes, and for any size under dirty logging. The first fault then marks
> > > the whole folio after clearing only its own piece, and the rest keeps
> > > its previous owner's tags for the guest to read.
> >
> > I'm guessing the folio size is always >= size here?
>
> Yes, the stage-2 mapping of a hugetlb VMA is never larger than its
> hugetlb page size, so it always sits within one folio.

OK good! :)

>
> [...]
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
> > > @@ -1514,7 +1514,8 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> > >          if (folio_test_hugetlb(folio)) {
> > >                  /* Hugetlb has MTE flags set on head page only */
> >
> > Is this comment redundant now?
>
> I'd keep it: it's why the whole folio has to be cleared, as the flags
> on the head page cover every page in it.

OK, but there's an inconsistency between the comments in 1/3 and 2/3 (you update
one in 2/3 to reflect what's happening), so maybe worth having the comment from
2/3 on both, rather than this one?

(the PG_arch1,2,3 flags are folio flags unless there's something weird so it's
sort of redundant I think?)

>
> > >                  if (folio_try_hugetlb_mte_tagging(folio)) {
> > > -                        for (i = 0; i < nr_pages; i++, page++)
> > > +                        page = folio_page(folio, 0);
> > > +                        for (i = 0; i < folio_nr_pages(folio); i++, page++)
> >
> > I know it's a stable fix, but the fact that this pattern exists in multiple
> > places really argues for a mte_clear_folio_tags(), which would make this
> > trivially:
> >
> >         mte_clear_folio_tags(folio);
> >
> > And avoid the re-use of page etc.
> >
> > It's not a huge change and makes the next patch in the series simpler too so
> > arguably could be part of the series?
>
> I think you're right about the helper, but I'd rather keep the fixes
> as small as possible for the backports. I'll send
> mte_clear_folio_tags() as a separate patch on top of these, using it
> in mte_sync_tags() too. In v2 the loop uses folio_page(folio, i)
> rather than reusing page.

Sure makes sense, though honestly I think the duplication there means delta of
lines of code is small. But then again, adding a helper in a Fixes: is iffy
itself so fair enough :)

--
Cheers, Lorenzo
