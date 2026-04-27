Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8425F3CCA05
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297749; cv=none; b=laNvIgECB25GBvZgw1Pd2vL12SFMWD8SinWLE01Ua/VcxSQ0Gb7CiZel7zMES9grNFKG4nOYRc/oJ8sxNlyCGA0mtcNO3S8VBkFOvPBlPHLaXfrOzf3AYHe0paNLtgdt0cucYSXJUxeuzjnYoaufaTw/VRXm8s8SLEm+O9KjyXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297749; c=relaxed/simple;
	bh=AiaEXL2vP7Re9WDbKnigCW6bt2LfZHNbeafJta6NglE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYa9nkIbvXBbsfVg5zVXI8psuDWgyzL1dO6Qx4MTYgy16Qx2q4qJEn0t+I0ZrCYF/IDQIJo7F5scfEjhLYG290jZKNsxy8OyzgcLH/QSytteoj4wV5YscMS9U0C9S+fETLW1XZOEf16h/B8pB35X0x0McDvaaMI9+3EdfcQnvc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lxR1sGjh; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lxR1sGjh"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8acb3dab8dfso64062616d6.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 06:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777297745; x=1777902545; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8PYGlOXEG6E9/P2t0qYpdnkfCSnyFBuw0mLKh5MPI4E=;
        b=lxR1sGjhW4Y7GT3xcWDKd4qw+q7dLoiH9nUJGQmDkYy5aksQ0xEqXQm5hBewaAN9t5
         +HVdnsVBKM4VK1CorWgR3CSqImBLIYcyZ9LufuZeyOM4sSXcxuO516cb8kqFfKwVN5We
         7a8ze9ZNWnK+YGAJ2xakcFHKRbc4iI+m63z14hrOQeCg4fhTUsREobCH6Nx+mBvyFHJl
         qthltrRTkccUiqDOg/8yh9dgq182jNKWZF7iLHjYGadwldFku/IxnE1AZLI1t3egNdiD
         LSdO9Gpzlv/b7JDOsTWbTX/VGJXQp/DDQtrAWdHikzrIJTKWiq68IcWcxaIDW++fQH46
         DihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777297745; x=1777902545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PYGlOXEG6E9/P2t0qYpdnkfCSnyFBuw0mLKh5MPI4E=;
        b=n8iNkQCJinTyoxFuZrc403wplxNfVQcwVbd0GayUEYOuaiC1UINXGeRMpCZsqGStMM
         12JAJJH20cmpQa4vtHNMG9kgq5O9m7lHg74xIvU7JahWpZewLtuhSvV+R0uX9qJ3g+HV
         5Z5oCGVNfxGtoo+nRx4guwQDdwaQzvxsoZdpzls7y32LN6QI7aFqV5pddfwYiXAxUCVj
         Hzw+m0tgl1TgrQipXOk4IVi/WpNJuitTkHiGdxNUQSmXMiv1K7OhcG/gDdz9iwITRDF9
         rSsgwcC1JVXAWtQnfC4JOvjr6JUHXLqfrdjt6ea2Bgvy4ALvORicfBvSMORZApk2XtTe
         v7zQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BrEqin/b91leDT2MWuv739KF9DD+NYss04hD9auzZXrUjolhVNL7BKktAVMx/n/2e5upmxBA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdQy0F0wfxwQL1PtH5GO0tcqJtyJ3GEyzGCggVpX0YmN5UF+Xf
	Q+hXl1ldxlut4FhWZuRj2jmonZQhz++xNlNeFau7PSwNj7I6CT17ILCrPxTgQpgqu2o=
X-Gm-Gg: AeBDievKSShgxJ8hE2n4v5tI+LoIJ8ZW0+lc+uwIhStsTrNQqiX/Rfvy6tOU7H/Nj6U
	JCanvgJ+dNDwoVY1mU0K3zphRJXflXigXnMA63QEGhw7UCPoo9WlWci1TppmZmzLiELQxY0bDF1
	luWDwqWu6DBdoT1d0es6W0Ssd3A69SiOmFyw8ngMHj9Zjtp+RzBXm7UMGlHjPzFfI9hq6bf4llB
	Xx3Ob4JZLXjio53USk4tEZ3IUsDTcZBEvzQWO8m8Ea2uEGWQcvuRqxwn42hiPOGmvmqb32sDr3b
	uwNJ0PHwhsK+xaTDoV5JZLkQdFJO2cXyZCfrkpnwUKgjqShm3TobIUgQzoIXY98vmErneZYtnad
	DebOPz2JYlY2K0fwgoWkXNcZBvxCWRDF2OPpyXgLvltT1Z+2F9LiTEgQitu2WEZVWFn79GQ9LV+
	xt5dO6Us9aEf35kGGXEWBkQSg992jDEbq9I7Bd//Kpe2YtnGpoyTpy90GW72zdE5VmHMPeYXn3M
	MK2A3cmHeX1iBBf
