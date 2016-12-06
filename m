From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/1] arm64: Correcting format specifier for printing 64
 bit addresses
Date: Tue, 6 Dec 2016 16:43:19 +0000
Message-ID: <1b98f8e5-b450-5cfa-b217-ed88a4d8b278@arm.com>
References: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>, catalin.marinas@arm.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, cmetcalf@mellanox.com, panand@redhat.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, ard.biesheuvel@linaro.org, wangkefeng.wang@huawei.com
Cc: Vaneet Narang <v.narang@samsung.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ajeet.y@samsung.com, cpgs@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, pankaj.m@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

On 05/12/16 08:09, Maninder Singh wrote:
> This patch corrects format specifier for printing 64 bit addresses.
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Signed-off-by: Vaneet Narang <v.narang@samsung.com>
> ---
>  arch/arm64/kernel/signal.c |  2 +-
>  arch/arm64/kvm/sys_regs.c  |  8 ++++++--
>  arch/arm64/mm/fault.c      | 15 ++++++++++-----
>  arch/arm64/mm/mmu.c        |  4 ++--
>  4 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index c7b6de6..c89d5fd 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -155,7 +155,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
>  
>  badframe:
>  	if (show_unhandled_signals)
> -		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
> +		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%016llx sp=%016llx\n",
>  				    current->comm, task_pid_nr(current), __func__,
>  				    regs->pc, regs->sp);
>  	force_sig(SIGSEGV, current);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 87e7e66..89bf5c1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1554,8 +1554,12 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
>  		WARN_ON(1);
>  	}
>  
> -	kvm_err("Unsupported guest CP%d access at: %08lx\n",
> -		cp, *vcpu_pc(vcpu));
> +	if (params->is_32bit)
> +		kvm_err("Unsupported guest CP%d access at: %08lx\n",
> +			cp, *vcpu_pc(vcpu));
> +	else
> +		kvm_err("Unsupported guest CP%d access at: %016lx\n",
> +			cp, *vcpu_pc(vcpu));

As with the other patch - use '%0*lx' in these cases rather than
pointlessly duplicating everything.

Robin.

>  	print_sys_reg_instr(params);
>  	kvm_inject_undefined(vcpu);
>  }
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index a78a5c4..d96a42a 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -77,7 +77,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
>  
>  	pr_alert("pgd = %p\n", mm->pgd);
>  	pgd = pgd_offset(mm, addr);
> -	pr_alert("[%08lx] *pgd=%016llx", addr, pgd_val(*pgd));
> +	pr_alert("[%016lx] *pgd=%016llx", addr, pgd_val(*pgd));
>  
>  	do {
>  		pud_t *pud;
> @@ -177,7 +177,7 @@ static void __do_kernel_fault(struct mm_struct *mm, unsigned long addr,
>  	 * No handler, we'll have to terminate things with extreme prejudice.
>  	 */
>  	bust_spinlocks(1);
> -	pr_alert("Unable to handle kernel %s at virtual address %08lx\n",
> +	pr_alert("Unable to handle kernel %s at virtual address %016lx\n",
>  		 (addr < PAGE_SIZE) ? "NULL pointer dereference" :
>  		 "paging request", addr);
>  
> @@ -198,9 +198,14 @@ static void __do_user_fault(struct task_struct *tsk, unsigned long addr,
>  	struct siginfo si;
>  
>  	if (unhandled_signal(tsk, sig) && show_unhandled_signals_ratelimited()) {
> -		pr_info("%s[%d]: unhandled %s (%d) at 0x%08lx, esr 0x%03x\n",
> -			tsk->comm, task_pid_nr(tsk), fault_name(esr), sig,
> -			addr, esr);
> +		if (compat_user_mode(regs))
> +			pr_info("%s[%d]: unhandled %s (%d) at 0x%08lx, esr 0x%03x\n",
> +				tsk->comm, task_pid_nr(tsk), fault_name(esr), sig,
> +				addr, esr);
> +		else
> +			pr_info("%s[%d]: unhandled %s (%d) at 0x%016lx, esr 0x%03x\n",
> +				tsk->comm, task_pid_nr(tsk), fault_name(esr), sig,
> +				addr, esr);
>  		show_pte(tsk->mm, addr);
>  		show_regs(regs);
>  	}
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 17243e4..cbf444c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -683,9 +683,9 @@ void __init early_fixmap_init(void)
>  		pr_warn("pmd %p != %p, %p\n",
>  			pmd, fixmap_pmd(fix_to_virt(FIX_BTMAP_BEGIN)),
>  			fixmap_pmd(fix_to_virt(FIX_BTMAP_END)));
> -		pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
> +		pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %016lx\n",
>  			fix_to_virt(FIX_BTMAP_BEGIN));
> -		pr_warn("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
> +		pr_warn("fix_to_virt(FIX_BTMAP_END):   %016lx\n",
>  			fix_to_virt(FIX_BTMAP_END));
>  
>  		pr_warn("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
> 

