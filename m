Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7778205AA1
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031669; cv=none; b=jleBKASiYgNBDWhDEN2wXEIkXKGFPAuSeWsirROUO35HS306pdZvSznqYTjhVTufg+eQ2PncvdsiiqjbLmPyDNUMuEc33OrM138XI/48OJ0BocH4Mk23WL7p9x8Ix6uGjjRMqdZ41X8Idb0WiN7MdEMSXYPJsBm3RESJoqnFKzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031669; c=relaxed/simple;
	bh=1NFn5KE/kXg8kjuzgfmxfbGhfOgwFsV7gF4h39ukfKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMThw1L2jbN97AD1TGJ72msKFfODgxl8izIbZPHvxbFPSMZuCUeOlV+k3e3b2ssDhPkwJngu9HbgFQb9KTXllNYQn539eqGie40gVT553dC+mL/A2sgBXsT8THU4X/ozUs49eIggs+lJyItRaGJk6l+Vz3WmPPxBw4BNszyZR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i4nDF3jB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i4nDF3jB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f2d21cbabso54605e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758031665; x=1758636465; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HShoPQmKhWPfy1OnMwKg01Y3DNas9O6fwq8aUeABtfI=;
        b=i4nDF3jBVrDEaFZ+aiVJbMSYaQPY9a3YlAvSrxIT2kezBUAB70vidht1AQiN3HL9ua
         dWixJhjRAKbnRpOkUmn7Je73wOUF8btwAS08IS7kLKoXXLUYfvFiF20/rypufpLqYPCQ
         TsTC7/2I7d73QREUyDsIcDuj/62/z9zDHjHDl+gAc1t29p3L4suD0Tw/yZmnTrRpArDb
         AbpWWjInL9aRCg74reIdZFQttyzoBcQb2ANkWCNV89cvlS1YtbXadgHzquZ70SnXYk1r
         2LaLYs5F3MzIOgzFjDkGnC/q9GZrQzR4goKbR2dnyzlTow5rKbr84EY5d41diKrNT2yY
         VyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031665; x=1758636465;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HShoPQmKhWPfy1OnMwKg01Y3DNas9O6fwq8aUeABtfI=;
        b=fR4xaZvbd0qkeJtT7R83LDcr8f6ZVKc7Lofccin2UIZ2EBtbzpg37z7kJfYREizsA+
         xLSwfBcILLsVhW3biRP41UxFLhvOqa/0WgSZj+lKRl9TvvcLi5bj+DyALLk4N550OUNa
         Hy4C6zRl0kWxRpNVApJkGkiaKzd5q5PIGOr+wpBa9lT66+/jWRxQnvGqIvFqFaXmt+tH
         PMguLPn+wqUbgdiRF1n4gM5Wrj/htaTSARDoQpA4KuBF7hqJAKSd1pFfeoFrk5Oaats0
         UiGCEFuQKB29er0tzOnWZbzlOwfopIi6EXrNJQ+YzRXqLGsAvCwVnFx8QcU/dLhVO8c7
         Oi3g==
X-Forwarded-Encrypted: i=1; AJvYcCVtPD9edVjW2zVWi28aqD3d9DeuZ4PIPwiDkeahTweRPRVqd/TXs3skdXRVovqkY0fM3qRDmO0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy27MxxmlCMrG9ejRi1VpB4w1Tj+Os+VzPvVmgi8G18ZtqqJaKv
	4jOX9oXFJuG5WYiea7xvqyoS21gKAIhJQA9UehimcFDPnb+nqE4g8EAPPtGq/259Ag==
X-Gm-Gg: ASbGnct+x37ymAGtAA7x7zntDJU55SBDuVWUUAMlqEybks9Pqx26ly48rlemiZ2Zw6T
	SaZrhRzKk2dVEMIFCvLm/PwC3bi9noAYCFzdfr7wPHpt6TXKoCWzYHI090/FMJg6LE2zui0e2eD
	YYEF4P3VJL8HB7FYuRr/rtln9WpTjH3SfqJPjT7Piz5s8GH7o+t6YIEGvdbR2b6W3Fb8ndNe3JP
	jPXkFsw15ThqDe7nEJW6TZFI4/Tuz2mlMccIVvKfuJQ5ecCRpLh7n22Bl4LiI9/67gz7uDzrehy
	WtGvcNR/mIULyvC1RbWBzaegKWEa54zJ6tH6QT41uxXuN8Ey2mmK5XFVKxUkMaEK8eopqHRMp0L
	PLknUjEg+/eahacHQfbecrijhdn+PI0m/xqtw/nLbruRTPSil5Aym2ATux0Y+fJqvWi6ZIHNSAr
	HbcH2I