X-Received: by 2002:a05:6214:6107:b0:8a5:bd5b:e5f with SMTP id 6a1803df08f44-8b02817a4a5mr537295746d6.51.1777297745279;
        Mon, 27 Apr 2026 06:49:05 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aa4f1f9sm257474006d6.0.2026.04.27.06.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 06:49:04 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wHMKd-00000003T5r-43dX;
	Mon, 27 Apr 2026 10:49:03 -0300
Date: Mon, 27 Apr 2026 10:49:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
Message-ID: <20260427134903.GA740385@ziepe.ca>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427063108.909019-3-aneesh.kumar@kernel.org>

On Mon, Apr 27, 2026 at 12:01:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
> When running private-memory guests, the guest kernel must apply additional
> constraints when allocating buffers that are shared with the hypervisor.

This patch has way too much stuff in it.

I think your patch structure should be changed around

1) Patch to add mem_decrypt_granule_size(), and explain it as
   the alignment & size of what can be passed to
   set_memory_encrypted/decrypted()

2) Add support for mem_decrypt_granule_size() to ARM

Then patches going caller by caller of set_memory_decrypted() to make
them follow the new rule:

3) its

4) swiotlb 

3) dma_alloc_coherent

etc.

don't forget about the new dma buf heaps too:

drivers/dma-buf/heaps/system_heap.c:    ret = set_memory_decrypted(addr, nr_pages);

It is worth calling out in the cover letter that all the ARM CCA
relevant places are fixed but drivers/hv/ is left for future.

> @@ -33,18 +32,30 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
>  
>  int set_memory_encrypted(unsigned long addr, int numpages)
>  {
> -	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
> +	if (likely(!crypt_ops))
>  		return 0;
>  
> +	if (WARN_ON(!IS_ALIGNED(addr, mem_decrypt_granule_size())))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(numpages << PAGE_SHIFT, mem_decrypt_granule_size())))
> +		return -EINVAL;
> +
>  	return crypt_ops->encrypt(addr, numpages);
>  }
>  EXPORT_SYMBOL_GPL(set_memory_encrypted);
>  
>  int set_memory_decrypted(unsigned long addr, int numpages)
>  {
> -	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
> +	if (likely(!crypt_ops))
>  		return 0;
>  
> +	if (WARN_ON(!IS_ALIGNED(addr, mem_decrypt_granule_size())))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(numpages << PAGE_SHIFT, mem_decrypt_granule_size())))
> +		return -EINVAL;
> +
>  	return crypt_ops->decrypt(addr, numpages);
>  }
>  EXPORT_SYMBOL_GPL(set_memory_decrypted);

This should go in the ARM patch adding mem_decrypt_granule_size() to CCA

> diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
> index 07584c5e36fb..1e01c9ac697f 100644
> --- a/include/linux/mem_encrypt.h
> +++ b/include/linux/mem_encrypt.h
> @@ -11,6 +11,8 @@
>  #define __MEM_ENCRYPT_H__
>  
>  #ifndef __ASSEMBLY__
> +#include <linux/align.h>
> +#include <vdso/page.h>
>  
>  #ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
>  
> @@ -54,6 +56,18 @@
>  #define dma_addr_canonical(x)		(x)
>  #endif
>  
> +#ifndef mem_decrypt_granule_size
> +static inline size_t mem_decrypt_granule_size(void)
> +{
> +	return PAGE_SIZE;
> +}
> +#endif
> +
> +static inline size_t mem_decrypt_align(size_t size)
> +{
> +	return ALIGN(size, mem_decrypt_granule_size());
> +}
> +
>  #endif	/* __ASSEMBLY__ */
>  
>  #endif	/* __MEM_ENCRYPT_H__ */

I know it seems a bit small, but put this in its own patch and explain
how it works. I'd also like to see a kdoc here, and add a kdoc to
set_memory_decrypted() that links back so people have a better chance
to know about this.

Jason
