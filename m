Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191F33D75D3;
	Mon, 28 Sep 2026 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592614; cv=none; b=r3czZCDJTkdHFt0vKkaQyOenvPFH/2Nf7Lk1Pl0sbHfY/s+WpoBzaWgBfPkUYkGyZlCVoEfDMSLcf5GDfcWy4vvg2WF15NYDhWG4UMR5lNqHTLchZ41b5pFnFz4SYw8flZt7++LCZQgzTwtM0iKDAUZwtEFZdELR2vU4Z0KsBwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592614; c=relaxed/simple;
	bh=9tV5Pn8ooPxhrLztnSQxkF37uFI7GsTa1JPkqGqqzFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7thtzY4bDHCNLTM4Uk0r2Za06yV9P0yUfQBqQskmAIlgciLkKdljAJC4IXrezh5XmaZyxrTu+N4WZs5pIMqy1YsTOIeWk+Fqa9w5IT/1Z6oA59gFsaXQYt+hzLcBoQiX794x+jOSFrSYOcDkAPPhEc8P2Ko/pZJJnHnDUUe6YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hfvAdTd1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hfvAdTd1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1537B1595;
	Mon, 28 Sep 2026 03:50:09 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C9E43F86F;
	Mon, 28 Sep 2026 03:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790592612; bh=9tV5Pn8ooPxhrLztnSQxkF37uFI7GsTa1JPkqGqqzFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hfvAdTd10gjJiRGpBvkXYx8H/qPQJmd3XfXW5vEcVef2RdaTFLvQNRd4FIpOZMceL
	 aXlsDWOkRnFBNTFBxEiO2FaQpn/gqW68Lr/FdQWHrClHxPrExbUMk2tWgSCB6HW9HW
	 aZdYg3k20hE9ERIsNq8idf9yFUMRdPRg1ANj+FdE=
Date: Mon, 28 Sep 2026 11:50:00 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Don't advertise FEAT_LPA2 for
 guest stage-1
Message-ID: <2fyohrzjogtj4dr2otnfpftsfn24wsycwlmwc7enpyq464vfi5@botsrehddt5y>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-2-weilin.chang@arm.com>
 <20260917215144.B50A91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260917215144.B50A91F000FF@smtp.kernel.org>

On Thu, Sep 17, 2026 at 09:51:44PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] arm64: kvm: exact equality check for FEAT_LPA2 leaks future CPU features to guest
> --
> 
> commit 04c3c148ddb66ae2c7e9c401ce8ccd1c725fafd5
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
> 
> This commit sanitizes ID_AA64MMFR0_EL1 to prevent advertising FEAT_LPA2
> to nested guests for non-stage-2 granule size fields (TGRAN4, TGRAN16).
> It explicitly clears and resets the fields to IMP when the 52-bit values
> are detected.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> 
> [ ... ]
> 
> > @@ -1731,6 +1731,17 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
> >  		/* Hide CNTPOFF if present */
> >  		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
> >  
> > +		/* NV does not support FEAT_LPA2. */
> > +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, val) == ID_AA64MMFR0_EL1_TGRAN4_52_BIT) {
> > +			val &= ~ID_AA64MMFR0_EL1_TGRAN4;
> > +			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4, IMP);
> > +		}
> 
> [Severity: Medium]
> Could this exact equality check fail to cap future values of TGRAN4?
> 
> If a future hardware extension introduces a CPUID value where TGRAN4 is
> greater than ID_AA64MMFR0_EL1_TGRAN4_52_BIT, this condition would be
> bypassed. This could expose unsupported capabilities to nested guests on
> future hardware, potentially leading to guest crashes or page table
> corruption when the guest attempts to use 52-bit translation granules.

This is the same comment from Sashiko as v1, and it was Nack'd by the
maintainer.

> 
> > +
> > +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN16, val) == ID_AA64MMFR0_EL1_TGRAN16_52_BIT) {
> > +			val &= ~ID_AA64MMFR0_EL1_TGRAN16;
> > +			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP);
> > +		}
> 
> [Severity: Medium]
> Similarly, could this equality check leak future values of TGRAN16 greater
> than ID_AA64MMFR0_EL1_TGRAN16_52_BIT?
> 
> Would it be safer to handle both of these limits using
> ID_REG_LIMIT_FIELD_ENUM instead of exact equality checks to ensure
> future monotonic CPUID values remain properly capped?

Same here.

Thanks,
Wei-Lin Chang

> 
> > +
> >  		/* Disallow unsupported S2 page sizes */
> >  		switch (PAGE_SIZE) {
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260917214215.74135-1-weilin.chang@arm.com?part=1
