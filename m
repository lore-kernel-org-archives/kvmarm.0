From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 11/26] KVM: arm64: Extend reset_unknown() to handle
 mixed RES0/UNKNOWN registers
Date: Fri, 22 Feb 2019 16:04:01 +0000
Message-ID: <a77d3eb5-58a2-5c1a-95b5-e3d54804e5ac@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1550519559-15915-12-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/02/2019 19:52, Dave Martin wrote:
> The reset_unknown() system register helper initialises a guest
> register to a distinctive junk value on vcpu reset, to help expose
> and debug deficient register initialisation within the guest.
> 
> Some registers such as the SVE control register ZCR_EL1 contain a
> mixture of UNKNOWN fields and RES0 bits.  For these,
> reset_unknown() does not work at present, since it sets all bits to
> junk values instead of just the wanted bits.
> 
> There is no need to craft another special helper just for that,
> since reset_unknown() almost does the appropriate thing anyway.
> This patch takes advantage of the unused val field in struct
> sys_reg_desc to specify a mask of bits that should be initialised
> to zero instead of junk.
> 
> All existing users of reset_unknown() do not (and should not)
> define a value for val, so they will implicitly set it to zero,
> resulting in all bits being made UNKNOWN by this function: thus,
> this patch makes no functional change for currently defined
> registers.
> 
> Future patches will make use of non-zero val.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Reviewed-by: Julien Grall <julien.grall@arm.com>

Cheers,

> ---
>   arch/arm64/kvm/sys_regs.h | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 3b1bc7f..174ffc0 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -56,7 +56,12 @@ struct sys_reg_desc {
>   	/* Index into sys_reg[], or 0 if we don't need to save it. */
>   	int reg;
>   
> -	/* Value (usually reset value) */
> +	/*
> +	 * Value (usually reset value)
> +	 * For reset_unknown, each bit set to 1 in val is treated as
> +	 * RES0 in the register: the corresponding register bit is
> +	 * reset to 0 instead of "unknown".
> +	 */
>   	u64 val;
>   
>   	/* Custom get/set_user functions, fallback to generic if NULL */
> @@ -92,7 +97,9 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
>   {
>   	BUG_ON(!r->reg);
>   	BUG_ON(r->reg >= NR_SYS_REGS);
> -	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
> +
> +	/* If non-zero, r->val specifies which register bits are RES0: */
> +	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL & ~r->val;
>   }
>   
>   static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> 

-- 
Julien Grall
