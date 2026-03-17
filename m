Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A013F54D7
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767424; cv=none; b=uOtfWMWccpE5VnxhVyu/6w+kFQ4g9OAEBQLuRDs7mKb8C+fkZyLfnbLrg3zyiQoYGhn6ibhTR0LQgVGBtpOhNv8aEgUJ0PD6deUkgO/BiaJtZpQUWRl+jAshifyLFPCmg52TwlSF2Kr0fBwvtmD7qeX1rh8hfHe5VjshQnrPJ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767424; c=relaxed/simple;
	bh=Slq1lHSOfugxO8jMwD/VdkL3EJqWWt5C2T4XhV+f8Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdQDA7enZ6IUTQzYMJDb8ZpgHEBxLDi2DIosMF5fa/d/qLt9n8SVR13/hslA09JY0JOddFEPzwpsoHZeyp9i4l2+2NhXlZhrySBIi0jrbtwq9P5gG7rGe5zqPB/nOovaeZhlncteC70zKki2grhZYrFHd1xVYdc4xRJMqbI1X5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC95E1477;
	Tue, 17 Mar 2026 10:10:16 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0671C3F778;
	Tue, 17 Mar 2026 10:10:20 -0700 (PDT)
Date: Tue, 17 Mar 2026 17:10:18 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, vdonnefort@google.com
Subject: Re: [PATCH v1 11/13] KVM: arm64: Optimize early exit checks in
 kvm_s2_fault_pin_pfn()
Message-ID: <20260317171018.GC3808327@e124191.cambridge.arm.com>
References: <20260306140232.2193802-1-tabba@google.com>
 <20260306140232.2193802-12-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306140232.2193802-12-tabba@google.com>

On Fri, Mar 06, 2026 at 02:02:30PM +0000, Fuad Tabba wrote:
> Optimize the early exit checks in kvm_s2_fault_pin_pfn by grouping all
> error responses under the generic is_error_noslot_pfn check first,
> avoiding unnecessary branches in the hot path.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2d6e749c1756..9265a7fc43f7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1791,12 +1791,13 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
>  				       fault->write_fault ? FOLL_WRITE : 0,
>  				       &fault->writable, &fault->page);
> -	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
> -		return 0;
> -	}
> -	if (is_error_noslot_pfn(fault->pfn))
> +	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
> +		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> +			kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
> +			return 0;
> +		}
>  		return -EFAULT;
> +	}
>  
>  	return 1;
>  }
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 
