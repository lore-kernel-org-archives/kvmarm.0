Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EBA3B894A
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633184; cv=none; b=WlVkSxxGUsNzBKvewtugP7CVzOVIoNZs9KasMK93qKuNB30W/QZQ+6c63IPe82eJdWWcIo9nT47Yj0/3kFY90qh3Qx2NQmkJGZo93vxvA+5WJW0RV3XVzkQG4qrIvUl2lutyZ5zmKf9rVLVB/uwXCbcZfoeet/HnvCpq6hbX6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633184; c=relaxed/simple;
	bh=wxXDr1QgTU6gkNXy3Zs/MWD84psAtMhiIYMJo/aj2aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hO7FHf5aialwA8LJgJdv6AW+mTz/1cAtW2LZFG5ZcrDnot6HKgTn6D+ILs+hBJlYNCkNisOa5pXmRJFVh5ng9lTLE/7JOFZ3F5AiIdhq3UfiQQpyxioiFuuY6BkocQ5SLPWQyPyYhcY2CZEeE291iKc6lNmm8EDCtJrIEzRUyLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2qb/h72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2qb/h72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B92EC4CEF7;
	Wed,  4 Mar 2026 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772633184;
	bh=wxXDr1QgTU6gkNXy3Zs/MWD84psAtMhiIYMJo/aj2aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F2qb/h721GOUEpt2dlo5BXt7vSNW+6wMBpBoLkRWRkziixIr3aIvguWO5AoT8eBJY
	 MvbR7t1FswR3SCC2zxkzFS76xxmbSh7xOl/FIigqpgL2DjJ3c3GrXuRgFgHELw6QWp
	 WjT3//wMsyAo51Lgq/mosmyNrvtKjh8Dc+sW6/s64En0j+eh2tFhOYyZdJ3haXMbHO
	 T3Q+uvwMLOAzdm/9cN6y442XUfJ7x1lSR5MvbpJP3bEBK6jHqogkjcrwrBIk2t7qrD
	 /zWMvWWb9oDfofrRoxJNBk4lYVz6w4E9aVqUIXg6+VJDFtSoaQIj7dnQoAzSlQwX/V
	 1uUuMwdmkLmzQ==
Date: Wed, 4 Mar 2026 14:06:18 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 25/35] KVM: arm64: Reclaim faulting page from pKVM in
 spurious fault handler
Message-ID: <aag8Wi47wSzGNs35@willie-the-truck>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-26-will@kernel.org>
 <aY4MVDoEnq-fqv_F@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY4MVDoEnq-fqv_F@raptor>

On Thu, Feb 12, 2026 at 05:22:28PM +0000, Alexandru Elisei wrote:
> Would be nice to merge this with the previous patch, that added the force
> reclaim function, as it would make reviewing easier.

I deliberately kept them separate as the previous patch isn't exactly
small and this makes the EL1 part easier to review in isolation.

> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 8be91051699e..d1926cb08c76 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -563,3 +563,10 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  	WARN_ON_ONCE(1);
> >  	return -EINVAL;
> >  }
> > +
> > +bool pkvm_reclaim_guest_page(phys_addr_t phys)
> > +{
> > +	int ret = kvm_call_hyp_nvhe(__pkvm_force_reclaim_guest_page, phys);
> 
> Nitpicking here, we have the functions __pkvm_reclaim_page_guest() and this
> function, pkvm_reclaim_guest_page(), which calls
> __pkvm_force_reclaim_guest_page, which in turn calls
> __pkvm_host_force_reclaim_page_guest(). I think having a bit of naming
> consistency would be really useful when navigating the source code.

Yuck, you're right! I'll make sure 'force' is used consistently on this
path.

> It might also be useful to document that callers of the hypercall
> __pkvm_force_reclaim_guest_page are not expected to unpin the page in case of
> success, but callers of __pkvm_reclaim_dying_guest_page are.

I'll add a comment, but this is the private hypercall interface with the
host and, as lwn might put it, it's rigorously undocumented. Unpinning
memory from panic context is an interesting idea ;)

Will
