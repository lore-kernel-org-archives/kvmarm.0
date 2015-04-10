From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 03/10] KVM: arm: guest debug, define API headers
Date: Fri, 10 Apr 2015 15:05:36 +0200
Message-ID: <20150410130535.GF3227@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E144C0FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 08:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E-nOVo4svljy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 08:58:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 646694C0F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 08:58:15 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:01PM +0100, Alex Benn=E9e wrote:
> This commit defines the API headers for guest debugging. There are two
> architecture specific debug structures:
> =

>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>   - kvm_debug_exit_arch, signals the exact debug exit and pc
> =

> The type of debugging being used is control by the architecture specific
controlled
> control bits of the kvm_guest_debug->control flags in the ioctl
> structure.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2
>    - expose hsr and pc directly to user-space
> =

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 3ef77a4..6ee70a0 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -100,10 +100,24 @@ struct kvm_sregs {
>  struct kvm_fpu {
>  };
>  =

> +/*
> + * See ARM ARM D7.3: Debug Registers
> + *
> + * The control registers are architecturally defined as 32 bits but are
> + * stored as 64 bit values along side the value registers and aligned
> + * with the rest 64 bit registers in the normal CPU context.
                   ^ of the
> + */
> +#define KVM_ARM_NDBG_REGS 16
>  struct kvm_guest_debug_arch {
> +	__u64 dbg_bcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_bvr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wvr[KVM_ARM_NDBG_REGS];
>  };
>  =

>  struct kvm_debug_exit_arch {
> +	__u64 pc;
> +	__u32 hsr;
>  };
>  =

>  struct kvm_sync_regs {
> @@ -207,4 +221,11 @@ struct kvm_arch_memory_slot {
>  =

>  #endif
>  =

> +/*
> + * Architecture related debug defines - upper 16 bits of
> + * kvm_guest_debug->control
> + */
> +#define KVM_GUESTDBG_USE_SW_BP	        __KVM_GUESTDBG_USE_SW_BP
> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> +
>  #endif /* __ARM_KVM_H__ */
> -- =

> 2.3.4
>

couple typo nits, otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>
