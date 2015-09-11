From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/22] KVM: ARM64: Add a helper for CP15 registers
 reset to UNKNOWN
Date: Fri, 11 Sep 2015 11:17:55 +0100
Message-ID: <55F2AA53.40503@arm.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com> <1441961715-11688-6-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1441961715-11688-6-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/09/15 09:54, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index d411e25..a0b3811 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -104,6 +104,14 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
>  	vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
>  }
>  
> +static inline void reset_unknown_cp15(struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *r)
> +{

Oh, and given that you are using this as a function pointer in the next
patch, why is it an inline function?

Please merge this with patch #6.

	M.
-- 
Jazz is not dead. It just smells funny...
