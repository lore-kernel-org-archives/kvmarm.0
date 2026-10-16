Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C23845CB;
	Fri, 16 Oct 2026 14:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161034; cv=none; b=Bj1px/adAmrmGWCPmR6Gg9Xmto70HoTaC5HJqVeLz58GL0xgXa4+RcwlXbsMVMPNSx/Oy1deJYjPQ4immIMH+DxNd9qm/roYyWwh2RYBOVkupV4sS2C+c4tuct3ABp6tS4bBR2Hx+MXE72rakXHdL1vS2/eHY0ltmg3PBhdoqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161034; c=relaxed/simple;
	bh=d4MPPdO5XHaBgijKwR4djxJZCTl14g1N2pr5fKJ6MpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPdQIoMmGKwp4sA6SzkeitpAoEhgRIXARVzf8E2BaJ0LuDJi5BpK0xXVBN0a41YgA7zXAQ9Y277/mXPmpu+tY58iUwjqh60BL1L3VDUASrZlub1020J3ix0UxuCZX6CDFojb/ny+Z2Wgd6z8YJJWoOj+zZYKyR0ws6WG0VDa75Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/zQhxy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/zQhxy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C791F000C5;
	Fri, 16 Oct 2026 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792161032;
	bh=BC2GgbK+WoFQXcV9V5/6mo0si8p848r+VKvD9YiR8iA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J/zQhxy3DvvHtqlJgPR2wCD6FtIcCpZDGlMxgpqkGGOcbZPi2Z5FSg5pav4I9SOZM
	 eUcBaIxHIKW/XlnIizLNd3Tp11ed8og4XnvEHSiRuJgaOXacO5qcUAmjpUzZb6CJoh
	 SZaasebWVHsUO16EJIFaKgGPd9zMhEjvqTEf0yBosyZqdJaSorlkhev3BOdjy1WHKj
	 CjX/fsi/oM4Fn9vcH/TdwrRjtOKjB7mnl5+0VLiMWEvYuFwoc7jgcxY2vVYiZu4YUt
	 R1Q7VGkl/Qt+Wt5PJRSjKnuaSHJXN4E01nYVDhdGQaQ1LS7TkAsECRJBWThOnWtz9/
	 uojxREGTx2JhA==
Date: Fri, 16 Oct 2026 15:30:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 08/28] HACK! KVM: arm64: Disable SPE
 virtualization if protected KVM is enabled
Message-ID: <atIzmvlo78PDwAXI@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-9-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-9-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:03PM +0100, Alexandru Elisei wrote:
> For RFC only.
>

I realise this isn't intended for the final series :) but be good to put
something here briefly for reviewers to explain why this is here, e.g. pKVM
needs special attention etc. Similar comment for 9, 10 if there's an RFC
respin.

So for this and patches 9, 10 in general it seems you disable the feature
for:

- pKVM (at global level)
- non-VHE
- nested virt

Are these temporary for proof-of-concept reasons or do you plan to make
them permanent limitations for the initial implementation of SPE?

If the former it'd be good to know what your plans are to provide support
for these, if the latter it seems sensible to put these all in one patch
that describes why you are limiting each.

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I won't bother actually reviewing the hacks, so just the queries above for
8, 9, 10. Will resume review at 11 :)

> ---
>  arch/arm64/kvm/spe.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 646806a60d66..97160d1fae81 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -22,6 +22,10 @@ void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
>  {
>  	struct spe_pmu_entry *entry;
>
> +	/* TODO: pKVM support */
> +	if (is_protected_kvm_enabled())
> +		return;
> +
>  	guard(mutex)(&spe_pmus_lock);
>
>  	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
