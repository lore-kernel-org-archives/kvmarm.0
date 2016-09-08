From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: arch_timer: remove unused error handling
Date: Thu, 8 Sep 2016 16:25:25 +0200
Message-ID: <20160908142525.GB9940@cbox>
References: <20160908135908.1312349-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59906412A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 10:14:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XOc02nDNAul5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 10:14:24 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1ECA411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 10:14:24 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id w12so92422043wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2016 07:22:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160908135908.1312349-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Thu, Sep 08, 2016 at 03:58:44PM +0200, Arnd Bergmann wrote:
> A cleanup removed the call to create_singlethread_workqueue(), but did not
> remove the code that was used in case it failed:
> 
> virt/kvm/arm/arch_timer.c: In function 'kvm_timer_hyp_init':
> virt/kvm/arm/arch_timer.c:457:1: error: label 'out_free' defined but not used [-Werror=unused-label]
> 
> This removes the now dead code too.

Paolo beat you to it:
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-September/021626.html

Thanks,
-Christoffer

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 3706feacd007 ("KVM: Remove deprecated create_singlethread_workqueue")
> ---
>  virt/kvm/arm/arch_timer.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4309b60ebf17..46980a49a3bb 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -453,9 +453,6 @@ int kvm_timer_hyp_init(void)
>  	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
>  			  "AP_KVM_ARM_TIMER_STARTING", kvm_timer_starting_cpu,
>  			  kvm_timer_dying_cpu);
> -	goto out;
> -out_free:
> -	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
>  out:
>  	return err;
>  }
> -- 
> 2.9.0
> 
