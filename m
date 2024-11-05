Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BE61FEFA9;
	Tue,  5 Nov 2024 05:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786055; cv=none; b=VTnjL/wudaL8LY+ZAgaXHSsXnohOSYDm6/jkxGlDf1k0wNd7D2P1On9sVdyDQVMy3piTL0Ph7iRYEh5V0fuSLctvFxNciwAyiqVDQ6S1F56q0/B0HVvNvSBTXKNYk6SVe+tpwKdCwOBdMbIQfSjciPFb5UQHgg09leGbt0Mj/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786055; c=relaxed/simple;
	bh=mGA7O6fgfWIf/Pwu4MvEyfLhFnqrGvQTMMOxj9Qazzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3GRqFXXPp5zBNLoYO73Kg9bWuc4H91vi8ZDCWBDYibDvhvFaG7W5Wjss6RmTSZEjqigsnYQHdlqR5JqvYLqOg9YGm8s6eAw9QiDEdMQIGGN2jDpQZ+T2/fCOj9hVkh7QmRwc7zMXZ0433ZqRmcx9FYMKDw+RcKqLyyUzAz3MRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXOxxrgB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXOxxrgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730786052; x=1762322052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mGA7O6fgfWIf/Pwu4MvEyfLhFnqrGvQTMMOxj9Qazzs=;
  b=PXOxxrgBZjCNd1mGUppARyHsnxuQtA1oJNoGw06y47KrWXWO0onv0SiW
   /f6neqaD9ipgjxxJL7sFmqkr7UWkPMCPntKNd2hGY5Nb73we2DHJ52cN5
   NP7dxAVWSjbAOOTyTEvi4kUmZNg6uz89UxlHKBxR88w0EKN37kz2KBDQy
   98R3V3jVociiHHqmOrPSFrAQu3Rx4P6o2iaAH6Lfq5CodsTVf2GBo1/iy
   3RT/2ppGHsU0FqFIkv8K5GHptcek95D8B76tk0vqiVGRi462+eEtC1Mjc
   qd6uBAd4LMMxEp58ImrT9g+zzMnj6PeE2fDIdowiP+3zncpNM0Uq8IMLB
   w==;
X-CSE-ConnectionGUID: e9ZcuuarRHmfn0W3pMa7bw==
X-CSE-MsgGUID: W27+5if4TAWQS6vt3Tta5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41618641"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41618641"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:54:11 -0800
X-CSE-ConnectionGUID: Ud1QZqu5Q7y+3MTYCN7GcA==
X-CSE-MsgGUID: s6QMNsPpSXyaQICF17edmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="88447927"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 04 Nov 2024 21:54:08 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8CVy-000lgf-0o;
	Tue, 05 Nov 2024 05:54:06 +0000
Date: Tue, 5 Nov 2024 13:53:22 +0800
From: kernel test robot <lkp@intel.com>
To: Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
Message-ID: <202411051325.EBkzE0th-lkp@intel.com>
References: <20241104133204.85208-19-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104133204.85208-19-qperret@google.com>

Hi Quentin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.12-rc6]
[also build test WARNING on linus/master]
[cannot apply to kvmarm/next next-20241104]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Quentin-Perret/KVM-arm64-Change-the-layout-of-enum-pkvm_page_state/20241104-213817
base:   v6.12-rc6
patch link:    https://lore.kernel.org/r/20241104133204.85208-19-qperret%40google.com
patch subject: [PATCH 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
config: arm64-randconfig-002-20241105 (https://download.01.org/0day-ci/archive/20241105/202411051325.EBkzE0th-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241105/202411051325.EBkzE0th-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411051325.EBkzE0th-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/kvm/mmu.c:338: warning: Function parameter or struct member 'pgt' not described in 'kvm_s2_unmap'
>> arch/arm64/kvm/mmu.c:338: warning: Function parameter or struct member 'addr' not described in 'kvm_s2_unmap'
>> arch/arm64/kvm/mmu.c:338: warning: expecting prototype for __unmap_stage2_range(). Prototype was for kvm_s2_unmap() instead


vim +338 arch/arm64/kvm/mmu.c

   299	
   300	/*
   301	 * Unmapping vs dcache management:
   302	 *
   303	 * If a guest maps certain memory pages as uncached, all writes will
   304	 * bypass the data cache and go directly to RAM.  However, the CPUs
   305	 * can still speculate reads (not writes) and fill cache lines with
   306	 * data.
   307	 *
   308	 * Those cache lines will be *clean* cache lines though, so a
   309	 * clean+invalidate operation is equivalent to an invalidate
   310	 * operation, because no cache lines are marked dirty.
   311	 *
   312	 * Those clean cache lines could be filled prior to an uncached write
   313	 * by the guest, and the cache coherent IO subsystem would therefore
   314	 * end up writing old data to disk.
   315	 *
   316	 * This is why right after unmapping a page/section and invalidating
   317	 * the corresponding TLBs, we flush to make sure the IO subsystem will
   318	 * never hit in the cache.
   319	 *
   320	 * This is all avoided on systems that have ARM64_HAS_STAGE2_FWB, as
   321	 * we then fully enforce cacheability of RAM, no matter what the guest
   322	 * does.
   323	 */
   324	/**
   325	 * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
   326	 * @mmu:   The KVM stage-2 MMU pointer
   327	 * @start: The intermediate physical base address of the range to unmap
   328	 * @size:  The size of the area to unmap
   329	 * @may_block: Whether or not we are permitted to block
   330	 *
   331	 * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
   332	 * be called while holding mmu_lock (unless for freeing the stage2 pgd before
   333	 * destroying the VM), otherwise another faulting VCPU may come in and mess
   334	 * with things behind our backs.
   335	 */
   336	
   337	static int kvm_s2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 > 338	{
   339		return KVM_PGT_S2(unmap, pgt, addr, size);
   340	}
   341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
