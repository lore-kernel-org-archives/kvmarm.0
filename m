Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC982367BF;
	Thu,  7 Aug 2025 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754582193; cv=none; b=oSuFaLWkSJCdjIlyxEFSZ7VzlwBc3qRvdMJYymamrjx5YOUQ4CT7lbs9awsYlNKlFig3KY6/T3kCmIU3O1bDvmCzclKI2SGciQ2jweqkS4vy84atCQgxANz1gBD9qHvl4MpEuhrBD/xxG09JjwyfDUjxIC5Fgu7p1DeT8XOFJGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754582193; c=relaxed/simple;
	bh=Xs2eRRgMOKZ3yJrDm7z8G/UmvBpz47OWkvePKKXCCzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryRdrvpuJpGi3YyzldtPmbA/xSdp52PlCRJfo54NqjAOlp1bJsn1JEZEve/5I/pjVpi7EQYiXVcC1q0YqA2oOviU/qXQpH+M7us2syb0ZTUU8BzuTSzjUiFRPavFCin2CkmlyggGGxvHQVGR19iqZvg2OfvB/qoPAfL2Pqj9a/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/xuTx+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/xuTx+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60936C4CEEB;
	Thu,  7 Aug 2025 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754582192;
	bh=Xs2eRRgMOKZ3yJrDm7z8G/UmvBpz47OWkvePKKXCCzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/xuTx+Xd3I3yDNkd0MUdhEoTNZ047KhLQOr9QMASpgWAs41RDJGRtToDZumDRi7F
	 8nt4LKReshbg3CBXwjNAV2gHvn+kp+Dw6CIX1DS1CyqATd22MgTQ0qgHj8QEsz8xki
	 iL/AmLh0jkWcGPTRYMKbT1J+/fiED9IxR3Zd6pxEFVZXrRzH7yDuSutgaGkHUpfwCr
	 ycWChe0d/aUecgorjBVETU9z+ishyX96Wl2IJDrJqnwqGLQFK0axlZtjspMGYsoZR6
	 UjjHWaHJYgqfV9JpFuLzkzO79RYVwIIr30gO3CzG6zB18SjxVIaM+2SBIfZzmyvO82
	 vt8EY3yvXZIqQ==
Date: Thu, 7 Aug 2025 08:56:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] kvm: arm64: use BUG() instead of BUG_ON(1)
Message-ID: <20250807155626.GA2145434@ax162>
References: <20250807072132.4170088-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807072132.4170088-1-arnd@kernel.org>

On Thu, Aug 07, 2025 at 09:21:28AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The BUG_ON() macro adds a little bit of complexity over BUG(), and in
> some cases this ends up confusing the compiler's control flow analysis
> in a way that results in a warning. This one now shows up with clang-21:
> 
> arch/arm64/kvm/vgic/vgic-mmio.c:1094:3: error: variable 'len' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>  1094 |                 BUG_ON(1);
> 
> Change both instances of BUG_ON(1) to a plain BUG() in the arm64 kvm
> code, to avoid the false-positive warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Yeah I had responded to a build report around this but I never followed
up on seeing if it got fixed.

https://lore.kernel.org/20250714171559.GA1364710@ax162/

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  arch/arm64/kvm/hyp/nvhe/list_debug.c | 2 +-
>  arch/arm64/kvm/vgic/vgic-mmio.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/list_debug.c b/arch/arm64/kvm/hyp/nvhe/list_debug.c
> index 46a2d4f2b3c6..baa6260f88dc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/list_debug.c
> +++ b/arch/arm64/kvm/hyp/nvhe/list_debug.c
> @@ -17,7 +17,7 @@ static inline __must_check bool nvhe_check_data_corruption(bool v)
>  		bool corruption = unlikely(condition);			 \
>  		if (corruption) {					 \
>  			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
> -				BUG_ON(1);				 \
> +				BUG();				 	 \
>  			} else						 \
>  				WARN_ON(1);				 \
>  		}							 \
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index e416e433baff..a573b1f0c6cb 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -1091,7 +1091,7 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>  		len = vgic_v3_init_dist_iodev(io_device);
>  		break;
>  	default:
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	io_device->base_addr = dist_base_address;
> -- 
> 2.39.5
> 
> 
