Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C81465B4;
	Mon,  9 Mar 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068196; cv=none; b=TvdePzBiVR6laSb0yMa7z40Q91Apa+yWFcKLbCBBOAV2KpNDI9BPOkV6tZ/Pa0pUoo6FrljC+AbQv8pnLEQQFZZ/2DDU5z0c2v6af26CqoIxwLFUOF9MaXswxe4/5iDMTvvWFs9MBjXDmfiqRBmygMkB9TWcVEvc4B3KhQMMHlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068196; c=relaxed/simple;
	bh=PoL/RgNXwrNphLvs7PMzEUNTz2yJHtGScrZkcIXw6Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4j3tm7QRZtRVgxFuXbAcqRbd20w/PHPFcOSkk0oJoIXsgTTiX0FkBvxBW2fOAL7jSmEdrdtulRR+oyM7eUy5yrqwA5qm3ZIYC07v3C3cGBUxKZmhX4hhVC9FeqKfezUaHfdUm+cmmo/WfLePXOjcv2LKsTpQc++Xi8Kx0qEk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hENevFAQ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hENevFAQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773068194; x=1804604194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PoL/RgNXwrNphLvs7PMzEUNTz2yJHtGScrZkcIXw6Kk=;
  b=hENevFAQf8nJJ6vwyADuZAa5Mh1Wqm3bzcZeFuKXVEE+MuZk46E1nXyu
   cY/bHXcDGdB6Kf2ofKLK3TFsh9OnCm6zcaoSXZayhTm0575F1nj4ee1FX
   709WPYIWL+gSpjTXW5eOrnbyCrC0zXopGYiF+TxiRuEUBWHEXRx/IYwqO
   xjjWy2d6kY+3RMAW8Ogy2EnUsrmsQWOyM2LkVtl1wAvIETaEDO6annXlZ
   PSzAYUtf6auqVOYglmeNyPlNDkkY0Jz0M4ozFJTP5oHwlr12RP+eclqtg
   7bpRpke+cCQtScUTtuGGMtdE+NV8mBjFDqjAUhnQjneWR6ceON+KXAhIL
   Q==;
X-CSE-ConnectionGUID: f51dDY+kQKy9atOFe/H4jA==
X-CSE-MsgGUID: 7LGrIbi3Sg2NVjbPg7yK9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="99563856"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="99563856"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 07:56:34 -0700
X-CSE-ConnectionGUID: NFt3wrsXQPKq6hWDp/kCeg==
X-CSE-MsgGUID: gLqp2eh/TBizXqUAxt8SBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="224219446"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 09 Mar 2026 07:56:30 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzc20-000000002sv-0s97;
	Mon, 09 Mar 2026 14:56:28 +0000
Date: Mon, 9 Mar 2026 15:55:54 +0100
From: kernel test robot <lkp@intel.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
Message-ID: <202603091555.ZRQIMCqJ-lkp@intel.com>
References: <20260309102625.2315725-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309102625.2315725-3-aneesh.kumar@kernel.org>

Hi Aneesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on tip/irq/core arm/for-next arm/fixes kvmarm/next soc/for-next linus/master v7.0-rc3 next-20260306]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Aneesh-Kumar-K-V-Arm/dma-direct-swiotlb-handle-swiotlb-alloc-free-outside-__dma_direct_alloc_pages/20260309-182834
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20260309102625.2315725-3-aneesh.kumar%40kernel.org
patch subject: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size alignment for shared buffers
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260309/202603091555.ZRQIMCqJ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603091555.ZRQIMCqJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603091555.ZRQIMCqJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/processor-flags.h:6,
                    from arch/x86/include/asm/irqflags.h:5,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/swait.h:7,
                    from include/linux/completion.h:12,
                    from include/linux/crypto.h:15,
                    from arch/x86/kernel/asm-offsets.c:9:
   include/linux/mem_encrypt.h: In function 'mem_decrypt_granule_size':
>> include/linux/mem_encrypt.h:60:16: error: 'PAGE_SIZE' undeclared (first use in this function)
      60 |         return PAGE_SIZE;
         |                ^~~~~~~~~
   include/linux/mem_encrypt.h:60:16: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/mem_encrypt.h: In function 'mem_decrypt_align':
>> include/linux/mem_encrypt.h:66:16: error: implicit declaration of function 'ALIGN' [-Wimplicit-function-declaration]
      66 |         return ALIGN(size, mem_decrypt_granule_size());
         |                ^~~~~
   make[3]: *** [scripts/Makefile.build:184: arch/x86/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1333: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/PAGE_SIZE +60 include/linux/mem_encrypt.h

    56	
    57	#ifndef mem_decrypt_granule_size
    58	static inline size_t mem_decrypt_granule_size(void)
    59	{
  > 60		return PAGE_SIZE;
    61	}
    62	#endif
    63	
    64	static inline size_t mem_decrypt_align(size_t size)
    65	{
  > 66		return ALIGN(size, mem_decrypt_granule_size());
    67	}
    68	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
