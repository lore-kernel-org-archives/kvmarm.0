Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7E313C80C;
	Thu,  9 Jan 2025 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736441143; cv=none; b=t9GTsVxPOPPtBdUqGFFKxOWtIqTskS3seWA2NbqgA+FMZ2NYev1AQxuEYcZCu2R4S1CWVEZBtsvGAvFqqEDimOoaQkew/r8SY9+pEkACmVFM4Nk0L2LXF91JdFV/Vt/WE0Bm0b94O1YstqU6SARwv0qburv9OACBeEzTI/t3O/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736441143; c=relaxed/simple;
	bh=dthvaoFmVx6ekANWfNCrbEN7/AW4ltSxGAfXIHK7Mao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jC7m+8g4Y73JEfk5HS7dIt6eLPHB4yrpkZ450YSzjCK908FgtYVPIlU1ZZIv9EWZoGHFbxGhUCODQ//drqvxYmFrMtiSQg4a/c7JAn+lxxJg2wiyivMXkdkC1ih4p/A0/DUgjmktIC0lgIg5C1TWsLlKj5Y+vcvAVbP12feqcrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nnT6kB7l; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nnT6kB7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736441142; x=1767977142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dthvaoFmVx6ekANWfNCrbEN7/AW4ltSxGAfXIHK7Mao=;
  b=nnT6kB7l6RlK3laClk74UvMlV6u7CtKUtabpBox6tsDndrhH9rDJmLfF
   aiZos2DKLW5i9NKtaZEb//2fnaHqkzEeADJd+bJ6TtBER+f1KNFR6xMbU
   TuTLqEZ2bbhA4N3OwdnMCL4jg0uWlMuIEr6XOTyoZcy6uYCueuLQ6Ia+B
   GunfO0VNmM1cC9R0TXilWRyuk4d3MI7LeKlL8OMtP9EAnPt0l650p5+2X
   /CIkKeMY2MOM+vMIQrOjWbXpmhBUsceCaRL+IY6XseH1VjAMAquJCq1yH
   MX4YXRPmrnjxRGtpLW3+D6Xnijnhiym1Drh4IgIwsonWlsQlkXBXvnalA
   Q==;
X-CSE-ConnectionGUID: pOqtSRE2R/OU7J+XwmXZEQ==
X-CSE-MsgGUID: FPFF5lGsQ7O1Mb1Kz0cj1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="54259038"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="54259038"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 08:45:41 -0800
X-CSE-ConnectionGUID: vM2BVWakT9eb+szAJCcFHg==
X-CSE-MsgGUID: fnYt+aC4RcSjiy9r1+zr/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103983305"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 09 Jan 2025 08:45:36 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVvf3-000Hsl-1X;
	Thu, 09 Jan 2025 16:45:33 +0000
Date: Fri, 10 Jan 2025 00:45:19 +0800
From: kernel test robot <lkp@intel.com>
To: Vincent Donnefort <vdonnefort@google.com>, rostedt@goodmis.org,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Cc: oe-kbuild-all@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v2 02/12] ring-buffer: Introducing ring-buffer remote
Message-ID: <202501100025.WNnMyW13-lkp@intel.com>
References: <20250108114536.627715-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108114536.627715-3-vdonnefort@google.com>

Hi Vincent,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 09a0fa92e5b45e99cf435b2fbf5ebcf889cf8780]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincent-Donnefort/ring-buffer-Check-for-empty-ring-buffer-with-rb_num_of_entries/20250108-200217
base:   09a0fa92e5b45e99cf435b2fbf5ebcf889cf8780
patch link:    https://lore.kernel.org/r/20250108114536.627715-3-vdonnefort%40google.com
patch subject: [PATCH v2 02/12] ring-buffer: Introducing ring-buffer remote
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20250110/202501100025.WNnMyW13-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250110/202501100025.WNnMyW13-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501100025.WNnMyW13-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/trace/ring_buffer.c:2535: warning: Function parameter or struct member 'remote' not described in '__ring_buffer_alloc_remote'
>> kernel/trace/ring_buffer.c:2535: warning: Function parameter or struct member 'key' not described in '__ring_buffer_alloc_remote'


vim +2535 kernel/trace/ring_buffer.c

  2528	
  2529	/**
  2530	 * __ring_buffer_alloc_remote
  2531	 *
  2532	 */
  2533	struct trace_buffer *__ring_buffer_alloc_remote(struct ring_buffer_remote *remote,
  2534							struct lock_class_key *key)
> 2535	{
  2536		return alloc_buffer(0, 0, 0, 0, 0, key, remote);
  2537	}
  2538	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
