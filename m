Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0E91E5B8B
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743670875; cv=none; b=DqrpX8/yS3ANx3xtptYPZnoMuH/fEsVItWCivvAsEDgXz6m1U5E8eojBva/2sFmfUo1NHDNdq5TK2YF5+yYYCkO54zN8OYWADjdkMummZFZbE8Bm1mkaqDbMm/5ahG2Rd68mHPckWFtxf237z5y2i1Z5if8TnkJM9pt3sXgGVPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743670875; c=relaxed/simple;
	bh=sxw491Z8LMPDKSO+07agHSEfaaL/qFP44nfZQ2jYKxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roAjtl/N7JV8gY8SH3nO77P/dxSWIkPSOVt9jNu/NRFn4ZFzbFF+FxKATLNRe5AP9AbxRsRtR46AneiumQXam716WtlmmJZS3YjNscxDsdZ58aa+7fIRKBDhcjOmRlx5kQxgPsz80ZIk4S/DJUs6t3g8iU0kmpRcGFD/0xGurvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AA17106F;
	Thu,  3 Apr 2025 02:01:16 -0700 (PDT)
Received: from bogus (unknown [10.57.41.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F51E3F63F;
	Thu,  3 Apr 2025 02:01:11 -0700 (PDT)
Date: Thu, 3 Apr 2025 10:01:08 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	mark.rutland@arm.com, lpieralisi@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Message-ID: <20250403-steadfast-bold-puffin-f0d2ed@sudeepholla>
References: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>
 <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
 <Z-1pPLI8HRjg-bSx@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-1pPLI8HRjg-bSx@linux.dev>

On Wed, Apr 02, 2025 at 09:43:40AM -0700, Oliver Upton wrote:
> Hi Sudeep,
> 
> On Wed, Apr 02, 2025 at 02:58:06PM +0100, Sudeep Holla wrote:
> > On Wed, Apr 02, 2025 at 02:44:01PM +0100, Shameer Kolothum wrote:
> > > Fixes cocci reported warning:Unneeded semicolon
> > > 
> > 
> > There was similar patch on the list [1] few days ago.
> > 
> > > Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
> > 
> > ^^^ Is this really necessary as they get backported as well ?
> 
> The blamed commit was introduced this release cycle so no concern about
> backports.
> 

Ah OK, sorry didn't look at the details.

> > Since, KVM maintainers are in cc-ed, let me know if you guys want to pick
> > this ? Else I can send it as part of my firmware (ffa/scmi) fixes.
> 
> I can grab the fix here in a moment, I've already got one queued up [*]
> for the KVM guest driver anyway.
> 

Thanks!

-- 
Regards,
Sudeep
