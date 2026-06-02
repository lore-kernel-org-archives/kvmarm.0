Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582A39FCD8;
	Tue,  2 Jun 2026 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780435607; cv=none; b=UN3W4mbERe85TLM1ga0BAD42UVISfYxJIt1xq4TXM6/5flqXIfoV5/IdI7uOt/ulbHtJ8R+izWisJE+15FTAM/4ml3+Tgg/oML7pnfxwSsogZlWwBqNHSRlsZ48rFQ2iyh/gxlUyZ5fwg07z2aUhNjQl2NP9oOuaGA84FfBxJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780435607; c=relaxed/simple;
	bh=d4n5Bid4CGYWzFjvUI7PZkjkb1uPv28ufUeP5I/d+bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8fNQoxQFUDOcaebcEWPjK0YH8XN3HFBenWrxA2ZVDQagOGn9xlVVzwV2pf3Mf9cZw8h23NRKlaO6VP5OvSKohB4uv0EF2ASq9RIMymrh7SrijCkUlBzT8HuLZWERIDjtI4QwIGIRqTEQUufOQjHphnMSvkPV2fSSQIEOMfZck8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFwHDOgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFwHDOgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6DD1F0089B;
	Tue,  2 Jun 2026 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780435605;
	bh=ze0kNDk6g2fIlh+GS7Z/yQ6VYddrJB+PKpzcEjeF1PU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KFwHDOgFvIhGuQcI+ESC5fZw6qjE8ld7genCRd/zpNjBooCmQS5a0A/NAntHb9aNl
	 7HPL4It0xnAM9X5Rn2oeMnoTHUWVDv3/pxh0qCql2xq1tS/eQDES3Hss0tsZqlrL4r
	 iCmxBdnQwfk/uVoIei8Iuz5ghvmKZ+vTQ3JVEkq0Lf3UErTx6YwGhhV3Wm6JcPSXZz
	 bUW5/pTfsD7XocB2uKoZYFTnPX6z8YN9Cz7iJVD0dy8I+IinFopnCMZSj2hkoSCDt9
	 PiG4pFn4T+tcX21l20/ursTZXm6L8pULwJSI5i3+ZMQhQXvq7+xvXV5RxYkN7IuCY0
	 6I289whe+O/XA==
Date: Tue, 2 Jun 2026 14:26:44 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Drop the translation cache
 reference only for the erased entry
Message-ID: <ah9KlG9agyde6Ipf@kernel.org>
References: <ah2c5lu4JbUg7dj-@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah2c5lu4JbUg7dj-@v4bel>

On Mon, Jun 01, 2026 at 11:53:26PM +0900, Hyunwoo Kim wrote:
> vgic_its_invalidate_cache() walks the per-ITS translation cache with
> xa_for_each() and drops the cache's reference on each entry with
> vgic_put_irq(). It puts the iterated pointer, though, rather than the
> value returned by xa_erase().
> 
> The function is called from contexts that do not exclude one another: the
> ITS command handlers hold its_lock, the GITS_CTLR write path holds
> cmd_lock, and the path that clears EnableLPIs in a redistributor's
> GICR_CTLR holds neither. Two or more of them can drain the same cache
> concurrently, and if each one observes the same entry, erases it and then
> puts it, the single reference the cache holds on that entry is dropped
> more than once. The entry can then be freed while an ITE still maps it.
> 
> xa_erase() is atomic and returns the previous entry, so put only the entry
> that this context actually removed. The cache reference is then dropped
> exactly once per entry even when the invalidations run concurrently, and
> the behavior is unchanged when only one context runs.
> 
> Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 1d7e5d560af4..1e3706ac3b8e 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -597,8 +597,10 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
>  	unsigned long idx;
>  
>  	xa_for_each(&its->translation_cache, idx, irq) {
> -		xa_erase(&its->translation_cache, idx);
> -		vgic_put_irq(kvm, irq);
> +		/* Only the context that erases the entry drops its cache ref. */
> +		irq = xa_erase(&its->translation_cache, idx);
> +		if (irq)
> +			vgic_put_irq(kvm, irq);
>  	}
>  }
>  
> -- 
> 2.43.0
> 
