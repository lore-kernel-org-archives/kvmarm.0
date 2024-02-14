Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761D712CD95
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707936035; cv=none; b=eDZXF/uhPdquIyNOelkU26jsZfMA5c8jIIDmTC8HEXChSb8tMdMFbUbJV21fEdXFnrUaX6cGBdj8RGQl1vyhZCpVVaK/FpQiBZwFFCBD6l21kTy0oEcOVKv+mvYFVpDaYKPGNHxgt6UXM7J2+g/nZZkYEtJyuz2tXaMA4HrxxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707936035; c=relaxed/simple;
	bh=QUSG3BjW4+NlVMe7Rm/SiimRN0MgjuaWYIne5NHr5SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuO/TX/RhZ+N6x2rPJ6av1nq6XSCOKMEI/ZLSuN4Dm1zYrHAEk59Rj3ZQ517Os/EjSSBB7hgiKN56/oDKefhfaB7JjhyrjJEZ2j7QfFOfG92MF+pxVpVYkbPZF6HXXhEnUef8SQ5nPfrVYpGGe8tSwtZ8lWORtPzi9bcRPSxJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CG61ZVSB; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CG61ZVSB"
Date: Wed, 14 Feb 2024 10:40:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707936032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HteG6wI3EUm2H1LShgPJUXyy8lpsiiNykuq3fjbolTk=;
	b=CG61ZVSBEE4WGfRWEOIp3h9wA3MZ2YPsnnaOpLGsZ8kAjbIAXomleuP4DeJUj9Rr7/uoSO
	TeW9FXRK2h8MO7fonOUHoeePgk+/aF1XJHbHot4r3nXY1QpxU4xPyM/2BS81yRm3/JJ6aT
	nZTs12ZOG2RjAJanbcCbZfvaUEPGAsw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] KVM: arm64: Improvements to LPI injection
Message-ID: <Zc0JG8pNRanuXzvR@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <86y1bn3pse.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y1bn3pse.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 05:43:13PM +0000, Marc Zyngier wrote:
> On Tue, 13 Feb 2024 09:32:37 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > For full details on the what/why, please see the cover letter in v1.
> > 
> > Apologies for the delay on v2, I wanted to spend some time to get a
> > microbenchmark in place to slam the ITS code pretty hard, and based on
> > the results I'm glad I did.
> 
> [...]
> 
> Buglets and potential improvements aside, I like the smell of this. At
> least the first handful of patches could easily be taken as a separate
> improvement series.
> 
> Let me know how you'd like to play this.

Yeah, I think there's 3 independent series here if we want to take the
initial improvements:

 - Address contention around vgic_get_irq() / vgic_put_irq() with the
   first 10 patches. Appears there is violent agreement these are good
   to go.

 - Changing out the translation cache into a per-ITS xarray

 - A final series cleaning up a lot of the warts we have in LPI
   management, like vgic_copy_lpi_list(). I believe we can get rid of
   the lpi_list_lock as well, but this needs to be ordered after the
   first 2.

I'd really like to de-risk the performance changes from the cleanups, as
I'm convinced they're going to have their own respective piles of bugs.

How does that sound?

-- 
Thanks,
Oliver
