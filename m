Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261B52135D1
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738681705; cv=none; b=rIr5rpxYAF90AnEOL2nqJ2xMzNxSW5jHoSQRy9juzj41FWe+DBy14z9sJXBxerSjFgVWT11PnDAkjb4wa8hA9cz4e9rY0FvCLdEMus+YTojLcl58UQmyUAmvFUJHXefkMzcgYAa1pMTEWgTHNEOVme6v+55d9nBN3Xuvu8ay1QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738681705; c=relaxed/simple;
	bh=l1qA03tQEmI/rLZ+4KDdsUaRKYVffN2FebZGpB3KVOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7kfPnNiF01M8d37/RVgwiuLjIg1QCjHGRgx5As/wBJIpr8rD52ng2p9lArBqx3UReeuAFjhXZHMwqN+JYYeJHh7vGOd/65CS+A3sbzz6//lIm49YC9LHWpQNBzJzJK9CGzwC/nwlD4dkeiuYrgbIQp5ync3AdEtNZtoRXBs1QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wTlPobc2; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wTlPobc2"
Date: Tue, 4 Feb 2025 07:08:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738681698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7cXNqLxMlULBvs/VEbdMrugBVf2tfrg1LcLQRcSc95s=;
	b=wTlPobc2RG3aLZEY6tCJL0R/bQ5JLhm7Ph9lBuwv52CZlBP3GSiDpoNP2EzbXuEiZXUSOW
	DwGvZFQ2YZBLuCnTrSKAaCm/6tGx0EIsYR555/Y4VL3ZysiAaAuoUUyWAapyp7uXDWSn+D
	uG3eqvES0nyUKDyro+KvOfkxuCkpzhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/3] KVM/arm64: timer fixes for 6.14
Message-ID: <Z6ItW1ziOWy7LsMc@linux.dev>
References: <20250204110050.150560-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204110050.150560-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 04, 2025 at 11:00:47AM +0000, Marc Zyngier wrote:
> It's been recently pointed out that the NV timer code that is
> (hopefully) on its way upstream is marginally sub-optimal (read:
> terminally broken). This short series attempts to fix things:
> 
> - Correctly arm a background timer in all situations
> 
> - Avoid corrupting the EL2 state by shoving the EL1 state into it, and
>   simplify the handling of emulated timers
> 
> - Drop the weird HV timer offset dance dance on E2H switch that never
>   happens and make HV timer correctly UNDEF on E2H==0.
> 
> Thanks to Volodymyr Babchuk and Wei-Lin Chang for their help.
> 
> Patches on top of kvmarm/fixes, and merged back on top of my
> kvm-arm64/nv-next branch.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
