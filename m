Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8361C5D77
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032693; cv=none; b=iyRKygttbki87SNigT99B9ySUrOxUhVtCZMyJwwmtEg1LUxCS172JOmuRFRd3uvY/qcs6zM3bNaLvZrMI2DHZwK3SIoh+C+xQDUt2sHmYZ24pNHQh+NAfkdf2jJfHJcE7pWeZNKXDab/OMnaJDbhmYQFT5PeYhrcfcPGyzN4b9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032693; c=relaxed/simple;
	bh=9FKMvjaVooNs8mUaTMZuG1iwH62PNlh/Vx9vRvmfxg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1B7vpzQ47JG7T/LeGJ6CeJVcUKr7GtRBrVI+JhRsqHZysHgTeN9ht6buZ33z1X/OxbdT3YCoz2kq7Du65CZvofPodA1kXhem304Tyu00ONnhg4MXMl7N4aG1yScGO9Q5HOkJetnBUvybJPRgq0rSUFP0iHG4K85BlkxWBOdDFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ql/yeJX1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ql/yeJX1"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45f2d21cbabso56035e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758032690; x=1758637490; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=phDp4VnCXN9xpbEyamDNS1NPHJ+wYuQ3EZcaTqxylTM=;
        b=ql/yeJX1tFGNZBfr+qyLBCuvaTkg0iPywmMxJx/+DKMJp2X8sdLzGlwyiISFeUuiHB
         9ASYKnvajKw3jX8txFfYc1FPPPmfQm5lb45C7O/a/q0qms1ErGSE12zuxWqq97cQ0DIN
         NmgyDqzmBr3ZYXfXQim6/q01P0wyxOcKtFi/5lWadi6aWRxkuB7mkbHAjx0qwE1WOQf/
         3toO/yw9FdNHrv1uBpI7QznSecQr3rY6XldrXRfyO91lEZjfZpIbYX5xQtR32SAKEHAE
         P5GydnCukWYvCCEuzAp67T8/ize3MAuWkrKLLdCYQGDJEwb6NrW3C/+buqHvQSKKy5QJ
         r1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032690; x=1758637490;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phDp4VnCXN9xpbEyamDNS1NPHJ+wYuQ3EZcaTqxylTM=;
        b=Qf2LWRORzAfgXxJfIneTUhclBW8Fd42Cg0B0p7yiiNm2kHfQ6p0da/Gm6F2jfxTKXm
         36VnSYHBFVEtzLwgm/0FaxYGZ+W73ifDXL26CbTCTWEQX8UY6dkrgcELfLaGdLqGK329
         YRSYy+2AvhcznhX4j1C2t0Zqo7EJ3BvA9B0AvimEswL8BzXZ6co6z3wApkrtt8xmwwQK
         4SESmB4aFbaXr3cDki4xE+U7P34p0Yt6IE9++1wuB566/m+aHEqcztGEOR3GqvX3x7oc
         js1jH/lM/Kttwb8yph4sTvszmQo7ZDV7VYZ9dgZVOeh2R5mScNeeWgu6wfAsr2awk6iq
         uSaw==
X-Forwarded-Encrypted: i=1; AJvYcCXajzt1++/qQwQjOrERrUiXaPVStGdB2UEqJcV0hAN2n8AM8L9SRSvVaFYjhYAkOO3l/TAFdCA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0MqipJssoHzkRPy1FXiumsbluvg26pbZJO0+z4Y3xgQtaipX8
	ufo7lh4pRqM2hs5epgYmstM8nfb+dKheEfdFswz4vP0Hvxh4yDfheY7xw6Tk6Ydrww==
X-Gm-Gg: ASbGnctC8LkxAljCOvyDcDXae4nAmOUWFLLU/XUDNvXPaeff5Z29AuVlKd4omUaV4LY
	YH1ZUJEQSjo3vVupwrXo6XXwbpVTXte+zTXbl0YyBPf0+d44z2remhIlTp1ozIuYoBq6Bn6O5Qq
	4ROXygALTuw3c0tiKIM/o9lskQT/5RMBnvzJuuTWQ7fNpCQQwdeQAMvlkQXoTVL65F0df4LiydH
	8u8Pz1fKwz0OKWqNhkwGl5/3gi/Ed3I1I4fBrBig4uoHTWUmVbj43Rv+i+GL2m4CzNnVRIBJ4NS
	W1cGQmcCI6mVH1aX1hBTAjdWpHeGntNsv6FNEbcEZRCMVYOe76C91cwb6uCieEgSYYyhaQi6Bix
	ik57GkRl4s8Piq7sg2gCGYFNqruO+GC3D0k9Ef1yB/RwKcuFsw5F+tkEHMx9GYrMrqXZrzgIsOi
	BC+M4MfVX76j9zZTM=
