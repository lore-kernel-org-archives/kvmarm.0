Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53EA4A5EC6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099988; cv=none; b=XixTzk5xzl1gq7e0zieFBk8bmqQIZdnh7+PQb3VYClS3DKrFr80bGIInbxMf412Ps7eU+L5PfjSvEXuEYJrTNjg+jXkig/nEUay6FwsimBeAkt9/ezWgU8CZa/PSxlVXHOCdrb152KLbuUi6zuaL2V+r0zmfBCGgBV7z9Ogr+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099988; c=relaxed/simple;
	bh=+9zg8vzXT1f7G0XkyVztNjSyeeGX4DYy/1FPhinu/wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBCQr6JY+zndJzkNhLCdCQ0UvuAknj68LNpBYdvguqa5EBXkBCk6386sMaBn6fx/FhFDPuthasakOIqJbCJAnO2pZgkpySuTZz4/HxIckUFtVPp0uj9ZllmKZ3etdh65oxm8mvYdVrfdNz9tPmrB/rtP8rqD6rFpHztGWoldlAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aiX2SpZM; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aiX2SpZM"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a18617ae90so23455e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099984; x=1792704784; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cg42GAQPU7NwQLaVw5oHOROSWv7kA9t3moSVYV4GJIg=;
        b=aiX2SpZMRpY6t1eK6uRR5zmFJWCkfBBOHI2YkwfVeRpKDNEMaqqLT+pV6k08i75ybE
         4P8saXx4jU786gl2A5hboHy167hxl8ky/F6ZBPW7mkQviCgMXIW/zT38j9Vkj9LlQmSk
         p3Nys79eiK9Xv8Gg4ypud1sJWmxz2vFSyyscLZITDEVsTv5lqYrI3jPulkdeE9PkNCqr
         CsSIhZxxnGuEGI0mTyEgRC5dWoDNGBoESRu50H+dXR8HCILukoUKSOdlZj7UMQLhdb15
         yThvSuqhaVpueM4Vuu7IATujC94vZQe6cb4T9xDh6gl5NKYkkERdWQM6oxp2iFNqzOQB
         oJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099984; x=1792704784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cg42GAQPU7NwQLaVw5oHOROSWv7kA9t3moSVYV4GJIg=;
        b=k2U46pqOlqW+fwvFfFr/2tnZtQX/++GYomtMMOxUDv5BASQ0HNFUtSK88ufc16VuZE
         hJQ/Ot4iVDW1yBUIzA7LuUU6Z3RpWc4Ho2tVsx7VAQs5uIhZ8PaOu62sutlf/mW+Q169
         2ZIaXgVFJHq0A+uTwFvBo3wBUG+wyTRkqsCWYyK+1RRNS6SP1NjdHUdxv7getpOZpeT6
         uzPtbffuKHij7KlTCUB3cF5rEx6xwLzwSaUVsFLLDzw2dW7Nbgdd8x4R6hw0xko4LJdD
         L7eKwEXgdiB2CRfNorlLpgkjAWcmNfRE+JrFnzwsJDiRZV/YiwOwan29cth4dxVYCzK0
         Fbvg==
X-Gm-Message-State: AFq9FYL0F+rccvbr/6Zd4BaE3mNSubrfkNO4cMIf12OJ1QRAxCbl0IDg
	8twjtbKsKV//e6r/kEXl1cZXiTLixNexD3CR2qltmvTF2rUh2anFUOIdpa3x1cRCcQ==
X-Gm-Gg: AYBFou0fO6PUCrEtxXSQjvuneVUHz/3tvup+OzkhzOu6cbKS0rlRBDnp9wRu/xefFy2
	FRUy74u8XsXD+vvrBQFassDtPG4hoP8wbDKYhW4MTjGwiHRGcErZdwVB63fL49c/whUx3KPmVnZ
	ltTvxFXen7HQ5Vj5opJ8SwgdkOV+omkHiwFwqqYWScgmFWqsCd6kiOObDurgk4+oH/j5wzbGjno
	G4HkQJOGVrg5uOFkWe9szf57ia78ds6d0l38kpKMURzcrlQtLIDzqkMUxgzNeYW3e6WsWevKi7l
	ufRsFFXSW3Qetylb4IJEYnKZghCIToIpKqab2hX6nQBiCdP6xuOMS2CLNGdtEjg5b8W6nOx3F1J
	6s/pg/YekSIyD3wqB8/9Z99FbXqkxQc4F+oyvGkiRr7gD9Qey4/9q9kOgCCJz/X37FyYkD1YOPX
	59rLXgvWWV/lyxlqSfAwo5UYwKpPveFugIDTRAyfekVb9bWj+VESNdyPBuChbDUwGk482FGkzMh
	qd6VIjPSUGNgFY4vMOf8TOEk83dSxa2FAhWEqjp
