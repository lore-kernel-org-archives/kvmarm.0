From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: ARM64: fix phy counter access failure in guest.
Date: Mon, 12 Jun 2017 10:22:52 +0200
Message-ID: <20170612082252.GA14808@cbox>
References: <20170612143748.37278-1-huhuajun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C42FE40625
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jun 2017 04:18:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rSry92iGfusC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jun 2017 04:18:36 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B93B340187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jun 2017 04:18:36 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id q97so87477562wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jun 2017 01:22:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170612143748.37278-1-huhuajun@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Hu Huajun <huhuajun@huawei.com>
Cc: songwenjun@huawei.com, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Mon, Jun 12, 2017 at 10:37:48PM +0800, Hu Huajun wrote:
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

In the future please put the changelog after the '---' delimeter,
because it doesn't have to be part of the commit log.

I can fix this up when applying though.

> 
> Signed-off-by: Hu Huajun <huhuajun@huawei.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

Applied.

Thanks,
-Christoffer

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
> -- 
> 2.10.1
> 
