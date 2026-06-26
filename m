Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D13E3C41
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782485449; cv=none; b=gFKGRmf1ZccHkLGA0xwjW9QoHFZalUUrDCPvT1w1AwJmD0nghviDHoXzaTUHhD1zBK2H2nWOhcHmt2FDz+ahuFE4UsvpYASznPy8tq6W98pGXx8j2xOEwIrqisQUGCg9MH7ClbT5RqfLECyhqgLPRahBHuCnpU0HpiZMZUgNPs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782485449; c=relaxed/simple;
	bh=GaN6Al/Zq21V3pL9n+F4uMo+tJN4+gqEHQ7B5HgOb/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEqKTAbQMh1HjWV1zmxfQJZCPe/sx1P4496v50031tqayDbqpiOkSTw6CnRmmd7jBbQsCLc6WGrb02/CtHmKBg+yZoIA68bc8EncR9cNrap2cFs0eH+U0SxVdb2O/TcxRXijbikLqcIlEWSUC3ZCIcuEHS+UzstYJjSD/i+d75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F17iETAE; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F17iETAE"
Date: Fri, 26 Jun 2026 09:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782485446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2M5GRRXuBFHtlNRTiJc8jlynvQNVnYVXnJZfh3OWQ30=;
	b=F17iETAEuZylIK7f9l4np2PsD8P1OITaPE4bqdjieCSMxpFk4cTyiOdkQn3FQjqvCrdHVX
	SM16pvJqVPyLo0+ZgqskAHNHi1Se8lhYOMMZLvV9KOoTitDLF34A0oqFPKFzRe7AdQOQjT
	zqfDp6sxJynF88bifC6JctxHsdA0Tdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, jingzhangos@google.com, 
	alexandru.elisei@arm.com, Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1] arm64: update ESR_ELx definitions to
 match Linux kernel
Message-ID: <kmvpsg2pm5oaf5d4juvbdib6hdts7arhu2i4h7ob5pft2nldj4@h3atwamgylcl>
References: <20260422130820.4023122-1-joey.gouly@arm.com>
 <ggcgjlswla2t5eg6iuzm5lowiv32nzua3qocmqkmrfchibcx3n@3f3a6gi7grwh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ggcgjlswla2t5eg6iuzm5lowiv32nzua3qocmqkmrfchibcx3n@3f3a6gi7grwh>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 26, 2026 at 09:37:06AM -0500, Andrew Jones wrote:
> On Wed, Apr 22, 2026 at 02:08:20PM +0100, Joey Gouly wrote:
> ...
> > +#define ESR_ELx_FSC_MASK	(0x3F)
> 
> Linux calls this ESR_ELx_FSC. I've fixed it up on merge and applied to
> https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue
>

Merged.

Thanks,
drew
