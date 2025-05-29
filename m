Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C9220F5E;
	Thu, 29 May 2025 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748512494; cv=none; b=gjBSwICaNUd74SnEBFuMdJvsORfk1MNWXpYXxpJ3uyw1B97Cpp7wyzf9Fv2kVfRHsWwbQESD4DUGpW35QjoPBwSGSHwrBNNX1WiyPQ7Ewu0k2tRgVVI1W6tfYMkSpN+9kBNyB5rbDHKmAUu+CyaZZ1H44inF0ROzY5Bk/fSTdHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748512494; c=relaxed/simple;
	bh=p8bTd3R8QqEl2fi6VDqo5Vv2oBJDWSobyKoefPozxi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxGGTwRRsHipFmSBmZeBMvPu2NHn2u5Pwss+QtknsYD+5iPmOQBD6NAat5muTQb7VLq9jbiKXeCjPbYGLont2rGofRXjDWAD4pdaBfq1g5f1DBoGAftL/0SV77Cb1ZBIi+EbvOYMiLoM66ZBpBVU1mgxSBcd6t0VEFcR6ZpiA2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mm/BJaqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mm/BJaqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3766CC4CEE7;
	Thu, 29 May 2025 09:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748512494;
	bh=p8bTd3R8QqEl2fi6VDqo5Vv2oBJDWSobyKoefPozxi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mm/BJaqT9j09R5484NuixQcFzKwi1VxzPF8w9ohL6UpDzW3Nuy9sNqoWYzQ+fBgJm
	 iPCQY/Zvtn/O307jaW7bu82luyPbql3adEAHxAcmR3gyff3tzx1ZiWDSbR7o3Lf3yP
	 LfuHyVnnmsJaGcbmwt1umAq5VWuqP/XsmaU+1n/byW7wrWzsYhCTUG59MuGI4Ij+7d
	 qHbku1cXZLvAOc5Rb91nYnQl167jvT62uTXHfU018CvB/kx/3WNekACdsG/jv+GUCr
	 WUGUf8vRR5M3ddJoNQCuki+aUz7NqQzAfKShJ6eteiUUVEA1x/M5+Eay/saQrZHx8w
	 g1uPc2PYWlAgQ==
Date: Thu, 29 May 2025 10:54:46 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, sebastianene@google.com,
	qperret@google.com, qwandor@google.com, arve@android.com,
	perl@immunant.com, lpieralisi@kernel.org, kernel-team@android.com,
	tabba@google.com, james.morse@arm.com, armellel@google.com,
	jean-philippe@linaro.org, ahomescu@google.com
Subject: Re: [PATCH v4 1/5] KVM: arm64: Restrict FF-A host version
 renegotiation
Message-ID: <20250529095446.GA29035@willie-the-truck>
References: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
 <20250516-virtio-msg-ffa-v4-1-580ee70e5081@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516-virtio-msg-ffa-v4-1-580ee70e5081@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 16, 2025 at 12:14:00PM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> Prevent the host from re-negotiating a lesser minor version with the
> hypervisor. Once the hypervisor negotiates a version, that should
> remain locked in. Fix the current behaviour by returning NOT_SUPPORTED
> to avoid the FF-A interoperability rules with lesser minor versions that
> allow the host version to downgrade.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 3369dd0c4009f84ad3cf9481c747bdc57a162370..2c199d40811efb5bfae199c4a67d8ae3d9307357 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -712,7 +712,10 @@ static void do_ffa_version(struct arm_smccc_res *res,
>  
>  	hyp_spin_lock(&version_lock);
>  	if (has_version_negotiated) {
> -		res->a0 = hyp_ffa_version;
> +		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
> +			res->a0 = FFA_RET_NOT_SUPPORTED;
> +		else
> +			res->a0 = hyp_ffa_version;
>  		goto unlock;
>  	}

I already Acked this one:

https://lore.kernel.org/all/20250513142113.GA9443@willie-the-truck/

So please add the tag to the patch if/when you post a new version of the
series without any changes to this patch.

For the bots:

Acked-by: Will Deacon <will@kernel.org>

Will
