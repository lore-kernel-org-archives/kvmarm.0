From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: ARM64: fix phy counter access failure in guest.
Date: Mon, 12 Jun 2017 10:08:16 +0100
Message-ID: <71600c75-79e0-1043-2b75-2c96a6e24c58@arm.com>
References: <20170612143748.37278-1-huhuajun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170612143748.37278-1-huhuajun@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hu Huajun <huhuajun@huawei.com>, christoffer.dall@linaro.org, rkrcmar@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, songwenjun@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Nit: Please fix the time on your machine. It ended up in my Spam folder
because it comes from the future...

On 12/06/17 15:37, Hu Huajun wrote:
> When reading the cntpct_el0 in guest with VHE (Virtual Host Extension)
> enabled in host, the "Unsupported guest sys_reg access" error reported.
> The reason is cnthctl_el2.EL1PCTEN is not enabled, which is expected
> to be done in kvm_timer_init_vhe(). The problem is kvm_timer_init_vhe
> is called by cpu_init_hyp_mode, and which is called when VHE is disabled.
> This patch remove the incorrect call to kvm_timer_init_vhe() from
> cpu_init_hyp_mode(), and calls kvm_timer_init_vhe() to enable
> cnthctl_el2.EL1PCTEN in cpu_hyp_reinit().
> 
> Changes from v1:
> * According to Christoffer Dall's comment, remove the incocrrect call
> to kvm_timer_init_vhe() in cpu_init_hyp_mode().
> 
> Signed-off-by: Hu Huajun <huhuajun@huawei.com>
> ---
>  virt/kvm/arm/arm.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3417e18..a430125 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1115,9 +1115,6 @@ static void cpu_init_hyp_mode(void *dummy)
>  	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
>  	__cpu_init_stage2();
>  
> -	if (is_kernel_in_hyp_mode())
> -		kvm_timer_init_vhe();
> -
>  	kvm_arm_init_debug();
>  }
>  
> @@ -1137,6 +1134,7 @@ static void cpu_hyp_reinit(void)
>  		 * event was cancelled before the CPU was reset.
>  		 */
>  		__cpu_init_stage2();
> +		kvm_timer_init_vhe();
>  	} else {
>  		cpu_init_hyp_mode(NULL);
>  	}
> 

How about:

Cc: stable@vger.kernel.org
Fixes: 488f94d7212b ("KVM: arm64: Access CNTHCTL_EL2 bit fields
correctly on VHE systems")

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
