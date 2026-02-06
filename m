Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB7523183F;
	Fri,  6 Feb 2026 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416981; cv=none; b=dPEFZUMJ/OMzUfpXdQle7tK2Lh+0A6ufQqpOdNBW4tRelQsnUdjDBGgEmQhem97BdSSq9aDyThvyuU+tXzOQQ7GXIeyUyNg8VgF24g4kKOBtB5z3wZqRJF/6+Rg9ZAw7j654P/9m4dRzfNdEZrzgMr49PzPDr8PCKhy2izK7HIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416981; c=relaxed/simple;
	bh=B6i1AY01mf6+Or5Bod2QPlTsM8AkTOEprb6IK6po4dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhpgL5TjYr26QTplV7CdGzazhrih+7Vi0e2t3cijAhCYQ51rIoqRLo0oG9ZjOWEk3Q/dkUhueYmMVopPJmvhS7+d6WtkF69+/Sc5Ou7Umokc6b/d2taF/Fhwict84Eb1j1e0XgHxRZiStytozMbO/rAETQzfTME/SXA1j7E5UnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLtZpnFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLtZpnFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4886C116C6;
	Fri,  6 Feb 2026 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770416980;
	bh=B6i1AY01mf6+Or5Bod2QPlTsM8AkTOEprb6IK6po4dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aLtZpnFtqhRUa6BntvNQngKuRUYxjj+rJ9l8Xg9KYLRb2RMTciq07c8/mD1IvXA4o
	 A5vYd8c54TzHc/gf2mjbuWLcwiFJgsm4D41Y/VimDAUCWlTL2gJd1EAWvVdqJ+9qAr
	 xNJLvl4oRgFLR927qQbaR7gLImKdPupsKVQGDA8Q0TBFIqcn4iptmJCybxp4xi8Qd6
	 Jpd/R8YO8Aa6J8GJNBoX4aVvnBZasdWDNalvTH0bSUwJQj8zqFg8rFi3eb8FU5MN9X
	 8d6jC+bRwGvNZJIk81iA07xIacWLI+4CHoBj3PXX1q1NefP3CFcl7blmiTjdWsrEPu
	 5fGz5UZoQZ2MA==
Date: Fri, 6 Feb 2026 14:29:40 -0800
From: Kees Cook <kees@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Timothy Hayes <timothy.hayes@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Keir Fraser <keirf@google.com>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: Handle const qualifier from clusters
 allocation type
Message-ID: <202602061429.4FB68A777@keescook>
References: <20260206222651.work.438-kees@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206222651.work.438-kees@kernel.org>

Oops, bad Subject... sending v2

On Fri, Feb 06, 2026 at 02:26:53PM -0800, Kees Cook wrote:
> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct gic_kvm_info", but the returned type,
> while matching, is const qualified. To get them exactly matching, just
> use the dereferenced pointer for the sizeof().
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: <linux-arm-kernel@lists.infradead.org>
> Cc: <kvmarm@lists.linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 86c149537493..a53f93546aa0 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -654,7 +654,7 @@ static struct gic_kvm_info *gic_kvm_info;
>  void __init vgic_set_kvm_info(const struct gic_kvm_info *info)
>  {
>  	BUG_ON(gic_kvm_info != NULL);
> -	gic_kvm_info = kmalloc(sizeof(*info), GFP_KERNEL);
> +	gic_kvm_info = kmalloc(sizeof(*gic_kvm_info), GFP_KERNEL);
>  	if (gic_kvm_info)
>  		*gic_kvm_info = *info;
>  }
> -- 
> 2.34.1
> 

-- 
Kees Cook
