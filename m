Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9426D229B38
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984370; cv=none; b=meJPW6l1H9LBmFwdmWkk/22/S653o/t3bb0SnlaL5V6btq92wXDZhlBRp33uml3Wed1NzjfQqv+hlN/8JzLCy8QxsWnyyYZGSiIz6GDW22KGiHdTfu2A+uDqobDMXHAA9I0BBVHZFTjETT9VsyVorfotdIKo7HSKy8SwdYg1tws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984370; c=relaxed/simple;
	bh=1hEqkjv2D0hSRyFz8anD5p5B//7oIENYTkt9Kf7Orec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0gOfjX5ldM42Bgzwr1pzKXLa9TBDJ9d7sTcQLkvgTBSZJvkswWKWQc0kh88Wm9HBd+r5jEwsRi7WMef3XW1E6NmA9auC5q2dljL06a1gZNu8gJSJmUvWvUNVD5oYYvy3601CYoLLjRUAsQRsMFrzf64vzmV2hQ1ZCwtaPgvDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5YMg3U1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5YMg3U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39ACC4CEF1;
	Fri,  9 Jan 2026 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767984370;
	bh=1hEqkjv2D0hSRyFz8anD5p5B//7oIENYTkt9Kf7Orec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S5YMg3U1aJw9i8kle0Bnt+0wTkXcr99qOrAizB76xRIO/do+diMXDEZmekcBDOhr3
	 PHph5ANqVIzo9SvHBSxJUcP/Y7R8W+dv2Xoyk3QVh4DFDn5Tb7XQ8lViu/XWq7pyTr
	 KfIRBYxOyeJXGZyiqbu6NF9M3sP3alryHj93kBUn85RjVM15Vk1Vhdgc9Ly9uy+0ZB
	 vxti68FhS59GC2VaVDQQ40lKdd6AxDm+pHQ0pxI0wZjNSxGCqXLCmQ6zmok1cQ8vHl
	 XTT7C2yQEDMHkisKyv5cPeyWdctBdmQx5uIsq/jNpQuJJQ92QMderinB4b2SCjJhLZ
	 FLEHmkT3bRV3w==
Date: Fri, 9 Jan 2026 18:46:04 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 17/30] KVM: arm64: Generalise
 kvm_pgtable_stage2_set_owner()
Message-ID: <aWFM7NnBkRiM4OQI@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-18-will@kernel.org>
 <rm55zbvakwmh5ny25bosf3jjiehfubcm2st5q4porsmnffuod5@edygmhqq2ckn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rm55zbvakwmh5ny25bosf3jjiehfubcm2st5q4porsmnffuod5@edygmhqq2ckn>

On Tue, Jan 06, 2026 at 03:20:15PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:25 (+0000), Will Deacon wrote:
> >  /**
> > - * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
> > - *				    track ownership.
> > + * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
> > + *				   to track ownership (and more).
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> >   * @addr:	Base intermediate physical address to annotate.
> >   * @size:	Size of the annotated range.
> >   * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> >   *		page-table pages.
> > - * @owner_id:	Unique identifier for the owner of the page.
> > + * @annotation:	A 62-bit value that will be stored in the page tables.
> > + *		@annotation[0] and @annotation[63] must be 0.
> > + * 		@annotation[62:1] is stored in the page tables.
> >   *
> >   * By default, all page-tables are owned by identifier 0. This function can be
> >   * used to mark portions of the IPA space as owned by other entities. When a
> > @@ -673,8 +678,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >   *
> >   * Return: 0 on success, negative error code on failure.
> >   */
> > -int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > -				 void *mc, u8 owner_id);
> > +int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				void *mc, kvm_pte_t annotation);
> 
> While we're on this topic, perhaps we could go one step further and 'type'
> the annotation itself? For instance have a 'type' and 'meta' parameter
> directly at the kvm_pgatble_stage2_annotate() level instead of leaving
> that up to the callers. This would allow to have one place to allocate
> annotation 'types' (donated pages, locked PTE, MMIO guard, ...) and one
> way to serialize/deserialize them. That 'type' would be stored in top 2
> or 3 bits of the PTE for instance, and decoding of the 'meta' field would
> be dependant on the type value. Thoughts?

I don't think a global 'type' space is particularly beneficial, as most
annotations (with the exception of PTE_LOCKED) are specific to the owner
and putting them into a single number space will just waste bits.

But I do like the idea of encoding an annotation type in the pte and
defining those per-owner. I think it would also make some of the code
more robust; for example, I noticed that __pkvm_guest_unshare_host()
isn't putting back the right annotation with my series when I started
looking at implementing your idea.

I'll come back with a diff. It won't be quite what you're suggesting,
but let's see what you think.

Will
