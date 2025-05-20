Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5984020C473
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752964; cv=none; b=qx5HWOEyMsT166AWnzxGdwPly9ruWmR01lWmcdpwZgde7wwOs0STb0NcFXmqAX34P27aN1m5SOE8JKo78hW8rflYRmiYbPdKQyPefIsYJAEzWwedjBGDkQya4CmqBRHBdosdU2FPS/bkN9f3FNbb8OfqIcZ4Ctjurdd+/mkjtHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752964; c=relaxed/simple;
	bh=y0VfecFzDhr5bGdapkf3y1ZJhequieL6dE/5l0Ihe8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvRF9TZMWlCL5p7rO8IqB4qVBidxJP0EgW9/NoTCcZSg72MsptaSPDjY7GW7Fs1C7fcDzGXFADmwzlWMV04wgkua5jFvTcAFNacLjKPZo74K7Cy5iuNc+CAlBdLp75qL6w6H5SZVa1IPBQf+yIp3wIiV15VZ3B81uxrUXUprz20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ougTOzs8; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ougTOzs8"
Date: Tue, 20 May 2025 07:55:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747752959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zj+ANRRCM3elfcsUYTWPFAAqMrBVEKBDUe1b3TfKqtc=;
	b=ougTOzs8lk/ovza5YLoy9N0ZdDaLIty8216yrXX/PTHRFPrYWOAr39Ky7KXAitDyEwpSI7
	VdxjjfIwFeqk5Ta8Zp2V99dfZWbxov+vnaXJih+KqhKG4yJlyfF5YYhmqXLQZVtbYtqcNv
	VuRBvCtO4RA5O6IBzs2Ndd4/VnqHjIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v4 2/5] KVM: arm64: Make stage2_has_fwb global scope
Message-ID: <aCyX2nJzBXmQarAJ@linux.dev>
References: <20250518054754.5345-1-ankita@nvidia.com>
 <20250518054754.5345-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250518054754.5345-3-ankita@nvidia.com>
X-Migadu-Flow: FLOW_OUT

Hi Ankit,

On Sun, May 18, 2025 at 05:47:51AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Change the scope of stage2_has_fwb as it will be used in
> broader KVM code to determine whether the FWB feature is
> supported by the hardware.

Please just use the cpucap directly outside of the page table code. The
only non-FWB stage-2 that KVM maintains on a FEAT_S2FWB machine is for
the host when using protected mode. I don't anticipate that changing any
time soon.

Thanks,
Oliver

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 8 ++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 6b9d274052c7..f21e2fae2bfe 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -507,6 +507,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   */
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
>  
> +/**
> + * stage2_has_fwb() - Determine whether FWB is supported
> + * @pgt:    Page-table structure initialised by kvm_pgtable_stage2_init*()
> + *
> + * Return: True if FWB is supported.
> + */
> +bool stage2_has_fwb(struct kvm_pgtable *pgt);
> +
>  /**
>   * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
>   * @vtcr:	Content of the VTCR register.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index df5cc74a7dd0..ee6b98fefd61 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -637,7 +637,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>  	return vtcr;
>  }
>  
> -static bool stage2_has_fwb(struct kvm_pgtable *pgt)
> +bool stage2_has_fwb(struct kvm_pgtable *pgt)
>  {
>  	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>  		return false;
> -- 
> 2.34.1
> 
