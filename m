From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 03/10] KVM: arm: guest debug, define API headers
Date: Mon, 13 Apr 2015 14:08:13 +0200
Message-ID: <20150413120813.GN6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:01PM +0100, Alex Benn=E9e wrote:
> This commit defines the API headers for guest debugging. There are tw=
o
> architecture specific debug structures:
>=20
>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>   - kvm_debug_exit_arch, signals the exact debug exit and pc
>=20
> The type of debugging being used is control by the architecture speci=
fic
> control bits of the kvm_guest_debug->control flags in the ioctl
> structure.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2
>    - expose hsr and pc directly to user-space
>=20
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index 3ef77a4..6ee70a0 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -100,10 +100,24 @@ struct kvm_sregs {
>  struct kvm_fpu {
>  };
> =20
> +/*
> + * See ARM ARM D7.3: Debug Registers

see the ARM ARM for ??

> + *
> + * The control registers are architecturally defined as 32 bits but =
are
> + * stored as 64 bit values along side the value registers and aligne=
d

do you mean alongside?

> + * with the rest 64 bit registers in the normal CPU context.

rest of the 64 bit

> + */

why do we store them as 64 bit values?  There's nothing prevented us
from defining them as __u32 is there?  Is this to make the ONE_REG
interface accessers more convenient?

> +#define KVM_ARM_NDBG_REGS 16

nit: is NDBG short for something I don't know about or is it
the number of debug registers we are noting here, in which case I think
KVM_ARM_NUM_DBG_REGS is more clear.

>  struct kvm_guest_debug_arch {
> +	__u64 dbg_bcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_bvr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wvr[KVM_ARM_NDBG_REGS];
>  };
> =20
>  struct kvm_debug_exit_arch {
> +	__u64 pc;
> +	__u32 hsr;
>  };
> =20
>  struct kvm_sync_regs {
> @@ -207,4 +221,11 @@ struct kvm_arch_memory_slot {
> =20
>  #endif
> =20
> +/*
> + * Architecture related debug defines - upper 16 bits of
> + * kvm_guest_debug->control
> + */
> +#define KVM_GUESTDBG_USE_SW_BP	        __KVM_GUESTDBG_USE_SW_BP
> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> +
>  #endif /* __ARM_KVM_H__ */
> --=20
> 2.3.4
>=20

Thanks,
-Christoffer
