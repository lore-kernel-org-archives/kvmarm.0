From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: remove printing of vcpu address
Date: Fri, 13 Oct 2017 10:16:32 +0200
Message-ID: <20171013081632.GB8927@cbox>
References: <1507530701-10777-1-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507530701-10777-1-git-send-email-me@tobin.cc>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 05:31:41PM +1100, Tobin C. Harding wrote:
> Code currently prints the address of the kvm_vcpu structure in an error
> message. It is not immediately clear what value this address adds to
> the error string, we can use the vcpu ID instead. 

I would say it's not immediately clear how the vcpu ID is more valuable.
The pointer identifies a unique vcpu across all VMs, vcpu ID does not.

> Printing unnecessary
> kernel addresses to dmesg poses a security risk.

Is this really a concern we have for error messages?  I understand you
can get a single pointer revealed if you have broken hardware or if we
have a bug, but I see numerious other examples in the kernel.

If anything, we can remote printing the vcpu pointer entirely.


Thanks,
-Christoffer
> 
> Remove the address from error message output, show vcpu ID instead.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  virt/kvm/arm/arch_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 8e89d63005c7..ca6c331cad28 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -88,7 +88,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>  	 * interrupt at this point is a sure sign of some major
>  	 * breakage.
>  	 */
> -	pr_warn("Unexpected interrupt %d on vcpu %p\n", irq, vcpu);
> +	pr_warn("Unexpected interrupt %d on vcpu ID %d\n", irq, vcpu->vcpu_id);
>  	return IRQ_HANDLED;
>  }
>  
> -- 
> 2.7.4
> 
