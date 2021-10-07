Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2A0C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 15:36:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25AAD61245
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 15:36:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25AAD61245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F1DC4B2EE;
	Thu,  7 Oct 2021 11:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iDrtvxiuhQT7; Thu,  7 Oct 2021 11:36:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE674B2F1;
	Thu,  7 Oct 2021 11:36:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6A494B2E0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 11:36:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jOnWdPDER8vv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 11:36:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 782044B2DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 11:36:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633620967;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uAG2gSfGivkFqPdUcOcMoHWNK+3LPbOEp8js+1JX9D0=;
 b=CSR2qIOkpznwEp89vDXGcsniL/5XrYF5Xi2keeAWlvuMT3ik7Ri9ky8CI/oimsHdPSi2tl
 jDAkoK3d07Wl0VQnUc3B0qS1qTGr48TMtWXpdOr++YAAV8XXcXyMpuKPnokKOr2dq43Ab+
 /Ot8Ttcd19hYEkdLcjXyGAYYvwoQLaM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-hyS_csqENhW-6VYGzpM0xQ-1; Thu, 07 Oct 2021 11:36:06 -0400
X-MC-Unique: hyS_csqENhW-6VYGzpM0xQ-1
Received: by mail-wr1-f70.google.com with SMTP id
 r16-20020adfbb10000000b00160958ed8acso5020100wrg.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 08:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uAG2gSfGivkFqPdUcOcMoHWNK+3LPbOEp8js+1JX9D0=;
 b=oRmy2BUxvRNL9AAnK/k7bKMBcaXv66svpBXwHvD9EDJhdiWx7JVZqNzI1MCbORgAoa
 6aeZXkF6VCZ8q/Nut2hoxTmdzFkZUA/Y7GX0b61/sVBqjKNVbb0G7u+ycn+Azc8abpdZ
 a7F1JcC0I38RUr1JH7dbXTa5p0korSxOVjSFglwMaK4deFbJJP0AkbuP7b1Lbxz9AkAa
 4GX+/e4fnQg4wSJgDGnG46PvouqAVjMVKC4N1Brz3J0QzgG1utqqQyvGY5Jal3Px3e6s
 U+q1T1lQ7EU2KzGC+VRIMuj+cvthqW7kuXAaDApAX20hQtDjfWG0iOY+/zICQB2nWA55
 HYSg==
X-Gm-Message-State: AOAM533AtNA1cT4jdv26pu6+9eu7r0Qb0dmh0KBWM/aVTZdtfF/jRfSe
 fpDi8WH60XFr6+NDMLxr+UYOyvAz1A58hjD/a7WP05uFLnTlbO0P2A9lqwnGkp2V4wB5guJyE8R
 fdKOQghoBcg7QWtSFOyu4ElKZ
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr6309719wrw.226.1633620964990; 
 Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOKhb13upVjPdpIgw2cu/kQXMovUZ4V+HV98DQtzXtkqpTYLB5D5upVw8rRtM4pTWx6MSkgA==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr6309692wrw.226.1633620964837; 
 Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id z1sm20480911wrt.41.2021.10.07.08.36.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 08:36:04 -0700 (PDT)
Date: Thu, 7 Oct 2021 17:36:02 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 13/16] arm64: Implement ioremap/iounmap hooks calling
 into KVM's MMIO guard