X-Google-Smtp-Source: AGHT+IEVo4a+qAIT+mxk3e2bBJu0HzPute2usozdzr8r6tBTGChpG2GP9sikTw0U3WHTfaTbYtNMLw==
X-Received: by 2002:a05:600c:8b6a:b0:45f:5b02:b0cb with SMTP id 5b1f17b1804b1-45f5b02b390mr1185505e9.0.1758031664917;
        Tue, 16 Sep 2025 07:07:44 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdbc7fe1bsm804909f8f.52.2025.09.16.07.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:07:44 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:07:40 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com
Subject: Re: [PATCH v4 04/28] iommu/io-pgtable-arm: Move selftests to a
 separate file
Message-ID: <aMlvLHFgubf0lcfO@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-5-smostafa@google.com>
 <aMgkvTLAWLUJ7OD5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMgkvTLAWLUJ7OD5@google.com>

On Mon, Sep 15, 2025 at 02:37:49PM +0000, Pranjal Shrivastava wrote:
> On Tue, Aug 19, 2025 at 09:51:32PM +0000, Mostafa Saleh wrote:
> > Soon, io-pgtable-arm.c will be compiled as part of the KVM/arm64
> > in the hypervisor object, which doesn't have many of the kernel APIs,
> > as faux devices, printk...
> > 
> > We would need to factor this things outside of this file, this patch
> > moves the selftests outside, which remove many of the kernel
> > dependencies, which also is not needed by the hypervisor.
> > Create io-pgtable-arm-kernel.c for that, and in the next patch
> > the rest of the code is factored out.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/Makefile                |   2 +-
> >  drivers/iommu/io-pgtable-arm-kernel.c | 216 +++++++++++++++++++++++
> >  drivers/iommu/io-pgtable-arm.c        | 245 --------------------------
> >  drivers/iommu/io-pgtable-arm.h        |  41 +++++
> >  4 files changed, 258 insertions(+), 246 deletions(-)
> >  create mode 100644 drivers/iommu/io-pgtable-arm-kernel.c
> > 
> > diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> > index 355294fa9033..d601b0e25ef5 100644
> > --- a/drivers/iommu/Makefile
> > +++ b/drivers/iommu/Makefile
> > @@ -11,7 +11,7 @@ obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
> >  obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
> >  obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
> >  obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
> > -obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
> > +obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o io-pgtable-arm-kernel.o
> >  obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
> >  obj-$(CONFIG_IOMMU_IOVA) += iova.o
> >  obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
> > diff --git a/drivers/iommu/io-pgtable-arm-kernel.c b/drivers/iommu/io-pgtable-arm-kernel.c
> > new file mode 100644
> > index 000000000000..f3b869310964
> > --- /dev/null
> > +++ b/drivers/iommu/io-pgtable-arm-kernel.c
> 
> If this file just contains the selftests, how about naming it
> "io-pgtable-arm-selftests.c" ? 

In the next patch I am adding more kernel code to it, so it’s not just
selftests, but as Jason suggested, we can just completely move the self
tests out, in that case "io-pgtable-arm-selftests.c" makes sense.

Thanks,
Mostafa

