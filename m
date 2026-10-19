Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AB4B923E;
	Mon, 19 Oct 2026 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414484; cv=none; b=MmgdnhrzW2nDkpKUOYDMtDaAFSM14cA2wn5k7kVUV1A9ew08SnhAki+dxpN7Udlegd7kGxzLI/Tz65pQL7LSTkKUVJ6Yn6ZC5f1LTRl0xK7d4JJ8vhIyX/hEjgeq5Pi8neeO9a/LKUYgcNFRlK33fb6Vcw0LS+vQbVU4WWA7a9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414484; c=relaxed/simple;
	bh=lG8ba8f3XvMZ016RxZR1uTEgZGmbv/N4GGCyJVqPUXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sG0UuE4mkHGEpQqInnZAZ6IgKe8MwEAMRAqF1AyuTOG3NOxQN7oqTWTKi4kr43pNzvb9bdq8tgoK+7nH+g0uwUcp/uIRSIUgmwOzebntCNbSPtM9+iCa5b6fFKofV66PFsdN8BAplPHJYvCmx4QtlXhNv7QrLJvbrQjaKTqAhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Tw5QL/pZ; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Tw5QL/pZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792414488; x=1823950488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lG8ba8f3XvMZ016RxZR1uTEgZGmbv/N4GGCyJVqPUXg=;
  b=Tw5QL/pZ20tk9BQT1nNGhI6mrrTYb1vfZkMylF3Gv9Gwb9jrAdCDi45S
   bAA6MwVwTV4F9FWbyBzz9sAgxk1g6x1mP/3OzO0OgEB/OxIBHVwJYUGlX
   vcpvUeLxRQ8vaI4le/5n6qKUUx5eqQKO3dEIHUyWdBRuBfooeqGzdcNmw
   VzSTHygkoZsa1wjEr8/3xaYIG7zRLIoV1NQh5zz50gjZ/tCpLDn5x5ENw
   /L33dBfpxSIRM3yn35yr0Vg6LNqGZ5jVcAIxrzep8umSJZW9PNMnsY2EY
   5UN/J+KimyGiJOw3PIrdLNapKGZ1qSrsIzDsdwkCoT6970Ggv2zMD7dO3
   w==;
X-CSE-ConnectionGUID: CH/9T8XmQBu3VWq370i0ZQ==
X-CSE-MsgGUID: Hsac6XJjSP2uuEsfIVOX6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="258703255"
X-IronPort-AV: E=Sophos;i="6.27,167,1786978800"; 
   d="scan'208";a="258703255"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 21:53:36 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 24C201C000CE;
	Mon, 19 Oct 2026 12:53:30 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id C70211000862;
	Mon, 19 Oct 2026 12:53:29 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.51.148])
	by az2nlsmom4.fujitsu.com (Postfix) with SMTP id 9EDCE2000233;
	Mon, 19 Oct 2026 12:53:21 +0000 (UTC)
Date: Mon, 19 Oct 2026 21:53:20 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: kernel test robot <lkp@intel.com>
Cc: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 erratum E#030003
Message-ID: <atYOKfirjR1VqBZ3@FCCLS0092175.localdomain>
References: <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
 <202610171939.VWCcPPra-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202610171939.VWCcPPra-lkp@intel.com>

On 10/17 19:48, kernel test robot wrote:
> Hi Tomohiro,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Tomohiro-Misono/arm64-cputype-Add-FUJITSU-MONAKA-definition/20261016-190045
> base:   24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> patch link:    https://lore.kernel.org/r/20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48%40fujitsu.com
> patch subject: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA erratum E#030003
> config: arm-defconfig (https://download.01.org/0day-ci/archive/20261017/202610171939.VWCcPPra-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 6719b9e31d6a93099612c474eec76d9f41d0275a)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261017/202610171939.VWCcPPra-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610171939.VWCcPPra-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/irqchip/irq-gic-v3.c:1892:34: error: use of undeclared identifier 'ARM_CPU_IMP_FUJITSU'
>     1892 |         if (read_cpuid_implementor() != ARM_CPU_IMP_FUJITSU ||
>          |                                         ^~~~~~~~~~~~~~~~~~~
> >> drivers/irqchip/irq-gic-v3.c:1893:34: error: use of undeclared identifier 'FUJITSU_CPU_PART_MONAKA'
>     1893 |             read_cpuid_part_number() != FUJITSU_CPU_PART_MONAKA)
>          |                                         ^~~~~~~~~~~~~~~~~~~~~~~
>    2 errors generated.

Oops, I missed testing this with CONFIG_ARM=y. I will fix this in v3.