Message-ID: <20211007153602.ty72qbglrwbphokj@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-14-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-14-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 04, 2021 at 06:48:46PM +0100, Marc Zyngier wrote:
> Implement the previously defined ioremap/iounmap hooks for arm64,
> calling into KVM's MMIO guard if available.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/mm/ioremap.c | 112 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index b7c81dacabf0..5334cbdc9f64 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -9,13 +9,125 @@
>   * Copyright (C) 2012 ARM Ltd.
>   */
>  
> +#define pr_fmt(fmt)	"ioremap: " fmt
> +
>  #include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
> +#include <linux/slab.h>
>  #include <linux/io.h>
> +#include <linux/arm-smccc.h>
>  
>  #include <asm/fixmap.h>
>  #include <asm/tlbflush.h>
> +#include <asm/hypervisor.h>
> +
> +struct ioremap_guard_ref {
> +	refcount_t	count;
> +};
> +
> +static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
> +static DEFINE_XARRAY(ioremap_guard_array);
> +static DEFINE_MUTEX(ioremap_guard_lock);
> +
> +void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
> +{
> +	if (!static_branch_unlikely(&ioremap_guard_key))
> +		return;
> +
> +	if (pfn_valid(__phys_to_pfn(phys_addr)))
> +		return;
> +
> +	mutex_lock(&ioremap_guard_lock);
> +
> +	while (size) {
> +		u64 pfn = phys_addr >> PAGE_SHIFT;
> +		struct ioremap_guard_ref *ref;
> +		struct arm_smccc_res res;
> +
> +		ref = xa_load(&ioremap_guard_array, pfn);
> +		if (ref) {
> +			refcount_inc(&ref->count);
> +			goto next;
> +		}
> +
> +		/*
> +		 * It is acceptable for the allocation to fail, specially
> +		 * if trying to ioremap something very early on, like with
> +		 * earlycon, which happens long before kmem_cache_init.
> +		 * This page will be permanently accessible, similar to a
> +		 * saturated refcount.
> +		 */
> +		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
> +		if (ref) {
> +			refcount_set(&ref->count, 1);
> +			if (xa_err(xa_store(&ioremap_guard_array, pfn, ref,
> +					    GFP_KERNEL))) {
> +				kfree(ref);
> +				ref = NULL;
> +			}
> +		}
> +
> +		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
> +				  phys_addr, prot, &res);

OK, I see this follows the document and passes prot in x2, even though the
hypercall implementation doesn't look at it [yet].

> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn_ratelimited("Failed to register %llx\n",
> +					    phys_addr);
> +			xa_erase(&ioremap_guard_array, pfn);
> +			kfree(ref);
> +			goto out;
> +		}
> +
> +	next:
> +		size -= PAGE_SIZE;
> +		phys_addr += PAGE_SIZE;

Looks like we're assuming the guard granule to be PAGE_SIZE here. Looking
ahead at the next patch, I see it must be PAGE_SIZE, because if the info
hypercall doesn't have a matching value, then mmio guarding doesn't
happen at all. Maybe it should be documented that for this feature the
host and guest must have matching page sizes.

> +	}
> +out:
> +	mutex_unlock(&ioremap_guard_lock);
> +}
> +
> +void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
> +{
> +	if (!static_branch_unlikely(&ioremap_guard_key))
> +		return;
> +
> +	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
> +
> +	mutex_lock(&ioremap_guard_lock);
> +
> +	while (size) {
> +		u64 pfn = phys_addr >> PAGE_SHIFT;
> +		struct ioremap_guard_ref *ref;
> +		struct arm_smccc_res res;
> +
> +		ref = xa_load(&ioremap_guard_array, pfn);
> +		if (!ref) {
> +			pr_warn_ratelimited("%llx not tracked, left mapped\n",
> +					    phys_addr);
> +			goto next;
> +		}
> +
> +		if (!refcount_dec_and_test(&ref->count))
> +			goto next;
> +
> +		xa_erase(&ioremap_guard_array, pfn);
> +		kfree(ref);
> +
> +		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
> +				  phys_addr, &res);
> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn_ratelimited("Failed to unregister %llx\n",
> +					    phys_addr);
> +			goto out;
> +		}
> +
> +	next:
> +		size -= PAGE_SIZE;
> +		phys_addr += PAGE_SIZE;
> +	}
> +out:
> +	mutex_unlock(&ioremap_guard_lock);
> +}
>  
>  static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>  				      pgprot_t prot, void *caller)
> -- 
> 2.30.2
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
