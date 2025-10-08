Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B302283C9E
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759947993; cv=none; b=bC/D2qDxt2m07Ts0NWOSlWfbgO2x3flCjhNZ+/wRXMn9EAc1YOReNc7gGB2ZLKTGVoqoz+7GvFPLkfxLogCR7oRmoiiXchCya7GyKrBBLF7/L8T6d+DSicRFdVgFnATPLg2wdNDaZUJ69+Gd0PSHQ5noUdrpUkBME9LC0uqUMkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759947993; c=relaxed/simple;
	bh=W5bQLsCVnd3n1Di0lrXaR7g2Y5yLNe97M4Pa6u+x4YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQTptjb5fxIIwuVjzRFf9UDGvxQMIfS/qEZJcs8If1zlNcwxsPExBhpGWMi5oBa0M7RITt/3WcKbcqtJuPJKn/uxaFS+Fy+1gL05qDiHCmSFUTbax9Yue59jgsUiEyAx7HIuJk6k453e3aExsy/x1EfRm/fE0MKwsWHyv7+0LRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=epmNAkgG; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="epmNAkgG"
Date: Wed, 8 Oct 2025 11:26:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759947984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=exoYF71mnQYfHh6jQ94nWq8wP/ULR0XH0hX70hEYBmg=;
	b=epmNAkgGlhEJZyOUN10hOvhoZ5i1y2m9HLL2G3OcPnurM/7SMUqeqYlhJzR9iNqJ5fw5VG
	l0P3mAFIo0HshyNugMrOp/1qO/rsGVuydr3MWQ30PhDc6yPk3SW8Osf2hGpnUKhexDRqth
	KrkCUYhIkp8kUY7LCehBj29pyuSWDrc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
Message-ID: <aOasxgCMG0yS4t43@linux.dev>
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
 <aOVckTSJET5ORY1n@linux.dev>
 <861pndzn4w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pndzn4w.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 08, 2025 at 11:46:55AM +0100, Marc Zyngier wrote:
> On Tue, 07 Oct 2025 19:31:45 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hi Mukesh,
> > 
> > I find it a bit odd to refer to cpu_has_spe() in the shortlog, which
> > doesn't exist prior to this patch.
> > 
> > On Tue, Oct 07, 2025 at 11:53:56PM +0530, Mukesh Ojha wrote:
> > > commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
> > > initializes PMSCR_EL1 to 0 which is making the boot up stuck when KVM
> > > runs in VHE mode and reverting the change is fixing the issue.
> > > 
> > > [    2.967447] RPC: Registered tcp NFSv4.1 backchannel transport module.
> > > [    2.974061] PCI: CLS 0 bytes, default 64
> > > [    2.978171] Unpacking initramfs...
> > > [    2.982889] kvm [1]: nv: 568 coarse grained trap handlers
> > > [    2.988573] kvm [1]: IPA Size Limit: 40 bits
> > > 
> > > Lets guard the change with cpu_has_spe() check so that it only affects
> > > the cpu which has SPE feature supported.
> > 
> > This could benefit from being spelled out a bit more. In both cases we
> > check for the presence of FEAT_SPE, however I believe the issue you
> > observe is EL3 hasn't delegated ownership of the Profiling Buffer to
> > Non-secure nor does it reinject an UNDEF in response to the sysreg trap.
> > 
> > I agree that the change is correct but the rationale needs to be clear.
> 
> To me, this smells a lot more like some sort of papering over a
> firmware bug. Why isn't SPE available the first place?

While I agree this points the finger at a half-assed EL3, the
architecture explicitly allows this sort of crap and we cope with the
accessibility of SPE in almost every other case.

We should at least be consistent in how we handle an inaccessible SPE.

Thanks,
Oliver