> 
> > @@ -0,0 +1,216 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * CPU-agnostic ARM page table allocator.
> > + *
> > + * Copyright (C) 2014 ARM Limited
> > + *
> > + * Author: Will Deacon <will.deacon@arm.com>
> > + */
> > +#define pr_fmt(fmt)	"arm-lpae io-pgtable: " fmt
> > +
> > +#include <linux/device/faux.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +
> > +#include "io-pgtable-arm.h"
> > +
> > +#ifdef CONFIG_IOMMU_IO_PGTABLE_LPAE_SELFTEST
> > +
> > +static struct io_pgtable_cfg *cfg_cookie __initdata;
> > +
> > +static void __init dummy_tlb_flush_all(void *cookie)
> > +{
> > +	WARN_ON(cookie != cfg_cookie);
> > +}
> > +
> > +static void __init dummy_tlb_flush(unsigned long iova, size_t size,
> > +				   size_t granule, void *cookie)
> > +{
> > +	WARN_ON(cookie != cfg_cookie);
> > +	WARN_ON(!(size & cfg_cookie->pgsize_bitmap));
> > +}
> > +
> > +static void __init dummy_tlb_add_page(struct iommu_iotlb_gather *gather,
> > +				      unsigned long iova, size_t granule,
> > +				      void *cookie)
> > +{
> > +	dummy_tlb_flush(iova, granule, granule, cookie);
> > +}
> > +
> > +static const struct iommu_flush_ops dummy_tlb_ops __initconst = {
> > +	.tlb_flush_all	= dummy_tlb_flush_all,
> > +	.tlb_flush_walk	= dummy_tlb_flush,
> > +	.tlb_add_page	= dummy_tlb_add_page,
> > +};
> > +
> > +static void __init arm_lpae_dump_ops(struct io_pgtable_ops *ops)
> > +{
> > +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> > +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> > +
> > +	pr_err("cfg: pgsize_bitmap 0x%lx, ias %u-bit\n",
> > +		cfg->pgsize_bitmap, cfg->ias);
> > +	pr_err("data: %d levels, 0x%zx pgd_size, %u pg_shift, %u bits_per_level, pgd @ %p\n",
> > +		ARM_LPAE_MAX_LEVELS - data->start_level, ARM_LPAE_PGD_SIZE(data),
> > +		ilog2(ARM_LPAE_GRANULE(data)), data->bits_per_level, data->pgd);
> > +}
> > +
> > +#define __FAIL(ops, i)	({						\
> > +		WARN(1, "selftest: test failed for fmt idx %d\n", (i));	\
> > +		arm_lpae_dump_ops(ops);					\
> > +		-EFAULT;						\
> > +})
> > +
> > +static int __init arm_lpae_run_tests(struct io_pgtable_cfg *cfg)
> > +{
> > +	static const enum io_pgtable_fmt fmts[] __initconst = {
> > +		ARM_64_LPAE_S1,
> > +		ARM_64_LPAE_S2,
> > +	};
> > +
> > +	int i, j;
> > +	unsigned long iova;
> > +	size_t size, mapped;
> > +	struct io_pgtable_ops *ops;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(fmts); ++i) {
> > +		cfg_cookie = cfg;
> > +		ops = alloc_io_pgtable_ops(fmts[i], cfg, cfg);
> > +		if (!ops) {
> > +			pr_err("selftest: failed to allocate io pgtable ops\n");
> > +			return -ENOMEM;
> > +		}
> > +
> > +		/*
> > +		 * Initial sanity checks.
> > +		 * Empty page tables shouldn't provide any translations.
> > +		 */
> > +		if (ops->iova_to_phys(ops, 42))
> > +			return __FAIL(ops, i);
> > +
> > +		if (ops->iova_to_phys(ops, SZ_1G + 42))
> > +			return __FAIL(ops, i);
> > +
> > +		if (ops->iova_to_phys(ops, SZ_2G + 42))
> > +			return __FAIL(ops, i);
> > +
> > +		/*
> > +		 * Distinct mappings of different granule sizes.
> > +		 */
> > +		iova = 0;
> > +		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
> > +			size = 1UL << j;
> > +
> > +			if (ops->map_pages(ops, iova, iova, size, 1,
> > +					   IOMMU_READ | IOMMU_WRITE |
> > +					   IOMMU_NOEXEC | IOMMU_CACHE,
> > +					   GFP_KERNEL, &mapped))
> > +				return __FAIL(ops, i);
> > +
> > +			/* Overlapping mappings */
> > +			if (!ops->map_pages(ops, iova, iova + size, size, 1,
> > +					    IOMMU_READ | IOMMU_NOEXEC,
> > +					    GFP_KERNEL, &mapped))
> > +				return __FAIL(ops, i);
> > +
> > +			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> > +				return __FAIL(ops, i);
> > +
> > +			iova += SZ_1G;
> > +		}
> > +
> > +		/* Full unmap */
> > +		iova = 0;
> > +		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
> > +			size = 1UL << j;
> > +
> > +			if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> > +				return __FAIL(ops, i);
> > +
> > +			if (ops->iova_to_phys(ops, iova + 42))
> > +				return __FAIL(ops, i);
> > +
> > +			/* Remap full block */
> > +			if (ops->map_pages(ops, iova, iova, size, 1,
> > +					   IOMMU_WRITE, GFP_KERNEL, &mapped))
> > +				return __FAIL(ops, i);
> > +
> > +			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> > +				return __FAIL(ops, i);
> > +
> > +			iova += SZ_1G;
> > +		}
> > +
> > +		/*
> > +		 * Map/unmap the last largest supported page of the IAS, this can
> > +		 * trigger corner cases in the concatednated page tables.
> > +		 */
> > +		mapped = 0;
> > +		size = 1UL << __fls(cfg->pgsize_bitmap);
> > +		iova = (1UL << cfg->ias) - size;
> > +		if (ops->map_pages(ops, iova, iova, size, 1,
> > +				   IOMMU_READ | IOMMU_WRITE |
> > +				   IOMMU_NOEXEC | IOMMU_CACHE,
> > +				   GFP_KERNEL, &mapped))
> > +			return __FAIL(ops, i);
> > +		if (mapped != size)
> > +			return __FAIL(ops, i);
> > +		if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> > +			return __FAIL(ops, i);
> > +
> > +		free_io_pgtable_ops(ops);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int __init arm_lpae_do_selftests(void)
> > +{
> > +	static const unsigned long pgsize[] __initconst = {
> > +		SZ_4K | SZ_2M | SZ_1G,
> > +		SZ_16K | SZ_32M,
> > +		SZ_64K | SZ_512M,
> > +	};
> > +
> > +	static const unsigned int address_size[] __initconst = {
> > +		32, 36, 40, 42, 44, 48,
> > +	};
> > +
> > +	int i, j, k, pass = 0, fail = 0;
> > +	struct faux_device *dev;
> > +	struct io_pgtable_cfg cfg = {
> > +		.tlb = &dummy_tlb_ops,
> > +		.coherent_walk = true,
> > +		.quirks = IO_PGTABLE_QUIRK_NO_WARN,
> > +	};
> > +
> > +	dev = faux_device_create("io-pgtable-test", NULL, 0);
> > +	if (!dev)
> > +		return -ENOMEM;
> > +
> > +	cfg.iommu_dev = &dev->dev;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(pgsize); ++i) {
> > +		for (j = 0; j < ARRAY_SIZE(address_size); ++j) {
> > +			/* Don't use ias > oas as it is not valid for stage-2. */
> > +			for (k = 0; k <= j; ++k) {
> > +				cfg.pgsize_bitmap = pgsize[i];
> > +				cfg.ias = address_size[k];
> > +				cfg.oas = address_size[j];
> > +				pr_info("selftest: pgsize_bitmap 0x%08lx, IAS %u OAS %u\n",
> > +					pgsize[i], cfg.ias, cfg.oas);
> > +				if (arm_lpae_run_tests(&cfg))
> > +					fail++;
> > +				else
> > +					pass++;
> > +			}
> > +		}
> > +	}
> > +
> > +	pr_info("selftest: completed with %d PASS %d FAIL\n", pass, fail);
> > +	faux_device_destroy(dev);
> > +
> > +	return fail ? -EFAULT : 0;
> > +}
> > +subsys_initcall(arm_lpae_do_selftests);
> > +#endif
> > diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> > index 96425e92f313..791a2c4ecb83 100644
> > --- a/drivers/iommu/io-pgtable-arm.c
> > +++ b/drivers/iommu/io-pgtable-arm.c
> > @@ -7,15 +7,10 @@
> >   * Author: Will Deacon <will.deacon@arm.com>
> >   */
> >  
> > -#define pr_fmt(fmt)	"arm-lpae io-pgtable: " fmt
> > -
> >  #include <linux/atomic.h>
> >  #include <linux/bitops.h>
> >  #include <linux/io-pgtable.h>
> > -#include <linux/kernel.h>
> > -#include <linux/device/faux.h>
> >  #include <linux/sizes.h>
> > -#include <linux/slab.h>
> >  #include <linux/types.h>
> >  #include <linux/dma-mapping.h>
> >  
> > @@ -24,33 +19,6 @@
> >  #include "io-pgtable-arm.h"
> >  #include "iommu-pages.h"
> >  
> > -#define ARM_LPAE_MAX_ADDR_BITS		52
> > -#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
> > -#define ARM_LPAE_MAX_LEVELS		4
> > -
> > -/* Struct accessors */
> > -#define io_pgtable_to_data(x)						\
> > -	container_of((x), struct arm_lpae_io_pgtable, iop)
> > -
> > -#define io_pgtable_ops_to_data(x)					\
> > -	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> > -
> > -/*
> > - * Calculate the right shift amount to get to the portion describing level l
> > - * in a virtual address mapped by the pagetable in d.
> > - */
> > -#define ARM_LPAE_LVL_SHIFT(l,d)						\
> > -	(((ARM_LPAE_MAX_LEVELS - (l)) * (d)->bits_per_level) +		\
> > -	ilog2(sizeof(arm_lpae_iopte)))
> > -
> > -#define ARM_LPAE_GRANULE(d)						\
> > -	(sizeof(arm_lpae_iopte) << (d)->bits_per_level)
> > -#define ARM_LPAE_PGD_SIZE(d)						\
> > -	(sizeof(arm_lpae_iopte) << (d)->pgd_bits)
> > -
> > -#define ARM_LPAE_PTES_PER_TABLE(d)					\
> > -	(ARM_LPAE_GRANULE(d) >> ilog2(sizeof(arm_lpae_iopte)))
> > -
> >  /*
> >   * Calculate the index at level l used to map virtual address a using the
> >   * pagetable in d.
> > @@ -163,18 +131,6 @@
> >  #define iopte_set_writeable_clean(ptep)				\
> >  	set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)(ptep))
> >  
> > -struct arm_lpae_io_pgtable {
> > -	struct io_pgtable	iop;
> > -
> > -	int			pgd_bits;
> > -	int			start_level;
> > -	int			bits_per_level;
> > -
> > -	void			*pgd;
> > -};
> > -
> > -typedef u64 arm_lpae_iopte;
> > -
> >  static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
> >  			      enum io_pgtable_fmt fmt)
> >  {
> > @@ -1274,204 +1230,3 @@ struct io_pgtable_init_fns io_pgtable_arm_mali_lpae_init_fns = {
> >  	.alloc	= arm_mali_lpae_alloc_pgtable,
> >  	.free	= arm_lpae_free_pgtable,
> >  };
> > -
> > -#ifdef CONFIG_IOMMU_IO_PGTABLE_LPAE_SELFTEST
> > -
> > -static struct io_pgtable_cfg *cfg_cookie __initdata;
> > -
> > -static void __init dummy_tlb_flush_all(void *cookie)
> > -{
> > -	WARN_ON(cookie != cfg_cookie);
> > -}
> > -
> > -static void __init dummy_tlb_flush(unsigned long iova, size_t size,
> > -				   size_t granule, void *cookie)
> > -{
> > -	WARN_ON(cookie != cfg_cookie);
> > -	WARN_ON(!(size & cfg_cookie->pgsize_bitmap));
> > -}
> > -
> > -static void __init dummy_tlb_add_page(struct iommu_iotlb_gather *gather,
> > -				      unsigned long iova, size_t granule,
> > -				      void *cookie)
> > -{
> > -	dummy_tlb_flush(iova, granule, granule, cookie);
> > -}
> > -
> > -static const struct iommu_flush_ops dummy_tlb_ops __initconst = {
> > -	.tlb_flush_all	= dummy_tlb_flush_all,
> > -	.tlb_flush_walk	= dummy_tlb_flush,
> > -	.tlb_add_page	= dummy_tlb_add_page,
> > -};
> > -
> > -static void __init arm_lpae_dump_ops(struct io_pgtable_ops *ops)
> > -{
> > -	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> > -	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> > -
> > -	pr_err("cfg: pgsize_bitmap 0x%lx, ias %u-bit\n",
> > -		cfg->pgsize_bitmap, cfg->ias);
> > -	pr_err("data: %d levels, 0x%zx pgd_size, %u pg_shift, %u bits_per_level, pgd @ %p\n",
> > -		ARM_LPAE_MAX_LEVELS - data->start_level, ARM_LPAE_PGD_SIZE(data),
> > -		ilog2(ARM_LPAE_GRANULE(data)), data->bits_per_level, data->pgd);
> > -}
> > -
> > -#define __FAIL(ops, i)	({						\
> > -		WARN(1, "selftest: test failed for fmt idx %d\n", (i));	\
> > -		arm_lpae_dump_ops(ops);					\
> > -		-EFAULT;						\
> > -})
> > -
> > -static int __init arm_lpae_run_tests(struct io_pgtable_cfg *cfg)
> > -{
> > -	static const enum io_pgtable_fmt fmts[] __initconst = {
> > -		ARM_64_LPAE_S1,
> > -		ARM_64_LPAE_S2,
> > -	};
> > -
> > -	int i, j;
> > -	unsigned long iova;
> > -	size_t size, mapped;
> > -	struct io_pgtable_ops *ops;
> > -
> > -	for (i = 0; i < ARRAY_SIZE(fmts); ++i) {
> > -		cfg_cookie = cfg;
> > -		ops = alloc_io_pgtable_ops(fmts[i], cfg, cfg);
> > -		if (!ops) {
> > -			pr_err("selftest: failed to allocate io pgtable ops\n");
> > -			return -ENOMEM;
> > -		}
> > -
> > -		/*
> > -		 * Initial sanity checks.
> > -		 * Empty page tables shouldn't provide any translations.
> > -		 */
> > -		if (ops->iova_to_phys(ops, 42))
> > -			return __FAIL(ops, i);
> > -
> > -		if (ops->iova_to_phys(ops, SZ_1G + 42))
> > -			return __FAIL(ops, i);
> > -
> > -		if (ops->iova_to_phys(ops, SZ_2G + 42))
> > -			return __FAIL(ops, i);
> > -
> > -		/*
> > -		 * Distinct mappings of different granule sizes.
> > -		 */
> > -		iova = 0;
> > -		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
> > -			size = 1UL << j;
> > -
> > -			if (ops->map_pages(ops, iova, iova, size, 1,
> > -					   IOMMU_READ | IOMMU_WRITE |
> > -					   IOMMU_NOEXEC | IOMMU_CACHE,
> > -					   GFP_KERNEL, &mapped))
> > -				return __FAIL(ops, i);
> > -
> > -			/* Overlapping mappings */
> > -			if (!ops->map_pages(ops, iova, iova + size, size, 1,
> > -					    IOMMU_READ | IOMMU_NOEXEC,
> > -					    GFP_KERNEL, &mapped))
> > -				return __FAIL(ops, i);
> > -
> > -			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> > -				return __FAIL(ops, i);
> > -
> > -			iova += SZ_1G;
> > -		}
> > -
> > -		/* Full unmap */
> > -		iova = 0;
> > -		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
> > -			size = 1UL << j;
> > -
> > -			if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> > -				return __FAIL(ops, i);
> > -
> > -			if (ops->iova_to_phys(ops, iova + 42))
> > -				return __FAIL(ops, i);
> > -
> > -			/* Remap full block */
> > -			if (ops->map_pages(ops, iova, iova, size, 1,
> > -					   IOMMU_WRITE, GFP_KERNEL, &mapped))
> > -				return __FAIL(ops, i);
> > -
> > -			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> > -				return __FAIL(ops, i);
> > -
> > -			iova += SZ_1G;
> > -		}
> > -
> > -		/*
> > -		 * Map/unmap the last largest supported page of the IAS, this can
> > -		 * trigger corner cases in the concatednated page tables.
> > -		 */
> > -		mapped = 0;
> > -		size = 1UL << __fls(cfg->pgsize_bitmap);
> > -		iova = (1UL << cfg->ias) - size;
> > -		if (ops->map_pages(ops, iova, iova, size, 1,
> > -				   IOMMU_READ | IOMMU_WRITE |
> > -				   IOMMU_NOEXEC | IOMMU_CACHE,
> > -				   GFP_KERNEL, &mapped))
> > -			return __FAIL(ops, i);
> > -		if (mapped != size)
> > -			return __FAIL(ops, i);
> > -		if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> > -			return __FAIL(ops, i);
> > -
> > -		free_io_pgtable_ops(ops);
> > -	}
> > -
> > -	return 0;
> > -}
> > -
> > -static int __init arm_lpae_do_selftests(void)
> > -{
> > -	static const unsigned long pgsize[] __initconst = {
> > -		SZ_4K | SZ_2M | SZ_1G,
> > -		SZ_16K | SZ_32M,
> > -		SZ_64K | SZ_512M,
> > -	};
> > -
> > -	static const unsigned int address_size[] __initconst = {
> > -		32, 36, 40, 42, 44, 48,
> > -	};
> > -
> > -	int i, j, k, pass = 0, fail = 0;
> > -	struct faux_device *dev;
> > -	struct io_pgtable_cfg cfg = {
> > -		.tlb = &dummy_tlb_ops,
> > -		.coherent_walk = true,
> > -		.quirks = IO_PGTABLE_QUIRK_NO_WARN,
> > -	};
> > -
> > -	dev = faux_device_create("io-pgtable-test", NULL, 0);
> > -	if (!dev)
> > -		return -ENOMEM;
> > -
> > -	cfg.iommu_dev = &dev->dev;
> > -
> > -	for (i = 0; i < ARRAY_SIZE(pgsize); ++i) {
> > -		for (j = 0; j < ARRAY_SIZE(address_size); ++j) {
> > -			/* Don't use ias > oas as it is not valid for stage-2. */
> > -			for (k = 0; k <= j; ++k) {
> > -				cfg.pgsize_bitmap = pgsize[i];
> > -				cfg.ias = address_size[k];
> > -				cfg.oas = address_size[j];
> > -				pr_info("selftest: pgsize_bitmap 0x%08lx, IAS %u OAS %u\n",
> > -					pgsize[i], cfg.ias, cfg.oas);
> > -				if (arm_lpae_run_tests(&cfg))
> > -					fail++;
> > -				else
> > -					pass++;
> > -			}
> > -		}
> > -	}
> > -
> > -	pr_info("selftest: completed with %d PASS %d FAIL\n", pass, fail);
> > -	faux_device_destroy(dev);
> > -
> > -	return fail ? -EFAULT : 0;
> > -}
> > -subsys_initcall(arm_lpae_do_selftests);
> > -#endif
> > diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
> > index ba7cfdf7afa0..a06a23543cff 100644
> > --- a/drivers/iommu/io-pgtable-arm.h
> > +++ b/drivers/iommu/io-pgtable-arm.h
> > @@ -2,6 +2,8 @@
> >  #ifndef IO_PGTABLE_ARM_H_
> >  #define IO_PGTABLE_ARM_H_
> >  
> > +#include <linux/io-pgtable.h>
> > +
> >  #define ARM_LPAE_TCR_TG0_4K		0
> >  #define ARM_LPAE_TCR_TG0_64K		1
> >  #define ARM_LPAE_TCR_TG0_16K		2
> > @@ -27,4 +29,43 @@
> >  #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
> >  #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
> >  
> > +/* Struct accessors */
> > +#define io_pgtable_to_data(x)						\
> > +	container_of((x), struct arm_lpae_io_pgtable, iop)
> > +
> > +#define io_pgtable_ops_to_data(x)					\
> > +	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> > +
> > +struct arm_lpae_io_pgtable {
> > +	struct io_pgtable	iop;
> > +
> > +	int			pgd_bits;
> > +	int			start_level;
> > +	int			bits_per_level;
> > +
> > +	void			*pgd;
> > +};
> > +
> > +#define ARM_LPAE_MAX_ADDR_BITS		52
> > +#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
> > +#define ARM_LPAE_MAX_LEVELS		4
> > +
> > +/*
> > + * Calculate the right shift amount to get to the portion describing level l
> > + * in a virtual address mapped by the pagetable in d.
> > + */
> > +#define ARM_LPAE_LVL_SHIFT(l,d)						\
> > +	(((ARM_LPAE_MAX_LEVELS - (l)) * (d)->bits_per_level) +		\
> > +	ilog2(sizeof(arm_lpae_iopte)))
> > +
> > +#define ARM_LPAE_GRANULE(d)						\
> > +	(sizeof(arm_lpae_iopte) << (d)->bits_per_level)
> > +#define ARM_LPAE_PGD_SIZE(d)						\
> > +	(sizeof(arm_lpae_iopte) << (d)->pgd_bits)
> > +
> > +#define ARM_LPAE_PTES_PER_TABLE(d)					\
> > +	(ARM_LPAE_GRANULE(d) >> ilog2(sizeof(arm_lpae_iopte)))
> > +
> > +typedef u64 arm_lpae_iopte;
> > +
> >  #endif /* IO_PGTABLE_ARM_H_ */
> 
> Apart from the renaming above, I was able to apply this patch alone, and
> build succesfully while toggling IOMMU_IO_PGTABLE_LPAE_SELFTEST across 
> builds.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> 
> > -- 
> > 2.51.0.rc1.167.g924127e9c0-goog
> > 
