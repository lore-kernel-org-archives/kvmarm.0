Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C6D41C63
	for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755284206; cv=none; b=qE3Gpnxu2WyShERi9gDH/MhKyQolwVBMPsAVqVnLTu6n9+4PKxcorIQtGaAzdiriRz9IPFapaPykRQPp9BynuEhANphLSvHQKAgDn0BfmLrS/X7GXh87IVfqOeO3PVj1IG2PB/a6ULN4ri12BQ61AlaurVucwQc+ApiM2i4hYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755284206; c=relaxed/simple;
	bh=EnaU4b4BQq+lkAyTdDiB/9LaASwrKTZEFuTi9pN7/P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHoABcgRVinYPwIlMwKKYf9FZAxpBpVbRo4YZuy2gzQ/XZgfTCDcMOTQZTV+5mHXcpkconz4xGSl/sUOTISAPTiEY0lGq9VklCa5KxiNHdSk8JQlZMSQOJGJSLfAFOadL58mUEF9QbUNVEFT9moFrJ0EInBUMducpxLLiqRXMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EUyntAwU; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EUyntAwU"
Date: Fri, 15 Aug 2025 11:56:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755284192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lcbfpvMeFZQQn0Wme2x0gtEmZjwzrQjTk83v9La0I3o=;
	b=EUyntAwUGNP/CpsSxVdmHUhjkdjEdHDWrZWWYFZIDeeITLWtAbhB3hO+OwHpaSTwnIx21Q
	01GwZJmbrE0uNEcu0XDorAhiZVvHELUpOkSvwqt9MpAMSmjB+Jp6bewqgzu3Lz0ifQUmBh
	vALVpkSNpUgK73qZTRlhGWrPhb8WSK4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
Message-ID: <aJ-C1-t34aVmHLjY@linux.dev>
References: <20250809144811.2314038-1-maz@kernel.org>
 <20250809144811.2314038-3-maz@kernel.org>
 <aJuixWlc87f2UlK0@linux.dev>
 <86ikipev46.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikipev46.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 14, 2025 at 05:16:57PM +0100, Marc Zyngier wrote:
> My current conclusion is that a macro hack is not really practical, if
> only because we end-up here from out-of-line C code, and that at this
> stage we've lost all symbolic information.
> 
> We *could* take the nuclear option of re-modelling the sysreg enum as
> a bunch of #define, similar to the way we deal with vcpu flags, and
> have accessors for the various bits of information, but that comes
> with two different problems:
> 
> - we don't have a good way to iterate over symbolic registers
> 
> - we need to repaint a large portion of the code base
> 
> Given that, I've taken another approach, which is to move all these
> things close together (no more inlining), and add enough WARN_ON()s
> that you really have to try and game the code to miss something and
> not get caught. In the process, I found a couple of extra stragglers
> that are always loaded when running a 32bit guest (the *32_EL2
> registers...).
> 
> I've pushed the current state on my kvm-arm64/at-fixes-6.17 branch,
> and I'll try to repost patches over the weekend.

Thanks! I've taken a glance at the branch and LGTM. Just wanted to make
sure we have sufficient idiotproofing for the next time I misuse this
stuff ;-)

Best,
Oliver
