Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F04AF165
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271538; cv=none; b=L8qit3dNOx7m9luAIYvhH6zWRg3SYrj5f1Roo2RfOfDfp+nuCsxw0YFaTSLIjmYQ5KdKSZ4FpsARZCxmFdxW+oF+MlkPmAO4Xb3NJ9BD4obQIXkPWwXofCbsLocW+kZDlsMN4cmKKMkSyRiKEbZAssuA5n0pULVsxaQckHomBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271538; c=relaxed/simple;
	bh=673/qBs7WiUNUJHGddXDF8prZOjLumLORMBU6ZcneDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYbhbLa/zZfaYKajQUr0AU/hkPBbeBaBzUgdZ2pPCgNOI6e+utxshSo9QRHy64zVo1aflKm86fgIuTjqXC0WnGGTW2H+4Kb8HFUV/Wx/tyfUsnWS4bgkZY2kQ0RBO5LHOJ71bmf6g7cdD4kHXn9bbp+lsO60X5aEIMwWTrkSBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qg+htPmb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qg+htPmb"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-498012a61f6so4495e9.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790271534; x=1790876334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fHnT+GMhZhgB49AXdS40CMB1qPWsP3S6DBlSvAeDhzQ=;
        b=qg+htPmbjrrfKQYccqDrI/Q2xFEztQYQuMMaFjhba/WIi8lyS6bcGvHUXm45zETqJ5
         E3I2P4YtEtWx2qIJsPEMrFm4EoMc3f82Qc/wPUH6iX4cjZ/wUUK+Z1+N4uKUroVawsRJ
         /SueKSEL7AiQgVUMyZ1iXyEZCuW1IMbLDEfIrU+V1VvRnrc1x9xiWNGk1i/WqUxz8OUp
         ZHS6evObpWgOs3VsyYMTz9wZWBeEgt5siafOvAU2KMeLxvXWCt+cpoHyTzOH2/0AdlBL
         kUnSfG9O/d8GJAO80NjlO0ofBRMqik0H2V9B2zmYeSmp6PRyl+v6Xd1X9zG7FN8BqGHF
         IZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271534; x=1790876334;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fHnT+GMhZhgB49AXdS40CMB1qPWsP3S6DBlSvAeDhzQ=;
        b=sgbZonbhTO+uXWSVg9hxCD7HMk7UBSflasx1jkjFg5RuCJB6FnwHO9NRWY8W6cc6qT
         FQmFBSlzkjvwsawNpVJu5jdVJtTTayxerCt3szQk8Bo2u/lupXypcVJrQMDm7AQTvusW
         sJNQ2joZLkup40xYTgPO5v36YkHkv0XGZcO5eXBjF0U9dvyq55ZVa01kw15K54XL0TJs
         AC6eScLSfYwne8olQOhSiVrJchRSSwEqsVs9EfStW3IpjDt8kxWScG1VcC3ADOqgLe2t
         210UeAmsjKSzEyMISA5GURtHXujgaE1x0qNkWZDCa9sKJptXZ/hE/+GYTCSMebqcph8Y
         QI8Q==
X-Forwarded-Encrypted: i=1; AKwUvByLofX3iEcFiuDE9Mro/hzgfxTfAentrLpJmHMZTqFR6AxLjlrQAjQebjibfdSgKGzHLz3HgqM=@lists.linux.dev
X-Gm-Message-State: AFuF++m8GrA+tDIIgYBApFMb0dOo1B1M8ISW0DJHUB0i4859gxLwZM9G
	WSLepZ0R9thVV7Y1tuNRapsWngIGy6UDVse/yQmH/GqD5wZWO2iUku2k/N6tcOfSMw==
X-Gm-Gg: AYBFou2U9YovlTViv30aI9pGQrzv9MvFkSn7PokpLyvPF4V1qjg/laP0d0SiJmhZKXS
	ecvs3Csb+M6H1ri9/ut3/o4Zyg5wzNtLFuocJpQ3nxOvA15lPsaHjgOTXtYAbfATy8BH0ETBRnS
	2TSCkhpDeYZJqmy7vGg1qzJrQ+MvJSVIfUqCqBwUa1pKmG61Vt6L62Q3sPMvyNLIm1tEmCnzRTT
	ziFEEynQswd6krAzFVj+6TkkYfw0G/tSccbWwqi4ntX4SQkDOdtTphsXIMitSWKu21UY5LA/MiG
	nE/ZwD5P0RsYUHLYvHjL15AmuD5jMvCAfil8QLHxjD2/lj64PT9T2DUAo00aWi/uBNq/H/wnCRE
	13gIYhJJQANo35PryR2VLuYvP0y0zheHacGunOJBbNZpSPTDz+dIhY4au19tdMzPkJND0DG+LRy
	I4cCTGgk4DimY1/H9rhBppYxxi85HtiNwGgZ4WjZko+vEJeuaoIyilQylmX4wgru3W8oQDOQbgs
	z/veVYEfcxdCL7ACT39YKTkXV3109awBl/v6aAB
X-Received: by 2002:a05:600d:1b:b0:49c:ca44:63db with SMTP id 5b1f17b1804b1-49feef0df76mr39215e9.13.1790271534149;
        Thu, 24 Sep 2026 10:38:54 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm129441475e9.12.2026.09.24.10.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:38:53 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:38:49 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, weilin.chang@arm.com,
	Keir Fraser <keirf@google.com>
Subject: Re: [PATCH v2 01/22] KVM: arm64: Prefault host stage-2 entries on
 block split
Message-ID: <arVgKRqRRon00wTD@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911135053.146435-2-vdonnefort@google.com>

On Fri, Sep 11, 2026 at 02:50:32PM +0100, 'Vincent Donnefort' via kernel-team wrote:
> From: Keir Fraser <keirf@google.com>
> 
> For the host stage-2 that is idmap, we can avoid lazy-mapping on block
> splitting by propagating existing valid mappings to neighbouring entries
> of the new table.
> 
> Signed-off-by: Keir Fraser <keirf@google.com>
> Co-developed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd..34f78a58cded 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>  	return 0;
>  }
>  
> +static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
> +{
> +	kvm_pte_t block_pte = ctx->old;
> +	u64 pa;
> +	int i;
> +
> +	if (!kvm_pte_valid(block_pte))
> +		return;
> +
> +	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
> +	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
> +		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
> +
> +		/*
> +		 * Skip ptes in the range being modified by the caller if we're
> +		 * installing last level entries. Otherwise, we need to
> +		 * temporarily put in a valid mapping to make sure the
> +		 * prefaulting logic is triggered on the next
> +		 * stage2_map_walk_leaf(). This adds an unnecessary TLBI as
> +		 * we'll presumably re-break the freshly installed block, but
> +		 * that should happen very infrequently.
> +		 */
> +		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
> +		    (pa < ctx->addr) || (pa >= ctx->end))
> +			*ptep = pte;

Do we need now to call get_page() on the table as we are installing a
new PTE?

Also, I think we need a WRITE_ONCE() for the PTE write.

Thanks,
Mostafa

> +	}
> +}
> +
>  static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  				struct stage2_map_data *data)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
>  	kvm_pte_t *childp, new;
>  	int ret;
>  
> @@ -1051,6 +1080,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!childp)
>  		return -ENOMEM;
>  
> +	if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
> +		stage2_map_prefault_idmap(ctx, childp);
> +
>  	if (!stage2_try_break_pte(ctx, data->mmu)) {
>  		mm_ops->put_page(childp);
>  		return -EAGAIN;
> -- 
> 2.55.0.1007.g17ff1f9808-goog
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
