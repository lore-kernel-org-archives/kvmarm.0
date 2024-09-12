Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DCC1A4E7E;
	Thu, 12 Sep 2024 12:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145765; cv=none; b=HWiW56Ro2ufRpDFkNd2GtrOcBV59w/eDBTQNltWsjQzRBbYYDFUgHLecHb8NnSEwVBRu6tuf8rb7aGPnakzbJTpc92UEy9vXrx+w5cF21vetGkOh6vvdobU0GhGT09iS9Wdwfyo/9bpCMqJKCGAwQW18iEjqTpm/llRn0Vx3jnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145765; c=relaxed/simple;
	bh=Kwfo5f4An26AmCCZDlCBlZrnHosspVuY37bnCcQFc5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XK1U1JRguI/QpajRKmCBudkOPO5e+kAtk6h2d8K6g6Vwt5wK8aEKfkPaAyYbHWA4+BD1CNEZMplIgLnj7M0ZjJ7NQ4PGi559dBEN778VM4o3hyQZrnM6D6gP04ULahrrwkiAxo/28y+KeAJyI52UTFBF/hkRY0YB/2MDo1u/aGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fkziWmnI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkziWmnI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726145763; x=1757681763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Kwfo5f4An26AmCCZDlCBlZrnHosspVuY37bnCcQFc5Y=;
  b=fkziWmnIbSG/CdwF2xn9WzCetAaEhd0s85pq8Gu8f5hi4qz6awN9yFUT
   2cXXoVeDibLm6Ez5OrRAFxpD+8UBsWTywvdsT6KP2jhOKmfAO3jKt5Q8w
   1X4FamQd9Eu6Q4mMOfMGeYQzoo4a4TXA8FUGvoc3NgQ6KXracCpOu5g1L
   UTYLgSocU8YlFj1yKsK4iYCvy+jPxNjGEi70SyZ2WozqkbGve2in6KeWy
   SZZln70A13k6sW5ZsA2X8hQpzk+xz0BHQcNddC/bK2omrmuW6Cjs6m6iO
   cyVd8f5VqePtT0uvDwpAdfMxcqjniTtJSLEo+RqxogKuiG6E4PRSyRDES
   Q==;
X-CSE-ConnectionGUID: 54QsaxFlTE6WK19VlmARFQ==
X-CSE-MsgGUID: ot/k1Ga3S9qB47+qGU697w==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="47506300"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="47506300"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 05:56:02 -0700
X-CSE-ConnectionGUID: O2EXwjEFSl++EYE3cXl0Jg==
X-CSE-MsgGUID: Lyp3om2ARXKnunbmFvc1aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="98523054"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 12 Sep 2024 05:56:00 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sojMb-0005B3-0z;
	Thu, 12 Sep 2024 12:55:57 +0000
Date: Thu, 12 Sep 2024 20:55:24 +0800
From: kernel test robot <lkp@intel.com>
To: Vincent Donnefort <vdonnefort@google.com>, rostedt@goodmis.org,
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 02/13] ring-buffer: Introducing ring-buffer writer
Message-ID: <202409122021.A3dHcn9b-lkp@intel.com>
References: <20240911093029.3279154-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911093029.3279154-3-vdonnefort@google.com>

