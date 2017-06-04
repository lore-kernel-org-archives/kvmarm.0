From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 03/25] KVM: arm64: Make kvm_condition_valid32()
 accessible from EL2
Date: Sun, 4 Jun 2017 14:11:29 +0200
Message-ID: <20170604121129.GB9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-4-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:20:55AM +0100, Marc Zyngier wrote:
> As we're about to trap CP15 accesses and handle them at EL2, we
> need to evaluate whether or not the condition flags are valid,
> as an implementation is allowed to trap despite the condition
> not being met.
> 
> Tagging the function as __hyp_text allows this.

is the cc_map also guaranteed to work (by simple reference) in EL2 then?


Thanks,
-Christoffer

> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/aarch32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> index 528af4b2d09e..79c7c357804b 100644
> --- a/virt/kvm/arm/aarch32.c
> +++ b/virt/kvm/arm/aarch32.c
> @@ -60,7 +60,7 @@ static const unsigned short cc_map[16] = {
>  /*
>   * Check if a trapped instruction should have been executed or not.
>   */
> -bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
> +bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
>  {
>  	unsigned long cpsr;
>  	u32 cpsr_cond;
> -- 
> 2.11.0
> 
