Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F921D00A;
	Mon, 23 Mar 2026 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273973; cv=none; b=N+G0y8Cf6rZxRKSGYyDS4tTT201q4pxaSeaZfTqKJoGZnuYmrPVZFy/CsI/OT5oAlBMZ0IvCpE6xxRwfiyaTSnZokDbvJ8k0/M3X43BLTH3oAeo0u6mKsT2xIUAc47dZUdR3lXHv9rggCHcqzOhGkenRSFm8noaTHApGexbjZkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273973; c=relaxed/simple;
	bh=7jiJnoPiC7mzd34UzA0mbtNzWXYVJzwZa57Ijvymt78=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EsovE6rNGVNEBNE95K2WjDhZcRTPHmgYHRkOtbbpsyhe5rwmehMlzUKRDornXs9ZGYB66SlIDXsTy+t8CE+fVQ4ohum8dkZzEerBj/XzKnQ9KlmSX1GzK1/bIx+qlBFAe1UMQREtjDjQDoxKYkk6L1A7pACcWA4iFl/HsCq7aI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiXSiBK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiXSiBK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45BC4CEF7;
	Mon, 23 Mar 2026 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273973;
	bh=7jiJnoPiC7mzd34UzA0mbtNzWXYVJzwZa57Ijvymt78=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jiXSiBK1QppgTl6/vLB9H2UV9uQ3VzRFjylVLGRov5URWxPGikF8RYzBU8sU81r1j
	 e5/aesdfmYjWK28UOhtXO1QjriCaLqRmHYovbKGwUtwFrLAoaWfiwaYikXJ2G6s5hu
	 x3THcGuYBrqjdziWwQx7E17Ze/NtNvByZh8XoyaTibSuRMZjzlQSHzrDTKdz2CDmRQ
	 70+wqO3Go3/1cc0ySV4+WofNkpJhabURRMUj7jvvBJGDXRx53GQO71K7+GoWXZARdx
	 t3cOeG/YoymTlcbBK7d6fJgLghKpFgBblkfGGHk+2iO1UI7iNz58EV6IVsdQagVHkY
	 eGUXY/Rh7Gbyg==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
In-Reply-To: <202603092320.JgtItJg0-lkp@intel.com>
References: <20260309102625.2315725-3-aneesh.kumar@kernel.org>
 <202603092320.JgtItJg0-lkp@intel.com>
Date: Mon, 23 Mar 2026 19:22:44 +0530
Message-ID: <yq5ah5q6odoz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

kernel test robot <lkp@intel.com> writes:

> Hi Aneesh,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on arm64/for-next/core]
> [also build test ERROR on tip/irq/core arm/for-next arm/fixes kvmarm/next soc/for-next linus/master v7.0-rc3 next-20260306]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Aneesh-Kumar-K-V-Arm/dma-direct-swiotlb-handle-swiotlb-alloc-free-outside-__dma_direct_alloc_pages/20260309-182834
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
> patch link:    https://lore.kernel.org/r/20260309102625.2315725-3-aneesh.kumar%40kernel.org
> patch subject: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size alignment for shared buffers
> config: i386-randconfig-012-20260309 (https://download.01.org/0day-ci/archive/20260309/202603092320.JgtItJg0-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603092320.JgtItJg0-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603092320.JgtItJg0-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from arch/x86/kernel/asm-offsets.c:9:
>    In file included from include/linux/crypto.h:15:
>    In file included from include/linux/completion.h:12:
>    In file included from include/linux/swait.h:7:
>    In file included from include/linux/spinlock.h:59:
>    In file included from include/linux/irqflags.h:18:
>    In file included from arch/x86/include/asm/irqflags.h:5:
>    In file included from arch/x86/include/asm/processor-flags.h:6:
>>> include/linux/mem_encrypt.h:60:9: error: use of undeclared identifier 'PAGE_SIZE'
>       60 |         return PAGE_SIZE;
>          |                ^
>>> include/linux/mem_encrypt.h:66:9: error: call to undeclared function 'ALIGN'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>       66 |         return ALIGN(size, mem_decrypt_granule_size());
>          |                ^
>

Fixed this by including

modified   include/linux/mem_encrypt.h
@@ -11,6 +11,8 @@
 #define __MEM_ENCRYPT_H__
 
 #ifndef __ASSEMBLY__
+#include <linux/align.h>
+#include <vdso/page.h>
 
 #ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
 


Will include this in the next patch update.

The other alternative is to switch that to a macro 

modified   include/linux/mem_encrypt.h
@@ -55,16 +55,10 @@
 #endif
 
 #ifndef mem_decrypt_granule_size
-static inline size_t mem_decrypt_granule_size(void)
-{
-	return PAGE_SIZE;
-}
+#define mem_decrypt_granule_size()     PAGE_SIZE
 #endif
 
-static inline size_t mem_decrypt_align(size_t size)
-{
-	return ALIGN(size, mem_decrypt_granule_size());
-}
+#define mem_decrypt_align(size)        ALIGN((size), mem_decrypt_granule_size())
 
