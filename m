Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE833DEAC0;
	Mon,  9 Mar 2026 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071144; cv=none; b=UQzEA9lj8jEudBxhNIQjJ8kId/YcE8vV8ECdjgW7bWHFO9lpFVFRcMaqZkLt/eYLeDr3od5Q/r9arRp+i4l4OuB6G260eppfZWFQ3THAfRl+kXWroF69gCvB7L3I3L88eHQpaozZEJFmvOWbEUFm60hD63qf+yOEv0tvcXU/wAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071144; c=relaxed/simple;
	bh=C0IERCaiDhJjwjRH+GzcWKFQytEH7/GbdqP3ydZUU+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNyZaeyp2Ja/v35CVXhafjepuzxBYK/VOixjp9fRob7aM0UEkDcFZu7feWAMzqtAPslZx0nP5Y1APpUGOF4DFQ7w/rfJJ8Fy350sDTFAUNEz+22O8A1tFeTJylJN5+hciI6vEbluud6AVjkGwbxVF7N0fDARmdjGemsbEwDUglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QEcYXTsH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QEcYXTsH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773071143; x=1804607143;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C0IERCaiDhJjwjRH+GzcWKFQytEH7/GbdqP3ydZUU+A=;
  b=QEcYXTsHO7Boq50iJL40p5U5SwriMpwOFTqicBK4xIMinpSs5UBvaEjR
   buqXfQvlCXZgxl352B9bfZzgUpxN6KkyHSpw6xopDNYBS0d58PPtJWkV1
   2EbMUXYCmvs3IK/YpsylAwGbL3wyHaOE106aQABu5LuU7SBTrTnySTrDR
   KLk2PHfrGZKv9hMgd454/k6Okoi8ftNXxWkAWnuj1PvN/ayWUN66LNXEv
   8AO6kWW1CS0qrAYiV6yHqN0V4nI+c+AeZGfdcvWoALFIBOcVYPSf2W11q
   ++T7ybMfbbZP/jf6X9gB81OV29JAQxJzx9yJL59QgNEP7az6PlkfeQrQN
   w==;
X-CSE-ConnectionGUID: RaXwO4JaRkCitwiOpNEV7A==
X-CSE-MsgGUID: PvZz6k0DQJSkw6SClNdtQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="84425145"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="84425145"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:45:40 -0700
X-CSE-ConnectionGUID: C4FrXierQmyhlsz5uk+0cA==
X-CSE-MsgGUID: xknhvzjeTO2fAxTcp1vAPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="218939086"
Received: from lkp-server01.sh.intel.com (HELO 434e41ea3c86) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 09 Mar 2026 08:45:36 -0700
Received: from kbuild by 434e41ea3c86 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzcnV-000000000Ry-19GY;
	Mon, 09 Mar 2026 15:45:33 +0000
Date: Mon, 9 Mar 2026 23:44:48 +0800
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
Message-ID: <202603092323.myqT3tXw-lkp@intel.com>
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
config: i386-randconfig-013-20260309 (https://download.01.org/0day-ci/archive/20260309/202603092323.myqT3tXw-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603092323.myqT3tXw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603092323.myqT3tXw-lkp@intel.com/

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
   make[3]: *** [scripts/Makefile.build:184: arch/x86/kernel/asm-offsets.s] Error 1 shuffle=4157930943
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1333: prepare0] Error 2 shuffle=4157930943
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=4157930943
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=4157930943
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
