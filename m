From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 8 May 2015 11:28:44 +0200
Message-ID: <20150508092844.GC24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430929407-3487-4-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 06, 2015 at 05:23:18PM +0100, Alex Benn=E9e wrote:
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
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
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
>=20
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index d268320..04957d7 100644
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
> +	__u64 dbg_bcr[KVM_ARM_MAX_DBG_REGS];
> +	__u64 dbg_bvr[KVM_ARM_MAX_DBG_REGS];
> +	__u64 dbg_wcr[KVM_ARM_MAX_DBG_REGS];
> +	__u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
>  };
> =20
>  struct kvm_debug_exit_arch {
> +	__u32 hsr;
> +	__u64 far;
>  };
> =20
>  struct kvm_sync_regs {
> @@ -216,4 +234,11 @@ struct kvm_arch_memory_slot {
> =20
>  #endif
> =20
> +/*
> + * Architecture related debug defines - upper 16 bits of

"Architecture specific debug control flags" seems more accurate.

> + * kvm_guest_debug->control
> + */
> +#define KVM_GUESTDBG_USE_SW_BP	        __KVM_GUESTDBG_USE_SW_BP
> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> +
>  #endif /* __ARM_KVM_H__ */
> --=20
> 2.3.5
>=20

Otherwise:
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,
-Christoffer