X-Received: by 2002:a05:600c:787:b0:4a1:945f:a6ba with SMTP id 5b1f17b1804b1-4a1c7f9b0a9mr233345e9.0.1792099983445;
        Thu, 15 Oct 2026 14:33:03 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4fe9d9sm558041f8f.40.2026.10.15.14.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:33:02 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:32:59 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2
 page table
Message-ID: <atFGi3RkmdQpKWRd@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-23-smostafa@google.com>
 <sashiko-outbox-173400@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173400@kernel.org>

On Thu, Oct 15, 2026 at 08:32:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] iommu/arm-smmu-v3: incorrect recovery from -EEXIST in smmu_host_stage2_idmap leaves holes in memory
> --
> 
> commit d265b84d43b0a3e480c297258952f561f0f39998
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
> 
> This commit mirrors changes to the host stage-2 page table into an identity
> mapped stage-2 for the SMMUv3. It handles memory mapped with PAGE_SIZE and
> MMIO mapped with the largest block that fits.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index 943ffef0bb4aa..75b2b1477a4fa 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -1011,8 +1070,100 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
> [ ... ]
> > +static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
> > +{
> > +	size_t pgsize = PAGE_SIZE, pgcount, size;
> > +	struct io_pgtable *pgtable = idmap_pgtable;
> > +	int ret = 0;
> > +
> > +	end = min(end, BIT(pgtable->cfg.oas));
> > +	if (start >= end)
> > +		return 0;
> > +
> > +	size = end - start;
> > +	if (prot) {
> > +		size_t mapped;
> > +
> > +		if (!(prot & IOMMU_MMIO))
> > +			prot |= IOMMU_CACHE;
> > +
> > +		while (size) {
> > +			mapped = 0;
> [ ... ]
> > +			if (prot & IOMMU_MMIO)
> > +				pgsize = smmu_pgsize_idmap(size, start, pgtable->cfg.pgsize_bitmap);
> > +
> > +			pgcount = size / pgsize;
> > +			ret = pgtable->ops.map_pages(&pgtable->ops, start, start,
> > +						     pgsize, pgcount, prot, 0, &mapped);
> > +			size -= mapped;
> > +			start += mapped;
> > +
> > +			if (ret == -EEXIST) {
> > +				/*
> > +				 * It is possible to get EEXIST when a VM dies with pages
> > +				 * in a shared state.
> > +				 */
> > +				ret = 0;
> > +				size -= pgsize;
> > +				start += pgsize;
> > +				continue;
> > +			}
> 
> [Severity: High]
> Does this error handling skip valid pages when a collision occurs later in
> the batch?
> 
> The io-pgtable-arm backend implementation of map_pages validates all entries
> in the batch before writing any PTEs:
> 
> drivers/iommu/io-pgtable-arm.c:arm_lpae_init_pte() {
> 	for (i = 0; i < num_entries; i++)
> 		if (iopte_leaf(ptep[i], lvl, data->iop.fmt)) {
> 			/* We require an unmap first */
> 			WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
> 			return -EEXIST;
> 		}
> }
> 
> If a collision is found at any index (for example, the 5th page of the batch),
> map_pages returns -EEXIST immediately without mapping anything, leaving mapped
> at 0.
> 
> Because mapped is 0, this code assumes the very first page of the batch caused
> the collision, skips it by doing start += pgsize, and retries the loop. This
> process repeatedly skips earlier non-colliding pages without mapping them,
> leaving holes in the SMMU stage 2 identity map and causing translation faults
> during host DMA.
> 

mmm, yes, this only works now because idmap is called with a single
leaf. That logic needs some cleanup just in case that changes.

Thanks,
Mostafa

> > +			if (!mapped || ret)
> > +				break;
> > +		}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=22
