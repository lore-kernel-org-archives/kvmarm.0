Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CDB5733E
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 22:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786917719; cv=none; b=EfHr8LQVlebMuRup9wweTdX4oWE8jVyckHr0nLpzBFMXSZVqXla8fwNYt71yfhUtgzw/4pichSGyhg5+8fcW/jwKth7+tVbWL7985GSzYgCvYtMWvXekIfOnUaJxkXyod7jakjOqYl7R5xL5VwhCuW1+non/PNNo8PDZHJKXttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786917719; c=relaxed/simple;
	bh=pVjiwzYXzj3mUBgzqtSSepmjg4P1MZh72aHgeka8p1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ys+f36c8W7jLWA2eSZA2XrsLTSJ94uc7yKJB6kAuDe3hS3sVaQs2H8vcpUH8/h+n0nPY/8Kn6DfWu6PDPon3JBt3FfBjRc5oKOJ5/5p5vT1drrnMe0u2X9752RVY+NSuKr99JkGRZyy15ultoD//F/qgxeL4L9j9sn3lcUbqLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=fPMn7VNu; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="fPMn7VNu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1786917718; x=1818453718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pVjiwzYXzj3mUBgzqtSSepmjg4P1MZh72aHgeka8p1w=;
  b=fPMn7VNunOJqVLvi/Tc/2ST/4gS8KWOCjvX/0WPWUzEAdkzGuEbjG+pZ
   CNw+eIVcA38t17mLRelhJbx2AMiY2gSDRQAWa53LfqbTkpL9rvC130OT1
   TjrZ24gFLAnV4cLNbCYnmZ2oyR19eSbsUB9/y0i2Rsv0CGYhqErs7NN2K
   9R0sJDVcM2imllvrvTinInVgflPXh37aVOhVtvv/lihhXGYpLGPhXYLm+
   X4zqhOjDruFrzgD9DDi57HWCdXSXVNyzxJCkf8JZuAqejqXcDgCi8tewa
   qbbd+hpPeBxNBZsIzLhhX8cA15bUgDBdex32NgRT3FbKj6hjD0rFUfG+V
   A==;
X-CSE-ConnectionGUID: 5X9ZnL+xR/eXYj9xFRt0Ow==
X-CSE-MsgGUID: NJgPkqeZSEuqnGOPoeLKWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="254950014"
X-IronPort-AV: E=Sophos;i="6.25,227,1779116400"; 
   d="scan'208";a="254950014"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 07:01:50 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 1F71B1002B80
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 22:01:50 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id D05A3896E34
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 22:01:49 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTPS id 46B28100008B;
	Sun, 16 Aug 2026 22:01:45 +0000 (UTC)
Date: Mon, 17 Aug 2026 07:01:42 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: arm64: nv: Introduce guest stage-2 tracking
 structures
Message-ID: <aoIzRuS6OSP68nHl@sm-arm-grace07>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260810205038.118843-3-weilin.chang@arm.com>
 <an5puT6fe3lOMY4Q@sm-arm-grace07>
 <y6gzme4o5lsitrjb5bua6vhloypeoluchcmi3ndlvl4e6t6od7@vgkqqf75i25e>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y6gzme4o5lsitrjb5bua6vhloypeoluchcmi3ndlvl4e6t6od7@vgkqqf75i25e>

On Fri, Aug 14, 2026 at 11:42:24AM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> On Fri, Aug 14, 2026 at 10:04:57AM +0900, Itaru Kitayama wrote:
> > On Mon, Aug 10, 2026 at 09:50:34PM +0100, Wei-Lin Chang wrote:
> > > In order to avoid unmapping all shadow stage-2 mappings when KVM
> > > receives a MMU notifier unmap call, we have to keep track of the
> > > canonical IPA -> nested IPA relationship of the shadow mappings
> > > created. This essentially means tracking the guest's stage-2.
> > > 
> > > To do this, represent each mapping by struct kvm_guest_s2_mapping. It
> > > stores the mapping's canonical IPA range and the nested IPA range using
> > > two interval tree nodes. Both nodes will be inserted into their
> > > respective interval trees called guest_s2_mappings. The canonical IPA
> > > ranges will be stored in the tree within the canonical MMU, and the
> > > nested IPA ranges will be stored in the corresponding nested MMU's tree.
> > > 
> > > For example:
> > > 
> > > struct kvm_guest_s2_mapping mapping1, mapping2;
> > > 
> > >     ---------------------> mapping2.canonical
> > >     |                      mapping1.canonical
> > >     |                          ^   (both stored in canonical mmu's tree)
> > >     |                          |
> > > --*****-----------------------*****----------- CIPA
> > >    \\\\\                      |||||                  mapping1.nested_mmu
> > >     \\\\\                     \\\\\                            |
> > >      \\\\\                     \\\\\                           v
> > > ------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
> > >        \\\\\                      |
> > >         \\\\\                     -> mapping1.nested
> > >          \\\\\                       (stored in nested mmu #1's tree)
> > >           \\\\\
> > > -----------*****------------------------------ NIPA #2 (nested mmu #2)
> > >              |                                                 ^
> > >              -> mapping2.nested                                |
> > >                 (stored in nested mmu #2's tree)   mapping2.nested_mmu
> > > 
> > > Using the trees we can look up nodes in either of the IPA spaces, and
> > > for each node, find the corresponding range in the other IPA space from
> > > the other node in the enclosing kvm_guest_s2_mapping.
> > > 
> > > Define kvm_guest_s2_mapping and the interval tree here. Guest stage-2
> > > mapping tracking will come in subsequent patches.
> > > 
> > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > ---
> 
> [...]
> 
> > >  
> > > +/*
> > > + * Record of a guest stage-2 mapping, storing canonical and nested IPA
> > > + * ranges. Both ranges have the same size.
> > > + */
> > > +struct kvm_guest_s2_mapping {
> > > +	struct interval_tree_node canonical;
> > > +	struct interval_tree_node nested;
> > > +	struct kvm_s2_mmu *nested_mmu;
> > > +};
> > 
> > Is this to be used for normal (L1) guests? I guess this series is for
> > shadow stage 2 unmapping optimization, so not sure.
> 
> Sorry I don't totally understand your question. Yes this series is
> optimizing cases where a GPA (L1's PA) range have to be unmapped, from
> an MMU notifier unmap call.
> 
> When we want to unmap a GPA range, the corresponding L2PAs must also be
> unmapped from the shadow page tables. Before this series there is no way
> of knowing what L2PAs are affected, so the code just calls
> kvm_nested_s2_unmap() to unmap all shadow mappings.
> 
> Each struct kvm_guest_s2_mapping instance keeps one L1PA <-> L2PA
> mapping record. For example:
> 
> canonical (L1PA space): [x, x+4K)  <- node stored in canonical MMU tree
> nested (L2PA space):    [y, y+4K)  <- node stored in nested MMU tree
> 
> Does this make sense?

Yes, makes sense. I was mostly wondering about the sturct name,
kvm_guest_s2_mapping you introduced, since this is only needed for a guest 
acting as a hypervisor. No strong opinion.

Thanks,
Itaru.

> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Thanks,
> > Itaru.
> > 
> 
> [...]
