Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEFB1BD9D3
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732816565; cv=none; b=K6BU+h98hlo5105ykyoDzN0uJ9L8FiSFCZKUl14fLttZfg2Rv2cwXwFmFb3KSn+txpIvf5o3H+T+kxvhLImmxbSTrh19bAnWz6M14pGUwE/HMjOK4pZqIpyVPZFToeJquQBo2ZLI7fNL3Y75p0GEolO1k6K6QrU96FBmlXinfHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732816565; c=relaxed/simple;
	bh=RFFAD16NrorvkER74LgoxUidv7K9vsrdWXU+MKveKjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJd3rMFEnu2SS+wDN3rSt4r7EOgzPckPnuiLQFKYexGs2WmSlVMMTHbqTauzJUbQdk+BGVLLIPToiiXBXLjUd7+VtwOqTCyABC5s4dyLNNOJn5DTyT0jxntGhny5Qgb7NV1a3t2WFAA5k7hzn8eiAkSaOyEKEAYZnQ3qCoXhkkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c8WtAUUv; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c8WtAUUv"
Date: Thu, 28 Nov 2024 09:55:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732816559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eoxpt1hElYo3Lr62axL4tvLlza1cfj6ZJRW4ApIUI20=;
	b=c8WtAUUvBNRiabDrwj6WM9TrNXaEq/7nYN5wia0xgHXaDyqiGiWSJEU4yYoQskC1p8wItb
	xjfRfkkTCgO0914+sKtW7cqwgOYnRNbd0uVgP1YdlWyJQq4AsBmNmR56VXXHwlZr3ETmG6
	8fIT9nUhHCzKvddR7po2TvgF9X7IW1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Add error handling in
 vgic_its_cache_translation
Message-ID: <Z0iujBMl1ypdwfBu@linux.dev>
References: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 28, 2024 at 02:45:34PM +0100, Keisuke Nishimura wrote:
> The xa_store() may fail because there is no guarantee that the cache_key
> index is already used in its->translation_cache. This fix (1) resolves
> the kref inconsistency on failure and (2) returns the error code.

xa_store() doesn't fail if an entry is already present at the specified
index. It returns the old entry, which is why we have a vgic_put_irq()
on the "error" path.

Genuine error handling definitely is missing here, but that would only
happen if the xarray library failed to allocate (-ENOMEM) or if the
xarray itself is broken beyond repair (-EINVAL).

> Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
> Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 198296933e7e..8f423857b7d2 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -555,7 +555,7 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
>  	return irq;
>  }
>  
> -static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> +static int vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
>  				       u32 devid, u32 eventid,
>  				       struct vgic_irq *irq)

This was deliberately made a void return. The entire translation cache
is opportunistic and not required for functional correctness. Nothing
breaks if we fail to insert an entry for, say, a failed memory
allocation.

It would be extremely helpful if you could share the steps to reproduce
the error you observe.

-- 
Thanks,
Oliver
