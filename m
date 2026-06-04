Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E23BBFDC
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 22:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780612038; cv=none; b=TYqucFuUmGKuVjd0ERCHwJsn0pk8EODIPrDgCQdDJ+l6vnSxkdjIH+7pA7gCZF8rhzVyMAtUI7v0jZmft2fl34C9Wbr2iNcJfTf2N267OZB12+p/Ou4Nj7sAygUhkdq+Jv/ZJNmpWu/lc4IthyklUybnG7mTGVRjzZKBAx/GDTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780612038; c=relaxed/simple;
	bh=FAzTBD6K/Z3MG0ycrZfsQXj1ITObrpAqAJRFlIK7KvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEW6Z8aPPNxb/bZ7HczN3bnL9j2ccF45lms4OW497/4Uy3hucqj0AcV+ngQMI+awMrwQiRzvArgXn3QmROrQqv+S/L7nMpBQLEi3YA0cu3KKVprRbXZ3nM87iNVM14K9Y5ISnOFkfhOdfbz38iJ9i7mlTUaIthwNp+mqIsD7Sgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YY+PWJbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YY+PWJbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5E51F00893;
	Thu,  4 Jun 2026 22:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780612037;
	bh=F+Z44FQYE3kr39+LeJ1gbg5UpwtjtjiI6+HmJr0+Ky4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YY+PWJbqFOW7MVHs2UWn9WKb/O3pLlrClAakAXKjMh1xBVdz51aK2XYVyhzzk/Yei
	 cXqj142YHZuANKznAmo7xUOCxc4ZTt7Dy+D/wO+tGgjNiqwXzGB5QU9ecuKvvp9nz4
	 LbE/Lv0Y+XlDSqFM7RKgNC9riQq325Dcru28U6nmW+aFoMZuy74lafmpFek2sVgR7W
	 +XcIOZgw97Xyw4BtM1x2fhEen2PUuQLHapOkKEnvXQ5OP8ZQKTBKDqU68RYY02L+wg
	 76UsarN/e2oiRjJjEsjwXPSlo11i3yzqpso1I9WLuesFGXP7ZT2J9L38eUo5UuE7VJ
	 IKMbxFwuk0KkQ==
Date: Thu, 4 Jun 2026 15:27:16 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, christoffer.dall@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Reallocate the nested_mmus array under the
 mmu_lock
Message-ID: <aiH7xKnprU9bUap5@kernel.org>
References: <aiHEKOeZMVwsRlvP@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiHEKOeZMVwsRlvP@v4bel>

Hi,

The shortlog is very confusing, since "allocate behind $LOCK" is usually
something alarming. Maybe instead:

  KVM: arm64: Reassign nested_mmus array behind mmu_lock

On Fri, Jun 05, 2026 at 03:30:00AM +0900, Hyunwoo Kim wrote:
> Code that walks kvm->arch.nested_mmus[] holds kvm->mmu_lock. By contrast,
> kvm_vcpu_init_nested() reallocates the array and frees the old buffer while
> holding only kvm->arch.config_lock, so a walker can reference the freed
> array.

It wouldn't hurt to share slightly more information here. Are you
dealing with a concurrent MMU notifier?

> Allocate the new array outside the lock, as the allocation can sleep, and
> do only the copy and the pointer swap under the mmu_lock. After the swap no
> walker can reach the old buffer, so free it once the lock has been
> released.
> 
> Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

The diff itself LGTM

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  arch/arm64/kvm/nested.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 38f672e940878..6f7bc9a9992e0 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -89,21 +89,28 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  	 * again, and there is no reason to affect the whole VM for this.
>  	 */
>  	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
> -	tmp = kvrealloc(kvm->arch.nested_mmus,
> -			size_mul(sizeof(*kvm->arch.nested_mmus), num_mmus),
> -			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> -	if (!tmp)
> -		return -ENOMEM;
>  
> -	swap(kvm->arch.nested_mmus, tmp);
> +	if (num_mmus > kvm->arch.nested_mmus_size) {
> +		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
> +		if (!tmp)
> +			return -ENOMEM;
>  
> -	/*
> -	 * If we went through a realocation, adjust the MMU back-pointers in
> -	 * the previously initialised kvm_pgtable structures.
> -	 */
> -	if (kvm->arch.nested_mmus != tmp)
> -		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
> -			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
> +		write_lock(&kvm->mmu_lock);
> +
> +		if (kvm->arch.nested_mmus_size) {
> +			memcpy(tmp, kvm->arch.nested_mmus,
> +			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
> +
> +			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
> +				tmp[i].pgt->mmu = &tmp[i];
> +		}
> +
> +		swap(kvm->arch.nested_mmus, tmp);
> +
> +		write_unlock(&kvm->mmu_lock);
> +
> +		kvfree(tmp);
> +	}
>  
>  	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
>  		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
> -- 
> 2.43.0
> 
