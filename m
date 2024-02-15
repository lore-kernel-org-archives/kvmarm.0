Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5014641C61
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708030992; cv=none; b=Qpc60ADo00qHQyuHVUAZUxJY0HeLUuKo5yP70YtieyAutTFiB1VVnbJRgqIZH4mPQ97mwzn/VPKcp4U8Jl3Ss3mjeo774GXaUIygu//pmhQk8SXr8Z3dsunXk6x8ebqG6felfow0tOa0sqGCZdzpIgyEJJYQs3CfF9rlwwrgp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708030992; c=relaxed/simple;
	bh=sQCeFU3SpaVRQEY7caus3BVVCR0Axb23+J8VEhqPs/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0GH8+DJnMHkHlnn8IVVhP3VrCK1fhJpGZsUVaKNBONnwvyIKQVXcA7cyqSNIEU81cfXF+mC/8kkPRnbFjfWBnYJ934KlCrt8cqb8WLgnkUn6UbC1eEMdwUdbo1NQ/9tVaKUdwkEL7avvRdMJd7KxGmI9rPYqFD2HXGzCsEv4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PYSSQ+lL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PYSSQ+lL"
Date: Thu, 15 Feb 2024 21:03:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708030988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ts5Qsxc+TilT9M3NIx6W+fFZNH0j/3iCtOkk3o5vdsU=;
	b=PYSSQ+lLZDVi2JaF7700GzPKsrEDtspSntVRpa0IZTWSCNqGaJ/daYEeCWBts7uqdsWBSY
	YhxsfGYSpzJoIv4oRMiUWbH7JxFRDu9Gi8qQz2gOLLFYmoFIrYEycqOYEOh0evvKzOBgoy
	ACzXPJOFKXwcDRk0DhSqK/Brjgmg924=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 00/26] KVM/arm64: VM configuration enforcement
Message-ID: <Zc58BDf6X6lkYLz_@linux.dev>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 01:18:01PM +0000, Marc Zyngier wrote:
> This is the fourth version of this configurationm enforcement series
> after additional reviewing from Suzuki and Oliver. Many thanks to
> both.

I'm leaning towards applying the whole series, this is looking good. I'm
going to take it for a spin on a few machines, especially AmpereOne
to make sure that hack still works :)

-- 
Thanks,
Oliver
