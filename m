Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E140D11187;
	Wed,  5 Mar 2025 00:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741135530; cv=none; b=GYHt13iFMTxkQMXXlqtnqXaRKN4Mo0oxoaKjnXTU/76QHjye8hvHWC2eypp5OJBGfWatLV/oZdq0JqDws8ZiWz1x9lRE2Eeih3bebO30d6pGzqYbYv96RPFn8Hd5wQXO4JAQxSg2w5FM9CLecGIsw9nsCFY/fMTo9JveJcHJoho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741135530; c=relaxed/simple;
	bh=gFLlK8tKubCvB0zH2AmLKFcC0Bw0FyNX/KP5Xafjw14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr510PGddRqyy3peMxEuR72tNyxsSLM9mFZNGkDucz/6WnJ/R3pQV8dka2rld/qBLQZYrNC4SBxThRRuzxXS+JPEVAoV6lLxTvDXUJo8J05ek5Ky7s9BBAxsewurN1yZmD9ZsJssKywH68vsjnBSl2TGJ+0QJguzyaIK+P1maA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZi4Nst1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZi4Nst1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D50C4CEE5;
	Wed,  5 Mar 2025 00:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741135529;
	bh=gFLlK8tKubCvB0zH2AmLKFcC0Bw0FyNX/KP5Xafjw14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pZi4Nst1ORWhKWhrislwqJ0nN6gzS2masD/TWLsThj5T1FkvvBjYE4H6+bduYuIb2
	 6lp8GbvTwxeuLUMoCFXb+QKNPQclw6Or4uh7PHcKLTMXVFCXaIPS4tgRJAQbAZ3U3V
	 uFl67ncSydHcttrWPwd8UnI62QJafNDziGcEoBo6ZhuFqR3GObn+OhqBQwtKSc7AgV
	 wuoZnF8pUu84XipAeYsvSDz9v6BCPZSGJQnf7LfFNdlhQVpY+08EAtvBgRSzMhkDx1
	 dmFQovKTn0qh7ndZlU8fUG6icPeISOQMOJrSXW34dEdzNIx5b7nkzOAkva4kK43VnJ
	 vZRYw3jRpHdng==
Date: Wed, 5 Mar 2025 00:45:23 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <20250305004522.GC31667@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227181750.3606372-5-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 27, 2025 at 06:17:49PM +0000, Sebastian Ene wrote:
> Introduce the release FF-A call to notify Trustzone that the hypervisor
> has finished copying the data from the buffer shared with Trustzone to
> the non-secure partition.
> 
> Reported-by: Andrei Homescu <ahomescu@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 861f24de97cb..7da0203f1ee9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -725,6 +725,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	DECLARE_REG(u32, uuid3, ctxt, 4);
>  	DECLARE_REG(u32, flags, ctxt, 5);
>  	u32 count, partition_sz, copy_sz;
> +	struct arm_smccc_res _res;
>  
>  	hyp_spin_lock(&host_buffers.lock);
>  	if (!host_buffers.rx) {
> @@ -741,7 +742,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  
>  	count = res->a2;
>  	if (!count)
> -		goto out_unlock;
> +		goto release_rx;
>  
>  	if (hyp_ffa_version > FFA_VERSION_1_0) {
>  		/* Get the number of partitions deployed in the system */
> @@ -757,10 +758,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	copy_sz = partition_sz * count;
>  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
>  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> -		goto out_unlock;
> +		goto release_rx;
>  	}
>  
>  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> +release_rx:
> +	ffa_rx_release(&_res);

Hmm, the FFA spec is characteristically unclear as to whether or not we
need to release the rx buffer in the case that the flags indicate use of
the rx buffer but the returned partition count is 0.

Sudeep -- do you know what we should be doing in that case?

Will
