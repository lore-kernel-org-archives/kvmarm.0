Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFCF4EB860
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616090; cv=none; b=L0BJMgO0Blt/rqntT9k+nONMhm/ZwSdlKlpfEVDGF+NoNN+rt8G0cI28tW+wGgyT185ILQ42PKfgV42cLcOkqUnZ47wo/qJ1JqzrASnUJtXcCDMJciFXgAs5ePm2D3FQfgcclc00t7Bo61/sHJFGRgAhumYNv2nMi2eUOoSxa5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616090; c=relaxed/simple;
	bh=790JUH5G22WyxFCJKmJhxP6ZybggdKZ1IIYxsE558ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=B1piN3wbmsc/dNS6SPTFsUo4W08rBp02eSkYoX9cBAwWUrxHurz9bwuez7wvGn20WW8+nkTHch+yk+fS7Rox8jCuiC4Vfbjn5TqrtcOtOQeBiksgvjHItIY7GewivweIJX+s4WMpB9c2BVatPywLuYr4qqULQ4nY4IJAYdxpZww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D/hhgv2n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D/hhgv2n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2559F1655;
	Mon, 28 Sep 2026 10:21:16 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FB6F3F763;
	Mon, 28 Sep 2026 10:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790616079; bh=790JUH5G22WyxFCJKmJhxP6ZybggdKZ1IIYxsE558ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/hhgv2noAxj80V4lN8MfW2byio/EQ3T8ZOdss3Y+ZF7Dbl6YRGQ4/yXhX7ZxNpqJ
	 VTyV56dO7+ZKCmlKdnJe8qYt0L1dBge9JCHece0i55BJJO5zWMY0cXFWw3190Fr74X
	 EpOQ2qBrEe8bXjnMEjqtXV10iHvNGSX8dni18Mtw=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 22/22] HACK: KVM: arm64: nv: Set the dirty state for CMOs that fetch for write
Date: Mon, 28 Sep 2026 18:21:16 +0100
Message-ID: <arqiCz1ncT2uUGL9@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-23-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-23-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:42:01AM -0700, Oliver Upton wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> Cache maintenance instructions that fetch for write do not set the dirty
> state on descriptors, effectively passing the permission check and
> leaving the descriptor in a writable-clean state. While this may make
> some sense as the literal write has already occurred, there is no way to
> correctly represent a "writable, but only for CMOs" permission in the
> shadow stage-2 in such a way that the next genuine write generates a
> permission fault.

Sorry, I could not understand the issue above. Could you please expand on 
that?

Thanks!
Leo


> 
> A possible alternative would be to treat CMOs using writable-clean
> translations as NOPs, relying on FWB to force everything coherent on the
> CPU. This mostly works but will lead to breakage for VMs that have
> assigned devices performing non-coherent DMA.
> 
> Another option would be to set HCR_EL2.TPCP and do full trap+emulate of
> CMOs. And yes, dear reader, that would suck.
> 
> Just do the obvious thing instead and mark the descriptor as dirty for
> CMOs. Maybe we can get an architectural relaxation if we're lucky...
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/at.c     | 1 -
>  arch/arm64/kvm/nested.c | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 31a55b9d3385..2be9100cb84e 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -480,7 +480,6 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
>  
>  	switch (access->type) {
>  	/* R_RKMHW */
> -	case WALK_ACCESS_CMO:
>  	case WALK_ACCESS_AT:
>  	case WALK_ACCESS_NONARCH:
>  		return false;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index dc2a8b6483c2..54c5966e1a6f 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -246,7 +246,6 @@ static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step
>  
>  	switch (access->type) {
>  	/* R_RKMHW */
> -	case WALK_ACCESS_CMO:
>  	case WALK_ACCESS_AT:
>  	case WALK_ACCESS_NONARCH:
>  		return false;
> -- 
> 2.47.3
> 
