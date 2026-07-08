Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B89175A7E
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783475582; cv=none; b=bWSoOGMkvqnc708u4Y9WdQWwlWjnGSLGa6k82d08sAi5le7mjTHQ5LC3+nyoxDofMnBwKYtabrXOlJoCsQI8ach1QhSIGGrmJq4twDdAwjqYDpijmaIO3WOkTZxehZQGX9djmn4zholCVtAI3LriYTzQMSCOAMGqY99/9cnEvtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783475582; c=relaxed/simple;
	bh=swkmBcA/vlpg2LoQPpVjWmEVZxRFBZpAvJtJOAFB7cg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ftbKPVO38VahsV5ki+PGXslktnuCYUKW/v9B/Q5xzKI8QkdiYRzcRNUubQ++uvaU6t13D6V0DT9EaYJ/Z8gJxPJkKUzXLsNFUtCvwNLuK0M9wfPlln8PVeQcgaaQREZjiz5/5k16qum+yLF3otUGF/8uiq9Yf48ErBUEWyR3GJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTBjGKYs; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTBjGKYs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783475581; x=1815011581;
  h=date:from:to:cc:subject:message-id;
  bh=swkmBcA/vlpg2LoQPpVjWmEVZxRFBZpAvJtJOAFB7cg=;
  b=YTBjGKYs4yK+KOv4ItBe6WvAiAu+rC5QW2XHaUYTyB8eQBEhgfjpEp0a
   xPpGkHiVQWP+wPKwm236+FUkwKvwAa6kKOQSkIEYoij53H1pzM5jrE9eE
   NTCE1yxGa/DZHIduiv9JUsI7RQU9ZTSqK1gdDTW0ewRWHOXqhJEKF+CHs
   byRnNdTPtL0F12xmxYmXrUbHIsY0f2U20nP3RAwJGjOXYW6uvMnlWDSSr
   fQ/xyH/cMJeJ5T7qo/jHKWKr9R0HwJXseWbV/jve5F60O9Pa3rn7MbdA6
   Im07QEixz3HDXRjoIRrzJK7hLk04T42cgOtwZ6bXYVcJP/ZHnmkp2mqte
   w==;
X-CSE-ConnectionGUID: 5gWctxCZQKWD4YVJWioYiw==
X-CSE-MsgGUID: Pve5khUAS+ufp+rnNny0fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="84190028"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84190028"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 18:53:00 -0700
X-CSE-ConnectionGUID: /JeXpta9SF2HQalxBWRsYQ==
X-CSE-MsgGUID: VuQwhgVJQtaRMRf9b49bcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="258462221"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 07 Jul 2026 18:52:58 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whHT4-00000000Ftb-1v0U;
	Wed, 08 Jul 2026 01:52:54 +0000
