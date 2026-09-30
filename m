Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1914FDE55
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789020; cv=none; b=hLRDV6H713sG5GCy+45yjStyiSfWn1VDO97CMu74t7Q1JHZ1FbX/GUoPtaZ99bTO5Kg0atP+CfIqhN2lc/k++wSnLkuYiLMU3RN0oinR1tTD5D6ChokEZHJKDowPJoBg/PFb/WHq0ArRnINNQYuf+zRu9YX4KMtbkUgSI7yYHx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789020; c=relaxed/simple;
	bh=fXE743sIM/nQSiWcBGoUx8NbFyewBUf1llAQH/QXNJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tuhIE7MMqb9GOJhe+5zxce5pIHlceZS+/CvKYPZxwiibfU8Iuf74SIBEy942OGGI/OPZ+1TV9yfmQ+gHNDeRELBZpSSC10GhFzFTmP7dYzUqvehA6t1JMH76RltTLY09NCUkLRYCZHl7/cMVNmdkzp5EOiuUHWT/j+RJquOqQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bBbQ8nfQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bBbQ8nfQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BCD1497;
	Wed, 30 Sep 2026 10:23:34 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C2D53F86F;
	Wed, 30 Sep 2026 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790789017; bh=fXE743sIM/nQSiWcBGoUx8NbFyewBUf1llAQH/QXNJM=;
	h=From:To:Cc:Subject:Date:From;
	b=bBbQ8nfQDoAcsAtuR3J/+/fGsYRgmvutWn97mfQHggHKgwYRv/IhGQwJ1t6mQoFae
	 Zst3eoeFFkzTNATXvaKpXMtqx9b4M/izVQwWZDB+upDvh1Zu2LxyHbpEzhy8NaOlC6
	 QqrhwTq+4memHNWujbNBn9jFnXsVaTVj5q7UiJFs=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] Optimize S2 hugepage splitting, introduce skip-level flags
Date: Wed, 30 Sep 2026 18:22:20 +0100
Message-ID: <20260930172226.2459423-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4418; i=leo.bras@arm.com; h=from:subject; bh=6jIvAO7qm3jjgSq+Dla4mVhMhm4SWwAU9Gn4g47wvek=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLL2urrXvru1b3qBc7n6tD8TmfxPfJsQvnjx5hUhDJrm+ 2/OPV7c1VHKwiDGxSArpsgi+2j+Kp7vUzKOXPmxAGYOKxPIEAYuTgGYSEY5wz+dtfHzpHInzj6z u7irfqPlkrN82bsOxUS/cOzYqfjjVYAIw18RHsPe/Gvs9nunhUtVfP6XpPvMa/2/w/vPzGHJui6 k/5kZAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit


While playing with dirty-bit tracking, I decided to take a look on how page
splitting works. Found out all entries are walked, even though we don't need
to walk the level-3 entries, as they don't need to be split. 

This patches' idea is to introduce new walking flags to skip pagetable
levels 0-3.

Optimization measured on two scenarios involving eager-splitting on a
VM with 32 memslot of 2GB (total 64GB), and vcpu per slot:
- Scenario 1: No manual protect, whole memslot split at dirty-track enable
  (KVM_SET_USER_MEMORY_REGION2 ioctl with KVM_MEM_LOG_DIRTY_PAGES)
  - Split happens only once, whole region
  - Evalutes improved batch performance of splitting
- Scenario 2: Manual protect, split happens during every dirty-bit clean
  (KVM_CLEAR_DIRTY_LOG ioctl), average for 2 iterations.
  - Split called multiple times, for smaller 64-page sections.
  - Evaluate improved performance for multiple calls

Scenario 1, improvement on dirty-track enable ioctl for the memslot:
- Memory was already split (4k pages):  -47.82% runtime
- THP backed memory:                    -27.50% runtime
- 64x1GB hugetlb memory:                -28.47% runtime

Scenario 2, improvement on dirty-log clean ioctl for the memslot:
- Memory was already split (4k pages):  -44.72% runtime
- THP backed memory:                    -29.80% runtime
- 64x1GB hugetlb memory:                -30.01% runtime

For collecting above numbers, the following script was ran in both vanilla
and patched kernels, with kernel parameter 'default_hugepagesz=1G', on an
TX2 with 128GB RAM.

--- dirty_test.sh
#!/bin/bash
filename=$(uname -r |cut -d'-' -f 4-)

run_test(){
  base_test="./dirty_log_perf_test -b 2G -v 32 -m 6 -m 8"

  # Manual cleaning disable
  ${base_test} -g
  ${base_test} -g -s anonymous_thp
  echo 64 > /proc/sys/vm/nr_hugepages  
  ${base_test} -g -s shared_hugetlb
  echo 0 > /proc/sys/vm/nr_hugepages

  # Manual cleaning enable
  ${base_test}
  ${base_test} -s anonymous_thp
  echo 64 > /proc/sys/vm/nr_hugepages  
  ${base_test} -s shared_hugetlb
  echo 0 > /proc/sys/vm/nr_hugepages
}

run_test 2>&1 | tee ${filename}
---

Above dirty_log_perf_test command is the standard kvm selftest found in the
kernel tree. It tested the following guest modes:
Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
(Modes with PA-bits:36 were discarted in this version, given the amount
of RAM being used for testing, and the similarity of previous results)

Performance numbers from above modes were used to calculate average showed
in the optimization improvements.

Changes since v3:
- Check if root level should be skipped,
- Improve commit messages (Marc)
- Improve skip_level documentation (Marc & Wei Lin)
- Improved skip_level code (Marc)
- Dropped skip_children explanation in the cover letter (Dev)
- Rebased on top of v7.3-rc5
v3 Link: https://lore.kernel.org/all/20260708134101.2514759-1-leo.bras@arm.com/

Changes since v2:
- Rebased on top of v7.2-rc1
- Improved testing, added more memory, re-tested
  - Now: 32 vcpus @ total of 64G
  - Before: 1cpu @ 16G
v2 Link: https://lore.kernel.org/all/20260618131447.764085-1-leo.bras@arm.com/

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

 arch/arm64/include/asm/kvm_pgtable.h | 14 ++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.55.0

