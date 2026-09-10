Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072B033986F;
	Thu, 10 Sep 2026 10:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037780; cv=none; b=pRKz/fcB/EjI0eRW28tBBCvtyBPoD17Q5KU4McpXvA12zAek8+7DzrWBeCw9FqZDJN2XYFGXpsfJiyds2NNeckDBHOMyupCOKI4h6wNuIYDtg0zABU8WV5j3gK9Qj3LS5Scuw6K//RK+f2lsjcscAf4s2ZHj+0yvfKtaLCy3RFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037780; c=relaxed/simple;
	bh=BR+Iyh2pr7tzL6ty9EUUcJcf5w9Qc/W2kyT2qXL0bvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pI2L7ri+5CX+DI+8YTf+aVjDVl4GOsVJjuzAIrwG3HVTSjBhSe5lf5NSHjV+pf5ok9EsCSnwJRBsZfARgtmkuvzbE0fbXR1xJ2zQmL56vEVMGtQ+OQZFR7vgDAMPjio+P7EA0g+xBCd5nxJWy3ndxIgSDk5hsiYV1GV3qCR+PGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e00ZG+wT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e00ZG+wT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EF481477;
	Thu, 10 Sep 2026 03:56:09 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E568E3F7B4;
	Thu, 10 Sep 2026 03:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789037773; bh=BR+Iyh2pr7tzL6ty9EUUcJcf5w9Qc/W2kyT2qXL0bvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e00ZG+wTTiVMihiabXKmWzwOrCFXWXrAbbWvNrqWSylkQ2Y4X+A87Lde5bjpH6Ufl
	 rSVzUa8gR4w+FJmx7hRvmYiO7H+gbRzC599SUFwXxL4aj3f3/tWFQGuVNg9Pg/xwYb
	 APxOS3WZ/xdhLbHX0bvicsQgjRnaGA4v/sjUBldA=
Date: Thu, 10 Sep 2026 11:56:05 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1 1/3] KVM: arm64: nv: Don't advertise FEAT_LPA2 for
 guest stage-1
Message-ID: <hucdlhnem5q2ykqxpxu4czjmac5uhazt5jbvgkawh6yqoidnhg@7p74vks5cqx6>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
 <20260909222015.3046432-2-weilin.chang@arm.com>
 <20260909224458.E7F0D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260909224458.E7F0D1F00898@smtp.kernel.org>

On Wed, Sep 09, 2026 at 10:44:58PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Equality checks for TGRAN4 and TGRAN16 fail to mask future architectural enum values, leaking unsupported hardware capabilities to NV guests.
> --
> 
> commit 6c2ebbb5542b3e22eaee90b7cf8d8cbbc9704e7c
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
> 
> There is no FEAT_LPA2 support for NV guests as of now, but we missed
> limiting it for the non-stage-2 granule size fields (TGRAN4, TGRAN16) in
> ID_AA64MMFR0_EL1. Add the sanitisation.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 17123f0b6daba..4d1884b32fc48 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1731,6 +1731,19 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
> >  		/* Hide CNTPOFF if present */
> >  		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
> >  
> > +		/* NV does not support FEAT_LPA2. */
> > +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, val) ==
> > +		    ID_AA64MMFR0_EL1_TGRAN4_52_BIT) {
> 
> [Severity: Medium]
> Will this exact equality check fail to mask future architectural enum values?
> 
> If future hardware implements a capability enum value greater than 52_BIT for
> TGRAN4, this check will evaluate to false, leaking the unsupported capability
> to NV guests.
> 
> Could this be capped instead, perhaps using inequalities or the
> ID_REG_LIMIT_FIELD_ENUM macro, to maintain forward compatibility?

ID_REG_LIMIT_FIELD_ENUM works only for unsigned fields, perhaps it is
worth extending it so it can deal with signed enums too.

Thanks,
Wei-Lin Chang

> 
> > +			val &= ~ID_AA64MMFR0_EL1_TGRAN4;
> > +			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4, IMP);
> > +		}
> > +
> > +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN16, val) ==
> > +		    ID_AA64MMFR0_EL1_TGRAN16_52_BIT) {
> 
> [Severity: Medium]
> Similarly, will this exact equality check fail to mask future unsigned capability
> values greater than 52_BIT for TGRAN16?
> 
> > +			val &= ~ID_AA64MMFR0_EL1_TGRAN16;
> > +			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP);
> > +		}
> > +
> >  		/* Disallow unsupported S2 page sizes */
> >  		switch (PAGE_SIZE) {
> >  		case SZ_64K:
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260909222015.3046432-1-weilin.chang@arm.com?part=1
