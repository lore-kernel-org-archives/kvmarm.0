From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2] KVM: arm: reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Thu, 15 Mar 2018 17:57:23 +0000
Message-ID: <CAFEAcA-p-N6eF4LpDVfXOM4niBZTEyZi+Xg6RnjM7a5RQk+WCw@mail.gmail.com>
References: <20180306194741.30395-1-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38ED04029E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:50:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s6fcTpIM2VMr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 13:50:08 -0400 (EDT)
Received: from mail-ot0-f196.google.com (mail-ot0-f196.google.com
 [74.125.82.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D913402D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:50:08 -0400 (EDT)
Received: by mail-ot0-f196.google.com with SMTP id r30-v6so7786585otr.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 10:57:44 -0700 (PDT)
In-Reply-To: <20180306194741.30395-1-peter.maydell@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 6 March 2018 at 19:47, Peter Maydell <peter.maydell@linaro.org> wrote:
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
> v1->v2: expanded comment

Ping -- is this version OK, Marc?

> ---
>  arch/arm/include/uapi/asm/kvm.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 6edd177bb1c7..2ba95d6fe852 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -135,6 +135,15 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_CRM_SHIFT          7
>  #define KVM_REG_ARM_32_CRN_MASK                0x0000000000007800
>  #define KVM_REG_ARM_32_CRN_SHIFT       11
> +/*
> + * For KVM currently all guest registers are nonsecure, but we reserve a bit
> + * in the encoding to distinguish secure from nonsecure for AArch32 system
> + * registers that are banked by security. This is 1 for the secure banked
> + * register, and 0 for the nonsecure banked register or if the register is
> + * not banked by security.
> + */
> +#define KVM_REG_ARM_SECURE_MASK        0x0000000010000000
> +#define KVM_REG_ARM_SECURE_SHIFT       28
>
>  #define ARM_CP15_REG_SHIFT_MASK(x,n) \
>         (((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
> --
> 2.16.2

thanks
-- PMM
