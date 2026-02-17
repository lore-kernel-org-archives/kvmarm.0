Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954C92EACF9
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331166; cv=none; b=syQUDVWo1xaVQdFzvpoD5IflHIhDEcrQaHVfKyKy3/4A5mVDZJxOrS/o5nAAoaSADcOggLYYkvmBsidIz68+GIfkzBghhtqviBWr/yHzbKV9s3MypwobJc1ui1vWNE6uap7rKdqo/uqZfCVfM1r6hC5XOAAsgYg67+DXeuZBLg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331166; c=relaxed/simple;
	bh=2KlYMYJvT7Y1hTSO1LDecXwagv+AIm7sgfiCCrb0pYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct4i7d5zUCmw7X4qvSE6cldK9ucFTOFz7uSRMdDhALU4IkMFq3P8JpoLAAouwdFWq+0NszXNNASItjcd87OI4JdWa/Hj9CE4tO16G5WE2QX/N7R1Bt/7zuP8lug/+BBw95H1Ivt8TzAisUokyxF81ZlF2ijQfAyekECuSJAwNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TI9AL0PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TI9AL0PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7682BC4CEF7;
	Tue, 17 Feb 2026 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771331166;
	bh=2KlYMYJvT7Y1hTSO1LDecXwagv+AIm7sgfiCCrb0pYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TI9AL0PJHNoLl0/+DUPyswIEazvwwB78CNj8mD4bRvCbR0MbGiEPMChYqzrw9BFC2
	 5TLTun3MnEffKHQz/v6Y3Uf3AhgS3QgFmZqCBkviX700Y1USxbbpxaApVINvRFISki
	 eWmMw3sy+XqJodL07DZFztJ+Vaw4Od0grh+QCYs1klINpTnvkD0akl5GhsyNKJauR6
	 4xzBmH6flQGJQWI7BggQc1RNioqchViAsoJvWYSoP4rq9HwMCn3NSjoV0OmfSnsma+
	 SBKANRTyf3bamNkIPyBIKePAyZqjmYqsRNWeJf9sD/3bZeqpDmScj1vw74vSsVxumV
	 eCycN4OD+yb8Q==
Date: Tue, 17 Feb 2026 12:26:01 +0000
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZReWRme4InoSa8M@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <aZNUqONyOUVd0opW@willie-the-truck>
 <cda4e111-29cc-481c-aee2-811f4178f54b@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda4e111-29cc-481c-aee2-811f4178f54b@linaro.org>

On Tue, Feb 17, 2026 at 12:20:14PM +0000, James Clark wrote:
> On 16/02/2026 5:32 pm, Will Deacon wrote:
> > On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
> > > And even then, I'm tempted to simply get rid of any sort of
> > > guest-only tracing, given that TRBE is not capable of representing
> > > exceptions that are synthesised by the host, making it the resulting
> > > traces useless.
> > 
> > I think that effectively means reverting the series merged from here:
> > 
> > https://lore.kernel.org/all/20250106142446.628923-1-james.clark@linaro.org/
> > 
> > but then we still need to clear TRBLIMITR_EL1.E.
> > 
> 
> Removing that series would actually have the effect of turning guest trace
> on in nVHE for non-TRBE sinks. The reason for implementing the filtering was
> to turn guest trace off because a user didn't want to see it.

What I meant was, revert that series and then also ensure that both TRFCR
and TRBLIMITR are always zero while running in the guest. Is that not
sufficient?

Will
