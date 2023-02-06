Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DE97B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:48 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id l5-20020a056e020e4500b00313cbbd4729so1749924ilk.13
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tCF6TwGhxQnyhb8yf01ctYnmoYyzioEblNPgudqLhvI=;
        b=p/wXgrPNwOmYwnwQi6Qc6gdGccfckZ2RvMBN8pImZaYmTFF4ujhuUJehAV5qMCQ491
         L6rhQXozyuQ39i8N9WDSfPbwRAjln0vDJSc3p9PBMEYVEJKh6z3rZdDWkQo8cm/D5Fna
         Z9iPHuQK54hieDrQtk1FAnLpxQN9Nzy0kN7VIDfgIJP/wzjDGXy4Rj8+fAfEwqyNv7Km
         IHL98kC7sgTyUSO/5dLs6mb1EVQcQlqgX5S/b99uQb1oq5nPHpV9MARL56nHul9Gsgnk
         9Th8GMa8k51SsbF7VRLwj1i9P8Ql8n2hcMsaMazAJqMNiQnYI7yj+qNUGwgmP0mrK3Fk
         nLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tCF6TwGhxQnyhb8yf01ctYnmoYyzioEblNPgudqLhvI=;
        b=u4FnRnsoCX3m0v2easXQks2NFYmxa5ddEuzMCv2e3rgm1457WhHSw9Stes+Sv2sCrD
         +ugsbNnGvCRs9eNCFIot3H1JrFRoGnCpiKp1epvC0LGa19ewb3dHB8oAI9/pmclq8C9U
         0uzsQBx+fH+MXgLeZLKfInS16rJghn5sLZ9nvAO60H+qyqG6xow2zZuFH7nlfw6QYs3/
         JCJ975v/gO7S/LHRDKM8/uBXg0wIdjAXC6zvy2qsJOWWF+ToIjgWskFtnmgjr1+DDmMI
         J/1rddflSccEN5C++9x5RolTmjWF8lxtZe7jNZaxJTz2Wa8ts5VOkNWKLBIXFAUhTnwE
         j1FQ==
X-Gm-Message-State: AO0yUKVeFPyJtiVOclKMEbvMCrOybq/99+fo5Xj++iSCGT6ojUQO84o/
	8GRrt/HNz7qinpfrnypfXfgALrM7DwaV
X-Google-Smtp-Source: AK7set9DGjb1VmXyo14vzBucOK7rbEBbB63YtEW75mXeAWNEYrP3B1/9EPBtu6jfjfsTUqO3mnPjYm62RBqr
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:1a47:0:b0:313:d78c:918f with SMTP id
 z7-20020a921a47000000b00313d78c918fmr1460ill.40.1675704227420; Mon, 06 Feb
 2023 09:23:47 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-1-rananta@google.com>