Hi Vincent,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8d8d276ba2fb5f9ac4984f5c10ae60858090babc]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincent-Donnefort/ring-buffer-Check-for-empty-ring-buffer-with-rb_num_of_entries/20240911-173526
base:   8d8d276ba2fb5f9ac4984f5c10ae60858090babc
patch link:    https://lore.kernel.org/r/20240911093029.3279154-3-vdonnefort%40google.com
patch subject: [PATCH 02/13] ring-buffer: Introducing ring-buffer writer
config: x86_64-buildonly-randconfig-005-20240912 (https://download.01.org/0day-ci/archive/20240912/202409122021.A3dHcn9b-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240912/202409122021.A3dHcn9b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409122021.A3dHcn9b-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/trace/ring_buffer.c:1755: warning: Function parameter or struct member 'writer' not described in '__ring_buffer_alloc'


vim +1755 kernel/trace/ring_buffer.c

7a8e76a3829f10 Steven Rostedt              2008-09-29  1740  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1741  /**
d611851b421731 zhangwei(Jovi               2013-07-15  1742)  * __ring_buffer_alloc - allocate a new ring_buffer
68814b58c52077 Robert Richter              2008-11-24  1743   * @size: the size in bytes per cpu that is needed.
7a8e76a3829f10 Steven Rostedt              2008-09-29  1744   * @flags: attributes to set for the ring buffer.
59e7cffe5cca6f Fabian Frederick            2014-06-05  1745   * @key: ring buffer reader_lock_key.
7a8e76a3829f10 Steven Rostedt              2008-09-29  1746   *
7a8e76a3829f10 Steven Rostedt              2008-09-29  1747   * Currently the only flag that is available is the RB_FL_OVERWRITE
7a8e76a3829f10 Steven Rostedt              2008-09-29  1748   * flag. This flag means that the buffer will overwrite old data
7a8e76a3829f10 Steven Rostedt              2008-09-29  1749   * when the buffer wraps. If this flag is not set, the buffer will
7a8e76a3829f10 Steven Rostedt              2008-09-29  1750   * drop data when the tail hits the head.
7a8e76a3829f10 Steven Rostedt              2008-09-29  1751   */
13292494379f92 Steven Rostedt (VMware      2019-12-13  1752) struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1753  					struct lock_class_key *key,
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1754  					struct ring_buffer_writer *writer)
7a8e76a3829f10 Steven Rostedt              2008-09-29 @1755  {
13292494379f92 Steven Rostedt (VMware      2019-12-13  1756) 	struct trace_buffer *buffer;
9b94a8fba501f3 Steven Rostedt (Red Hat     2016-05-12  1757) 	long nr_pages;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1758  	int bsize;
9b94a8fba501f3 Steven Rostedt (Red Hat     2016-05-12  1759) 	int cpu;
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1760  	int ret;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1761  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1762  	/* keep it in its own cache line */
7a8e76a3829f10 Steven Rostedt              2008-09-29  1763  	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
7a8e76a3829f10 Steven Rostedt              2008-09-29  1764  			 GFP_KERNEL);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1765  	if (!buffer)
7a8e76a3829f10 Steven Rostedt              2008-09-29  1766  		return NULL;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1767  
b18cc3de00ec34 Sebastian Andrzej Siewior   2016-12-07  1768  	if (!zalloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
9e01c1b74c9531 Rusty Russell               2009-01-01  1769  		goto fail_free_buffer;
9e01c1b74c9531 Rusty Russell               2009-01-01  1770  
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1771) 	/* Default buffer page size - one system page */
f9b94daa542a8d Tzvetomir Stoyanov (VMware  2023-12-19  1772) 	buffer->subbuf_order = 0;
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1773) 	buffer->subbuf_size = PAGE_SIZE - BUF_PAGE_HDR_SIZE;
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1774) 
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1775) 	/* Max payload is buffer page size - header (8bytes) */
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1776) 	buffer->max_data_size = buffer->subbuf_size - (sizeof(u32) * 2);
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1777) 
139f84002145d8 Tzvetomir Stoyanov (VMware  2023-12-19  1778) 	nr_pages = DIV_ROUND_UP(size, buffer->subbuf_size);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1779  	buffer->flags = flags;
37886f6a9f62d2 Steven Rostedt              2009-03-17  1780  	buffer->clock = trace_clock_local;
1f8a6a10fb9437 Peter Zijlstra              2009-06-08  1781  	buffer->reader_lock_key = key;
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1782  	if (writer) {
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1783  		buffer->writer = writer;
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1784  		/* The writer is external and never done by the kernel */
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1785  		atomic_inc(&buffer->record_disabled);
5f3fc4f452e3d3 Vincent Donnefort           2024-09-11  1786  	}
7a8e76a3829f10 Steven Rostedt              2008-09-29  1787  
15693458c4bc06 Steven Rostedt (Red Hat     2013-02-28  1788) 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
f1dc6725882b5c Steven Rostedt (Red Hat     2013-03-04  1789) 	init_waitqueue_head(&buffer->irq_work.waiters);
15693458c4bc06 Steven Rostedt (Red Hat     2013-02-28  1790) 
7a8e76a3829f10 Steven Rostedt              2008-09-29  1791  	/* need at least two pages */
438ced1720b584 Vaibhav Nagarnaik           2012-02-02  1792  	if (nr_pages < 2)
438ced1720b584 Vaibhav Nagarnaik           2012-02-02  1793  		nr_pages = 2;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1794  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1795  	buffer->cpus = nr_cpu_ids;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1796  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1797  	bsize = sizeof(void *) * nr_cpu_ids;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1798  	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
7a8e76a3829f10 Steven Rostedt              2008-09-29  1799  				  GFP_KERNEL);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1800  	if (!buffer->buffers)
9e01c1b74c9531 Rusty Russell               2009-01-01  1801  		goto fail_free_cpumask;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1802  
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1803  	cpu = raw_smp_processor_id();
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1804  	cpumask_set_cpu(cpu, buffer->cpumask);
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1805  	buffer->buffers[cpu] = rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1806  	if (!buffer->buffers[cpu])
7a8e76a3829f10 Steven Rostedt              2008-09-29  1807  		goto fail_free_buffers;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1808  
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1809  	ret = cpuhp_state_add_instance(CPUHP_TRACE_RB_PREPARE, &buffer->node);
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1810  	if (ret < 0)
b32614c03413f8 Sebastian Andrzej Siewior   2016-11-27  1811  		goto fail_free_buffers;
554f786e284a6c Steven Rostedt              2009-03-11  1812  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1813  	mutex_init(&buffer->mutex);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1814  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1815  	return buffer;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1816  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1817   fail_free_buffers:
7a8e76a3829f10 Steven Rostedt              2008-09-29  1818  	for_each_buffer_cpu(buffer, cpu) {
7a8e76a3829f10 Steven Rostedt              2008-09-29  1819  		if (buffer->buffers[cpu])
7a8e76a3829f10 Steven Rostedt              2008-09-29  1820  			rb_free_cpu_buffer(buffer->buffers[cpu]);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1821  	}
7a8e76a3829f10 Steven Rostedt              2008-09-29  1822  	kfree(buffer->buffers);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1823  
9e01c1b74c9531 Rusty Russell               2009-01-01  1824   fail_free_cpumask:
9e01c1b74c9531 Rusty Russell               2009-01-01  1825  	free_cpumask_var(buffer->cpumask);
9e01c1b74c9531 Rusty Russell               2009-01-01  1826  
7a8e76a3829f10 Steven Rostedt              2008-09-29  1827   fail_free_buffer:
7a8e76a3829f10 Steven Rostedt              2008-09-29  1828  	kfree(buffer);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1829  	return NULL;
7a8e76a3829f10 Steven Rostedt              2008-09-29  1830  }
1f8a6a10fb9437 Peter Zijlstra              2009-06-08  1831  EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
7a8e76a3829f10 Steven Rostedt              2008-09-29  1832  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
