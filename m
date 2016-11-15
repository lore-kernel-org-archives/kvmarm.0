From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: clean up useless code in kvm_timer_enable
Date: Tue, 15 Nov 2016 12:41:51 +0100
Message-ID: <20161115114151.GA3811@cbox>
References: <1478659814-364872-1-git-send-email-longpeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 385E8401E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2016 06:41:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJdS-0hwBSKB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2016 06:41:27 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAA2440102
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2016 06:41:26 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id a197so161132785wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2016 03:41:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1478659814-364872-1-git-send-email-longpeng2@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Longpeng(Mike)" <longpeng2@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, wu.wubin@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 09, 2016 at 10:50:14AM +0800, Longpeng(Mike) wrote:
> 1) Since commit:41a54482 changed timer enabled variable to per-vcpu,
>    the correlative comment in kvm_timer_enable is useless now.
> 
> 2) After the kvm module init successfully, the timecounter is always
>    non-null, so we can remove the checking of timercounter.
> 
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/arch_timer.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 27a1f63..17b8fa5 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -498,17 +498,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		return ret;
>  
> -
> -	/*
> -	 * There is a potential race here between VCPUs starting for the first
> -	 * time, which may be enabling the timer multiple times.  That doesn't
> -	 * hurt though, because we're just setting a variable to the same
> -	 * variable that it already was.  The important thing is that all
> -	 * VCPUs have the enabled variable set, before entering the guest, if
> -	 * the arch timers are enabled.
> -	 */
> -	if (timecounter)
> -		timer->enabled = 1;
> +	timer->enabled = 1;
>  
>  	return 0;
>  }
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
