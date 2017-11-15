From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 24/37] KVM: arm64: Prepare to handle traps on deferred EL0
 sysregs
Date: Wed, 15 Nov 2017 09:25:08 +0000
Message-ID: <ff71a471-4a16-806c-c355-15bf778c7d98@arm.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-25-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171012104141.26902-25-christoffer.dall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/10/17 11:41, Christoffer Dall wrote:
> We can trap access to ACTLR_EL1 which we can later defer to only
> save/restore during vcpu_load and vcpu_put, so let's read the value
> directly from the CPU when necessary.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   arch/arm64/kvm/sys_regs_generic_v8.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 969ade1..348f227 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -38,7 +38,10 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
>   	if (p->is_write)
>   		return ignore_write(vcpu, p);
>   
> -	p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
> +	if (vcpu->arch.sysregs_loaded_on_cpu)
> +		read_sysreg(actlr_el1);

Did you mean "p->regval = read_sysreg(actlr_el1);" ?

> +	else
> +		p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
>   	return true;
>   }
>   
> 

-- 
Julien Thierry
