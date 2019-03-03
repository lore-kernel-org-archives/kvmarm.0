From: Zenghui Yu <zenghuiyu96@gmail.com>
Subject: Re: [RFC PATCH] KVM: arm64: Force a PTE mapping when logging is
 enabled
Date: Sun, 3 Mar 2019 23:14:38 +0800
Message-ID: <CAKcZhuWa4UcsoFPRkZg=M3WeUJibX8T0_R+JHS3=cyd51N9cgQ@mail.gmail.com>
References: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: julien.thierry@arm.com, Punit Agrawal <punit.agrawal@arm.com>, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, wanghaibin.wang@huawei.com, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

I think there're still some problems in this patch... Details below.

On Sat, Mar 2, 2019 at 11:39 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> The idea behind this is: we don't want to keep tracking of huge pages when
> logging_active is true, which will result in performance degradation.  We
> still need to set vma_pagesize to PAGE_SIZE, so that we can make use of it
> to force a PTE mapping.
>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>
> ---
> Atfer looking into https://patchwork.codeaurora.org/patch/647985/ , the
> "vma_pagesize = PAGE_SIZE" logic was not intended to be deleted. As far
> as I can tell, we used to have "hugetlb" to force the PTE mapping, but
> we have "vma_pagesize" currently instead. We should set it properly for
> performance reasons (e.g, in VM migration). Did I miss something important?
>
> ---
>  virt/kvm/arm/mmu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 30251e2..7d41b16 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1705,6 +1705,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>              (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>             !force_pte) {
>                 gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> +       } else {
> +               /*
> +                * Fallback to PTE if it's not one of the stage2
> +                * supported hugepage sizes or the corresponding level
> +                * doesn't exist, or logging is enabled.

First, Instead of "logging is enabled", it should be "force_pte is true",
since "force_pte" will be true when:

        1) fault_supports_stage2_pmd_mappings() return false; or
        2) "logging is enabled" (e.g, in VM migration).

Second, fallback some unsupported hugepage sizes (e.g, 64K hugepage with
4K pages) to PTE is somewhat strange. And it will then _unexpectedly_
reach transparent_hugepage_adjust(), though no real adjustment will happen
since commit fd2ef358282c ("KVM: arm/arm64: Ensure only THP is candidate
for adjustment"). Keeping "vma_pagesize" there as it is will be better,
right?

So I'd just simplify the logic like:

        } else if (force_pte) {
                vma_pagesize = PAGE_SIZE;
        }


Will send a V2 later and waiting for your comments :)


thanks,

zenghui


> +                */
> +               vma_pagesize = PAGE_SIZE;
>         }
>         up_read(&current->mm->mmap_sem);
>
> --
> 1.8.3.1
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
