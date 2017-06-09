From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: ARM64: fix phy counter access failure in guest.
Date: Fri, 9 Jun 2017 10:41:34 +0200
Message-ID: <20170609084134.GC6378@cbox>
References: <20170609162220.1460-1-huhuajun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FAAA4095A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 04:37:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aFJtx34X-pux for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 04:37:26 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D61AB40948
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 04:37:25 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id d64so1880959wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Jun 2017 01:41:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170609162220.1460-1-huhuajun@huawei.com>
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

On Sat, Jun 10, 2017 at 12:22:20AM +0800, Hu Huajun wrote:
> When reading the cntpct_el0 in guest with VHE (Virtual Host Extension)
> enabled in host, the "Unsupported guest sys_reg access" error reported.
> The reason is cnthctl_el2.EL1PCTEN is not enabled, which is expected
> to be done in kvm_timer_init_vhe(). The problem is kvm_timer_init_vhe
> is called by cpu_init_hyp_mode, and which is called when VHE is disabled.
> This patch calls kvm_timer_init_vhe() to enable cnthctl_el2.EL1PCTEN
> in cpu_hyp_reinit().
> 
> Signed-off-by: Hu Huajun <huhuajun@huawei.com>
> ---
>  virt/kvm/arm/arm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3417e18..b703741 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1137,6 +1137,7 @@ static void cpu_hyp_reinit(void)
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

Could you rework this patch to remove the incorrect call to
kvm_timer_init_vhe() from cpu_init_hyp_mode() as well?

Thanks,
-Christoffer
