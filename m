From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v5 0/7] KVM: Support PUD hugepages at stage 2
Date: Mon, 09 Jul 2018 15:49:44 +0100
Message-ID: <871sccqx9z.fsf@e105922-lin.cambridge.arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709143835.28971-2-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA35E40196
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 10:37:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JQNYqZlFk+fW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 10:37:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3379D40192
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 10:37:05 -0400 (EDT)
In-Reply-To: <20180709143835.28971-2-punit.agrawal@arm.com> (Punit Agrawal's
 message of "Mon, 9 Jul 2018 15:38:28 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Please ignore this cover letter.

Apologies for the duplicate cover-letter and a somewhat funky threading
(I blame emacs unsaved buffer).

The patches appear to be intact so don't let the threading get in the
way of review.

Punit Agrawal <punit.agrawal@arm.com> writes:

> This series is an update to the PUD hugepage support previously posted
> at [0]. This patchset adds support for PUD hugepages at stage
> 2. This feature is useful on cores that have support for large sized
> TLB mappings (e.g., 1GB for 4K granule).
>
> The biggest change in this version is to replace repeated instances of
> walking the page tables to get to a leaf-entry with a function to
> return the appropriate entry. This was suggested by Suzuki and should
> help reduce the amount of churn resulting from future changes. It also
> address other feedback on the previous version.
>
> Support is added to code that is shared between arm and arm64. Dummy
> helpers for arm are provided as the port does not support PUD hugepage
> sizes.
>
> The patches have been tested on an A57 based system. The patchset is
> based on v4.18-rc4. The are a few conflicts with the support for 52
> bit IPA[1] due to change in number of parameters for
> stage2_pmd_offset().
>
> Thanks,
> Punit
>
> v4 -> v5:
>
> * Patch 1 - Drop helper stage2_should_exec() and refactor the
>   condition to decide if a page table entry should be marked
>   executable
> * Patch 4-6 - Introduce stage2_get_leaf_entry() and use it in this and
>   latter patches
> * Patch 7 - Use stage 2 accessors instead of using the page table
>   helpers directly
> * Patch 7 - Add a note to update the PUD hugepage support when number
>   of levels of stage 2 tables differs from stage 1
>
>
> v3 -> v4:
> * Patch 1 and 7 - Don't put down hugepages pte if logging is enabled
> * Patch 4-5 - Add PUD hugepage support for exec and access faults
> * Patch 6 - PUD hugepage support for aging page table entries
>
> v2 -> v3:
> * Update vma_pagesize directly if THP [1/4]. Previsouly this was done
>   indirectly via hugetlb
> * Added review tag [4/4]
>
> v1 -> v2:
> * Create helper to check if the page should have exec permission [1/4]
> * Fix broken condition to detect THP hugepage [1/4]
> * Fix in-correct hunk resulting from a rebase [4/4]
>
> [0] https://www.spinics.net/lists/arm-kernel/msg663562.html
> [1] https://www.spinics.net/lists/kvm/msg171065.html
>
>
> Punit Agrawal (7):
>   KVM: arm/arm64: Share common code in user_mem_abort()
>   KVM: arm/arm64: Introduce helpers to manupulate page table entries
>   KVM: arm64: Support dirty page tracking for PUD hugepages
>   KVM: arm64: Support PUD hugepage in stage2_is_exec()
>   KVM: arm64: Support handling access faults for PUD hugepages
>   KVM: arm64: Update age handlers to support PUD hugepages
>   KVM: arm64: Add support for creating PUD hugepages at stage 2
>
>  arch/arm/include/asm/kvm_mmu.h         |  60 +++++
>  arch/arm64/include/asm/kvm_mmu.h       |  47 ++++
>  arch/arm64/include/asm/pgtable-hwdef.h |   4 +
>  arch/arm64/include/asm/pgtable.h       |   9 +
>  virt/kvm/arm/mmu.c                     | 289 ++++++++++++++++++-------
>  5 files changed, 330 insertions(+), 79 deletions(-)
