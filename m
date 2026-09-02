Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB8247044E;
	Wed,  2 Sep 2026 11:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788347271; cv=none; b=ntw3lUui5qHV4kborMC3hk+Gog5SIfcamkPWy4dMHUzaPPxfH5bXVsbd2uwleTycjp0f6pWBUmtTIn8h1XL9V1p+rOF2WXPVjXlpCkcVm0cH/SsNqG/kJcyM0NPTj1aBuNFQomp+eTsrGm3vjriYBUo8aaIUnu7JDfevXO5ixU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788347271; c=relaxed/simple;
	bh=C/nFNCl7y0Wc2aQS0J6axFgFkV9ClrMkWYsc+DjvGJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=KPE6qMuoENbvdHk+mNVBzO83ThfJHz1UXHuF2tH7HsKBshX3DZN4A06X+PcLn7Ei14M0PVtKcBslx7Okg/9N+zORdI0rGsrt6oug0ZGgV/KZQN6K0UhzFnozS+irhmDW35uoPQ/cjxxoFgZUlNL7xUKe564zUed7NuWa894xccQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B1F8uZUL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B1F8uZUL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B699F165C;
	Wed,  2 Sep 2026 04:07:44 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBB513F85F;
	Wed,  2 Sep 2026 04:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788347268; bh=C/nFNCl7y0Wc2aQS0J6axFgFkV9ClrMkWYsc+DjvGJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1F8uZULJshmW4icxlOc5cf1Ggh1WcO2wtnDNK6TsUMqMqF4YpetLbQJf89RDWkcN
	 emrTdd6IwzUcVgAdPRQV6i+PbzZW3kf4QfR0FVYf/1tVq8zj26w+tlXz5Ff426vx1f
	 yXOcbXUFfHqecQrmtnibVwtdhW7uhtyO95DFSJ9o=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Wed,  2 Sep 2026 12:07:45 +0100
Message-ID: <apgDgf7JEhpD86cb@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901173014.AC1B41F00A3D@smtp.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-2-leo.bras@arm.com> <20260901173014.AC1B41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 05:30:14PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] walk_nested_s2_pgd() incorrectly evaluates the DBM bit in L1's stage-2 page tables, leading to L2 memory protection bypass and broken L1 dirty tracking.
> --
> 
> commit 6c412868c1a4af97b366b23a517db706c4c3511a
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
> 
> As a first step of changing the encoding for the Stage2 PTE descriptor,
> introduce the DBM bit, and adapt every usage of writable to use the DBM bit
> (51) instead of S2AP[1]/Dirty bit (7).
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 17123f0b6daba..eb8dfffc32c76 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -386,7 +386,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> >  	out->output = paddr;
> >  	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> >  	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> > +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> > +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
> 
> [Severity: High]
> Does this code in walk_nested_s2_pgd() incorrectly evaluate the DBM bit in
> the L1 hypervisor's stage-2 page tables?
> 
> By checking for the DBM bit unconditionally here, L0 treats L1's read-only
> stage-2 PTEs (where bit 51 is 1 and S2AP_W is 0) as writable. This allows an
> L2 guest to write to memory that the L1 hypervisor intended to be read-only,
> bypassing L1's memory protection.

Yeah, for this to work on NV we need Oliver's patch series enabling HAFDBS 
emulation.

> 
> Additionally, this breaks L1's dirty tracking because L0 never updates L1's
> PTE to set the S2AP_W bit on a write.
> 
> Since KVM restricts L1's HAFDBS capability to AF-only (no DBM), bit 51 is
> architecturally RES0 or ignored for L1. An honest L1 hypervisor might safely
> use this ignored bit for software metadata. A malicious L2 guest could then
> exploit this to write to read-only pages (such as shared firmware), breaching
> the L1-to-L2 security boundary.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260901171558.2674031-1-leo.bras@arm.com?part=1
