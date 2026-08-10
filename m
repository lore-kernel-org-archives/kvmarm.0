Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E225382371
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 20:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395112; cv=none; b=VZLILeCOOpSXKvq0XbkqfGLr0q+lKywRkYy79iUcWoTDLjLn9mTPElqzTYgJXavUyWdqX1WO5Liuw7b7dmQ7W0VHGo0kwjviEuyfwlJGvkZX6+rdG59FsGocSSDHfjv5chlKfrgRDqbWjH2wNz/UzBwfLi317Dd18z5bqxcpYuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395112; c=relaxed/simple;
	bh=I7jEk16c+g3+9u6Ivi+NOWCvGoomkASU82C6An8XdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OPi6w7WlugYw7xMjH/aouIGpLT+eogmKSyGkyx5wAGmdAKYzQsJg/bwqCMAE9ZeLxsZunaTORRx90Sw129GRKaCAsMfnuDkAtoEO4sJie/VATOSqGmSKXWVU9GRJilBfc6hQNn+mD5f8nOy71iN4M4ePc4q9K/SSnI4OSoOoU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sLw21ujF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sLw21ujF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32BFB14BF;
	Mon, 10 Aug 2026 13:51:45 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 417C23F673;
	Mon, 10 Aug 2026 13:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786395109; bh=I7jEk16c+g3+9u6Ivi+NOWCvGoomkASU82C6An8XdmQ=;
	h=From:To:Cc:Subject:Date:From;
	b=sLw21ujFa2uKPc3vyt5cm22jneCLIc0C+T8hHGRCDYC+CXfpmLPt6/yxzLbr5Kvf5
	 oQqGeCfAiRO1sYohbVvm96uPYM80QHHJiSGyAvcLeR2VkBwrIlws1PTpPgryR49GQr
	 SpBoDRTv4MjsYAHkzlTy1krpMifaNi2p+3xF9/Aw=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse map (new data structure)
Date: Mon, 10 Aug 2026 21:50:32 +0100
Message-ID: <20260810205038.118843-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v5 of optimizing the shadow s2 mmu unmapping during MMU
notifiers.

This time, a major overhaul is done to the implementation. After
receiving some suggestions from Marc, I have identified that using the
interval tree to store the guest stage-2 mappings solves many problems
compared to using the maple tree.

Interval Tree vs Maple Tree
===========================

First of all, interval trees are capable of storing overlapping ranges,
which is helpful when the L1 hypervisor maps something like:

nested IPA [x, x+4K) -> canonical IPA [a, a+4K)
nested IPA [y, y+2M) -> canonical IPA [a, a+2M)

No problems with storing that in the interval tree with different nodes.
We can avoid the maple tree UNKNOWN_IPA mechanism as a compromise.

Second, ideally we would want to save the canonical IPA <-> nested IPA
mapping in both directions to allow MMU notifier unmap speed up, and
stale shadow mapping removals. If we use the maple tree, we'll have to
have 2 separate trees, and make sure they store the same mappings, which
isn't simple given the first point.

On the other hand, by using this pattern:

/* Record of a guest stage-2 mapping. */
struct kvm_guest_s2_mapping {
       struct interval_tree_node canonical; // CIPA range of the mapping
       struct interval_tree_node nested;    // NIPA range of the mapping
       struct kvm_s2_mmu *nested_mmu;       // mmu of the NIPA space
};

and equip each mmu with an interval tree storing mapping records
corresponding to the IPA space it represents, we can insert the
respective nodes into the canonical IPA tree, and the corresponding
nested IPA tree. This makes it trivial to find the range of the other
IPA space from a range in one IPA space.

Diagram to help understanding:

struct kvm_guest_s2_mapping mapping1, mapping2;

    ---------------------> mapping2.canonical
    |                      mapping1.canonical
    |                          ^   (both stored in canonical mmu's tree)
    |                          |
--*****-----------------------*****----------- CIPA
   \\\\\                      |||||                  mapping1.nested_mmu
    \\\\\                     \\\\\                            |
     \\\\\                     \\\\\                           v
------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
       \\\\\                      |
        \\\\\                     -> mapping1.nested
         \\\\\                       (stored in nested mmu #1's tree)
          \\\\\
-----------*****------------------------------ NIPA #2 (nested mmu #2)
             |                                                 ^
             -> mapping2.nested                                |
                (stored in nested mmu #2's tree)   mapping2.nested_mmu

Third, maple tree does its own memory allocation. In the KVM stage-2
fault path we only find out what the mapping ranges are after taking the
KVM MMU lock, and the maple tree has to know the range and entry to be
stored to preallocate, therefore in our case the maple tree is forced to
only use GFP_NOWAIT, which isn't the best. With the interval tree the
user does the memory management, and we can just allocate before taking
the locks.

Locking
=======

The guest_s2_tracking_lock serializes accesses to the tracking interval
trees. It is taken after the mmu_lock. However in reality it is only
taken after we take the read mmu_lock in the stage-2 fault path, as
other accesses have the write mmu_lock already. This saves us some
manual lock/unlocks.

vCPU Stage-2 Fault Scalability Reduction
========================================

KVM/arm64 is able to handle stage-2 faults from multiple vCPUs in
parallel, thanks to the engineering done to the s2 pgtable code. However
to safely insert mappings into the interval trees we have to serialize
using the guest_s2_tracking_lock. We trade some performance in stage-2
fault for faster MMU notifier unmaps, and keeping the unaffected shadow
mappings.

Memory Usage
============

Each interval tree node is 48 bytes, and a kvm_guest_s2_mapping is 104
bytes, residing in 128-byte slab objects. Each shadow stage-2 fault
requires one kvm_guest_s2_mapping instance. This is 32MB for a fully 4KB
mapped 1GB region, and 64KB for a 2MB mapped 1GB region.

Series Structure
================

Patch 1:   Preparatory refactoring.
Patch 2:   Introduce data structures for guest stage-2 tracking.
Patch 3-4: Guest stage-2 tracking addition and removal
Patch 5:   Avoid full unmap during MMU notifier unmap using the tracked
           guest stage-2 mapping information.
Patch 6:   Minor clean up.

As this is a complete rework, I will omit the change log this time.
Series is based on v7.2-rc5.

Thanks!

Link to v4: https://lore.kernel.org/kvmarm/20260714115926.2044757-1-weilin.chang@arm.com/

Wei-Lin Chang (6):
  KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
  KVM: arm64: nv: Introduce guest stage-2 tracking structures
  KVM: arm64: nv: Track guest stage-2 mapping creation
  KVM: arm64: nv: Track guest stage-2 mapping removal
  KVM: arm64: nv: Avoid full shadow stage-2 unmap
  KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables

 arch/arm64/include/asm/kvm_host.h   |  20 ++++++
 arch/arm64/include/asm/kvm_nested.h |   7 ++
 arch/arm64/kvm/mmu.c                | 105 ++++++++++++++++++++++++----
 arch/arm64/kvm/nested.c             |  95 +++++++++++++++++++++++++
 4 files changed, 215 insertions(+), 12 deletions(-)

-- 
2.43.0

