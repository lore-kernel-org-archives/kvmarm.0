From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PATCH] kvm-arm: Unmap shadow pagetables properly
Date: Fri, 9 Sep 2016 15:02:58 +0900
Message-ID: <57D25092.4050503@riken.jp>
References: <1473348349-5011-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2854113E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 01:54:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Gwr1oFR3n+v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 01:54:30 -0400 (EDT)
Received: from postman.riken.jp (postman1.riken.jp [134.160.33.83])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75A0410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 01:54:29 -0400 (EDT)
In-Reply-To: <1473348349-5011-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VM now shuts down normally on Mustang backed by DEBUG_PAGEALLOC=y
4.8.0-rc5 kernel.

On 9/9/16 12:25 AM, Suzuki K Poulose wrote:
> On arm/arm64, we depend on the kvm_unmap_hva* callbacks (via
> mmu_notifiers::invalidate_*) to unmap the stage2 pagetables when
> the userspace buffer gets unmapped. However, when the Hypervisor
> process exits without explicit unmap of the guest buffers, the only
> notifier we get is kvm_arch_flush_shadow_all() (via mmu_notifier::release
> ) which does nothing on arm. Later this causes us to access pages that
> were already released [via exit_mmap() -> unmap_vmas()] when we actually
> get to unmap the stage2 pagetable [via kvm_arch_destroy_vm() ->
> kvm_free_stage2_pgd()]. This triggers crashes with CONFIG_DEBUG_PAGEALLOC,
> which unmaps any free'd pages from the linear map.
>
>   [  757.644120] Unable to handle kernel paging request at virtual address
>    ffff800661e00000
>   [  757.652046] pgd = ffff20000b1a2000
>   [  757.655471] [ffff800661e00000] *pgd=00000047fffe3003, *pud=00000047fcd8c003,
>    *pmd=00000047fcc7c003, *pte=00e8004661e00712
>   [  757.666492] Internal error: Oops: 96000147 [#3] PREEMPT SMP
>   [  757.672041] Modules linked in:
>   [  757.675100] CPU: 7 PID: 3630 Comm: qemu-system-aar Tainted: G      D
>   4.8.0-rc1 #3
>   [  757.683240] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene Mustang Board,
>    BIOS 3.06.15 Aug 19 2016
>   [  757.692938] task: ffff80069cdd3580 task.stack: ffff8006adb7c000
>   [  757.698840] PC is at __flush_dcache_area+0x1c/0x40
>   [  757.703613] LR is at kvm_flush_dcache_pmd+0x60/0x70
>   [  757.708469] pc : [<ffff20000809dbdc>] lr : [<ffff2000080b4a70>] pstate: 20000145
>   ...
>   [  758.357249] [<ffff20000809dbdc>] __flush_dcache_area+0x1c/0x40
>   [  758.363059] [<ffff2000080b6748>] unmap_stage2_range+0x458/0x5f0
>   [  758.368954] [<ffff2000080b708c>] kvm_free_stage2_pgd+0x34/0x60
>   [  758.374761] [<ffff2000080b2280>] kvm_arch_destroy_vm+0x20/0x68
>   [  758.380570] [<ffff2000080aa330>] kvm_put_kvm+0x210/0x358
>   [  758.385860] [<ffff2000080aa524>] kvm_vm_release+0x2c/0x40
>   [  758.391239] [<ffff2000082ad234>] __fput+0x114/0x2e8
>   [  758.396096] [<ffff2000082ad46c>] ____fput+0xc/0x18
>   [  758.400869] [<ffff200008104658>] task_work_run+0x108/0x138
>   [  758.406332] [<ffff2000080dc8ec>] do_exit+0x48c/0x10e8
>   [  758.411363] [<ffff2000080dd5fc>] do_group_exit+0x6c/0x130
>   [  758.416739] [<ffff2000080ed924>] get_signal+0x284/0xa18
>   [  758.421943] [<ffff20000808a098>] do_signal+0x158/0x860
>   [  758.427060] [<ffff20000808aad4>] do_notify_resume+0x6c/0x88
>   [  758.432608] [<ffff200008083624>] work_pending+0x10/0x14
>   [  758.437812] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
>
> This patch fixes the issue by moving the kvm_free_stage2_pgd() to
> kvm_arch_flush_shadow_all().
>
> Reported-by: Itaru Kitayama <itaru.kitayama@riken.jp>
> Reported-by: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm/kvm/arm.c | 2 --
>   arch/arm/kvm/mmu.c | 1 +
>   2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 75f130e..c94b90d 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -158,8 +158,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   {
>   	int i;
>   
> -	kvm_free_stage2_pgd(kvm);
> -
>   	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>   		if (kvm->vcpus[i]) {
>   			kvm_arch_vcpu_free(kvm->vcpus[i]);
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 29d0b23..d626d08 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1893,6 +1893,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslots *slots)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> +	kvm_free_stage2_pgd(kvm);
>   }
>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
