Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AEC134A8;
	Wed, 16 Oct 2024 06:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729059607; cv=none; b=AYIp1RogcEHssEvXtjgVnOKHj9Rsg/Gg9iLC4p9cofwWed42Kq18P8PzYGagEVVBqgFFny2hgRuoygJfTOZ+MrVOaQIrYcTysRW9Z6xxYNvK3G5owOXPkHHYmWvP/B+bVh4HTt49TTZ/erKwou/8+QF+QMmZYtQ6JisI/Z8MBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729059607; c=relaxed/simple;
	bh=UDviM85gugcFWZ004QD0bpeKL+QfyPkNPeUDuyYM0P0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPp3RjI83OKl1/nQPtL5fMrh2i51kQGI0uhPCCrWQBlYtE2+j5rcqJiX9pJ9F9EDYhIg0jOXIX1cuptrA9hhRLpt8srLE/9vca/w4kEQkEe39MhHviFePQ9Sd5osPysq5Rce6G0CX95YbdvdKuue2SerjnM6m2Apf92oRFCQJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNJaxHqw; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNJaxHqw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729059605; x=1760595605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UDviM85gugcFWZ004QD0bpeKL+QfyPkNPeUDuyYM0P0=;
  b=UNJaxHqwjRF+l9haX3xqa2vuI2uoDwiVhUQNUlbZH/Huamcz5oszObDE
   J9Bw+9bgRbETAahuyFfAMcaDVHZDt8nz97t5pHkmiPoSYgeEhcfroVIRN
   G6zHmUBA+SEjKgs6OolponfjcQfcDv9c0i58UbP0KrXQEW8AXI6V6H+o5
   UViaAvxVbLwbxDkHWIbkQG8pE2AT4a8WxQxBjU43jXzuX5H9PrnY4KI54
   eUGOdDYbq+UrjI7Bf+fIUU882Tude3zpfqfdnUoscLpFOLuyUKdyyUB9p
   gXvlRrvFkz0r4fzlYl+LfFSvyUMmRtDHw0lvZxLAQl6zzlBdPd+lO7yCm
   w==;
X-CSE-ConnectionGUID: 8/4rsFQAT1ih5m364lrl0Q==
X-CSE-MsgGUID: H/HUQeyFTNmvDceGeJ1DmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="31359183"
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="31359183"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 23:20:05 -0700
X-CSE-ConnectionGUID: OCzLxIuGQuyqnLyrE39M8A==
X-CSE-MsgGUID: ky/CMyjIRruvQPXMJkjH7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="78295488"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 15 Oct 2024 23:20:01 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t0xO2-000KRR-0P;
	Wed, 16 Oct 2024 06:19:58 +0000
Date: Wed, 16 Oct 2024 14:19:06 +0800
From: kernel test robot <lkp@intel.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH] KVM: arm64: nVHE: gen-hyprel: Silent build warnings
Message-ID: <202410161313.tSgr3bAj-lkp@intel.com>
References: <20241009085751.35976-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009085751.35976-1-tianjia.zhang@linux.alibaba.com>

