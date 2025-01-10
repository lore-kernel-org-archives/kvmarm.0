Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C06209F22;
	Fri, 10 Jan 2025 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736514675; cv=none; b=TD4elodseH+MUEYI2gNiz4osx89eHuj5xEIO3WdJAT7Vihne6W89W7B86lCXa/XPaq1ZlBINOpK3YwT4hys2nubiXlsPn+ZZcXJoPAS5iDxR7R7ESPGoxA9nxyf/E7PMdLfKyk9Fi4QBzeoJ/eckgpUMlHsCWK/hmqJ7W4cgx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736514675; c=relaxed/simple;
	bh=60oy2juKT2oRp3xzi0phLhzQ+axEhNM8eylbyL3hDxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYpbWyPSs1H5xXFns8XyIsVV8M2O9V3E3aEHsdFvav4jEXM6D23gvORvJfKe8kv/1YYJ8VHcLu7/k/ENXkQFeLXgSnIDbRmTupdLy3HyBBpRpO5gx95zCiSbzB+zzfFcIXwFAdC1PqqoG+CGfsY2AejwuziOpNEpl9JDkOwFg8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68A3C4CEE0;
	Fri, 10 Jan 2025 13:11:12 +0000 (UTC)
Date: Fri, 10 Jan 2025 13:11:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: MTE: Update code comments
Message-ID: <Z4Ecbi9QUScEstCQ@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110110023.2963795-3-aneesh.kumar@kernel.org>

On Fri, Jan 10, 2025 at 04:30:18PM +0530, Aneesh Kumar K.V (Arm) wrote:
> commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
> initialisation") updated the locking such the kernel now allows
> VM_SHARED mapping with MTE. Update the code comment to reflect this.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c9d46ad57e52..eb8220a409e1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1391,11 +1391,11 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>   * able to see the page's tags and therefore they must be initialised first. If
>   * PG_mte_tagged is set, tags have already been initialised.
>   *
> - * The race in the test/set of the PG_mte_tagged flag is handled by:
> - * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
> - *   racing to santise the same page
> - * - mmap_lock protects between a VM faulting a page in and the VMM performing
> - *   an mprotect() to add VM_MTE
> + * The race in the test/set of the PG_mte_tagged flag is handled by using
> + * PG_mte_lock and PG_mte_tagged together. if PG_mte_lock is found unset, we can
> + * go ahead and clear the page tags. if PG_mte_lock is found set, then the page
> + * tags are already cleared or there is a parallel tag clearing is going on. We
				  ^^^^^^^^
				  remove this (or the other 'is')


> + * wait for the parallel tag clear to finish by waiting on PG_mte_tagged bit.
>   */

I don't think we need to describe the behaviour of set_page_mte_tagged()
and try_page_mte_tagging() in here. How the locking works for tagged
pages was hidden in those functions with their own documentation. I
would just remove this whole paragraph here, just leave the first one
stating that the tags must be initialised if not already done so.

-- 
Catalin
