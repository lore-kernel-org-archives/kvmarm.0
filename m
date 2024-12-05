Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D131DEAFA
	for <kvmarm@lists.linux.dev>; Thu,  5 Dec 2024 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733359235; cv=none; b=SD3GianLNK/BRspiOMLB1qmCnYKgmrI1reAXtXw4w5ol30cx9DBc0fhOlkBwWSh/AF4jNf3csVR1PbWJcvix8zafu8l5uFBZQLOf5RWPIAKS6y5npxC2efcPu/eA1TgagwoaMoA/TibNQPraTJLUZPmat/onY2bq9VF5XxIwOZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733359235; c=relaxed/simple;
	bh=yaVWmFdP6s62g597K06XDwtA/Md9LOpCv4G/1v6JBQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJZ4iGuxnrJ01QvOKCrQIvEieg2duOK+lU5/OS7lh5Bbyl/pGPcumFIvqy1v0cQ7au9R72JBKBkjRhyRVXrVguttw8C9XimeI113QpqLysFmXSwkyc8vtkgBHoyGxRyzV695vXKGz4v/svtIhkp5SrOGLxyYSo/O7YtjJpRwsws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vgOUdWhS; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vgOUdWhS"
Date: Wed, 4 Dec 2024 16:40:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733359232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4U0q3vONwMwpWG5uTnFmXFqnR3IIk2M7iJ9C6Mgww6E=;
	b=vgOUdWhSQE0eYd15Ox9xMmxkNDh/fO2gcsBrZSUMHOoyAPiKYhiUTHQelWEMEert+Zsi/u
	TwQcgDFkS3sI6CKURjqwF5X6cNjiDRfFqfVWpWaqFR16CJX1DKyoMdb3LlsrS0+EYdVKfM
	WSs16XWSEBgEloDqpD6XZsizs3GNodg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 00/11] KVM: arm64: Add NV timer support
Message-ID: <Z1D2ezLP7nL0TXaf@linux.dev>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 02, 2024 at 05:21:23PM +0000, Marc Zyngier wrote:
> Here's another batch of NV-related patches, this time bringing in most
> of the timer support for EL2 as well as nested guests.
> 
> The code is pretty convoluted for a bunch of reasons:
> 
> - FEAT_NV2 breaks the timer semantics by redirecting HW controls to
>   memory, meaning that a guest could setup a timer and never see it
>   firing until the next exit
> 
> - We go try hard to reflect the timer state in memory, but that's not
>   great.
> 
> - With FEAT_ECV, we can finally correctly emulate the virtual timer,
>   but this emulation is pretty costly
> 
> - As a way to make things suck less, we handle timer reads as early as
>   possible, and only defer writes to the normal trap handling
> 
> - Finally, some implementations are badly broken, and require some
>   hand-holding, irrespective of NV support. So we try and reuse the NV
>   infrastructure to make them usable. This could be further optimised,
>   but I'm running out of patience for this sort of HW.
> 
> What this is not implementing is support for CNTPOFF_EL2. It appears
> that the architecture doesn't let you correctly emulate it, so I guess
> this will be trap/emulate for the foreseeable future.
> 
> This series is on top of v6.13-rc1, and has been tested on my usual M2
> setup, but also on a Snapdragon X1 Elite devkit. I would like to thank
> Qualcomm for the free hardware with no strings (nor support) attached!

This series is looking pretty good to me, but I think it'd be good to
remap "EL0 timer" -> "EL1 timer" throughout this series to match the
architectural term.

-- 
Thanks,
Oliver
