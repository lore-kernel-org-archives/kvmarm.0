From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [patch] arm64: KVM: clean up a condition
Date: Thu, 14 Jul 2016 14:33:25 +0100
Message-ID: <578794A5.3000701@arm.com>
References: <20160714101934.GD18175@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160714101934.GD18175@mwanda>
Sender: kvm-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/16 11:19, Dan Carpenter wrote:
> My static checker complains that this condition looks like it should be
> == instead of =.  This isn't a fast path, so we don't need to be fancy.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a57d650..b0b225c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1546,7 +1546,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
>  				struct sys_reg_params *params)
>  {
>  	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
> -	int cp;
> +	int cp = -1;
>  
>  	switch(hsr_ec) {
>  	case ESR_ELx_EC_CP15_32:
> @@ -1558,7 +1558,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
>  		cp = 14;
>  		break;
>  	default:
> -		WARN_ON((cp = -1));
> +		WARN_ON(1);
>  	}
>  
>  	kvm_err("Unsupported guest CP%d access at: %08lx\n",
> 

Indeed, that looks a bit dodgy. I'll queue it for 4.8.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
