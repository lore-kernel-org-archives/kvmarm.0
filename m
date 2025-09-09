Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F6E21FF24;
	Tue,  9 Sep 2025 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425610; cv=none; b=gjVx4/HCvmR0LKa/Rm+/fmUP+TnwUI2Nw5d+YTcYeseQWraENxnFHogAdAfPsbn69JsFEVm0paX0X2xvnGoi74urlv6lGceAc2LFahREuMR5mU8kSfIVcevHJsdAAvHTch20xp5Quo+tYMLcB4t7ZFEcQ1V6Zd9INmeNh5dAv/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425610; c=relaxed/simple;
	bh=fzqqDDXTXgc1xKVVIHwn9vLmbH7HU5zTtM5qBx+V1ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvCkzOvHw12hjEo90jHirLB+iVACfOPxYMviqHcPCzau4BlTOZlG2CRGtOwMJW43nj8iOMmVnRoTzbfGJLxSI3TTdd8sPpS7jQpt3OQIQce/+m1ZefSBfNv1Ae9/dZoDuzHN83+xUgDcBoQL3WbsQndJHH6eRwKWBDEa4bY7ZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6O+tDe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6O+tDe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C10C4CEF4;
	Tue,  9 Sep 2025 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757425609;
	bh=fzqqDDXTXgc1xKVVIHwn9vLmbH7HU5zTtM5qBx+V1ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6O+tDe2nrg87Y7/S+Zk9CUrbY2AdJMilB+urbthEyUsD50w1xb2noRQ1hCfq76IO
	 OC9sU4Hg0uJfdwkJkJOdPfYuPYJ3kLD6dm4xpaPKqMxOpRvB6YOhyKHGaoqDDtJNMk
	 dwqSNFvk3G51DEKHhMh5plT2MAealjDxEpioHpsZDuSJmRqbkzRxgN5bRqAXaPdL4Z
	 qecqt2l8gxUclecmElV1DM1/ODvksxyOjKEL6UsI40CQDjtXObCrGsN+vpMdcM4jU+
	 xFO2svDAchpW7sWBsiJrHobI4p46x7Kj0bJp+Tgv4oE94k83/EhbqFzHRLuvO3gP6j
	 fXLkQS3/pTCCg==
Date: Tue, 9 Sep 2025 14:46:42 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 01/28] KVM: arm64: Add a new function to donate memory
 with prot
Message-ID: <aMAvwlMQ-Jf2MWzd@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-2-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:29PM +0000, Mostafa Saleh wrote:
> Soon, IOMMU drivers running in the hypervisor might interact with
> non-coherent devices, so it needs a mechanism to map memory as
> non cacheable.
> Add ___pkvm_host_donate_hyp() which accepts a new argument for prot,
> so the driver can add KVM_PGTABLE_PROT_NORMAL_NC.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 5f9d56754e39..52d7ee91e18c 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -36,6 +36,7 @@ int __pkvm_prot_finalize(void);
>  int __pkvm_host_share_hyp(u64 pfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8957734d6183..861e448183fd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -769,13 +769,15 @@ int __pkvm_host_unshare_hyp(u64 pfn)
>  	return ret;
>  }
>  
> -int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
>  	u64 size = PAGE_SIZE * nr_pages;
>  	void *virt = __hyp_va(phys);
>  	int ret;
>  
> +	WARN_ON(prot & KVM_PGTABLE_PROT_X);

Should this actually just enforce that the permissions are
KVM_PGTABLE_PROT_RW:

	WARN_ON((prot & KVM_PGTABLE_PROT_RWX) != KVM_PGTABLE_PROT_RW);

?

Since the motivation is about the memory type rather than the
permissions, it would be best to preserve the current behaviour.

Will
