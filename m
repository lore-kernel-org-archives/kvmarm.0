From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 02/28] arm64: KVM: Hide unsupported AArch64 CPU
 features from guests
Date: Wed, 11 Oct 2017 15:14:44 +0100
Message-ID: <20171011141444.wj7qhlgwadntqmdk@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-3-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:19PM +0100, Dave P Martin wrote:
> Currently, a guest kernel sees the true CPU feature registers
> (ID_*_EL1) when it reads them using MRS instructions.  This means
> that the guest will observe features that are present in the
> hardware but the host doesn't understand or doesn't provide support
> for.  A guest may legimitately try to use such a feature as per the
> architecture, but use of the feature may trap instead of working
> normally, triggering undef injection into the guest.
> 
> This is not a problem for the host, but the guest may go wrong when
> running on newer hardware than the host knows about.
> 
> This patch hides from guest VMs any AArch64-specific CPU features
> that the host doesn't support, by exposing to the guest the
> sanitised versions of the registers computed by the cpufeatures
> framework, instead of the true hardware registers.  To achieve
> this, HCR_EL2.TID3 is now set for AArch64 guests, and emulation
> code is added to KVM to report the sanitised versions of the
> affected registers in response to MRS and register reads from
> userspace.
> 
> The affected registers are removed from invariant_sys_regs[] (since
> the invariant_sys_regs handling is no longer quite correct for
> them) and added to sys_reg_desgs[], with appropriate access(),
> get_user() and set_user() methods.  No runtime vcpu storage is
> allocated for the registers: instead, they are read on demand from
> the cpufeatures framework.  This may need modification in the
> future if there is a need for userspace to customise the features
> visible to the guest.
> 
> Attempts by userspace to write the registers are handled similarly
> to the current invariant_sys_regs handling: writes are permitted,
> but only if they don't attempt to change the value.  This is
> sufficient to support VM snapshot/restore from userspace.
> 
> Because of the additional registers, restoring a VM on an older
> kernel may not work unless userspace knows how to handle the extra
> VM registers exposed to the KVM user ABI by this patch.
> 
> Under the principle of least damage, this patch makes no attempt to
> handle any of the other registers currently in
> invariant_sys_regs[], or to emulate registers for AArch32: however,
> these could be handled in a similar way in future, as necessary.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h |   3 +
>  arch/arm64/kvm/hyp/switch.c     |   6 +
>  arch/arm64/kvm/sys_regs.c       | 282 +++++++++++++++++++++++++++++++++-------
>  3 files changed, 246 insertions(+), 45 deletions(-)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