X-Google-Smtp-Source: AGHT+IGY+tRtVLT/xfCf+KRVVpAwIAtGnuReJMbcXmJZJALHm+2tVODOb2attNahOqJDhG6WrbUOoA==
X-Received: by 2002:a05:600c:3b85:b0:45c:b4fb:f0b3 with SMTP id 5b1f17b1804b1-45f3278c3admr1416035e9.3.1758032689764;
        Tue, 16 Sep 2025 07:24:49 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ea4b52b7fcsm9859169f8f.33.2025.09.16.07.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:24:49 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:24:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 10/28] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <aMlzLsj5slPQhWEr@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-11-smostafa@google.com>
 <aMA8vz0v0Vn-02QP@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMA8vz0v0Vn-02QP@willie-the-truck>

On Tue, Sep 09, 2025 at 03:42:07PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:38PM +0000, Mostafa Saleh wrote:
> > Create a shadow page table for the IOMMU that shadows the
> > host CPU stage-2 into the IOMMUs to establish DMA isolation.
> > 
> > An initial snapshot is created after the driver init, then
> > on every permission change a callback would be called for
> > the IOMMU driver to update the page table.
> > 
> > For some cases, an SMMUv3 may be able to share the same page
> > table used with the host CPU stage-2 directly.
> > However, this is too strict and requires changes to the core hypervisor
> > page table code, plus it would require the hypervisor to handle IOMMU
> > page faults. This can be added later as an optimization for SMMUV3.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/iommu.h |  4 ++
> >  arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 83 ++++++++++++++++++++++++-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  5 ++
> >  3 files changed, 90 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > index 1ac70cc28a9e..219363045b1c 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > @@ -3,11 +3,15 @@
> >  #define __ARM64_KVM_NVHE_IOMMU_H__
> >  
> >  #include <asm/kvm_host.h>
> > +#include <asm/kvm_pgtable.h>
> >  
> >  struct kvm_iommu_ops {
> >  	int (*init)(void);
> > +	void (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
> >  };
> >  
> >  int kvm_iommu_init(void);
> >  
> > +void kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
> > +				 enum kvm_pgtable_prot prot);
> >  #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > index a01c036c55be..f7d1c8feb358 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > @@ -4,15 +4,94 @@
> >   *
> >   * Copyright (C) 2022 Linaro Ltd.
> >   */
> > +#include <linux/iommu.h>
> > +
> >  #include <nvhe/iommu.h>
> > +#include <nvhe/mem_protect.h>
> > +#include <nvhe/spinlock.h>
> >  
> >  /* Only one set of ops supported */
> >  struct kvm_iommu_ops *kvm_iommu_ops;
> >  
> > +/* Protected by host_mmu.lock */
> > +static bool kvm_idmap_initialized;
> > +
> > +static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
> > +{
> > +	int iommu_prot = 0;
> > +
> > +	if (prot & KVM_PGTABLE_PROT_R)
> > +		iommu_prot |= IOMMU_READ;
> > +	if (prot & KVM_PGTABLE_PROT_W)
> > +		iommu_prot |= IOMMU_WRITE;
> > +	if (prot == PKVM_HOST_MMIO_PROT)
> > +		iommu_prot |= IOMMU_MMIO;
> 
> This looks a little odd to me.
> 
> On the CPU side, the only different between PKVM_HOST_MEM_PROT and
> PKVM_HOST_MMIO_PROT is that the former has execute permission. Both are
> mapped as cacheable at stage-2 because it's the job of the host to set
> the more restrictive memory type at stage-1.
> 
> Carrying that over to the SMMU would suggest that we don't care about
> IOMMU_MMIO at stage-2 at all, so why do we need to set it here?

Unlike the CPU, the host can set the SMMU to bypass, in that case the
hypervisor will attach its stage-2 with no stage-1 configured. So,
stage-2 must have the correct attrs for MMIO.

> 
> > +	/* We don't understand that, might be dangerous. */
> > +	WARN_ON(prot & ~PKVM_HOST_MEM_PROT);
> > +	return iommu_prot;
> > +}
> > +
> > +static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
> > +				  enum kvm_pgtable_walk_flags visit)
> > +{
> > +	u64 start = ctx->addr;
> > +	kvm_pte_t pte = *ctx->ptep;
> > +	u32 level = ctx->level;
> > +	u64 end = start + kvm_granule_size(level);
> > +	int prot =  IOMMU_READ | IOMMU_WRITE;
> > +
> > +	/* Keep unmapped. */
> > +	if (pte && !kvm_pte_valid(pte))
> > +		return 0;
> > +
> > +	if (kvm_pte_valid(pte))
> > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > +	else if (!addr_is_memory(start))
> > +		prot |= IOMMU_MMIO;
> 
> Why do we need to map MMIO regions pro-actively here? I'd have thought
> we could just do:
> 
> 	if (!kvm_pte_valid(pte))
> 		return 0;
> 
> 	prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte);
> 	kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> 	return 0;
> 
> but I think that IOMMU_MMIO is throwing me again...

We have to map everything pro-actively as we don’t handle page faults
in the SMMUv3 driver.
This would be a future work where the CPU stage-2 page table is shared with
the SMMUv3.

Thanks,
Mostafa

> 
> Will
