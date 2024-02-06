Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F364512E1E6
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 10:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707215319; cv=none; b=n74uB55jtkUZJlxnkL/sfvUcfotye5x6MUCKp9jg9tqp972t8H17lTh5GUK9HDHvID1arVPlwPdpqyiYcqLCI9IeY24btSB+lP+JkQXkcfrnIspk8KohOfI6a7JGuFOTprxdC50U2fGtA+kVTM51JYFQPemp1qwqHT0qk4jhNNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707215319; c=relaxed/simple;
	bh=12ljC+gaSJ1gkfLRkLsG39AQOSWyWJvCPPJpVFot1CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHB9ufg93hTAcblBO9jERpvG//eyOVmZ/TTOr7IJrdtuUMCBmWPxSp2OCRngInyDfZCTviCp7DsbxvZFmzPKq9mytJRYrA3ecvuoYQvRcFpXlwpN1bB7DWQ+u7JwhOcIrduS/3IAkpSbm2wBNrU+SP7Ng0zIk/T7id8YiYt0d6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sC+ynBUj; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sC+ynBUj"
Date: Tue, 6 Feb 2024 10:28:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707215316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UH4qnyV5AlPKuzyHE4nU37Hkz+CAr8GksiGngTSrZn0=;
	b=sC+ynBUjP2HdG1anTszZxl9OkpuQhhXiL+XqX9h1SsafTSnJQaWBtEA/1X4NVwjU4mAgrj
	FDC2SjZo1erNoQrKFmiJEVJKovL9V9OLMFyI4sZdaMLBSIoP7TkY+vG2k1d1PcvoMoaSu7
	Ud1L6lkEXjRKG6SfDrs0QxCo8xf9xpE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Saurav Sachidanand <sauravsc@amazon.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] KVM: arm64/vgic: Populate GICR_TYPER with Aff3
Message-ID: <ZcIJzn9KLR_bWdwc@linux.dev>
References: <20240205184326.78814-1-sauravsc@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205184326.78814-1-sauravsc@amazon.com>
X-Migadu-Flow: FLOW_OUT

Hi Saurav,

On Mon, Feb 05, 2024 at 06:43:26PM +0000, Saurav Sachidanand wrote:

[...]

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index c15ee1df036a..26bc838ce14c 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -324,6 +324,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  	u64 value;
>  
>  	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
> +	value |= (u64)((mpidr >> 32) & GENMASK(7, 0)) << 56;

This looks suspiciously similar to what MPIDR_AFFINITY_LEVEL()
accomplishes. I think we can tolerate a few extra lines of code to make
the entire thing more self-documenting, like:

	value = ((u64)MPIDR_AFFINITY_LEVEL(mpidr, 3) << 56 |
		MPIDR_AFFINITY_LEVEL(mpidr, 2) << 48 |
		MPIDR_AFFINITY_LEVEL(mpidr, 1) << 40 |
		MPIDR_AFFINITY_LEVEL(mpidr, 0) << 32);

-- 
Thanks,
Oliver
