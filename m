Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B30828469C
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356718; cv=none; b=M8oX0VPq5Y/uNaEUVA/Fjt4mBqnQJo/rY0leMwtuiE/87r9zfs8s7AyuOCcXWb01/imwaQKCajC+J1SMqTUJ2Tr7thj+/bbw2MWL6YAbo94Kim9VUZ3vTN4xyL+ZgSOCWnLJxWBB7GKAC5PRMX14tC4WblS/dk99bw87DMtKP84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356718; c=relaxed/simple;
	bh=4iiT0TdQ3+1FIKpnFcCZhKkX/j2LzqbfPiZtYSvtl+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r83YvOnDD1Ol3YQzM/dBaSiZVnwpMiT6qbt77+6HzEqEEWWrquC9m1UUeNWQFJ6dnYeGu66Bh8je6EQ0dgRlB3z1qewHVUxyZdGKP8TzNe37U1YeQY9B7JhFsISKxqVj/aAWQbv3NTtFG9bGZ+rVghmA+o9jrP8hXILQ2EJTcFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tjXHimy6; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tjXHimy6"
Date: Mon, 8 Sep 2025 13:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757356714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pBVcn6UmXxC022/oqozqmZqd13vUD+vhJOE1KvRibxw=;
	b=tjXHimy6rd6TdAcOs0apoBrOyZZOTbAH7JdIbaB5Cs37CoRfYJIYUqijKPFozNHtHy8jOl
	eX557DqvpY9qWglfxMQxPkpC88Kq6a+FnxGAPgwzaRxYcBRxF4n0Dcs2r9OK3QuqpCh4kv
	IVru9sXtupRVPip5bAqW9VacyZTg8/Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm64: mte: Fix MTE granule mask
Message-ID: <20250908-ccc886d2d9ea61b50001dbd7@orel>
References: <20250905124129.32435-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905124129.32435-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 05, 2025 at 01:41:29PM +0100, Vladimir Murzin wrote:
> So it generates correct mask when used together with MTE_TAG_SHIFT
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/mte.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/mte.c b/arm/mte.c
> index 95d58aaa..a1bed8a7 100644
> --- a/arm/mte.c
> +++ b/arm/mte.c
> @@ -26,7 +26,7 @@
>  #define MTE_TCF_ASYMM	0b11
>  
>  #define MTE_GRANULE_SIZE        UL(16)
> -#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
> +#define MTE_GRANULE_MASK        (MTE_GRANULE_SIZE - 1)
>  #define MTE_TAG_SHIFT           56
>  
>  #define untagged(p)									\
> -- 
> 2.34.1
>

Merged.

Thanks,
drew