Date: Wed, 08 Jul 2026 09:52:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 bpf@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 5c73cd9f0819c1c44e373e3dabb68318b1de1a12
Message-ID: <202607080951.rMUtVX8X-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5c73cd9f0819c1c44e373e3dabb68318b1de1a12  Add linux-next specific files for 20260707

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607080254.6qrH5NrH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202607080650.sMl0aR2a-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202607080709.kE9W2GbI-lkp@intel.com

    arch/arm64/kvm/hyp/pgtable.c:1359:13: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 2147483647 to -1 [-Wconstant-conversion]
    include/vdso/limits.h:8:25: warning: overflow in conversion from 'int' to 's8' {aka 'signed char'} changes value from '2147483647' to '-1' [-Woverflow]
    kernel/bpf/task_iter.c:759:14: warning: variable 'mmput_needed' set but not used [-Wunused-but-set-variable=]
    kernel/bpf/task_iter.c:759:14: warning: variable 'mmput_needed' set but not used [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/mtd/parsers/redboot.c:311:1: internal compiler error: in final_scan_insn_1, at final.c:3073

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   `-- arch-arm64-kvm-hyp-pgtable.c:warning:implicit-conversion-from-int-to-s8-(aka-signed-char-)-changes-value-from-to
|-- arm64-defconfig
|   `-- include-vdso-limits.h:warning:overflow-in-conversion-from-int-to-s8-aka-signed-char-changes-value-from-to
|-- csky-randconfig-r072-20260707
|   `-- drivers-mtd-parsers-redboot.c:internal-compiler-error:in-final_scan_insn_1-at-final.c
|-- m68k-randconfig-r132-20260708
|   `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used
|-- sh-allmodconfig
|   `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used
`-- sh-allyesconfig
    `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used

elapsed time: 734m

configs tested: 279
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              alldefconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-15.2.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260708    gcc-11.5.0
arm                   randconfig-001-20260708    gcc-13.4.0
arm                   randconfig-002-20260708    gcc-10.5.0
arm                   randconfig-002-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-8.5.0
arm                   randconfig-004-20260708    gcc-13.4.0
arm                   randconfig-004-20260708    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260708    clang-23
arm64                 randconfig-001-20260708    gcc-9.5.0
arm64                 randconfig-002-20260708    clang-23
arm64                 randconfig-002-20260708    gcc-9.5.0
arm64                 randconfig-003-20260708    gcc-9.5.0
arm64                 randconfig-004-20260708    gcc-15.2.0
arm64                 randconfig-004-20260708    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260708    gcc-11.5.0
csky                  randconfig-001-20260708    gcc-9.5.0
csky                  randconfig-002-20260708    gcc-9.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260707    clang-23
hexagon               randconfig-002-20260707    clang-18
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260707    clang-22
i386        buildonly-randconfig-001-20260708    clang-22
i386        buildonly-randconfig-002-20260707    clang-22
i386        buildonly-randconfig-002-20260708    clang-22
i386        buildonly-randconfig-003-20260707    clang-22
i386        buildonly-randconfig-003-20260708    clang-22
i386        buildonly-randconfig-004-20260707    gcc-14
i386        buildonly-randconfig-004-20260708    clang-22
i386        buildonly-randconfig-005-20260707    clang-22
i386        buildonly-randconfig-005-20260708    clang-22
i386        buildonly-randconfig-006-20260707    clang-22
i386        buildonly-randconfig-006-20260708    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260708    clang-22
i386                  randconfig-001-20260708    gcc-14
i386                  randconfig-002-20260708    clang-22
i386                  randconfig-002-20260708    gcc-14
i386                  randconfig-003-20260708    clang-22
i386                  randconfig-004-20260708    clang-22
i386                  randconfig-004-20260708    gcc-14
i386                  randconfig-005-20260708    clang-22
i386                  randconfig-006-20260708    clang-22
i386                  randconfig-007-20260708    clang-22
i386                  randconfig-007-20260708    gcc-12
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260707    gcc-14
i386                  randconfig-011-20260708    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260707    gcc-14
i386                  randconfig-012-20260708    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260707    clang-22
i386                  randconfig-013-20260708    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260707    gcc-14
i386                  randconfig-014-20260708    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260707    gcc-14
i386                  randconfig-015-20260708    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260707    gcc-14
i386                  randconfig-016-20260708    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260707    gcc-14
i386                  randconfig-017-20260708    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260707    clang-18
loongarch             randconfig-002-20260707    clang-19
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260707    gcc-11.5.0
nios2                 randconfig-002-20260707    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260707    gcc-15.2.0
parisc                randconfig-001-20260708    clang-22
parisc                randconfig-002-20260707    gcc-9.5.0
parisc                randconfig-002-20260708    clang-22
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260707    clang-23
powerpc               randconfig-001-20260708    clang-22
powerpc               randconfig-002-20260707    gcc-14.3.0
powerpc               randconfig-002-20260708    clang-22
powerpc64             randconfig-001-20260707    gcc-8.5.0
powerpc64             randconfig-001-20260708    clang-22
powerpc64             randconfig-002-20260707    clang-22
powerpc64             randconfig-002-20260708    clang-22
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260708    clang-23
riscv                 randconfig-001-20260708    gcc-8.5.0
riscv                 randconfig-002-20260708    clang-23
riscv                 randconfig-002-20260708    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260708    clang-20
s390                  randconfig-001-20260708    clang-23
s390                  randconfig-002-20260708    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260708    clang-23
sh                    randconfig-001-20260708    gcc-16.1.0
sh                    randconfig-002-20260708    clang-23
sh                    randconfig-002-20260708    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-8.5.0
sparc                 randconfig-002-20260708    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260708    clang-22
sparc64               randconfig-001-20260708    gcc-8.5.0
sparc64               randconfig-002-20260708    clang-20
sparc64               randconfig-002-20260708    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260708    gcc-14
um                    randconfig-001-20260708    gcc-8.5.0
um                    randconfig-002-20260708    clang-23
um                    randconfig-002-20260708    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260708    clang-22
x86_64      buildonly-randconfig-001-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-14
x86_64      buildonly-randconfig-003-20260708    gcc-12
x86_64      buildonly-randconfig-004-20260708    clang-22
x86_64      buildonly-randconfig-004-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-14
x86_64      buildonly-randconfig-006-20260708    clang-22
x86_64      buildonly-randconfig-006-20260708    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260708    gcc-14
x86_64                randconfig-002-20260708    clang-22
x86_64                randconfig-002-20260708    gcc-14
x86_64                randconfig-003-20260708    clang-22
x86_64                randconfig-003-20260708    gcc-14
x86_64                randconfig-004-20260708    clang-22
x86_64                randconfig-004-20260708    gcc-14
x86_64                randconfig-005-20260708    clang-22
x86_64                randconfig-005-20260708    gcc-14
x86_64                randconfig-006-20260708    gcc-14
x86_64                randconfig-011-20260707    clang-22
x86_64                randconfig-011-20260708    clang-22
x86_64                randconfig-012-20260707    gcc-14
x86_64                randconfig-012-20260708    clang-22
x86_64                randconfig-013-20260707    clang-22
x86_64                randconfig-013-20260708    clang-22
x86_64                randconfig-014-20260707    gcc-14
x86_64                randconfig-014-20260708    clang-22
x86_64                randconfig-015-20260707    gcc-14
x86_64                randconfig-015-20260708    clang-22
x86_64                randconfig-016-20260707    clang-22
x86_64                randconfig-016-20260708    clang-22
x86_64                randconfig-071-20260708    clang-22
x86_64                randconfig-072-20260708    clang-22
x86_64                randconfig-073-20260708    clang-22
x86_64                randconfig-074-20260708    clang-22
x86_64                randconfig-074-20260708    gcc-14
x86_64                randconfig-075-20260708    clang-22
x86_64                randconfig-076-20260708    clang-22
x86_64                randconfig-076-20260708    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260708    gcc-14.3.0
xtensa                randconfig-001-20260708    gcc-8.5.0
xtensa                randconfig-002-20260708    gcc-16.1.0
xtensa                randconfig-002-20260708    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
