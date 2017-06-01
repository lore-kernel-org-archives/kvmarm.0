From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 11/11] KVM: arm/arm64: timer: remove request-less vcpu
 kick
Date: Thu, 1 Jun 2017 12:34:54 +0200
Message-ID: <20170601103454.GA20919@cbox>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-12-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBE9740430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:31:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uRFHoQQCtHVH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 06:31:13 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FB5F40296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:31:13 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id 7so152221867wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jun 2017 03:35:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170516022035.7674-12-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 16, 2017 at 04:20:35AM +0200, Andrew Jones wrote:
> The timer work is only scheduled for a VCPU when that VCPU is
> blocked. This means we only need to wake it up, not kick (IPI)
> it. While calling kvm_vcpu_kick() would just do the wake up,
> and not kick, anyway, let's change this to avoid request-less
> vcpu kicks, as they're generally not a good idea (see
> "Request-less VCPU Kicks" in
> Documentation/virtual/kvm/vcpu-requests.rst)
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  virt/kvm/arm/arch_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 5976609ef27c..c9cd56f39b1e 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -95,7 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	 * If the vcpu is blocked we want to wake it up so that it will see
>  	 * the timer has expired when entering the guest.
>  	 */
> -	kvm_vcpu_kick(vcpu);
> +	swake_up(kvm_arch_vcpu_wq(vcpu));

We have kvm_vcpu_wake_up().  Why not use that?

Thanks,
-Christoffer

>  }
>  
>  static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
> -- 
> 2.9.3
> 
