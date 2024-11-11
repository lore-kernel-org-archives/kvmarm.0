Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E881AAE31
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731349045; cv=none; b=WEN4ZRE3PBX2L7bN8EyM9+Knw2Z0w5S/u7+ThYcpK7j1JstIk3xsjnextxopyI3kWYvqMIEuEQFwcSRz4vkaOJYz4hRwr+Ym5zyNGKlfpz3M/WmCO5WTlnL+FViR0VjUay85qKlJbAQMpUhK9qj2g2fa/FVH2TVvF89UhA2JhZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731349045; c=relaxed/simple;
	bh=p5bq4zWIYoOq42UIU31rDNIt/xnuNgm5VcmJkhieIv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBi+I8yfVyNHC8EMNmGRYZ9n87ygDNs7urkpfWxX33upYScdmgeLw/roVgbJQrJnJcPga+hrEg5uM3bAV5m/vWE+P3ppladIUOqmMjAhxddNWSck554SIXPlcQADKqEc3nZ0Pn18UGMsSa8T/bK08iEvrvo+c+T4T5BuCOWVGlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U+nK+y2/; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U+nK+y2/"
Date: Mon, 11 Nov 2024 10:17:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731349039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jOs1mpSKNFK+YNaPVnbRYbrVw6wDqgIJJk1/9O0Q1XU=;
	b=U+nK+y2/M8NU5cp46f1xUmoToXz55hWqAGmwQITcTWrUTqAIl+lYX0sfrGlhVsxO/a81iC
	TF8sR1VN9GCiTLhstZVIOsm7iw6lGoDVTC16ufQ7ISspEozJUs9Zk6JP8Ou/snJUlLyc+g
	smWKofKrztF5Dbhab+2yBeJ3CrzMs8Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, james.clark2@arm.com
Subject: Re: [PATCH 03/15] KVM: arm64: Track presence of SPE/TRBE in
 kvm_host_data instead of vCPU
Message-ID: <ZzJKJ1fgkRL7rYwf@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-4-oliver.upton@linux.dev>
 <fac9f76d-d7e4-4a1a-844a-85c64af581b6@arm.com>
 <80c6cafa-dc17-4a47-8fae-9eea03e69f15@arm.com>
 <80eba261-b61f-4197-bdf0-ced1355b06ae@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80eba261-b61f-4197-bdf0-ced1355b06ae@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 11, 2024 at 04:09:28PM +0000, James Clark wrote:
> 
> 
> On 11/11/2024 3:58 pm, Suzuki K Poulose wrote:
> > On 11/11/2024 13:47, Suzuki K Poulose wrote:
> > > Cc: James Clark
> > > 
> > > Hi Oliver
> > > 
> > > On 08/11/2024 22:24, Oliver Upton wrote:
> > > > Add flags to kvm_host_data to track if SPE/TRBE is present +
> > > > programmable on a per-CPU basis. Set the flags up at init rather than
> > > > vcpu_load() as the programmability of these buffers is unlikely to
> > > > change.
> > > > 
> > > 
> > > Heads up, there is a similar change from James Clark here :
> > > 
> > > https://lkml.kernel.org/r/20241101155412.1152709-6-james.clark2@arm.com
> > 
> > Ah, bad. That patch isn't on the public list yet. Never mind ;-). I will
> > leave James to deal with this series ;-).
> > 
> > For context, James is trying to enable Guest filtering for CoreSight
> > trace, v6 of that one is available here :
> > 
> > https://lkml.kernel.org/r/20240226113044.228403-1-james.clark@arm.com
> > 
> > Suzuki
> > 
> > 
> 
> Ah yeah I didn't get around to posting it here yet. I can still post it if
> you think it might be useful Oliver? But it will probably just confuse
> things. It does some of the same things as this patch, but I did expand
> vcpu_flags to be just "kvm_flags" so that they were more generic and could
> be used on host data too. It wasn't strictly required because I didn't need
> any of the preempt disable stuff that's in there, but the other features are
> quite nice.
> 
> I also had separate "feats" and "state" flags on the host data so it was a
> bit clearer which ones were static and could be passed from the host to pkvm
> hyp at init, and ones that were dynamic and would only be used for storage
> by the hype. Although just for the SPE and TRBE ones here you don't need
> that either.
> 
> Either way I can still do the filtering changes on the top of this.

I think that'd be good, at the very least post what you have and we can
decide how to iron out the differences. I'd like to resolve these features
at init to avoid reading an ID register for every vcpu_load(), which will
trap under nested virt.

-- 
Thanks,
Oliver
