Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEE11D45E5
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732634837; cv=none; b=Y0kpUjjqJH8e0uNKgCHKFn4Y/4B48UfZ/NLq7HRRAopfuhV4iQM+VjI2DTMHDbRVLb9Gn6ohz1VrWf5YCDe5cUYjSQRnk2hF7bxApjPy3h8H9/Fpbodbr845m/w4FKNOwPel8dHjo/fn6pFO3XMyUSY1iGcmX5WLqnzlwiCLvQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732634837; c=relaxed/simple;
	bh=SQFU+Xsv3szl9DD2+hg5ELVIvDu/dfVY2pxap8KnqHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIUkMJv1GKA6oiN5eoIhrPSD001pBJEl/QUDNKcwyjfTYoVW99rWUrSB06QzkDBICbnull9ZPQmISUfzpDY/KtWtsN4utTgEBvkC1fHvUXNY9jb4CWUXJovuA73Q1uWblhnhWv5QVt3mjrSnsojW1YliHMgq4mYo28S8gE+UEbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A4uEAhXN; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A4uEAhXN"
Date: Tue, 26 Nov 2024 07:27:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732634831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M2pdt1QKqUvhQF74nha7uxn2IzLNNgFKRfKY0UJFns0=;
	b=A4uEAhXN/IN4JzD/h5Bvk7X6D4FcKNtOdhYKUDeS4X+PtKv9ifrMkNkRxORI8wkDABMBER
	I1IQrnMYwpcc3Mc/QHzUbHuKKp2qA0I+sjNbV0gL4CmlRposshcn5Sxh5RdoQbDafNn6Uk
	URaRqsg4H6Xxh9ZtFmIPIkG7p4aI8/k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has
 Device memory type
Message-ID: <Z0XoxGSWRCjbTFie@linux.dev>
References: <20241125094756.609590-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125094756.609590-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 09:47:56AM +0000, Marc Zyngier wrote:
> The G.a revision of the ARM ARM had it pretty clear that HCR_EL2.FWB
> had no influence on "The way that stage 1 memory types and attributes
> are combined with stage 2 Device type and attributes." (D5.5.5).
> 
> However, this wording was lost in further revisions of the architecture.
> 
> Restore the intended behaviour, which is to take the strongest memory
> type of S1 and S2 in this case, as if FWB was 0. The specification is
> being fixed accordingly.

Since you're already asking for a spec fix, could you mention that the
column headers in DDI0487K.a Table D8-95 are incorrect? MemAttr[1:0] is
used twice, although I believe the first column is actually MemAttr[3:2].

> Fixes: be04cebf3e788 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8c5d7990e5b31..98cb499fa4b11 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -739,8 +739,15 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  			final_attr = s1_parattr;
>  			break;
>  		default:
> -			/* MemAttr[2]=0, Device from S2 */
> -			final_attr = s2_memattr & GENMASK(1,0) << 2;
> +			/*
> +			 * MemAttr[2]=0, Device from S2.
> +			 *
> +			 * FWB does not influence the way that stage 1
> + 			 * memory types and attributes are combined
> + 			 * with stage 2 Device type and attributes.
> +			 */
> +			final_attr = min(s2_memattr_to_attr(s2_memattr),
> +					 s1_parattr);

Otherwise, LGTM.

-- 
Thanks,
Oliver
