From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 11/11] KVM: arm/arm64: timer: remove request-less vcpu
 kick
Date: Sun, 4 Jun 2017 16:52:18 +0200
Message-ID: <20170604145218.GE9464@cbox>
References: <20170604124401.24902-1-drjones@redhat.com>
 <20170604124401.24902-12-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170604124401.24902-12-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jun 04, 2017 at 02:44:01PM +0200, Andrew Jones wrote:
> The timer work is only scheduled for a VCPU when that VCPU is
> blocked. This means we only need to wake it up, not kick (IPI)
> it. While calling kvm_vcpu_kick() would just do the wake up,
> and not kick, anyway, let's change this to avoid request-less
> vcpu kicks, as they're generally not a good idea (see
> "Request-less VCPU Kicks" in
> Documentation/virtual/kvm/vcpu-requests.rst)
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  virt/kvm/arm/arch_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 5976609ef27c..7933b1f8f7b7 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -95,7 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	 * If the vcpu is blocked we want to wake it up so that it will see
>  	 * the timer has expired when entering the guest.
>  	 */
> -	kvm_vcpu_kick(vcpu);
> +	kvm_vcpu_wake_up(vcpu);
>  }
>  
>  static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
> -- 
> 2.9.4
> 
