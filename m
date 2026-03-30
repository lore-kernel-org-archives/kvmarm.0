Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3B13B7B92
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865224; cv=none; b=iKFuAhy9P2wtQUTRAf7QuyF4jANNs1oG7t+31dcuezR+hXleNFhEHsFFg41usoJSEBsX1F71y3y64jykaMco3DQzn6iWSOe9erJfvvZa1jJqT7VgkY2LxRi7bux6/Vxgkfw4AgVOrbuPb7fSwCB3yD1OrN2l4UVFDpLhW1XKqqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865224; c=relaxed/simple;
	bh=WiZexc2ub8nU/DOmgIujcFqlS73bkRYd4DhNzKaOO50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AmKPcafUHENoNS6UzgifUbRmJI9aSZXXvajA/ytpJp2Vy9Y+Ls6h4F+g7scXDlqqMmMNnTr7SEjKmV9ac1BNn9NHGtgXImJA0RTUsiH0pm7ygj9Pr4lx5CIY/UK3l8mK4Cth3U7MWfQA5ZrWUo/TjNLs6iaZ9MSgZL2AcISQcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pV1SqD7m; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pV1SqD7m"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7855E1BF3;
	Mon, 30 Mar 2026 03:06:55 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B33533F915;
	Mon, 30 Mar 2026 03:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774865221; bh=WiZexc2ub8nU/DOmgIujcFqlS73bkRYd4DhNzKaOO50=;
	h=From:To:Cc:Subject:Date:From;
	b=pV1SqD7mbs2drzteiqah10JAJ8066fD2/JaEPWnUQw6oHCCaa43wQLT9IByBb1bkK
	 eqS0U34GyfQvbGg0N/Gpoi56PEk2U+7NmklK4C/2XztjVQ+HHhDzpizgZO2uFA/eH8
	 styJ4FsFfgG8L6GWGPMKjYQflagEIg/jDNhs1MEU=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/4] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Mon, 30 Mar 2026 11:06:29 +0100
Message-ID: <20260330100633.2817076-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series optimizes the shadow s2 mmu unmapping during MMU notifiers.

Motivation
==========

KVM registers MMU notifiers to unmap stage-2 mappings for the guest when
the backing memory's userspace VA to PA translation has changed, some
reasons include memory reclaim and and migration. In the non-NV case
this is straight forward, the registered function simply unmaps the VM's
IPA from the stage-2 page tables. However, in the NV case the nested
MMUs store nested IPA to PA mappings, and we have no clue which of these
nested mappings are backed by the same memory that the MMU notifiers are
unmapping. The consequence is that since we don't know which nested
mappings should be removed, we can only unmap every nested MMU in its
entirety within the guest to be safe. This kills performance when MMU
notifiers are called often, and we would like a better alternative than
unmapping all shadow stage-2s everytime.

Design
======

The basic idea is create a reverse map from the canonical IPA to the
nested IPA, so that when the MMU notifier informs us about the canonical
IPA range that must be unmapped, we can look up the reverse map to find
the nested IPA range affected and unmap it from the nested MMU. To
achieve fine grained unmapping, each nested MMU is equipped with its own
reverse map.

The maple tree is chosen to store the reverse map, mainly for its good
support for dealing with ranges. Two methods of storing the reverse map
are considered: either using the canonical IPA as the key for the tree,
or using the PA as the key for the tree, the value stored is the nested
IPA range for both. In this series the method using canonical IPA as the
key is implemented, which I believe is a better scheme. A comparison
between the two is presented in a later section.

It is possible for a nested context to have multiple nested IPA ranges
mapped to the same IPA. In these cases idealy our reverse map should
contain 1-to-many relations, so that we are able to find all nested IPA
ranges to unmap during MMU notifiers. However since this requires more
information than what a 64 bit maple tree value can store, we will be
forced to store the information in allocated data pointed to by the
maple tree value. This creates extra memory we have to manage, and
increases the maintenance effort from tracking 1-to-many mappings, for
example by keeping a linked list of nested IPA ranges.

Instead, we introduce what is called the "polluted" canonical IPA
ranges, which means for these canonical IPA ranges we have lost track of
what nested IPA ranges are mapped to this canonical IPA range. Polluted
canonical IPA ranges are created when at shadow stage-2 fault time, we
find that the canonical IPA range we are trying to insert to the reverse
map overlaps one or more pre-existing ranges, in this case the minimum
polluted spanning range is calculated and inserted to replace all
pre-existing ranges.

