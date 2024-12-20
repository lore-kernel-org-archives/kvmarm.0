Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F41C549D;
	Fri, 20 Dec 2024 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734704009; cv=none; b=RvojEeNUvwoeOIBCHVYsPD+7A0aZ4On5SFq3uvxVctd15L7xyLFH/TqsUH8E+vrmbPXIlAJsev4OWktWy6F0oZ31y4sVqbsaYVubNBNIS3X3CoWd3zGD4JOf8FgQYwvS9VZX66NCxf6orMUhvr8cfxLSV9hpoZoUALsDJ53hzIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734704009; c=relaxed/simple;
	bh=IfxXl6UuG4j5BIYEfkssc862+8tnobUWp4ToirmrRTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsqrpQSYQBNuc1m4vymh9qT9NlGRlZCTNieXK2UnfITnFoKXobYDE6JhhhimKI7ZeYbLaZZvDNEWELOXc4cUJNPWeQFN1ljHJ6T/ZIXmEl5M6zLqto5QyTjIDOUjsrX2vfTodmLhZVBR9fhZjNbfseQPmZATDbb2Z1CpuMKJMdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClQHk595; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClQHk595"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14334C4CECD;
	Fri, 20 Dec 2024 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734704007;
	bh=IfxXl6UuG4j5BIYEfkssc862+8tnobUWp4ToirmrRTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ClQHk595OanK3NzR1jRz96i5ng2jJw5jsvAlQtROFDF0mMP6HpYkOOjk7gpcozy1M
	 09nrL57Tv17Tqe2GScMn4nbdj22MAQ6yha3SDW77160RWKR5OTsMfGpEe99PR8sshe
	 5FT05wI5eAKBNyFmp0apHsR+qWtlOcPemRveYpuRHW4BTgJx1UwUMkHjVuZqljA+On
	 7c2/IBZQ7YxXR/CIFQfk+DoowDh37N7VkgpeHcilbyvbtT9350TR+B+Rn/iYoBsfxX
	 n7GD738cBWuy00SH9W3PxmYEaUPzk2tcvvghNnB6z1Z2fEDeAuF5E3svfU79yO853Y
	 w5XZBuLZuYU6A==
Date: Fri, 20 Dec 2024 14:13:22 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Selftest for pKVM transitions
Message-ID: <20241220141321.GA26794@willie-the-truck>
References: <20241129125800.992468-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129125800.992468-1-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Nov 29, 2024 at 12:58:00PM +0000, Quentin Perret wrote:
> We have recently found a bug [1] in the pKVM memory ownership
> transitions by code inspection, but it could have been caught with a
> test.
> 
> Introduce a boot-time selftest exercising all the known pKVM memory
> transitions and importantly checks the rejection of illegal transitions.

Thanks for doing this!

> 
> The new test is hidden behind a new Kconfig option separate from
> CONFIG_EL2_NVHE_DEBUG on purpose as that has side effects on the
> transition checks ([1] doesn't reproduce with EL2 debug enabled).

Hmm. What does a test failure look like without CONFIG_EL2_NVHE_DEBUG
enabled? Do we still get file:line information?

[...]

> +void pkvm_ownership_selftest(void)
> +{
> +	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
> +	u64 phys, size, pfn;
> +
> +	WARN_ON(!virt);
> +	selftest_page = hyp_virt_to_page(virt);
> +	selftest_page->refcount = 0;
> +
> +	size = PAGE_SIZE << selftest_page->order;
> +	phys = hyp_virt_to_phys(virt);
> +	pfn = hyp_phys_to_pfn(phys);
> +
> +	selftest_state.host = PKVM_NOPAGE;
> +	selftest_state.hyp = PKVM_PAGE_OWNED;
> +	assert_page_state();
> +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
> +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
> +
> +	selftest_state.host = PKVM_PAGE_OWNED;
> +	selftest_state.hyp = PKVM_NOPAGE;
> +	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);

Should we recheck the unshare transitions here?

> +	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
> +	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
> +	assert_transition_res(0,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);

We could check unshare_ffa here.

> +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> +
> +	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);

Is it worth trying an extra pin + unpin?

> +	WARN_ON(!hyp_page_count(virt));

Can we assert an exact value (e.g. count == 1)?

> +	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);

unshare_ffa again here.

> +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> +
> +	hyp_unpin_shared_mem(virt, virt + size);
> +	assert_page_state();
> +	WARN_ON(hyp_page_count(virt));
> +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);

Is this block actually testing anything new? Once we've asserted the page
state and checked the refcount, the transitions seem redundant to me.

> +	selftest_state.host = PKVM_PAGE_OWNED;
> +	selftest_state.hyp = PKVM_NOPAGE;
> +	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn);
> +
> +	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
> +	selftest_state.hyp = PKVM_NOPAGE;
> +	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
> +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
> +
> +	selftest_state.host = PKVM_PAGE_OWNED;
> +	selftest_state.hyp = PKVM_NOPAGE;
> +	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, 1);

Try it twice?

Will
