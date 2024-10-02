Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C6919E99E;
	Wed,  2 Oct 2024 23:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727911612; cv=none; b=RDy8KrZB59AweZ/faCppk9MFchspmlOps9Y2UhSbKrESzkRfojcbYzCAvIlWQ7efIhqrmcJ2NMYrketKPXtp50zUDW/rXCZ5ZgQwWNKMN6WvZhlfK6hSYPlCve+qV/ncqp2w+dFCGBLfBcvQPC647oLC+QtKw8NXutvIBjF/wS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727911612; c=relaxed/simple;
	bh=MOddhoRdVUNlZ6rFQAiTxa6MCDC1OsTEaQH/tMohL3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upwHFmkuQTfJYUBhzNCXdpkyvKO6A29KtjLGP7zX0IN60wEF1AyFEuWH5YPWIeqAGgihSC5rZy9TesOpLP++aFDCuhMZkhAtvxgGqz2vWgW//jVhAh1239Bjk8kbp7SkbVuats0RmmKXKcH+s7rFxvqHDP0qYQy2K3HtlxnTdHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XtNIDTmS; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XtNIDTmS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727911610; x=1759447610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MOddhoRdVUNlZ6rFQAiTxa6MCDC1OsTEaQH/tMohL3g=;
  b=XtNIDTmSRdYOLZf+5X7EYvgTm1bYzK6O7lSKxpC4VTNbVWIOj+7qRpFp
   wL79HXZmHMdTBnE9oVBnM+53lhvXeG+P/XIzYgoFyWPfzrFMqfc59BMqL
   dBj+v/mj2751nu2VnnnKWLeuq7yJ0hW+2gVEwTlc7g15uIYi490XomDSb
   SiJX6+YD4IVoF9HsOw0uVfaAbuJGfE0tZFvnKEKEgOdghEHEztbKWwAE3
   ZRD5wOfG93KzoWsek3JPcg4E7CmWxH+EEvzREo1fHDjNeV9cdLAfvU3Bf
   GF4DdXMqf1QUpQRnHQCiu101UdvzLTC6SFpWugeceZNTkeLzu+D/IW4I3
   g==;
X-CSE-ConnectionGUID: i1nrcdkwT7G41IQzwAjKBQ==
X-CSE-MsgGUID: ZINJl+IRQyiW9YImjXdmBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11213"; a="29967245"
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="29967245"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 16:26:47 -0700
X-CSE-ConnectionGUID: PP/MMty1QC2Zciupl7lINQ==
X-CSE-MsgGUID: XZzzxy2nTnOY4iLOwmrNaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="74158157"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 02 Oct 2024 16:26:44 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sw8jw-000UgV-35;
	Wed, 02 Oct 2024 23:26:40 +0000
Date: Thu, 3 Oct 2024 07:25:57 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <202410030702.9xBCVi6s-lkp@intel.com>
References: <20241001043602.1116991-3-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001043602.1116991-3-anshuman.khandual@arm.com>

Hi Anshuman,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on kvmarm/next soc/for-next arm/for-next arm/fixes linus/master v6.12-rc1 next-20241002]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/arm64-cpufeature-Add-field-details-for-ID_AA64DFR1_EL1-register/20241001-123752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20241001043602.1116991-3-anshuman.khandual%40arm.com
patch subject: [PATCH 2/3] arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
config: arm64-randconfig-002-20241003 (https://download.01.org/0day-ci/archive/20241003/202410030702.9xBCVi6s-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241003/202410030702.9xBCVi6s-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410030702.9xBCVi6s-lkp@intel.com/

All errors (new ones prefixed by >>):

>> <instantiation>:3:10: error: expected compatible register, symbol or integer in range [0, 4095]
    cmp x1, #ID_AA64MMFR0_EL1_FGT_FGT2
            ^
   <instantiation>:12:2: note: while in macro instantiation
    __init_el2_fgt2
    ^
   arch/arm64/kernel/head.S:317:2: note: while in macro instantiation
    init_el2_state
    ^
>> <instantiation>:1:5: error: expected absolute expression
   .if (((HDFGWTR2_EL2_nMDSELR_EL1) >> 31) == 0 || ((HDFGWTR2_EL2_nMDSELR_EL1) >> 31) == 0x1ffffffff)
       ^
   <instantiation>:11:2: note: while in macro instantiation
    mov_q x0, HDFGWTR2_EL2_nMDSELR_EL1
    ^
   <instantiation>:12:2: note: while in macro instantiation
    __init_el2_fgt2
    ^
   arch/arm64/kernel/head.S:317:2: note: while in macro instantiation
    init_el2_state
    ^
   <instantiation>:4:6: error: expected absolute expression
    .if (((HDFGWTR2_EL2_nMDSELR_EL1) >> 47) == 0 || ((HDFGWTR2_EL2_nMDSELR_EL1) >> 47) == 0x1ffff)
        ^
   <instantiation>:11:2: note: while in macro instantiation
    mov_q x0, HDFGWTR2_EL2_nMDSELR_EL1
    ^
   <instantiation>:12:2: note: while in macro instantiation
    __init_el2_fgt2
    ^
   arch/arm64/kernel/head.S:317:2: note: while in macro instantiation
    init_el2_state
    ^
>> <instantiation>:1:6: error: expected constant expression
   .inst(0xd5000000|(SYS_HDFGWTR2_EL2)|(.L__gpr_num_x0))
        ^
   <instantiation>:12:2: note: while in macro instantiation
    msr_s SYS_HDFGWTR2_EL2, x0
    ^
   <instantiation>:12:2: note: while in macro instantiation
    __init_el2_fgt2
    ^
   arch/arm64/kernel/head.S:317:2: note: while in macro instantiation
    init_el2_state
    ^
>> <instantiation>:1:6: error: expected constant expression
   .inst(0xd5000000|(SYS_HDFGRTR2_EL2)|(.L__gpr_num_x0))
        ^
   <instantiation>:13:2: note: while in macro instantiation
    msr_s SYS_HDFGRTR2_EL2, x0
    ^
   <instantiation>:12:2: note: while in macro instantiation
    __init_el2_fgt2
    ^
   arch/arm64/kernel/head.S:317:2: note: while in macro instantiation
    init_el2_state
    ^

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
