From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 15 May 2015 15:44:23 +0100
Message-ID: <20150515144423.GA23652@leverpostej>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 15, 2015 at 03:27:06PM +0100, Alex Benn=C3=A9e wrote:
> This commit defines the API headers for guest debugging. There are tw=
o
> architecture specific debug structures:
>=20
>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>   - kvm_debug_exit_arch, signals exception and possible faulting addr=
ess
>=20
> The type of debugging being used is controlled by the architecture
> specific control bits of the kvm_guest_debug->control flags in the io=
ctl
> structure.
>=20
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> ---
> v2
>    - expose hsr and pc directly to user-space
> v3
>    - s/control/controlled/ in commit message
>    - add v8 to ARM ARM comment (ARM Architecture Reference Manual)
>    - add rb tag
>    - rm pc, add far
>    - re-word comments on alignment
>    - rename KVM_ARM_NDBG_REGS -> KVM_ARM_MAX_DBG_REGS
> v4
>    - now uses common HW/SW BP define
>    - add a-b-tag
>    - use u32 for control regs
>=20
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index d268320..8796610 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -100,10 +100,28 @@ struct kvm_sregs {
>  struct kvm_fpu {
>  };
> =20
> +/*
> + * See v8 ARM ARM D7.3: Debug Registers
> + *
> + * The control registers are architecturally defined as 32 bits but =
are
> + * stored as 64 bit values alongside the value registers. This is do=
ne

Stale comment? They're stored as __u32 below.

It's possible that the registers could grow in future as happened in th=
e
case of CLIDR_EL1, so it might be worth treating system registers
generally as u64 values.

Mark.

> + * to keep the copying of these values into the vcpu context simple =
as
> + * everything is 64 bit aligned (see DBGBCR0_EL1 onwards in kvm_asm.=
h).
> + *
> + * The architectural limit is 16 debug registers of each type althou=
gh
> + * in practice there are usually less (see ID_AA64DFR0_EL1).
> + */
> +#define KVM_ARM_MAX_DBG_REGS 16
>  struct kvm_guest_debug_arch {
> +	__u32 dbg_bcr[KVM_ARM_MAX_DBG_REGS];
> +	__u64 dbg_bvr[KVM_ARM_MAX_DBG_REGS];
> +	__u32 dbg_wcr[KVM_ARM_MAX_DBG_REGS];
> +	__u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
>  };
> =20
>  struct kvm_debug_exit_arch {
> +	__u32 hsr;
> +	__u64 far;
>  };
> =20
>  struct kvm_sync_regs {
> --=20
> 2.3.5
>=20
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
