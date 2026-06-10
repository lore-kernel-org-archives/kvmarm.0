Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E52343D86
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 20:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781122911; cv=none; b=n0Fx0wRQdIpUgGbMgBOdz1OFqq7uZxA2MjEiyHyXoE+YBWNSx2G8HxRUEGyReqsRaSU8R90UaiBrVskZ8lDrTJFjX3i/JK2VcjJdmzDnkGtz81MH0DnI9x8KD0jdTCjiQ+9F5Iwy+KY6FqpG5CXRBIEa4678xqJQIrSAEQxlfmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781122911; c=relaxed/simple;
	bh=ERzphoGFlfsnQX/z/pHW9rsKUGoz2XFTjRwpnLKWgsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m9ZeqHtyhpVB5dcqaHxOeyMFYbUckervFP7iyl6UQLvd5ocXCD57PYQw541oTR7jwUn80RcJqm6RPNNgwqg63VZ92/DtdzjQzLe9B4GeTzOjaCTYmzFVoakFR5qROzAzhHGz/F/XrOXTRUNuY04MDz4TeMS/uCw3Mx5wWvyh7Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vYHFnVxp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vYHFnVxp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE665201B;
	Wed, 10 Jun 2026 13:21:43 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BE723FB7F;
	Wed, 10 Jun 2026 13:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781122908; bh=ERzphoGFlfsnQX/z/pHW9rsKUGoz2XFTjRwpnLKWgsw=;
	h=From:To:Cc:Subject:Date:From;
	b=vYHFnVxpf8WOs7yJo6tinH+R+HuLLxCdXavmmnL6ix0VlOsXsxv3muNlro7nJjl54
	 9CHyCQYP8ds9bu1F9z6lnVtzSCtecF7COd2UaGQZQxIG6Dg+jNKhekBFcL0pIbpJAM
	 LQz9qvg1Za4EILjqNMteTsDm3KgrpfD24lPhAmVs=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Optimize S2 page splitting
Date: Wed, 10 Jun 2026 21:21:07 +0100
Message-ID: <20260610202112.2695205-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3772; i=leo.bras@arm.com; h=from:subject; bh=ERzphoGFlfsnQX/z/pHW9rsKUGoz2XFTjRwpnLKWgsw=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLI0j4vKuvdMXPvjnLB/oYVIXofY01yDlblBu/PFU895r WLa8be2o5SFQYyLQVZMkUX20fxVPN+nZBy58mMBzBxWJpAhDFycAjCRenNGhv8TdstP1/Jpsmst Nl555s7p+w2dMfmCBhGWYXFcAo5LfBj+Z0sXR+eyi15hes160GPaikTR5rczQuK3eT6ob1wTvmg PAwA=
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

While playing with dirty-bit tracking, I decided to take a look on how page
splitting works. Found out all entries are walked, even though we can infer,
for instance that:
- If a level-3 entry is walked, it means the parent level-2 entry is split
- If a split just succeeded in an table entry, it means all children nodes
  are already split

This patches' idea is to introduce new walking flags to skip pagetable 
levels 0-3. 

The idea of skipping child nodes was also tested, but it was marginally 
slower than just skipping levels, so it was discarted. 

Optimization measured on two scenarios involving eager-splitting on a
VM with 1 memslot of 64GB:
- Scenario 1: No manual protect, whole memslot split at dirty-track enable
  (KVM_SET_USER_MEMORY_REGION2 ioctl with KVM_MEM_LOG_DIRTY_PAGES)
  - Split happens only once, whole region
  - Evalutes improved batch performance of splitting
- Scenario 2: Manual protect, split happens during every dirty-bit clean
  (KVM_CLEAR_DIRTY_LOG ioctl), average for 2 iterations.
  - Split called multiple times, for smaller 64-page sections.
  - Evaluate improved performance for multiple calls

Scenario 1, improvement on dirty-track enable ioctl for the memslot:
- Memory was already split (4k pages):  -35.47% runtime (stdev 5.63%)
- THP backed memory:                    -11.94% runtime (stdev 2.55%)
- 64x1GB hugetlb memory:                -14.46% runtime (stdev 2.68%)

Scenario 2, improvement on dirty-log clean ioctl for the memslot:
- Memory was already split (4k pages):  -26.36% runtime (stdev 3.32%)
- THP backed memory:                    -12.05% runtime (stdev 0.37%)
- 64x1GB hugetlb memory:                -13.87% runtime (stdev 0.86%)

For collecting above numbers, the following script was ran in both vanilla 
and patched kernels, with kernel parameter 'default_hugepagesz=1G', on an 
AmpereOne with 256GB RAM.

--- dirty_test.sh
#!/bin/bash
filename=$(uname -r |cut -d'-' -f 4-)

run_test(){
  uname -a
  cat /proc/cmdline

  #prepare
  sudo bash -c 'echo 64 > /proc/sys/vm/nr_hugepages'

  ./dirty_log_perf_test -g -b 64G
  ./dirty_log_perf_test -g -b 64G -s anonymous_thp
  ./dirty_log_perf_test -g -b 64G -s shared_hugetlb

  ./dirty_log_perf_test -b 64G
  ./dirty_log_perf_test -b 64G -s anonymous_thp
  ./dirty_log_perf_test -b 64G -s shared_hugetlb
}

run_test 2>&1 | tee ${filename}
---

Above dirty_log_perf_test command is the standard kvm selftest found in the 
kernel tree. It tested the following guest modes:
Testing guest mode: PA-bits:48,  VA-bits:48,  4K pages
Testing guest mode: PA-bits:48,  VA-bits:48, 16K pages
Testing guest mode: PA-bits:48,  VA-bits:48, 64K pages
Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
Testing guest mode: PA-bits:40,  VA-bits:48, 16K pages
Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages

Performance numbers from above modes were used to calculate average and 
stdev showed in the optimization results.

Changes since v1:
- Changed approach from return value to walk flags (Will Deacon)
- Discarted skip_child approach (Oliver Upton)
- Measured in real hardware, and from userspace perspective (Marc Zyngier)
- Better explanation of what and how numbers were collected
v1 Link: https://lore.kernel.org/all/20260515195904.2466381-1-leo.bras@arm.com/

Thanks!
Leo

Leonardo Bras (2):
  KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
  KVM: arm64: Make stage2_split_walker() skip unnecessary walks

 arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 18 ++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)


base-commit: acb7500801e98639f6d8c2d796ed9f64cba83d3a
-- 
2.54.0


