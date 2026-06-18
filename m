Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E4835202A
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788504; cv=none; b=K2sWuDFzl1gr/2++fLCr55Dw7c8oWkgViCVnr1ueY1YrplaPgkZ1TBy2crABKh0t5446TBtaI6M8d3yUc+IoByUUstcTenqwDnFbLnxS9hjjwF5Y2t8EKXQMgr8Etig/0HKPN1EBVHQDa0RcFGiIYBv7e/VhAUVqrximlrYyzGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788504; c=relaxed/simple;
	bh=+MFJqEWiNc1lFUhDg3t/SDZGSkgQwClK8BWo6/415HU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EEYzYJOjwChrpaH8kKScnCKBDKa1tgPnsr/a9x2FMIfg5dmM8BFkLk4hnoQdPd+TfRJtufcp8ld4tW8ZULac3pX1lMklrovtWParEacXyPSmn0h8zTGXiiQ6G8gaO1Xu4cVnbQm9J0jGs1SuxqJJ5bwd2MLC36jORHJ1fptyVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y8mCIPFK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y8mCIPFK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E61372936;
	Thu, 18 Jun 2026 06:14:54 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFDB63F915;
	Thu, 18 Jun 2026 06:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781788499; bh=+MFJqEWiNc1lFUhDg3t/SDZGSkgQwClK8BWo6/415HU=;
	h=From:To:Cc:Subject:Date:From;
	b=Y8mCIPFKpTbMfIzeaqZlLgR4QDYyVKzXlwNYS0WDNPtM2VioUZQJkCpmuCcurypd+
	 92lOXcBAzfVTAwLPthEfJsg08EPF4/64//5xSkAGlDiFlXT5dCx+zkW8/QVIoIxLTD
	 f4GbwBba8U2BoxVmvPj5kKi6MbRW6Pl2XyD07ggw=
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
Subject: [PATCH v2 0/3] Optimize S2 page splitting
Date: Thu, 18 Jun 2026 14:14:41 +0100
Message-ID: <20260618131447.764085-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4029; i=leo.bras@arm.com; h=from:subject; bh=+MFJqEWiNc1lFUhDg3t/SDZGSkgQwClK8BWo6/415HU=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKM37Hd0Y1yqVLYKWjDw39am4W7MT3Dbla0r92H5rLF6 i8tiqZ0lLIwiHExyIopssg+mr+K5/uUjCNXfiyAmcPKBDKEgYtTACayqpbhf1HrPsOHn3XTLJ1k 6/i2vp88/af+1zlOVryPZ37cy/KhfQ0jw9eZWk7RL1dFpNVfVIzJUWruOsawM6ROU29Xj9+v6J3 v+AE=
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
VM with 1 memslot of 16GB:
- Scenario 1: No manual protect, whole memslot split at dirty-track enable
  (KVM_SET_USER_MEMORY_REGION2 ioctl with KVM_MEM_LOG_DIRTY_PAGES)
  - Split happens only once, whole region
  - Evalutes improved batch performance of splitting
- Scenario 2: Manual protect, split happens during every dirty-bit clean
  (KVM_CLEAR_DIRTY_LOG ioctl), average for 2 iterations.
  - Split called multiple times, for smaller 64-page sections.
  - Evaluate improved performance for multiple calls

Scenario 1, improvement on dirty-track enable ioctl for the memslot:
- Memory was already split (4k pages):  -44.01% runtime (stdev 2.80%)
- THP backed memory:                    -24.66% runtime (stdev 1.21%)
- 16x1GB hugetlb memory:                -24.78% runtime (stdev 0.85%)

Scenario 2, improvement on dirty-log clean ioctl for the memslot:
- Memory was already split (4k pages):  -38.98% runtime (stdev 1.91%)
- THP backed memory:                    -25.49% runtime (stdev 0.65%)
- 16x1GB hugetlb memory:                -24.24% runtime (stdev 0.65%)

For collecting above numbers, the following script was ran in both vanilla
and patched kernels, with kernel parameter 'default_hugepagesz=1G', on an
TX2 with 32GB RAM.

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
Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
Testing guest mode: PA-bits:36,  VA-bits:48,  4K pages
Testing guest mode: PA-bits:36,  VA-bits:48, 64K pages

Performance numbers from above modes were used to calculate average and
stdev showed in the optimization results.

Changes since v1:
- Fixed inverted flag verification priority (Sashiko)
- Fixed incorrectly skipping POST call if level was skipped (Sashiko), and to that
- New pre-patch that changes goto-out -> return to avoid re-testing walk_continue 
v1 Link: https://lore.kernel.org/lkml/20260610202112.2695205-2-leo.bras@arm.com/

Changes since RFC:
- Changed approach from return value to walk flags (Will Deacon)
- Discarted skip_child approach (Oliver Upton)
- Measured in real hardware, and from userspace perspective (Marc Zyngier)
- Better explanation of what and how numbers were collected
RFC Link: https://lore.kernel.org/all/20260515195904.2466381-1-leo.bras@arm.com/

Thanks!
Leo

Leonardo Bras (3):
  KVM: arm64: Avoid re-testing walk_continue
  KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
  KVM: arm64: Make stage2_split_walker() skip unnecessary walks

 arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 28 +++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 7 deletions(-)


base-commit: 66affa37cfac0aec061cc4bcf4a065b0c52f7e19
-- 
2.54.0

