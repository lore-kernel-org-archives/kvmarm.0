From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 0/2] arm64: add vtimer test
Date: Tue, 4 Jul 2017 19:29:39 +0200
Message-ID: <85cdaadf-1980-6de5-326a-8976c2236ddd@redhat.com>
References: <20170704135838.9061-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 161F840D2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 13:29:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SYqcDRRbFTG9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jul 2017 13:29:22 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CBE440D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 13:29:21 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id j85so27697623wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jul 2017 10:29:43 -0700 (PDT)
In-Reply-To: <20170704135838.9061-1-drjones@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/07/2017 15:58, Andrew Jones wrote:
> Add a test for the vtimer. I've tested on
>  accel=tcg
>  accel=kvm,kernel-irqchip=on  : on thunderx, seattle, and mustang
>  accel=kvm,kernel-irqchip=off : on thunderx and mustang
> 
> It works everywhere without modification except on mustang. My mustang
> seems to have a hardware problem requiring bit 31 of CNTV_CVAL_EL0
> to be clear before attempting to enable (setting CNTV_CTL_EL0.ENABLE),
> otherwise the VCPU hangs... My mustang's CNTV_CVAL_EL0 also has the
> strange issue of not being able to set the upper 8 bits.  Well, fixing
> hardware is outside my job description, so "oh, well..." If you hit
> the same problem, try the hack below, which allows tests to run and
> pass for me.

Applied and pushed, thanks.

Paolo

> diff --git a/arm/timer.c b/arm/timer.c
> index 89f4c9400ab69..18b8c4773c92f 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -73,7 +73,7 @@ static void test_vtimer(void)
>  	report_prefix_push("vtimer-busy-loop");
>  
>  	/* Enable the timer */
> -	write_sysreg(~0, cntv_cval_el0);
> +	write_sysreg(~0 & ~(1<<31), cntv_cval_el0);
>  	isb();
>  	write_sysreg(CNTV_CTL_ENABLE, cntv_ctl_el0);
>  
> 
> Alexander Graf (1):
>   arm64: add vtimer test
> 
> Andrew Jones (1):
>   arm64: timer: check for vtimer interrupt
> 
>  arm/Makefile.arm64 |   2 +-
>  arm/timer.c        | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg  |   6 +++
>  lib/arm/asm/gic.h  |   4 ++
>  4 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 arm/timer.c
> 
