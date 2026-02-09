Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8BD26B973;
	Mon,  9 Feb 2026 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770677108; cv=none; b=auABRRqgaqDrZKJpShbzoZWVcr3sxmhwMaekR00AiQukXEJGnPcKq7jDzUGzJNjcBqrUEwb/By0JGPli4QFnlVJZu1T84oT7I3REgzhfVSM/lm6+6vz7nPVoQpDPxZQIWR/TwyU72a4hmBR3KsJ4yfi51hcCLsgYDZdw/g51WhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770677108; c=relaxed/simple;
	bh=tkWj3JgcbeYlPLHKSXUowNE5MSQz4gAoqclO6I2NS5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMLudTdQxgwyFiUXsMIraEbaHcGPDOTl8YKh6DIJ4yexNBePdsduUWdaw+ALwiIesPytVsfS2GZGqNE+Tim2kjICuJovJHDpYYwI1Hu0LSEvkHwmWS2tj6eY8QCW41MatakB63GZUn+pKlTSBhVklI+BcFAQBPAceCeeTBIUjM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KJRRYhMN; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJRRYhMN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770677107; x=1802213107;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tkWj3JgcbeYlPLHKSXUowNE5MSQz4gAoqclO6I2NS5M=;
  b=KJRRYhMNGeV0qAXrGw94pYyU6Fv79+FluMXaCxQi+LqHiGge/dEQWfvS
   GSJ6d9Rn654NfywmHNgjeuvk8m9AXu+YG2oZXzMncLzFnVwqotdjXHkrS
   Ro+ECXdWui67nHEe5VEGh/vLPhebAcqm8edY4sxJFEteul6KfNaG3Hckq
   kYkz2I4nTts3U980Uc+uthWe8j3W7WOBOE3EX26CCnKD8WxRnyJJwc3vx
   nGXvSzDI0j5BzupjUZeFLITfeF+aAH4TzpQEiDSPhAr4D5lbbPEtu8N2E
   ThWpyoMI/ocRb5FhO3LicG/U+TTpONHZMsd+EmVCPG4bTLH5r+dNnC0RS
   A==;
X-CSE-ConnectionGUID: l9AEN938Q2WiwEpPRoulMw==
X-CSE-MsgGUID: rb9CjGaKRJeScLixmSasEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="89213177"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="89213177"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 14:45:06 -0800
X-CSE-ConnectionGUID: hD8YfJwIQVewqJzeCu1T2w==
X-CSE-MsgGUID: 0pEVhVq7QsGfJlBgGcnrwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211031702"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 09 Feb 2026 14:45:01 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpa03-00000000oNk-1EMJ;
	Mon, 09 Feb 2026 22:44:59 +0000
Date: Tue, 10 Feb 2026 06:44:17 +0800
From: kernel test robot <lkp@intel.com>
To: kyle-jk.liao@mediatek.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wsd_upstream@mediatek.com, rock.yeh@mediatek.com,
	hungwen.chien@mediatek.com,
	"kyle-jk.liao" <kyle-jk.liao@mediatek.com>
Subject: Re: [PATCH] KVM: arm64: Allow module-owned pages in host stage-2
 range adjustment
Message-ID: <202602100627.0HOjIqkT-lkp@intel.com>
References: <20260209032421.1278325-1-kyle-jk.liao@mediatek.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209032421.1278325-1-kyle-jk.liao@mediatek.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvmarm/next]
[also build test ERROR on linus/master v6.19 next-20260209]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/kyle-jk-liao-mediatek-com/KVM-arm64-Allow-module-owned-pages-in-host-stage-2-range-adjustment/20260209-112902
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
patch link:    https://lore.kernel.org/r/20260209032421.1278325-1-kyle-jk.liao%40mediatek.com
patch subject: [PATCH] KVM: arm64: Allow module-owned pages in host stage-2 range adjustment
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260210/202602100627.0HOjIqkT-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100627.0HOjIqkT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602100627.0HOjIqkT-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/hyp/nvhe/mem_protect.c:513:53: error: use of undeclared identifier 'PKVM_MODULE_OWNED_PAGE'
     513 |                         (state != PKVM_NOPAGE && state != (PKVM_NOPAGE | PKVM_MODULE_OWNED_PAGE)));
         |                                                                          ^
   1 error generated.


vim +/PKVM_MODULE_OWNED_PAGE +513 arch/arm64/kvm/hyp/nvhe/mem_protect.c

   492	
   493	static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
   494	{
   495		struct kvm_mem_range cur;
   496		kvm_pte_t pte;
   497		u64 granule;
   498		s8 level;
   499		int ret;
   500		enum pkvm_page_state state;
   501	
   502		hyp_assert_lock_held(&host_mmu.lock);
   503		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level);
   504		if (ret)
   505			return ret;
   506	
   507		if (kvm_pte_valid(pte))
   508			return -EAGAIN;
   509	
   510		if (pte) {
   511			state = get_host_state(hyp_phys_to_page(addr));
   512			WARN_ON(addr_is_memory(addr) &&
 > 513				(state != PKVM_NOPAGE && state != (PKVM_NOPAGE | PKVM_MODULE_OWNED_PAGE)));
   514			return -EPERM;
   515		}
   516	
   517		for (; level <= KVM_PGTABLE_LAST_LEVEL; level++) {
   518			if (!kvm_level_supports_block_mapping(level))
   519				continue;
   520			granule = kvm_granule_size(level);
   521			cur.start = ALIGN_DOWN(addr, granule);
   522			cur.end = cur.start + granule;
   523			if (!range_included(&cur, range))
   524				continue;
   525			*range = cur;
   526			return 0;
   527		}
   528	
   529		WARN_ON(1);
   530	
   531		return -EINVAL;
   532	}
   533	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
