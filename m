Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A91C84A0;
	Tue, 13 May 2025 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146081; cv=none; b=nVj+3t1oKOfMsv+gOEaWsi7EgbSwLTq1lVkAAK/oVWAgTpJYNBr2H099K5ijmTkN6gb1y18nTMngOO+0WHC67ynKYYX+veXxLajOehPq/i57Ihudk+YAvv340XuUSPLqmD45qZ3qUxRRXhBBMRu5WtKPP1uCVi6iSRBFH0TglJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146081; c=relaxed/simple;
	bh=CleVcc0og0R0I/ZNcQtinsoFZO2oVo5dhJzV7xbtVzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQ82l5TnW+0Yo7sT4v27+5IcOeH3SHQEn8Z/BmGIGm5qigX5Y6D2sO7+KboZnPTSNXzr8rX4KZgvrAXEL6o8jG5rcb3OnPHxfJINn7EnOrNbjuoMO6PwwGcHo9qnE2f7Cuvv2qpedKjL+tcDHtEown3RiB66KmsuJHOrRACkgJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnGZLGeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnGZLGeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E6DC4CEE4;
	Tue, 13 May 2025 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747146081;
	bh=CleVcc0og0R0I/ZNcQtinsoFZO2oVo5dhJzV7xbtVzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GnGZLGeoK7Asc4TqW1psqQgBMl7gMhbYoPXdf13r4wAcr5iwDyza+oM8gGEWjCG7/
	 6AUW7ZVViM66GigZ0bW/6cXOkAGlciAU7nOYc/7zPdsIhLWPUuI5ATPzc2T54t1Ntb
	 y/qzUPfVS+MTEb4D/99nupsyCP/Ha/nR1Psa8tt0TtXgSm5z0NTsomBdyiOQxWTa2u
	 tOToARSU0tyPYT4zBADk5M8hPI8wXMfD53f4Hcq8PI8VHZ3bh7hMM+ziaiR0l1cLgY
	 Kwm6WSar34DsACq+28Mo5jLyQEhN07TLy8pBoTpIaK2azW/P9A8f2bzIgKNi8kO7mG
	 +76T5BeW7NvIw==
Date: Tue, 13 May 2025 15:21:14 +0100
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
	lpieralisi@kernel.org, arve@android.com, qwandor@google.com,
	kernel-team@android.com, armellel@google.com, perl@immunant.com,
	jean-philippe@linaro.org, ahomescu@google.com, tabba@google.com,
	qperret@google.com, james.morse@arm.com
Subject: Re: [PATCH v3 1/3] KVM: arm64: Restrict FF-A host version
 renegotiation
Message-ID: <20250513142113.GA9443@willie-the-truck>
References: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
 <20250513-virtio-msg-ffa-v3-1-d66c76ff1b2c@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513-virtio-msg-ffa-v3-1-d66c76ff1b2c@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 13, 2025 at 06:28:30AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> Prevent the host from re-negotiating a lesser minor version with the
> hypervisor. Once the hypervisor negotiates a version, that should
> remain locked in. Fix the current behaviour by returning NOT_SUPPORTED
> to avoid the FF-A interoperability rules with lesser minor versions that
> allow the host version to downgrade.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> Signed-off-by: Per Larsen <perl@immunant.com>

I'm not entirely sure why we need two SoB lines here...

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

... but the patch looks fine to me.

Acked-by: Will Deacon <will@kernel.org>

Will
