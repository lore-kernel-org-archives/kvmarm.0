Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108E751356F;
	Tue,  8 Sep 2026 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863729; cv=none; b=s3yTT+KJZBqCIE5Z7ve64IVvYWKJe0SqzTKVhX/FubRwVhoSutSB5ErQa2KZ+zvsqaSC25/9UN1fzs9/mDDaRAJ8pBfRKkAktVNbCPQ/g9iwipTndXrTqqWBzRnLUIuix7fK/xqLDkA+h7msKga9YcBjJ/waJGWVMJjpB930enI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863729; c=relaxed/simple;
	bh=sxGzBQXSWU9yVu1UL94N88BtQ3fxazG6iyy/h1vW5a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9Dpp1U1qKbK3NWUxg8BgDT/mZ577GlXLFLg8hTgBcs7VULm43HbBnTsMcVoj5ygNjKFqBxczAW9b8mE7RMAwwAWqAWHKijfwzwt1KNYj2Ispi3UBmIO/acLjFTVdkHDgfq60Qef4ejunawsh2n5ohRkumtmuI8TKQ8WIxlljL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S7HTKT6P; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S7HTKT6P"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF4491476;
	Tue,  8 Sep 2026 03:35:22 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D75C53F528;
	Tue,  8 Sep 2026 03:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788863726; bh=sxGzBQXSWU9yVu1UL94N88BtQ3fxazG6iyy/h1vW5a4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7HTKT6PFTD0ZOzaES9LR4h7RRq5sfH2j0TVuEpavv/X0U7fjxXPdcmZUfkYfukES
	 U6zU3Hkw7f+yVtbTwmh9V07VhxoZzltYVR/tBzmjkIHPbaUPIxRRQmFwvWPrmhFldh
	 j3PlaeQiPG9TbttT6HLpe2p5KZTUn1PVR/fd3oRo=
Date: Tue, 8 Sep 2026 11:35:02 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, 
	sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <yt6esgk3mzstm6m7diwmspvcomqqrwo4b5hwn4lrgg63yk2nwf@i3rsml4swpls>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-19-vdonnefort@google.com>
 <20260803105411.B6ACE1F000E9@smtp.kernel.org>
 <ap6QjjJxysWVYCVM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap6QjjJxysWVYCVM@google.com>

On Mon, Sep 07, 2026 at 11:23:10AM +0100, Vincent Donnefort wrote:

[...]

> > 
> > > +	struct mm_struct *mm = current->mm;
> > > +	struct kvm_memory_slot *memslot;
> > 
> > [ ... ]
> > 
> > > +	idx = srcu_read_lock(&kvm->srcu);
> > > +	memslot = gfn_to_memslot(kvm, gfn);
> > > +	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> > > +	if (kvm_is_error_hva(hva) || !writable) {

[...]

> > > +		ret = -EFAULT;
> > > +		goto unlock_srcu;
> > > +	}
> > > +
> > > +	mmap_read_lock(mm);
> > > +	ret = pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE, pages);

[...]

> > > +	mmap_read_unlock(mm);
> > > +	if (ret != nr_pages) {
> > > +		if (ret > 0)
> > > +			unpin_user_pages(pages, ret);
> > > +		ret = -EFAULT;
> > > +		goto unlock_srcu;
> > > +	}
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + size - 1);
> > 
> > [Severity: Critical]
> > Is there a Time-of-Check to Time-of-Use race here since the MMU
> > notifier retry protocol is missing?
> > 
> > The resolution of the HVA to PFNs via pin_user_pages() happens outside
> > kvm->mmu_lock. A concurrent host MMU invalidation could unmap the region
> > and remove the pkvm_mapping, and a subsequent guest fault could establish
> > a new huge page mapping at the same IPA.
> 
> This is called on the back of a hypervisor request. This is only for
> protected-VM and we do have an existing pin on the huge-page, preventing
> any unmap. 
> 
> We do not use MMU notifier for protected VMs.

If I am not mistaken, pKVM gives up MMU notifiers, and uses pins to keep
the allocated folios around. A userspace unmap/remap can still happen,
just that the folio will survive.

This means hva->page/folio/pfn lookups could fail or resolve to a
different folio from the one returned from the initial pin.

This is also an issue when using transparent_hugepage_adjust() in patch
20. It walks the userspace page table to look at the mapping level,
which could have changed after the first pin_user_pages().

Thanks,
Wei-Lin Chang

> 
> -- 
> Vincent
> 

[...]
