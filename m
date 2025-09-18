Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993724E4C3
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758232750; cv=none; b=aDWqNKhe0p5FGyYH33xbAHwtqsEqEfSZcvhJidUY2kQIA953URF3ZMTtQ7BaGKPULSe5b210iS/CfdEqdFD8Xi3kZ3kDJnv49GwvTSQVdzV175+28fZFNlP9Z0duvSwjxXu99jJebuodCbrdPf5nK90MZCeDpmBdppZjZYzR1lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758232750; c=relaxed/simple;
	bh=2OiKmYY2Mab94kFiYXTmD/Tj7kOjaE6vWvMUuO7bYkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsOhbga/3YIkkyeJcKbnjGNWAD81MFfN4j3G06YZ9kBz4ne5iTqm4bBLVIPaZC2oi2VX0CrB9AaHo6zrSPkpm6dnwjy3/qXBrElK8VFJCZuasxLcnk3skrTQ2lu5//Iq5BIXUiwm6D5CmmWK88Ojn/OwY66tmz5Bmkvi5+hPcxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sk1hzzV1; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sk1hzzV1"
Date: Thu, 18 Sep 2025 14:21:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758232740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yV2xHUADIUVgzf3tVjzFgnathlyFhibAgpCijuTGhQ=;
	b=sk1hzzV1vpw6seiRIzauAmhjW9Wv6WImdrBjKPjkWSHvd0sCttC6o/4qulnF+/TLMfXiSs
	ilhFLgfEqC+Eozqf9GcAAHh2nnqg4/mAeKxJSXv3Fp0ufGnacyuEV5atDFYhyAAfgZxO32
	6sVM4RfVhqUJ1aA47p11qdnJrY9z1m8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, sebastianene@google.com, keirf@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Validate input range for pKVM mem transitions
Message-ID: <aMx351jkCPIv_j61@linux.dev>
References: <20250918180050.2000445-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918180050.2000445-1-vdonnefort@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 18, 2025 at 07:00:49PM +0100, Vincent Donnefort wrote:
> There's currently no verification for host issued ranges in most of the
> pKVM memory transitions. The subsequent end boundary might therefore be
> subject to overflow and could evade the later checks.
> 
> Close this loophole with an additional range_is_valid() check on a per
> public function basis.
> 
> host_unshare_guest transition is already protected via
> __check_host_shared_guest(), while assert_host_shared_guest() callers
> are already ignoring host checks.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8957734d6183..b156fb0bad0f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -443,6 +443,11 @@ static bool range_is_memory(u64 start, u64 end)
>  	return is_in_mem_range(end - 1, &r);
>  }
>  
> +static bool range_is_valid(u64 start, u64 end)
> +{
> +	return start < end;
> +}
> +

I'm being unnecessarily pedantic but isn't something like [-2MiB, 0) a
legal range if we had 64 bits of PA? Looks correct though so:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
