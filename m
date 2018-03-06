From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm: reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Tue, 6 Mar 2018 16:43:25 +0000
Message-ID: <4dbad5e5-8e62-4729-16f3-59ce1cfdd550@arm.com>
References: <20180306162646.7646-1-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180306162646.7646-1-peter.maydell@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

A couple of comments:

On 06/03/18 16:26, Peter Maydell wrote:
> We have a KVM_REG_ARM encoding that we use to expose KVM guest registers
> to userspace. Define that bit 28 in this encoding indicates secure vs
> nonsecure, so we can distinguish the secure and nonsecure banked versions
> of a banked AArch32 register.
> 
> For KVM currently, all guest registers are nonsecure, but defining
> the bit is useful for userspace. In particular, QEMU uses this
> encoding as part of its on-the-wire migration format, and needs to be
> able to describe secure-bank registers when it is migrating (fully
> emulated) EL3-enabled CPUs.
> 
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
> ---
>  arch/arm/include/uapi/asm/kvm.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 6edd177bb1c7..e0d742c36cb1 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -135,6 +135,11 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_CRM_SHIFT		7
>  #define KVM_REG_ARM_32_CRN_MASK		0x0000000000007800
>  #define KVM_REG_ARM_32_CRN_SHIFT	11
> +/* For KVM currently all guest registers are nonsecure, but we reserve a bit
> + * in the encoding to distinguish secure from nonsecure for banked registers.
> + */

Nit:

/*
 * This is the canonical comment style.
 */

It might be worth pointing out in the comment that this only applies to
AArch32 system registers that are banked by security.

> +#define KVM_REG_ARM_SECURE_MASK	0x0000000010000000
> +#define KVM_REG_ARM_SECURE_SHIFT	28
>  
>  #define ARM_CP15_REG_SHIFT_MASK(x,n) \
>  	(((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
> 

Don't you also need to define it on the arm64 side?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
