Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C341386BF
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478905; cv=none; b=L1S93ApWQSBWgXo5HQg98q9EtUw/F0NFeGKdkkkiU7t9H4vrHVqqBMSTqlz/Q5L1JQqfYUDOq64Dw2ia92eVeqKgnGbHxHPAEwyJRpA9lQycOi3lln75ULIwSZx+rd9ZxfFcJdGdj9wlSVqlCdYwzg9BYwvWBpe5z0BhmwrDpOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478905; c=relaxed/simple;
	bh=MBxcxIseze3sPy9QXZ09qRC3vmcpGwQqLGk1g9RMHI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWBMeUrgfcNltYFNZ8rreKCxAq0qSMMXjkSgIa0jRppliu3LF+LW/0B9V8oJaJbVfLz8Fyogc0kUcJxLySJ9s9QQAuDxP9k+qxm/w+rjQBlR0+GvwzK6Nu3aqBcHOR02J44JL/Pj36D9ERkbUvlWsJGKoEtQow8A3oyTgh+0WnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9EBC4CECD;
	Fri,  1 Nov 2024 16:35:02 +0000 (UTC)
Date: Fri, 1 Nov 2024 16:35:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature
 consumers
Message-ID: <ZyUDNCu-vYh_tpKv@arm.com>
References: <20241031083519.364313-1-maz@kernel.org>
 <ZyT1Tblp624a79CD@arm.com>
 <ZyT4JG1Nec_xPCHH@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyT4JG1Nec_xPCHH@linux.dev>

On Fri, Nov 01, 2024 at 08:47:48AM -0700, Oliver Upton wrote:
> On Fri, Nov 01, 2024 at 03:35:41PM +0000, Catalin Marinas wrote:
> > On Thu, Oct 31, 2024 at 08:35:19AM +0000, Marc Zyngier wrote:
> > > Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
> > > expose these feature bits to KVM.
> > > 
> > > Plumb in the feature in ID_AA64ISAR1_EL1.
> > > 
> > > Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > 
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > Happy for this to go in as a fix via the kvm tree but let me know if I
> > should pick it up instead.
> 
> Thanks Catalin. I think this can wait for 6.13, would you mind grabbing
> it?
> 
> If you do:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

I'll pick it up. Thanks.

-- 
Catalin
