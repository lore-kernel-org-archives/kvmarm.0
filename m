Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB533A1691
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774549281; cv=none; b=Q/pFu0MhyRRZVBlHglGXTGnMtcIUCA2nnUB7/f3nz1fNm/0WXANhHllricAfnWT8Zf/F/db3h+cveRJ2QpQEAWvGTsueuqDqvG5DsmAISTNmcPv+1FLpiIaakv27rRzU3SThJrs2M+QbbsDzrDTPLUfH+nbhv519LE67ZLb00E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774549281; c=relaxed/simple;
	bh=iUpkYvHbuGQP6Dw7lRN7ijRYKwL4SoItz2X0gx4MLnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0bCRYtGAV7TIvfyL2m9ftQ5xHHAHo3FSEJDD/+IrCI9D655vaIOGbSTac9iaWL4/YK7xM3YoAKZg5HIyUbRO/2FU5ebZRV/nFnaUVaCAMsr8f3cNyhLbx+kOsh//1Sbn+Bv1zjPwBTbJHz/qCoSn0buvt8t0YaDeruHva2WTXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0kplvyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0kplvyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1F6C116C6;
	Thu, 26 Mar 2026 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774549280;
	bh=iUpkYvHbuGQP6Dw7lRN7ijRYKwL4SoItz2X0gx4MLnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H0kplvyfivAHamFYFZxxfLFSvziykz+g1pxObnat8zxnPzTCgDAdRPCP+V1wa9KJn
	 2cGkRDmVZGww58rMsMNtXP5Fusw3j84nr1oenjeVIrQkPOuZO/wAZ8uiN0LLU17sNE
	 oO3G1jwYWQ66dzMdpDWWbq2NjWJMH9eDSPF/BQDOHTLK8mzEeJEykfOuDTVa3jREBn
	 K6Wkx5Ye62BD9jju3fw6HipLDbb1xkbM4bSlUmGfxNnjwuTHGAgqtWC5+mvxOVCn/p
	 zY/jFrqF/ZjQQiXpEOZvUJxjkhbg79Cc2Q/mTr6p23GkeXtVTGBPNliwuTliVKt9ud
	 xQIdHKzINpuJQ==
Date: Thu, 26 Mar 2026 18:21:15 +0000
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: Re: [PATCH v3 3/3] KVM: arm64: Don't pass host_debug_state to BRBE
 world-switch routines
Message-ID: <acV5G3ntjXZKBGsm@willie-the-truck>
References: <20260326141214.18990-1-will@kernel.org>
 <20260326141214.18990-4-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326141214.18990-4-will@kernel.org>

On Thu, Mar 26, 2026 at 02:12:13PM +0000, Will Deacon wrote:
> Now that the SPE and BRBE nVHE world-switch routines operate on the
> host_debug_state directly, tweak the BRBE code to do the same for
> consistency.
> 
> This is purely cosmetic.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 84bc80f4e36b..50413171bd1a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -156,9 +156,9 @@ static void __trace_switch_to_host(void)
>  			  *host_data_ptr(host_debug_state.trfcr_el1));
>  }
>  
> -static void __debug_save_brbe(u64 *brbcr_el1)
> +static void __debug_save_brbe(void)
>  {
> -	*brbcr_el1 = 0;
> +	u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);

Oh no, I've been sashiko'd!

The above is definitely not "purely cosmetic" and I should retain the
'*brbcr_el1 = 0; ' line.

Will
