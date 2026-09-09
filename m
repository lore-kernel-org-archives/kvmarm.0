Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842C9545288;
	Wed,  9 Sep 2026 11:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953660; cv=none; b=Dp7xJLJxi4LsdZgkbGzgwJb7o4ovMShZK9oWlYp5vT9A6HXiEsI7bscnt92nz4InoVKqVPJG9hBWYPyB/QmNoxHKoCfR7dg9uve/uRDG3Gy8wpzLKpvDZXRwgEll6cWxB5WICBBmieamI61OVErBP+jg3AasPGwDDn1ttxWM1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953660; c=relaxed/simple;
	bh=BYY1z10WkjEwK2mb4dVa2Dd8xSUo3dhWo++giVKDhnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5STOVcNODuqPBvOd+Jc4+ysLUEjcyP8ueGnLFp1wdM9deie4hkRtHPeJQly8nZigLpe8dWttXQd/4OmyVbLfX2JekVaxkTAFAPtowZSnudCI4C+hNEdy0/WDwefQ6yhSahzfw21ozUVdyJHYKTwvp2l2J6ExH/xb7sopRnnTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yde7Jb30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yde7Jb30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D401F00A3F;
	Wed,  9 Sep 2026 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788953658;
	bh=oSUP/FldKSKIh3rMEH+d3FwAjG9D+pH/7vnolvntLZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yde7Jb30UcygvXK1+GjsPtdnydHn1R+M/nx8DmYk/Yf32NI2SN6NuUACHfnYM5AmP
	 N+MpZQaEiEU1VY8D0fYerMGmJBbrnNH5FeTDmz5idDk18YK/FpLWJe60skjL4KHLvr
	 PeEpzfV6ykd0BDY3jXAbCr+HK9My1i/y6y8Wrw4KrvpeLobGeL0VGZ+RIggo7CyqOP
	 1tTeQAZhegkLr9eFSXFKTSQiZV5QN+Er8GnUYkT+EnCQW0iQj6ytK9lzCj/BnwJlVR
	 VylFoArNg/gAtvX6nhU4gSeUU43t0+01Kg2meWR8ZYhQkuGXr+BwlZDJBh2xPqi6sX
	 knSUvbNG+XKNw==
Date: Wed, 9 Sep 2026 12:34:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <aqFEGDkyZbXp1B0V@gremlin>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
 <apmfx08vccSd2MXw@gremlin>
 <d2659ac3-2f00-4fc4-8f9e-0585691a4ba2@sirena.org.uk>
 <apqA_SuoA6-TyHsS@gremlin>
 <apszJZ17KUvd6BJ7@sirena.co.uk>
 <ap7GPxGs3nhT70sS@gremlin>
 <1effee02-41f0-4680-9a6f-9b9f12459ec1@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1effee02-41f0-4680-9a6f-9b9f12459ec1@sirena.org.uk>

On Mon, Sep 07, 2026 at 03:55:43PM +0100, Mark Brown wrote:
> On Mon, Sep 07, 2026 at 03:14:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 04, 2026 at 10:07:49PM +0100, Mark Brown wrote:
> > > On Fri, Sep 04, 2026 at 09:54:51AM +0100, Lorenzo Stoakes (ARM) wrote:
>
> > > I think the best thing overall would be to leave the runtime paths as
> > > they are and refuse to run with an architecturally invalid setup, that
> > > would avoid bloating the fast path.
>
> > Ack, it'd be nice to not have to worry about that.
>
> > Presumably we definitely want an oops on a GCS violation in general?
>
> Yes, the guest is going to want GCS exceptions delivering if they've
> enabled them and something triggers them.  It might also be relying on
> the GCS for stack traces even if nothing triggers any GCS related fault.

OK so the answer seems definitely to be disallowing the invalid config at
runtime then I think! :)

--
Cheers, Lorenzo
