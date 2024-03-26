Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3462114
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711442270; cv=none; b=CJLuKFE3unfTRTy+LPKwCk5VNXY3Udn5KGNFIgnDJ1GpTl4ecfkFfIoar7XtWUVlThW1nL0qsltR1HQhusow9WJlPaDkmIFalYbwlS9qToukKvnFnWryZa9GqLk3T7aZSTMBLPSDSjR4C7eqP/Thpm1V5zWPxrvkaq925PJdyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711442270; c=relaxed/simple;
	bh=tm6zxb2ibreVJoPKL9yS3kRUHsegcHQMX1IF57LpnIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4BZgvDDeDUUsZLSnApg0XhuHe/yUoHTR8Lqepu1zT4wEJsmDMKN3BxZVTmly+AfMHwtrKA66kbfnM0JN5Exw6meqWwFN+SAdJd6790WNGRflYCX1kEHI3l8PpsMc+47IXHk1CMyWb+HikLxBEOiy4z2XXVDZecoWhchrq54Wso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k13gAAED; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k13gAAED"
Date: Tue, 26 Mar 2024 01:37:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711442266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GqNvhO0WKuGGPaCyfHB7FDU+6xJi5ATHg9+BhfA2FEU=;
	b=k13gAAEDqa/nCuZg1Hp2ODI9iOvpb0AUlYXhDsPADrgRByUkMCiPTXlMEI9ssX/tys00ul
	jdlNd3r9s+FPhfuIeBG02MUObEmQcrDytEKpohCAQ62wMX7zcbWdRdg0CUOZ7o1TA4Nkj6
	PpNdOEbdl0TKceq39dY2/aYB9ZUe9yE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Don't pass a TLBI level hint when
 zapping table entries
Message-ID: <ZgKJV-smLaMnapV3@linux.dev>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-3-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325185158.8565-3-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 25, 2024 at 06:51:57PM +0000, Will Deacon wrote:
> The TLBI level hints are for leaf entries only, so take care not to pass
> them incorrectly after clearing a table entry.
> 
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
> Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index de0b667ba296..a40dafc43bb6 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -528,7 +528,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  
>  		kvm_clear_pte(ctx->ptep);
>  		dsb(ishst);
> -		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
> +		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), TLBI_TTL_UNKNOWN);
>  	} else {
>  		if (ctx->end - ctx->addr < granule)
>  			return -EINVAL;
> @@ -896,10 +896,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (kvm_pte_valid(ctx->old)) {
>  		kvm_clear_pte(ctx->ptep);
>  
> -		if (!stage2_unmap_defer_tlb_flush(pgt) ||
> -		    kvm_pte_table(ctx->old, ctx->level)) {
> -			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> -					ctx->addr, ctx->level);
> +		if (kvm_pte_table(ctx->old, ctx->level)) {
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
> +				     TLBI_TTL_UNKNOWN);

Ah, here it is! Can you add this invalidation to patch #1? Otherwise the
fix will intermediately introduce another bug, AFAICT.

Rest of the diff looks good.

-- 
Thanks,
Oliver
