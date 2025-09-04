Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9222C08C4
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978251; cv=none; b=bj81CZQCmY9vzclgwAWaRCTIPI7OJjdyf/Q81lDZsuL3zpzqxMVKvrlGNEuuvUdfOMdBWv8J3OKmwx8LDhTI9H287n1WQ+JAJ0kKcYVRnEz+ZHuRppJjkXWU2eruqP+0AlIVERNOtciM+UTtDC4R1ZTI0f0dZafEZQ2elxj2sQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978251; c=relaxed/simple;
	bh=sIt763qDGoFtK8mb3vF00aS8HMGDWN9MfG1m65J9SiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+8H6POYzE/YcXFjq307u41WJagLOkfyHBUA7OVDcPHGx363jF8kxZu3pgPP6AwjHk9eI34vK/t7EwKEsMPdRPbpXQUfsbHA9VhknmdZ9uqGP0QDH+JoCf1ObvW6ks3+JOe4RK42RuOM/+oanPNHC6UtY3Xi1EV7RW+BC8JXIqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FFEA1756;
	Thu,  4 Sep 2025 02:30:34 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6294D3F6A8;
	Thu,  4 Sep 2025 02:30:41 -0700 (PDT)
Date: Thu, 4 Sep 2025 10:30:38 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: VHE: Initialize PMSCR_EL1
Message-ID: <aLlcPoBLA09mtGg3@raptor>
References: <20250902130833.338216-1-alexandru.elisei@arm.com>
 <20250902130833.338216-2-alexandru.elisei@arm.com>
 <aLk3xLd8ylxP63hH@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLk3xLd8ylxP63hH@linux.dev>

Hi Oliver,

On Wed, Sep 03, 2025 at 11:55:00PM -0700, Oliver Upton wrote:
> On Tue, Sep 02, 2025 at 02:08:32PM +0100, Alexandru Elisei wrote:
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index 381382c19fe4..e7ce0d5a622d 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -74,13 +74,19 @@ void kvm_init_host_debug_data(void)
> >  	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
> >  	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
> >  
> > +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
> > +	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P)) {
> > +		if (has_vhe()) {
> > +			/* Clear E{0,1}SPE, which reset to UNKNOWN values. */
> > +			write_sysreg_el1(0, SYS_PMSCR);
> > +		} else {
> > +			host_data_set_flag(HAS_SPE);
> > +		}
> > +	}
> > +
> 
> nit: While this is correct, from a code organization perspective it
> doesn't belong here. The rest of this function is concerned with probing
> hardware state and initializing the corresponding host data.

Yes, you're totally right.

> 
> I prefer Marc's suggestion which could be wrapped up in a function called
> 'kvm_debug_init_vhe()' or similar.

I forgot about Marc's suggestion, my bad. Will do that for the next iteration.

Thanks,
Alex

> 
> Thanks,
> Oliver
