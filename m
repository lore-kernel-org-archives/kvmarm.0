Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFDD30F814
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765820946; cv=none; b=KyxeYa5PDeVesdTS/HbroYEC0cxb3cu2M0+XT/cJCefyspjaYJW3VZMrkoZe6PRgRooqDepNpC8FlEmFOZAkjF5D5ISaRd67VK42wshIWN6s9dUZ5wbKKSbMWv/VTyL8fQ/oqXKeocM1lKP9juTWnT6bpGtv4Eb0bQ5euFqEG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765820946; c=relaxed/simple;
	bh=rfjxVtcYL0Sd/XxeTxoVufCK0c3pCSgU5bOQBrNAYHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgNCuiOFRrUJAErR4hraxd6BUy+gl8ICqtui2xP+yyhE9lxP2k31v55VSS4gpbVDoSC2QbCwYyaudbojEPiGsSLy3ojjYVHY93suHnTvb5Wan6Z4i5TAv1Ifam7znLCaOySNAFhBhp+Vq85GUFm9R4TWHxT6Uq8YLn8IdBL2ojA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43E0C168F;
	Mon, 15 Dec 2025 09:48:56 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 088373F73B;
	Mon, 15 Dec 2025 09:49:02 -0800 (PST)
Date: Mon, 15 Dec 2025 17:49:01 +0000
From: Leo Yan <leo.yan@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 08/35] HACK! KVM: arm64: Enable SPE virtualization
 only in VHE mode
Message-ID: <20251215174901.GA779696@e132581.arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-9-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114160717.163230-9-alexandru.elisei@arm.com>

On Fri, Nov 14, 2025 at 04:06:49PM +0000, Alexandru Elisei wrote:
> For RFC only.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/spe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 7e38f7d9075b..101258b55053 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -24,8 +24,8 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
>  {
>  	struct arm_spu_entry *entry;
>  
> -	/* TODO: pKVM support */
> -	if (is_protected_kvm_enabled())
> +	/* TODO: pKVM and nVHE support */
> +	if (is_protected_kvm_enabled() || !has_vhe())

I totally agree we should focus on VHE mode first.  But it is worth
considering if we can unify solution across different virtualization
modes.

Aside from register access and IRQ handling, buffer management is the
most complex part of this series, it would be useful to know whether
the change can support different modes.

Thanks,
Leo

P.S. an interesting question is whether we can reuse virtio-iommu or
DMA buffer allocation for SPE.  My understanding is the IOMMU would be
simpler case, as the page table allocation and mapping occur entirely
on the host side.
