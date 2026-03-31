Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4BA402BB3;
	Tue, 31 Mar 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970210; cv=none; b=aAmn4LcOvNpcutMmb0gRT0g2+4RQObx0gK7bdYhlGjwFFoHDqdf8Pa5tN49zgTsB3abLg2aptcCjYLzNGOUxO3E4ocTHozfqpQGSMoLyog0ynZpGGnfCppTloKxcrbG596F6Id5vHrofXYw+L7joUxFSWjk31bcxHZ9xhHgx3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970210; c=relaxed/simple;
	bh=tyOix1UW3bb2O6tgpfvkqzC+tRZ6dSt6wxdQRR75WR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFl/XehMy7fXQWLxDGgtQyNn/4uOHLcQxXTFqaKo+mQ4O/32MmmekTaOidnMZMK9z6IAb+t4dIFWt/vsbgoSCcEGavKxbBVQJ60n5iJeY7IhI4xbASzTgmSEeXG0bEcXomu8LElBRsaj1VYexWR7+7D+vBluiKvRihsvRb5ah3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJ2infEu; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJ2infEu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774970209; x=1806506209;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tyOix1UW3bb2O6tgpfvkqzC+tRZ6dSt6wxdQRR75WR8=;
  b=NJ2infEuJYbES9zPb99Qmr9viDs2YD+Jo7ZmS9hlzmkzc+yiOqtkvybw
   aPi1cmSddA/ojYzVgqgc4P7FTl2MK1BWAb81hpLemEcVJaQexDQRzTomJ
   2w3WhgyGWP5kUOg7n0UA8ZOSY6NL91BfYradOZ0rhgRKJhVPNyWUXE+Vc
   ofxkWvpG53p8AdhpqUZb1KdsjpTzbddS4yPWx6cXD+QDdojM+URu5NiUg
   J2/ccKUetkCYXWEbxjyN3P8oEwOSl1bCRUenLYVwIHwbPTg4JwsE1DeGO
   QCN2UhSrYSuNclupnDhR2pnEmPjr/ELLc//ZwgytYarzZYMO8vm7YeLUp
   Q==;
X-CSE-ConnectionGUID: UkiVaLwDQfyTgYicJz+hlw==
X-CSE-MsgGUID: MpfV+6JMTzSd/Un4YG7NWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="63539404"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="63539404"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 08:16:47 -0700
X-CSE-ConnectionGUID: IiYkO5c1S5KBcqP7V6n9nw==
X-CSE-MsgGUID: RKElrtYSTEGWS3sFojImjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="223091921"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 31 Mar 2026 08:16:43 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7apd-000000002nl-2ATg;
	Tue, 31 Mar 2026 15:16:41 +0000
Date: Tue, 31 Mar 2026 23:16:15 +0800
From: kernel test robot <lkp@intel.com>
To: Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <202603312322.Bli3MO76-lkp@intel.com>
References: <20260330100633.2817076-2-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330100633.2817076-2-weilin.chang@arm.com>

Hi Wei-Lin,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260327]
[cannot apply to kvmarm/next arm64/for-next/core arm/for-next arm/fixes soc/for-next v7.0-rc6 v7.0-rc5 v7.0-rc4 linus/master v7.0-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Lin-Chang/KVM-arm64-nv-Avoid-full-shadow-s2-unmap/20260330-230122
base:   next-20260327
patch link:    https://lore.kernel.org/r/20260330100633.2817076-2-weilin.chang%40arm.com
patch subject: [PATCH 1/4] KVM: arm64: nv: Avoid full shadow s2 unmap
config: arm64-randconfig-002-20260331 (https://download.01.org/0day-ci/archive/20260331/202603312322.Bli3MO76-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603312322.Bli3MO76-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603312322.Bli3MO76-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/nested.c:792:2: error: member reference type 'rwlock_t' (aka 'struct rwlock') is not a pointer; did you mean to use '.'?
     792 |         lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:291:22: note: expanded from macro 'lockdep_assert_held_write'
     291 |         do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_lock(l); } while (0)
         |              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:253:64: note: expanded from macro 'lockdep_is_held_type'
     253 | #define lockdep_is_held_type(lock, r)   lock_is_held_type(&(lock)->dep_map, (r))
         |                                                                  ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
>> arch/arm64/kvm/nested.c:792:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
     792 |         lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:291:22: note: expanded from macro 'lockdep_assert_held_write'
     291 |         do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_lock(l); } while (0)
         |              ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:253:57: note: expanded from macro 'lockdep_is_held_type'
     253 | #define lockdep_is_held_type(lock, r)   lock_is_held_type(&(lock)->dep_map, (r))
         |                                                           ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   2 errors generated.


vim +792 arch/arm64/kvm/nested.c

   782	
   783	int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
   784				     gpa_t fault_ipa, size_t map_size)
   785	{
   786		struct maple_tree *mt = &mmu->nested_revmap_mt;
   787		gpa_t start = ipa;
   788		gpa_t end = ipa + map_size - 1;
   789		u64 entry, new_entry = 0;
   790		int r = 0;
   791	
 > 792		lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
   793	
   794		MA_STATE(mas, mt, start, end);
   795		entry = (u64)mas_find_range(&mas, end);
   796	
   797		if (entry) {
   798			/* maybe just a perm update... */
   799			if (!(entry & UNKNOWN_IPA) && mas.index == start &&
   800			    mas.last == end &&
   801			    fault_ipa == (entry & NESTED_IPA_MASK))
   802				goto out;
   803			/*
   804			 * Remove every overlapping range, then create a "polluted"
   805			 * range that spans all these ranges and store it.
   806			 */
   807			while (entry && mas.index <= end) {
   808				start = min(mas.index, start);
   809				end = max(mas.last, end);
   810				mas_erase(&mas);
   811				entry = (u64)mas_find_range(&mas, end);
   812			}
   813			new_entry |= UNKNOWN_IPA;
   814		} else {
   815			new_entry |= fault_ipa;
   816		}
   817	
   818		mas_set_range(&mas, start, end);
   819		r = mas_store_gfp(&mas, (void *)new_entry, GFP_KERNEL_ACCOUNT);
   820	out:
   821		return r;
   822	}
   823	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