Hi Tianjia,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvmarm/next]
[also build test WARNING on linus/master v6.12-rc3 next-20241015]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianjia-Zhang/KVM-arm64-nVHE-gen-hyprel-Silent-build-warnings/20241009-170027
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
patch link:    https://lore.kernel.org/r/20241009085751.35976-1-tianjia.zhang%40linux.alibaba.com
patch subject: [PATCH] KVM: arm64: nVHE: gen-hyprel: Silent build warnings
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20241016/202410161313.tSgr3bAj-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241016/202410161313.tSgr3bAj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410161313.tSgr3bAj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c: In function 'section_by_off':
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type 'Elf64_Off' {aka 'long unsigned int'} [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:193:41: note: in expansion of macro 'assert_op'
     193 | #define assert_ne(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, !=)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:233:9: note: in expansion of macro 'assert_ne'
     233 |         assert_ne(off, 0ULL, "%llu");
         |         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c: In function 'init_elf':
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type '__off_t' {aka 'long int'} [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:195:41: note: in expansion of macro 'assert_op'
     195 | #define assert_ge(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, >=)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:9: note: in expansion of macro 'assert_ge'
     279 |         assert_ge(stat.st_size, (off_t)sizeof(*elf.ehdr), "%llu");
         |         ^~~~~~~~~
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 5 has type 'long int' [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:195:41: note: in expansion of macro 'assert_op'
     195 | #define assert_ge(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, >=)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:9: note: in expansion of macro 'assert_ge'
     279 |         assert_ge(stat.st_size, (off_t)sizeof(*elf.ehdr), "%llu");
         |         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c: In function 'emit_rela_abs64':
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:343:59: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 5 has type '__uint64_t' {aka 'long unsigned int'} [-Wformat=]
     343 |         printf(".reloc %lu, R_AARCH64_PREL32, %s%s + 0x%llx\n",
         |                                                        ~~~^
         |                                                           |
         |                                                           long long unsigned int
         |                                                        %lx
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c: In function 'emit_rela_section':
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type '__uint64_t' {aka 'long unsigned int'} [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:194:41: note: in expansion of macro 'assert_op'
     194 | #define assert_lt(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, <)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:379:17: note: in expansion of macro 'assert_lt'
     379 |                 assert_lt(elf64toh(rela->r_offset), elf64toh(sh_orig->sh_size), "0x%llx");
         |                 ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 5 has type '__uint64_t' {aka 'long unsigned int'} [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:194:41: note: in expansion of macro 'assert_op'
     194 | #define assert_lt(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, <)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:379:17: note: in expansion of macro 'assert_lt'
     379 |                 assert_lt(elf64toh(rela->r_offset), elf64toh(sh_orig->sh_size), "0x%llx");
         |                 ^~~~~~~~~


vim +166 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c

bc93763f178fd0 Marc Zyngier  2021-01-30  163  
8c49b5d43d4c45 David Brazdil 2021-01-05  164  #define fatal_error(fmt, ...)						\
8c49b5d43d4c45 David Brazdil 2021-01-05  165  	({								\
8c49b5d43d4c45 David Brazdil 2021-01-05 @166  		fprintf(stderr, "error: %s: " fmt "\n",			\
8c49b5d43d4c45 David Brazdil 2021-01-05  167  			elf.path, ## __VA_ARGS__);			\
8c49b5d43d4c45 David Brazdil 2021-01-05  168  		exit(EXIT_FAILURE);					\
8c49b5d43d4c45 David Brazdil 2021-01-05  169  		__builtin_unreachable();				\
8c49b5d43d4c45 David Brazdil 2021-01-05  170  	})
8c49b5d43d4c45 David Brazdil 2021-01-05  171  
8c49b5d43d4c45 David Brazdil 2021-01-05  172  #define fatal_perror(msg)						\
8c49b5d43d4c45 David Brazdil 2021-01-05  173  	({								\
8c49b5d43d4c45 David Brazdil 2021-01-05  174  		fprintf(stderr, "error: %s: " msg ": %s\n",		\
8c49b5d43d4c45 David Brazdil 2021-01-05  175  			elf.path, strerror(errno));			\
8c49b5d43d4c45 David Brazdil 2021-01-05  176  		exit(EXIT_FAILURE);					\
8c49b5d43d4c45 David Brazdil 2021-01-05  177  		__builtin_unreachable();				\
8c49b5d43d4c45 David Brazdil 2021-01-05  178  	})
8c49b5d43d4c45 David Brazdil 2021-01-05  179  
8c49b5d43d4c45 David Brazdil 2021-01-05  180  #define assert_op(lhs, rhs, fmt, op)					\
8c49b5d43d4c45 David Brazdil 2021-01-05  181  	({								\
8c49b5d43d4c45 David Brazdil 2021-01-05  182  		typeof(lhs) _lhs = (lhs);				\
8c49b5d43d4c45 David Brazdil 2021-01-05  183  		typeof(rhs) _rhs = (rhs);				\
8c49b5d43d4c45 David Brazdil 2021-01-05  184  									\
8c49b5d43d4c45 David Brazdil 2021-01-05  185  		if (!(_lhs op _rhs)) {					\
8c49b5d43d4c45 David Brazdil 2021-01-05 @186  			fatal_error("assertion " #lhs " " #op " " #rhs	\
8c49b5d43d4c45 David Brazdil 2021-01-05  187  				" failed (lhs=" fmt ", rhs=" fmt	\
8c49b5d43d4c45 David Brazdil 2021-01-05  188  				", line=%d)", _lhs, _rhs, __LINE__);	\
8c49b5d43d4c45 David Brazdil 2021-01-05  189  		}							\
8c49b5d43d4c45 David Brazdil 2021-01-05  190  	})
8c49b5d43d4c45 David Brazdil 2021-01-05  191  
8c49b5d43d4c45 David Brazdil 2021-01-05  192  #define assert_eq(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, ==)
8c49b5d43d4c45 David Brazdil 2021-01-05 @193  #define assert_ne(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, !=)
8c49b5d43d4c45 David Brazdil 2021-01-05  194  #define assert_lt(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, <)
8c49b5d43d4c45 David Brazdil 2021-01-05 @195  #define assert_ge(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, >=)
8c49b5d43d4c45 David Brazdil 2021-01-05  196  
8c49b5d43d4c45 David Brazdil 2021-01-05  197  /*
8c49b5d43d4c45 David Brazdil 2021-01-05  198   * Return a pointer of a given type at a given offset from
8c49b5d43d4c45 David Brazdil 2021-01-05  199   * the beginning of the ELF file.
8c49b5d43d4c45 David Brazdil 2021-01-05  200   */
8c49b5d43d4c45 David Brazdil 2021-01-05  201  #define elf_ptr(type, off) ((type *)(elf.begin + (off)))
8c49b5d43d4c45 David Brazdil 2021-01-05  202  
8c49b5d43d4c45 David Brazdil 2021-01-05  203  /* Iterate over all sections in the ELF. */
8c49b5d43d4c45 David Brazdil 2021-01-05  204  #define for_each_section(var) \
bc93763f178fd0 Marc Zyngier  2021-01-30  205  	for (var = elf.sh_table; var < elf.sh_table + elf16toh(elf.ehdr->e_shnum); ++var)
8c49b5d43d4c45 David Brazdil 2021-01-05  206  
8c49b5d43d4c45 David Brazdil 2021-01-05  207  /* Iterate over all Elf64_Rela relocations in a given section. */
8c49b5d43d4c45 David Brazdil 2021-01-05  208  #define for_each_rela(shdr, var)					\
bc93763f178fd0 Marc Zyngier  2021-01-30  209  	for (var = elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset));	\
bc93763f178fd0 Marc Zyngier  2021-01-30  210  	     var < elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset) + elf64toh(shdr->sh_size)); var++)
8c49b5d43d4c45 David Brazdil 2021-01-05  211  
8c49b5d43d4c45 David Brazdil 2021-01-05  212  /* True if a string starts with a given prefix. */
8c49b5d43d4c45 David Brazdil 2021-01-05  213  static inline bool starts_with(const char *str, const char *prefix)
8c49b5d43d4c45 David Brazdil 2021-01-05  214  {
8c49b5d43d4c45 David Brazdil 2021-01-05  215  	return memcmp(str, prefix, strlen(prefix)) == 0;
8c49b5d43d4c45 David Brazdil 2021-01-05  216  }
8c49b5d43d4c45 David Brazdil 2021-01-05  217  
8c49b5d43d4c45 David Brazdil 2021-01-05  218  /* Returns a string containing the name of a given section. */
8c49b5d43d4c45 David Brazdil 2021-01-05  219  static inline const char *section_name(Elf64_Shdr *shdr)
8c49b5d43d4c45 David Brazdil 2021-01-05  220  {
bc93763f178fd0 Marc Zyngier  2021-01-30  221  	return elf.sh_string + elf32toh(shdr->sh_name);
8c49b5d43d4c45 David Brazdil 2021-01-05  222  }
8c49b5d43d4c45 David Brazdil 2021-01-05  223  
8c49b5d43d4c45 David Brazdil 2021-01-05  224  /* Returns a pointer to the first byte of section data. */
8c49b5d43d4c45 David Brazdil 2021-01-05  225  static inline const char *section_begin(Elf64_Shdr *shdr)
8c49b5d43d4c45 David Brazdil 2021-01-05  226  {
bc93763f178fd0 Marc Zyngier  2021-01-30  227  	return elf_ptr(char, elf64toh(shdr->sh_offset));
8c49b5d43d4c45 David Brazdil 2021-01-05  228  }
8c49b5d43d4c45 David Brazdil 2021-01-05  229  
8c49b5d43d4c45 David Brazdil 2021-01-05  230  /* Find a section by its offset from the beginning of the file. */
8c49b5d43d4c45 David Brazdil 2021-01-05  231  static inline Elf64_Shdr *section_by_off(Elf64_Off off)
8c49b5d43d4c45 David Brazdil 2021-01-05  232  {
83de54b4bb92bc Tianjia Zhang 2024-10-09  233  	assert_ne(off, 0ULL, "%llu");
8c49b5d43d4c45 David Brazdil 2021-01-05  234  	return elf_ptr(Elf64_Shdr, off);
8c49b5d43d4c45 David Brazdil 2021-01-05  235  }
8c49b5d43d4c45 David Brazdil 2021-01-05  236  
8c49b5d43d4c45 David Brazdil 2021-01-05  237  /* Find a section by its index. */
8c49b5d43d4c45 David Brazdil 2021-01-05  238  static inline Elf64_Shdr *section_by_idx(uint16_t idx)
8c49b5d43d4c45 David Brazdil 2021-01-05  239  {
8c49b5d43d4c45 David Brazdil 2021-01-05  240  	assert_ne(idx, SHN_UNDEF, "%u");
8c49b5d43d4c45 David Brazdil 2021-01-05  241  	return &elf.sh_table[idx];
8c49b5d43d4c45 David Brazdil 2021-01-05  242  }
8c49b5d43d4c45 David Brazdil 2021-01-05  243  
8c49b5d43d4c45 David Brazdil 2021-01-05  244  /*
8c49b5d43d4c45 David Brazdil 2021-01-05  245   * Memory-map the given ELF file, perform sanity checks, and
8c49b5d43d4c45 David Brazdil 2021-01-05  246   * populate global state.
8c49b5d43d4c45 David Brazdil 2021-01-05  247   */
8c49b5d43d4c45 David Brazdil 2021-01-05  248  static void init_elf(const char *path)
8c49b5d43d4c45 David Brazdil 2021-01-05  249  {
8c49b5d43d4c45 David Brazdil 2021-01-05  250  	int fd, ret;
8c49b5d43d4c45 David Brazdil 2021-01-05  251  	struct stat stat;
8c49b5d43d4c45 David Brazdil 2021-01-05  252  
8c49b5d43d4c45 David Brazdil 2021-01-05  253  	/* Store path in the global struct for error printing. */
8c49b5d43d4c45 David Brazdil 2021-01-05  254  	elf.path = path;
8c49b5d43d4c45 David Brazdil 2021-01-05  255  
8c49b5d43d4c45 David Brazdil 2021-01-05  256  	/* Open the ELF file. */
8c49b5d43d4c45 David Brazdil 2021-01-05  257  	fd = open(path, O_RDONLY);
8c49b5d43d4c45 David Brazdil 2021-01-05  258  	if (fd < 0)
8c49b5d43d4c45 David Brazdil 2021-01-05  259  		fatal_perror("Could not open ELF file");
8c49b5d43d4c45 David Brazdil 2021-01-05  260  
8c49b5d43d4c45 David Brazdil 2021-01-05  261  	/* Get status of ELF file to obtain its size. */
8c49b5d43d4c45 David Brazdil 2021-01-05  262  	ret = fstat(fd, &stat);
8c49b5d43d4c45 David Brazdil 2021-01-05  263  	if (ret < 0) {
8c49b5d43d4c45 David Brazdil 2021-01-05  264  		close(fd);
8c49b5d43d4c45 David Brazdil 2021-01-05  265  		fatal_perror("Could not get status of ELF file");
8c49b5d43d4c45 David Brazdil 2021-01-05  266  	}
8c49b5d43d4c45 David Brazdil 2021-01-05  267  
8c49b5d43d4c45 David Brazdil 2021-01-05  268  	/* mmap() the entire ELF file read-only at an arbitrary address. */
8c49b5d43d4c45 David Brazdil 2021-01-05  269  	elf.begin = mmap(0, stat.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
8c49b5d43d4c45 David Brazdil 2021-01-05  270  	if (elf.begin == MAP_FAILED) {
8c49b5d43d4c45 David Brazdil 2021-01-05  271  		close(fd);
8c49b5d43d4c45 David Brazdil 2021-01-05  272  		fatal_perror("Could not mmap ELF file");
8c49b5d43d4c45 David Brazdil 2021-01-05  273  	}
8c49b5d43d4c45 David Brazdil 2021-01-05  274  
8c49b5d43d4c45 David Brazdil 2021-01-05  275  	/* mmap() was successful, close the FD. */
8c49b5d43d4c45 David Brazdil 2021-01-05  276  	close(fd);
8c49b5d43d4c45 David Brazdil 2021-01-05  277  
8c49b5d43d4c45 David Brazdil 2021-01-05  278  	/* Get pointer to the ELF header. */
83de54b4bb92bc Tianjia Zhang 2024-10-09  279  	assert_ge(stat.st_size, (off_t)sizeof(*elf.ehdr), "%llu");
8c49b5d43d4c45 David Brazdil 2021-01-05  280  	elf.ehdr = elf_ptr(Elf64_Ehdr, 0);
8c49b5d43d4c45 David Brazdil 2021-01-05  281  
8c49b5d43d4c45 David Brazdil 2021-01-05  282  	/* Check the ELF magic. */
8c49b5d43d4c45 David Brazdil 2021-01-05  283  	assert_eq(elf.ehdr->e_ident[EI_MAG0], ELFMAG0, "0x%x");
8c49b5d43d4c45 David Brazdil 2021-01-05  284  	assert_eq(elf.ehdr->e_ident[EI_MAG1], ELFMAG1, "0x%x");
8c49b5d43d4c45 David Brazdil 2021-01-05  285  	assert_eq(elf.ehdr->e_ident[EI_MAG2], ELFMAG2, "0x%x");
8c49b5d43d4c45 David Brazdil 2021-01-05  286  	assert_eq(elf.ehdr->e_ident[EI_MAG3], ELFMAG3, "0x%x");
8c49b5d43d4c45 David Brazdil 2021-01-05  287  
8c49b5d43d4c45 David Brazdil 2021-01-05  288  	/* Sanity check that this is an ELF64 relocatable object for AArch64. */
8c49b5d43d4c45 David Brazdil 2021-01-05  289  	assert_eq(elf.ehdr->e_ident[EI_CLASS], ELFCLASS64, "%u");
bc93763f178fd0 Marc Zyngier  2021-01-30  290  	assert_eq(elf.ehdr->e_ident[EI_DATA], ELFENDIAN, "%u");
bc93763f178fd0 Marc Zyngier  2021-01-30  291  	assert_eq(elf16toh(elf.ehdr->e_type), ET_REL, "%u");
bc93763f178fd0 Marc Zyngier  2021-01-30  292  	assert_eq(elf16toh(elf.ehdr->e_machine), EM_AARCH64, "%u");
8c49b5d43d4c45 David Brazdil 2021-01-05  293  
8c49b5d43d4c45 David Brazdil 2021-01-05  294  	/* Populate fields of the global struct. */
bc93763f178fd0 Marc Zyngier  2021-01-30  295  	elf.sh_table = section_by_off(elf64toh(elf.ehdr->e_shoff));
bc93763f178fd0 Marc Zyngier  2021-01-30  296  	elf.sh_string = section_begin(section_by_idx(elf16toh(elf.ehdr->e_shstrndx)));
8c49b5d43d4c45 David Brazdil 2021-01-05  297  }
8c49b5d43d4c45 David Brazdil 2021-01-05  298  
8c49b5d43d4c45 David Brazdil 2021-01-05  299  /* Print the prologue of the output ASM file. */
8c49b5d43d4c45 David Brazdil 2021-01-05  300  static void emit_prologue(void)
8c49b5d43d4c45 David Brazdil 2021-01-05  301  {
8c49b5d43d4c45 David Brazdil 2021-01-05  302  	printf(".data\n"
8c49b5d43d4c45 David Brazdil 2021-01-05  303  	       ".pushsection " HYP_RELOC_SECTION ", \"a\"\n");
8c49b5d43d4c45 David Brazdil 2021-01-05  304  }
8c49b5d43d4c45 David Brazdil 2021-01-05  305  
8c49b5d43d4c45 David Brazdil 2021-01-05  306  /* Print ASM statements needed as a prologue to a processed hyp section. */
8c49b5d43d4c45 David Brazdil 2021-01-05  307  static void emit_section_prologue(const char *sh_orig_name)
8c49b5d43d4c45 David Brazdil 2021-01-05  308  {
8c49b5d43d4c45 David Brazdil 2021-01-05  309  	/* Declare the hyp section symbol. */
8c49b5d43d4c45 David Brazdil 2021-01-05  310  	printf(".global %s%s\n", HYP_SECTION_SYMBOL_PREFIX, sh_orig_name);
8c49b5d43d4c45 David Brazdil 2021-01-05  311  }
8c49b5d43d4c45 David Brazdil 2021-01-05  312  
8c49b5d43d4c45 David Brazdil 2021-01-05  313  /*
8c49b5d43d4c45 David Brazdil 2021-01-05  314   * Print ASM statements to create a hyp relocation entry for a given
8c49b5d43d4c45 David Brazdil 2021-01-05  315   * R_AARCH64_ABS64 relocation.
8c49b5d43d4c45 David Brazdil 2021-01-05  316   *
8c49b5d43d4c45 David Brazdil 2021-01-05  317   * The linker of vmlinux will populate the position given by `rela` with
8c49b5d43d4c45 David Brazdil 2021-01-05  318   * an absolute 64-bit kernel VA. If the kernel is relocatable, it will
8c49b5d43d4c45 David Brazdil 2021-01-05  319   * also generate a dynamic relocation entry so that the kernel can shift
8c49b5d43d4c45 David Brazdil 2021-01-05  320   * the address at runtime for KASLR.
8c49b5d43d4c45 David Brazdil 2021-01-05  321   *
8c49b5d43d4c45 David Brazdil 2021-01-05  322   * Emit a 32-bit offset from the current address to the position given
8c49b5d43d4c45 David Brazdil 2021-01-05  323   * by `rela`. This way the kernel can iterate over all kernel VAs used
8c49b5d43d4c45 David Brazdil 2021-01-05  324   * by hyp at runtime and convert them to hyp VAs. However, that offset
8c49b5d43d4c45 David Brazdil 2021-01-05  325   * will not be known until linking of `vmlinux`, so emit a PREL32
8c49b5d43d4c45 David Brazdil 2021-01-05  326   * relocation referencing a symbol that the hyp linker script put at
8c49b5d43d4c45 David Brazdil 2021-01-05  327   * the beginning of the relocated section + the offset from `rela`.
8c49b5d43d4c45 David Brazdil 2021-01-05  328   */
8c49b5d43d4c45 David Brazdil 2021-01-05  329  static void emit_rela_abs64(Elf64_Rela *rela, const char *sh_orig_name)
8c49b5d43d4c45 David Brazdil 2021-01-05  330  {
8c49b5d43d4c45 David Brazdil 2021-01-05  331  	/* Offset of this reloc from the beginning of HYP_RELOC_SECTION. */
8c49b5d43d4c45 David Brazdil 2021-01-05  332  	static size_t reloc_offset;
8c49b5d43d4c45 David Brazdil 2021-01-05  333  
8c49b5d43d4c45 David Brazdil 2021-01-05  334  	/* Create storage for the 32-bit offset. */
8c49b5d43d4c45 David Brazdil 2021-01-05  335  	printf(".word 0\n");
8c49b5d43d4c45 David Brazdil 2021-01-05  336  
8c49b5d43d4c45 David Brazdil 2021-01-05  337  	/*
8c49b5d43d4c45 David Brazdil 2021-01-05  338  	 * Create a PREL32 relocation which instructs the linker of `vmlinux`
8c49b5d43d4c45 David Brazdil 2021-01-05  339  	 * to insert offset to position <base> + <offset>, where <base> is
8c49b5d43d4c45 David Brazdil 2021-01-05  340  	 * a symbol at the beginning of the relocated section, and <offset>
8c49b5d43d4c45 David Brazdil 2021-01-05  341  	 * is `rela->r_offset`.
8c49b5d43d4c45 David Brazdil 2021-01-05  342  	 */
83de54b4bb92bc Tianjia Zhang 2024-10-09 @343  	printf(".reloc %lu, R_AARCH64_PREL32, %s%s + 0x%llx\n",
8c49b5d43d4c45 David Brazdil 2021-01-05  344  	       reloc_offset, HYP_SECTION_SYMBOL_PREFIX, sh_orig_name,
bc93763f178fd0 Marc Zyngier  2021-01-30  345  	       elf64toh(rela->r_offset));
8c49b5d43d4c45 David Brazdil 2021-01-05  346  
8c49b5d43d4c45 David Brazdil 2021-01-05  347  	reloc_offset += 4;
8c49b5d43d4c45 David Brazdil 2021-01-05  348  }
8c49b5d43d4c45 David Brazdil 2021-01-05  349  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