Subject: [PATCH v2 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In certain code paths, KVM/ARM currently invalidates the entire VM's
page-tables instead of just invalidating a necessary range. For example,
when collapsing a table PTE to a block PTE, instead of iterating over
each PTE and flushing them, KVM uses 'vmalls12e1is' TLBI operation to
flush all the entries. This is inefficient since the guest would have
to refill the TLBs again, even for the addresses that aren't covered
by the table entry. The performance impact would scale poorly if many
addresses in the VM is going through this remapping.

For architectures that implement FEAT_TLBIRANGE, KVM can replace such
inefficient paths by performing the invalidations only on the range of
addresses that are in scope. This series tries to achieve the same in
the areas of stage-2 map, unmap and write-protecting the pages.

Patch-1 refactors the core arm64's __flush_tlb_range() to be used by
other entities.

Patch-2 adds a generic range-based TLBI mechanism for KVM.

Patch-3 adds support to flush a range of IPAs for KVM.

Patch-4 implements the kvm_arch_flush_remote_tlbs_range() for arm64.

Patch-5 aims to flush only the memslot that undergoes a write-protect,
instead of the entire VM.

Patch-6 operates on stage2_try_break_pte() to use the range based
TLBI instructions when breaking a table entry. The map path is the
immediate consumer of this when KVM remaps a table entry into a block.

Patch-7 introduces a fast stage-2 unmap path in which, for the right
conditions, instead of traversing each and every PTE and unmapping them,
disconnect the PTE at a higher level (say at level-1 for a 4K pagesize)
and unmap the table entries using free_removed_table(). This would allow
KVM to use the range based TLBI to flush the entire range governed at
that level.

The series is based off of upstream v6.2-rc6, and applied David
Matlack's common API for TLB invalidations[1] on top.

The performance evaluation was done on a hardware that supports
FEAT_TLBIRANGE, on a VHE configuration, using a modified kvm_page_table_test.
The modified version updates the guest code in the ADJUST_MAPPINGS case
to not only access this page but also to access up to 512 pages backwards
for every new page it iterates through. This is done to test the effect
of TLBI misses after KVM has handled a fault.

The series captures the impact in the map and unmap paths as described above.

$ kvm_page_table_test -m 2 -v 128 -s anonymous_hugetlb_2mb -b $i

+--------+------------------------------+------------------------------+
| mem_sz |    ADJUST_MAPPINGS (s)       |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series | Baseline | Baseline + series |
+--------+----------|-------------------+------------------------------+
|   1    |   4.15   |   4.26            | 0.50     | 0.007             |
|   2    |   6.09   |   6.08            | 0.50     | 0.009             |
|   4    |  12.65   |  11.46            | 0.50     | 0.01              |
|   8    |  25.35   |  24.75            | 0.52     | 0.02              |
|  16    |  52.17   |  48.23            | 0.53     | 0.03              |
|  32    | 100.09   |  84.53            | 0.57     | 0.06              |
|  64    | 176.46   | 166.96            | 0.75     | 0.11              |
| 128    | 340.22   | 302.82            | 0.81     | 0.20              |
+--------+----------+-------------------+----------+-------------------+

$ kvm_page_table_test -m 2 -b 128G -s anonymous_hugetlb_2mb -v $i

+--------+------------------------------+
| vCPUs  |    ADJUST_MAPPINGS (s)       |
|        | Baseline | Baseline + series |
+--------+----------|-------------------+
|   1    | 153.91   | 148.75            |
|   2    | 188.17   | 176.11            |
|   4    | 193.15   | 175.77            |
|   8    | 195.60   | 184.92            |
|  16    | 183.49   | 170.22            |
|  32    | 159.37   | 152.70            |
|  64    | 190.15   | 180.45            |
| 128    | 340.22   | 302.82            |   
+--------+----------+-------------------+

For the ADJUST_MAPPINGS cases, which maps back the 4K table entries to
2M hugepages, the series sees an average improvement of ~7%. For unmapping
2M hugepages, we see at least a 4x improvement.

$ kvm_page_table_test -m 2 -b $i

+--------+------------------------------+
| mem_sz |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series |
+--------+------------------------------+
|   1    |  1.03    |  0.58             |
|   2    |  1.57    |  0.72             |
|   4    |  2.65    |  0.98             |
|   8    |  4.77    |  1.54             |
|  16    |  9.06    |  2.57             |
|  32    | 17.60    |  4.41             |
|  64    | 34.72    |  8.92             |
| 128    | 68.92    | 17.70             |   
+--------+----------+-------------------+

The 4x improvement for unmapping also holds true when the guest is
backed by PAGE_SIZE (4K) pages.

v2:
- Rebased the series on top of David Matlack's series for common
  TLB invalidation API[1].
- Implement kvm_arch_flush_remote_tlbs_range() for arm64, by extending
  the support introduced by [1].
- Use kvm_flush_remote_tlbs_memslot() introduced by [1] to flush
  only the current memslot after write-protect.
- Modified the __kvm_tlb_flush_range() macro to accepts 'level' as an
  argument to calculate the 'stride' instead of just using PAGE_SIZE.
- Split the patch that introduces the range-based TLBI to KVM and the
  implementation of IPA-based invalidation into its own patches.
- Dropped the patch that tries to optimize the mmu notifiers paths.
- Rename the function kvm_table_pte_flush() to
  kvm_pgtable_stage2_flush_range(), and accept the range of addresses to
  flush. [Oliver]
- Drop the 'tlb_level' argument for stage2_try_break_pte() and directly
  pass '0' as 'tlb_level' to kvm_pgtable_stage2_flush_range(). [Oliver]

v1: https://lore.kernel.org/all/20230109215347.3119271-1-rananta@google.com/

Thank you.
Raghavendra

[1]: https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatlack@google.com/

Raghavendra Rao Ananta (7):
  arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
  KVM: arm64: Add FEAT_TLBIRANGE support
  KVM: arm64: Implement  __kvm_tlb_flush_range_vmid_ipa()
  KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
  KVM: arm64: Flush only the memslot after write-protect
  KVM: arm64: Break the table entries using TLBI range instructions
  KVM: arm64: Create a fast stage-2 unmap path

 arch/arm64/include/asm/kvm_asm.h   |  21 ++++++
 arch/arm64/include/asm/kvm_host.h  |   3 +
 arch/arm64/include/asm/tlbflush.h  | 107 +++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  12 ++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  28 ++++++++
 arch/arm64/kvm/hyp/pgtable.c       |  67 +++++++++++++++++-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  24 +++++++
 arch/arm64/kvm/mmu.c               |  17 ++++-
 8 files changed, 222 insertions(+), 57 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

