Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7622C409610
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782901001; cv=none; b=ecUnD/vbRpLJ+5W5lFo9tG9Xsn6MFyYY0UaPHzriNFTo1b1CF6afavgmNu2694Vdp0cZZowhgf5c3l9JdUHsHiFxiWDWWqAOqAY+702cSO20omfvJN4dWjn55AYKG1lybjmkPJ149Xf8jqax33ltw8r155I0bixfLuYzy1UgIqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782901001; c=relaxed/simple;
	bh=rBh+4Jlz1vSo8KexRyIY4dDU/MPpyI5S+I3kYP15Rso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oB/JJJn9Uw6U5yZHfVcRC1UvP09yNpoIGbSE4OG5VA3oLqw1VJWB/H2zOkkSYINJqP/lTGlL7szdgYXGjbtQGqQrjDZogzC0IHSQEaawyFDybZ9e9jgthmkyYZy3/otjB0x5xrzNbvHk+wd/iiAmLAzf0sBdnUpxy/B48g2omhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fzmJYai6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fzmJYai6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 160B02BCC;
	Wed,  1 Jul 2026 03:16:32 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D170B3F85F;
	Wed,  1 Jul 2026 03:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782900996; bh=rBh+4Jlz1vSo8KexRyIY4dDU/MPpyI5S+I3kYP15Rso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzmJYai6BtLrNkecmgEy9qUxmpTBvUnFF92l0aCmVy0txQIdZGHOtUY2RHD/4rTU9
	 g1ClsWgMqDSUb7Kpbq51/SSIvYxuaAn+sEP8evI96LbtYEkgOX6xJvAlRWrukJ/Wyu
	 iv6SFlSlt4bSuYbKj4x9m0lkspBcQva+utrny9SU=
Date: Wed, 1 Jul 2026 11:16:20 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 22/22] HACK: KVM: arm64: nv: Set the dirty state for CMOs
 that fetch for write
Message-ID: <wt53tup6v5hngzostsualmxnbyhmtjcg6yvyhbqpzellt3x73q@ncz6oc4oxar5>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-23-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623184201.1518871-23-oupton@kernel.org>

Hi Oliver,

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

This is interesting... So the problem is that when a CMO that require
write permission is run by a nested guest, and the guest stage-2 is
still in the writable-clean state (which means the shadow mapping must
not have W) the instruction gets trapped and KVM gets in an awkard
position.

If we keep the guest s2 writable-clean and shadow mapping RO -> guest
can't make progress unless we emulate the instruction, but if we make
the guest s2 writable-dirty and shadow mapping RW -> not architectural
as of now. Treating it as a NOP also comes with problems as you said.

Am I understanding this correctly?

Thanks,
Wei-Lin Chang

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
