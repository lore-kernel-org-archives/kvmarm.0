Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D814EC62;
	Fri, 12 Sep 2025 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685154; cv=none; b=NbSCIq6QOhRzzTyN1P+n5ajFqGMzK8TT8jx4ME3o6LkTfdDkSF2Dmnthe2QPruGzDFo57NKRiBCbXybSctvZlHYJBS2n5EW5eqmWvCmOaiqnkGEiaX5D+E/DtBTdmJttoQmk1dT9yXFxa6jL2N85KJAEdtMUFQxzgcBBmvVxZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685154; c=relaxed/simple;
	bh=oSkhs3wi6IQurSUKpmheTAydHRp4IZyXAqiEEjRfPHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fu+UTMA2amZpPi1uuBt4oCYTKW2rAqF9VEOWZ+teXGzK9khtJ02pr+v8YAQeM+wZdqt/aJyOl9LdXgfooiQQXSKk/E6uiMCln368pVxA+cTSshi8jpwAL82Y71UADfMG6KXiK3IksMXhxz7lyQ0wvkEgJH/E0aKLzMtOzdmLVg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFzy+L8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFzy+L8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1D1C4CEF1;
	Fri, 12 Sep 2025 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757685154;
	bh=oSkhs3wi6IQurSUKpmheTAydHRp4IZyXAqiEEjRfPHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DFzy+L8jBvK/16VKIZcPoi4CdJo4RN8TP/i2/2HDJXLIHeY8K+bHuFCuWKOtukdm/
	 m786a7PFUzlSybyymmOx5uAcaJVznFM9RsgMLQZW8S1vDsyOW1U89DZYt8pLOXqacp
	 tMpWsWhVf5E1oFqVXV7RcgTgKVnrilN4rrTxh3vQhot/QxnPpNK8W8aUO77qrs0E9M
	 FWF285+b8MNNxmLbydljFbgeVmGmX/eh7/morOW/7t9FBnVD1Z4atuaYozCezrBCHT
	 Mv+SKBNiLWjyY3mVoiu/5Moqe1DBBRQOux9cfbYibjMY4NHnQeXQuSMVRLlYx+JQCY
	 zs3/cPWvdF/0Q==
Date: Fri, 12 Sep 2025 14:52:27 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 14/28] iommu/arm-smmu-v3: Add KVM mode in the driver
Message-ID: <aMQlm9ucDtd5-15r@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-15-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-15-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:42PM +0000, Mostafa Saleh wrote:
> Add a file only compiled for KVM mode.
> 
> At the moment it registers the driver with KVM, and add the hook
> needed for memory allocation.
> 
> Next, it will create the array with available SMMUs and their
> description.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h             |  4 +++
>  arch/arm64/kvm/iommu.c                        | 10 ++++--
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 36 +++++++++++++++++++
>  4 files changed, 49 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fcb4b26072f7..52212c0f2e9c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1678,4 +1678,8 @@ struct kvm_iommu_ops;
>  int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
>  size_t kvm_iommu_pages(void);
>  
> +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> +size_t smmu_hyp_pgt_pages(void);
> +#endif
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
> index 5460b1bd44a6..0475f7c95c6c 100644
> --- a/arch/arm64/kvm/iommu.c
> +++ b/arch/arm64/kvm/iommu.c
> @@ -17,10 +17,16 @@ int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
>  
>  size_t kvm_iommu_pages(void)
>  {
> +	size_t nr_pages = 0;
> +
>  	/*
>  	 * This is called very early during setup_arch() where no initcalls,
>  	 * so this has to call specific functions per each KVM driver.
>  	 */
> -	kvm_nvhe_sym(hyp_kvm_iommu_pages) = 0;
> -	return 0;
> +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> +	nr_pages = smmu_hyp_pgt_pages();
> +#endif

Rather than hard-code this here, I wonder whether it would be better to
have a default size for the IOMMU carveout and have the driver tells us
how much it needs later on when it probes. Then we could either free
any unused portion back to the host or return an error to the driver if
it wants more than we have.

Will
