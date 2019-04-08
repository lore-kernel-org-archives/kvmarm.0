From: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
Date: Mon, 8 Apr 2019 11:50:58 +0800
Message-ID: <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, eric.auger@redhat.com, Marc Zyngier <marc.zyngier@arm.com>, Chirstoffer Dall <christoffer.dall@arm.com>, Zheng Xiang <zhengxiang9@huawei.com>, andrew.murray@arm.com, "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 2019/4/2 19:06, Suzuki K Poulose wrote:
> With commit a80868f398554842b14, we no longer ensure that the
> THP page is properly aligned in the guest IPA. Skip the stage2
> huge mapping for unaligned IPA backed by transparent hugepages.
> 
> Fixes: a80868f398554842b14 ("KVM: arm/arm64: Enforce PTE mappings at stage2 when needed")
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Chirstoffer Dall <christoffer.dall@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> Tested-by: Eric Auger <eric.auger@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Hi Suzuki,

Why not making use of fault_supports_stage2_huge_mapping()?  Let it do
some checks for us.

fault_supports_stage2_huge_mapping() was intended to do a *two-step*
check to tell us that can we create stage2 huge block mappings, and this
check is both for hugetlbfs and THP.  With commit a80868f398554842b14,
we pass PAGE_SIZE as "map_size" for normal size pages (which turned out
to be almost meaningless), and unfortunately the THP check no longer
works.

So we want to rework *THP* check process.  Your patch fixes the first
checking-step, but the second is still missed, am I wrong?

Can you please give a look at the below diff?


thanks,

zenghui

> ---
>   virt/kvm/arm/mmu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 27c9583..4a22f5b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>   		 * page accordingly.
>   		 */
>   		mask = PTRS_PER_PMD - 1;
> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
Somehow, I'd prefer keeping the VM_BUG_ON() here, let it report some
potential issues in the future (of course I hope none:) )
> +		/* Skip memslots with unaligned IPA and user address */
> +		if ((gfn & mask) != (pfn & mask))
> +			return false;
>   		if (pfn & mask) {
>   			*ipap &= PMD_MASK;
>   			kvm_release_pfn_clean(pfn);
> 

---8>---

Rework fault_supports_stage2_huge_mapping(), let it check THP again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
  virt/kvm/arm/mmu.c | 11 ++++++++++-
  1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..5e1b258 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1632,6 +1632,15 @@ static bool 
fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  	uaddr_end = uaddr_start + size;

  	/*
+	 * If the memslot is _not_ backed by hugetlbfs, then check if it
+	 * can be backed by transparent hugepages.
+	 *
+	 * Currently only PMD_SIZE THPs are supported, revisit it later.
+	 */
+	if (map_size == PAGE_SIZE)
+		map_size = PMD_SIZE;
+
+	/*
  	 * Pages belonging to memslots that don't have the same alignment
  	 * within a PMD/PUD for userspace and IPA cannot be mapped with stage-2
  	 * PMD/PUD entries, because we'll end up mapping the wrong pages.
@@ -1643,7 +1652,7 @@ static bool 
fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
  	 *    +-----+--------------------+--------------------+---+
  	 *
-	 *    memslot->base_gfn << PAGE_SIZE:
+	 *    memslot->base_gfn << PAGE_SHIFT:
  	 *      +---+--------------------+--------------------+-----+
  	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
  	 *      +---+--------------------+--------------------+-----+
-- 
