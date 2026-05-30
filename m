Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F50189F43
	for <kvmarm@lists.linux.dev>; Sat, 30 May 2026 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100850; cv=none; b=OrP1EUtqR5rEh53CPtX6HpEmJrxjj2B+wtp7EZAzzRw3OlJNc9RGZHOU8kmRXdrh5csNl5UomHt+mJcDRgSRIw+8lc+ZFtQhWIhciDi63RkkEOXvSyXfu/7IDDf8vZksLlMhcwjitaxO4kmHw0cYBUaARJ+rlHRVqO2oExqhRBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100850; c=relaxed/simple;
	bh=3u91ek+mgurxIUzlX/F4MMk2CTrpEqTFfAJpfXkzi8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDtsSs1wQthNUlDaQBk8yPPlTvuk99zTa3cpOO2GSnTuBmwFa28GYUzL/0bVW9KgDyIpiLmoANxVjo6rWW3RgO3p/Opn0k38W7xhFqeij0CywJCqO4/GpaX0UDAbIPvAaUiKf9fpvINQarNWhR+7qlnKJI8AVPJLp7sKG/r3ODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=magV8yMh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="magV8yMh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9374F2379;
	Fri, 29 May 2026 17:27:20 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE6EB3F632;
	Fri, 29 May 2026 17:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780100845; bh=3u91ek+mgurxIUzlX/F4MMk2CTrpEqTFfAJpfXkzi8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=magV8yMhbydlP6Mzekf8LceE5Yfv+ta9AcsS8GqoRsbr5tqgSdKHDKMQ9CIYWD4qq
	 oszU2C9MNDJNtw+OYiYv8opsv5eKbNe4BAcGo4LbaV+V6OX7/JW5znzc/yCJB+N46U
	 bnGE8u0LsuHQBSK5mbJo/p9oomt+WQ9xldJXcl+A=
Date: Sat, 30 May 2026 01:27:11 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 09/17] KVM: arm64: Move VMA-related information to
 kvm_s2_fault_vma_info
Message-ID: <mt5aqxlrtoosxbtqcchrzhxm5eitbq3dygvynivd4vza7ffppm@rl56r2yi5qqe>
References: <20260316175451.1866175-1-maz@kernel.org>
 <20260316175451.1866175-10-maz@kernel.org>
 <20260318142215.GB3915656@e124191.cambridge.arm.com>
 <CA+EHjTwbxTHr_fzSFD38cG4ZMj6XKr3L=o+=8T13XDQF0n6Raw@mail.gmail.com>
 <87ecldcxzj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecldcxzj.wl-maz@kernel.org>

Hi,

On Sat, Mar 21, 2026 at 09:50:40AM +0000, Marc Zyngier wrote:
> On Wed, 18 Mar 2026 16:14:19 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> > 
> > Hi Joey,
> > 
> > First, thanks for the reviews and the comments on my series. You're
> > right about my changes wrongly editing "page". I wanted it to be as
> > mechanical as possible to make it easy to review, but it ended up
> > being too mechanical.
> > 
> > <snip>
> > 
> > > > -     /* Mark the fault->page dirty only if the fault is handled successfully */
> > > > -     if (fault->writable && !ret)
> > > > -             mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
> > > > +     /* Mark the page dirty only if the fault is handled successfully */
> > > > +     if (fault->writable && !ret) {
> > > > +             phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
> > > > +             ipa &= ~(mapping_size - 1);
> > > > +             mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
> > >
> > > I don't understand this change, why do we need to mask stuff now?
> > 
> > Let me see if _I_ understand it (Marc, please correct me if I'm wrong).
> > 
> > Before this patch, fault->gfn and fault->vma_pagesize were mutable,
> > and transparent_hugepage_adjust() modified both directly. In addition
> > to this being confusing (which gfn is this: the host /canonical or the
> > nested one?), it made it more difficult to separate the logic.
> > 
> > So, to mark a dirty page, it did this:
> > -             mark_page_dirty_in_slot(kvm, s2fd->memslot,
> > get_canonical_gfn(s2fd, fault));
> > 
> > which relied on the old struct fault to calculate the canonical gfn
> > using the (magically) THP adjusted fault->vma_pagesize.
> > 
> > Now that fault (or s2vi, its successor in this case) isn't mutable, we
> > need to get the canonical gfn using the host mapping size.
> 
> It's exactly that, and it is slightly clearer if you look at how
> mapping_size is updated:
> 
> 	mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
> 						   s2fd->hva, &fault->pfn,
> 						   &gfn);
> 
> The faulting IPA is represented by 'gfn', and gets correctly updated
> by the helper. But that doesn't adjust the 'canonical' IPA, which is
> used for any memslot related update.
> 
> So if we need to call into mark_page_dirty_in_slot(), we really need
> to pick the base of the region we are actually marking dirty, hence
> the masking of the bottom bits.
> 
> Does this make sense? This is one of the area where the constification
> results in slightly more complicated code, as we can't update things
> in place anymore.

Sorry for being late, I think I am missing something:
If dirty logging is enabled, then the mapping size would be capped at
PAGE_SIZE, and THP adjust wouldn't happen. Why do we still need to align
the canonical IPA down?

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
