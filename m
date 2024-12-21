Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61601714A0
	for <kvmarm@lists.linux.dev>; Sat, 21 Dec 2024 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734818392; cv=none; b=jPmiCIzq+7mfYNYmBqhG/1u4JcsXTgSdl6PPbn+g3f1gaxIr2FGT3Pu6H0gSE8W6fCDp1/L/qCUPBtoAWOHEclXUHx/H/1n9wwPeuHIHqLPFyCvfiGovUYQl06VpUpTqm8GhCzhqL0ubY6JQzbtZAS0/E8kdM3RoUbUv2H6cWdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734818392; c=relaxed/simple;
	bh=q7H+q7RwLWdTFqmWeeYtoEabZmWvRkH8/I3tvAaQkDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0ouy54/A7YwzjASZeAZEk/+w5USw8nXEOQPPbdIb0pi2lybFEwjiwjg3cXd1Ere2DG/9iCdvb5TM5d4rj/ZJHXT6D88c3yuLLHygRAWXcLa2F/pBYh797Z65Dl+agySOVeAODBzksfAu6R+WPe+aw4Oygk/jArha8sAEim0cCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kooNmr1H; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kooNmr1H"
Date: Sat, 21 Dec 2024 13:59:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734818388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99plZstsQ2y7N4k+BZHSEU8wjYN1TzFeqMdUoCS0IB0=;
	b=kooNmr1Hhi2lrqZmoEA/krEiUgcdJjTIFZc56jKefODAgMj+PZiEwcvtdO7V4HXqy0pFc7
	9O3HEQdbK2VtoDyI9c7zIS77Ipl/9IEdpWHWZaq0+OWG0vL4wS381d/ke9WsDWGM0i46Nk
	g7WSi1aj+A3d57DWNeIe1LzB99yei0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Advertise the lack of AArch32 EL0 support
Message-ID: <Z2c6TzM2i3DjtCTY@linux.dev>
References: <20241221101137.1405271-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221101137.1405271-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 21, 2024 at 10:11:37AM +0000, Marc Zyngier wrote:
> Although we never supported 32bit anywhere in NV, we fail to
> advertise so for EL0, probably owing to the relative lack of
> hardware supporting both NV2 and 32bit EL0.
> 
> Add some sanitising to ID_AA64PFR0_EL1.EL0, and reaffirm that
> "in 64bit-only we trust".
> 
> Reported-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks!

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
