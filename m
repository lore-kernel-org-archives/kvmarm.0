Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D769459AED
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704172; cv=none; b=HvnkWdbPXcgB22rhBO3FJGCgPbdbVezau8c0GllLxwccFpIuKgYbSoCttf6yWTjoOnFTP2fpZiqC9qkVt3KaJkLKoipY1c2qtzpXf75Mkdh30Smit7XTU90y4dwAH4fqfTNhUiOUS7wZ1LMdCbUSQXAMnNRJyvuntSvg2Pzqa0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704172; c=relaxed/simple;
	bh=bLx/XPVcv18THPDJp+XH4URjd7ZZFW5FCaSQAyVUzY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNZL9oijzwEowcnOaLrZg3PV2kwkIMC5RnTgRxyLSOUNuAvr1f1WjisHOjrfeeBfxXdPhJHgg5hwdnBvKAxmQoT8dIXdegLwwrUkHeaibArBAd3oIZ1IMS+cELTB9gx21UbDXSl84D6e0dvdZTAK0wcOO6SzDdfWQiIrOHrJfRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A0A3FcjC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A0A3FcjC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 235851596;
	Fri, 14 Aug 2026 03:42:32 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0151D3F632;
	Fri, 14 Aug 2026 03:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786704155; bh=bLx/XPVcv18THPDJp+XH4URjd7ZZFW5FCaSQAyVUzY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0A3FcjCkUtykivhCurLS2QMM5HEs49QHCNwaqjkAu7FUDflkH96uyQr1NUZoJkpK
	 waDGiNQAT6YX0n0mau9nLFvFfcKQa+HljKwPbE/KKM7+0AzJtSfSRLQBejYBWJs44Q
	 VlLPorS7ENpDb1UIUf0EM7n0wMln7A0ARiUc1RCQ=
Date: Fri, 14 Aug 2026 11:42:24 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: arm64: nv: Introduce guest stage-2 tracking
 structures
Message-ID: <y6gzme4o5lsitrjb5bua6vhloypeoluchcmi3ndlvl4e6t6od7@vgkqqf75i25e>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260810205038.118843-3-weilin.chang@arm.com>
 <an5puT6fe3lOMY4Q@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an5puT6fe3lOMY4Q@sm-arm-grace07>

Hi,

On Fri, Aug 14, 2026 at 10:04:57AM +0900, Itaru Kitayama wrote:
> On Mon, Aug 10, 2026 at 09:50:34PM +0100, Wei-Lin Chang wrote:
> > In order to avoid unmapping all shadow stage-2 mappings when KVM
> > receives a MMU notifier unmap call, we have to keep track of the
> > canonical IPA -> nested IPA relationship of the shadow mappings
> > created. This essentially means tracking the guest's stage-2.
> > 
> > To do this, represent each mapping by struct kvm_guest_s2_mapping. It
> > stores the mapping's canonical IPA range and the nested IPA range using
> > two interval tree nodes. Both nodes will be inserted into their
> > respective interval trees called guest_s2_mappings. The canonical IPA
> > ranges will be stored in the tree within the canonical MMU, and the
> > nested IPA ranges will be stored in the corresponding nested MMU's tree.
> > 
> > For example:
> > 
> > struct kvm_guest_s2_mapping mapping1, mapping2;
> > 
> >     ---------------------> mapping2.canonical
> >     |                      mapping1.canonical
> >     |                          ^   (both stored in canonical mmu's tree)
> >     |                          |
> > --*****-----------------------*****----------- CIPA
> >    \\\\\                      |||||                  mapping1.nested_mmu
> >     \\\\\                     \\\\\                            |
> >      \\\\\                     \\\\\                           v
> > ------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
> >        \\\\\                      |
> >         \\\\\                     -> mapping1.nested
> >          \\\\\                       (stored in nested mmu #1's tree)
> >           \\\\\
> > -----------*****------------------------------ NIPA #2 (nested mmu #2)
> >              |                                                 ^
> >              -> mapping2.nested                                |
> >                 (stored in nested mmu #2's tree)   mapping2.nested_mmu
> > 
> > Using the trees we can look up nodes in either of the IPA spaces, and
> > for each node, find the corresponding range in the other IPA space from
> > the other node in the enclosing kvm_guest_s2_mapping.
> > 
> > Define kvm_guest_s2_mapping and the interval tree here. Guest stage-2
> > mapping tracking will come in subsequent patches.
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---

[...]

> >  
> > +/*
> > + * Record of a guest stage-2 mapping, storing canonical and nested IPA
> > + * ranges. Both ranges have the same size.
> > + */
> > +struct kvm_guest_s2_mapping {
> > +	struct interval_tree_node canonical;
> > +	struct interval_tree_node nested;
> > +	struct kvm_s2_mmu *nested_mmu;
> > +};
> 
> Is this to be used for normal (L1) guests? I guess this series is for
> shadow stage 2 unmapping optimization, so not sure.

Sorry I don't totally understand your question. Yes this series is
optimizing cases where a GPA (L1's PA) range have to be unmapped, from
an MMU notifier unmap call.

When we want to unmap a GPA range, the corresponding L2PAs must also be
unmapped from the shadow page tables. Before this series there is no way
of knowing what L2PAs are affected, so the code just calls
kvm_nested_s2_unmap() to unmap all shadow mappings.

Each struct kvm_guest_s2_mapping instance keeps one L1PA <-> L2PA
mapping record. For example:

canonical (L1PA space): [x, x+4K)  <- node stored in canonical MMU tree
nested (L2PA space):    [y, y+4K)  <- node stored in nested MMU tree

Does this make sense?

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 

[...]