Example:
|||| means existing range, ---- means empty range

input:            $$$$$$$$$$$$$$$$$$$$$$$$$$
tree:  --||||-----|||||||---------||||||||||-----------

free overlaps:
       --||||------------------------------------------
insert spanning polluted range:
       --||||-----||||||||||||||||||||||||||-----------
                  ^^^^^^^^polluted!^^^^^^^^^

Later when a request to unmap a canonical IPA range arises which affects
a polluted canonical IPA range, simply fall back to unmapping the entire
nested MMU.

MMU notifier optimization
=========================

Every nested MMU keeps its own reverse map, therefore we must check
every nested MMU when we unmap canonical IPA ranges in the MMU notifier,
which is not efficient. We can leverage the canonical stage-2 MMU's
unused maple tree to point to the nested MMUs that hold mappings
of each stored canonical IPA range. This is implemented in patch 2 with
more detail in the commit message.

TLBI handling
=============

When a guest hypervisor issues a TLBI for a specific IPA range, KVM
unmaps that range from all the effected shadow stage-2s. During this we
get the opportunity to remove the reverse map, and lower the probability
of creating polluted reverse map ranges at subsequent stage-2 faults.

However, the TLBI ranges are specified in nested IPA, so in order to
locate the affected ranges in the reverse map maple tree, which is a
mapping from canonical IPA to nested IPA, we can only iterate through
the entire tree and check each entry. This is implemented in patch 3.

In patch 4, we further improve this by introducing a direct map that
goes from nested IPA to canonical IPA, allowing us to quicky locate
which reverse mapping to remove when handed a nested IPA range during
TLBI handling.

Reverse map key, canonical IPA vs PA
====================================

This is a brief comparison of using either canonical IPA or PA as the
key to the reverse map, base on the 4 aspects of the implementation.

Reverse map creation
--------------------

Using both canonical IPA and PA requires almost identical operations.

Canonical IPA unmapping (MMU notifier)
--------------------------------------

For canonical IPA as the key, simply search the reverse map and
invalidate the retrieved nested IPA range.

For PA as the key, we must first translate the given canonical IPA range
into PA either via

a) walking the user space page table or..
b) calling kvm_gmem_get_pfn() if the memslot is a guest_memfd one

Further, kvm_gmem_get_pfn() forcefully allocates the physical page if
the queried canonical IPA is not faulted in. This of course is not
acceptable for our use case, so writing some guest_memfd code will be
required for this to work.

Canonical IPA unmapping optimization
------------------------------------

Using both canonical IPA and PA requires identical operation.

TLBI handling
-------------

For canonical IPA as the key, like said above we can either:

a) iterate the reverse map to find the entry to remove, or
b) create a direct map to find the canonical IPA range

For PA as the key, it is more straightforward, simply find the PA by
walking the shadow stage-2, then remove the PA range from the reverse
map. However this still requires a page table walk.

Summary
-------

I believe it is clear that using canonical IPA as the key saves us a lot
of trouble:

a) no page table walks are required
b) we go from dealing with 3 address spaces (PA, canonical IPA, nested
IPA) to 2 (canonical IPA, nested IPA)
c) the problem with guest_memfd is circumvented

Locking
=======

All maple trees are protected by kvm.mmu_lock, therefore no maple tree
locks are taken.

Testing
=======

The current plan to test is to enhance kselftest with NV capability, so
that we can instruct L1 and L2 to set up and access memory to populate
shadow page tables, userspace can then trigger MMU notifiers by e.g.
munmap, mremap, etc. During these operations userspace can read the
shadow page tables exposed in debugfs [1] to check whether the shadow
page tables are in an expected state or not.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260317182638.1592507-2-weilin.chang@arm.com

Wei-Lin Chang (4):
  KVM: arm64: nv: Avoid full shadow s2 unmap
  KVM: arm64: nv: Accelerate canonical IPA unmapping with canonical s2
    mmu maple tree
  KVM: arm64: nv: Remove reverse map entries during TLBI handling
  KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
    removal

 arch/arm64/include/asm/kvm_host.h   |   7 +
 arch/arm64/include/asm/kvm_nested.h |   5 +
 arch/arm64/kvm/mmu.c                |  32 ++-
 arch/arm64/kvm/nested.c             | 342 +++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c           |   3 +
 5 files changed, 382 insertions(+), 7 deletions(-)

-- 
2.43.0

