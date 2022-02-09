Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD7C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Feb 2022 16:41:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C112649EDE;
	Wed,  9 Feb 2022 11:41:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wGJyQpERZ18Q; Wed,  9 Feb 2022 11:41:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 149C249ED7;
	Wed,  9 Feb 2022 11:41:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C46F549E49
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 11:41:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MwkUyg+Chsl4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Feb 2022 11:41:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CA849E44
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 11:41:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 975E3ED1;
 Wed,  9 Feb 2022 08:41:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF7393F70D;
 Wed,  9 Feb 2022 08:41:04 -0800 (PST)
Date: Wed, 9 Feb 2022 16:41:20 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 30/64] KVM: arm64: nv: Configure HCR_EL2 for nested
 virtualization
Message-ID: <YgPusNvs86N4WEiw@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-31-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-31-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Fri, Jan 28, 2022 at 12:18:38PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> We enable nested virtualization by setting the HCR NV and NV1 bit.
> 
> When the virtual E2H bit is set, we can support EL2 register accesses
> via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
> better alternative, however, is to allow the virtual EL2 to access EL2
> register states without trap. This can be easily achieved by not traping
> EL1 registers since those registers already have EL2 register states.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h |  1 +
>  arch/arm64/kvm/hyp/vhe/switch.c  | 38 +++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 748c2b068d4e..d913c3fb5665 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -87,6 +87,7 @@
>  			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
>  			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>  			 HCR_FMO | HCR_IMO | HCR_PTW )
> +#define HCR_GUEST_NV_FILTER_FLAGS (HCR_ATA | HCR_API | HCR_APK)
>  #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
>  #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 1e6a00e7bfb3..28845f907cfc 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -35,9 +35,41 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  	u64 hcr = vcpu->arch.hcr_el2;
>  	u64 val;
>  
> -	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
> -	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> -		hcr |= HCR_TVM | HCR_TRVM;
> +	if (is_hyp_ctxt(vcpu)) {
> +		hcr |= HCR_NV;
> +
> +		if (!vcpu_el2_e2h_is_set(vcpu)) {
> +			/*
> +			 * For a guest hypervisor on v8.0, trap and emulate

That's confusing, because FEAT_NV is available from v8.3 and newer.

> +			 * the EL1 virtual memory control register accesses.
> +			 */

Wasn't the purpose of comment to explain why something is done instead of what
something does? The bits are explained in the Arm ARM. How about something like
this instead:

"A hypervisor running in non-VHE mode writes to EL1 the memory control registers
when preparing to run a guest or the host at EL1. Since virtual EL2 is emulated
on top of physical EL1, allowing the L1 guest hypervisor to access the registers
directly would lead to the L1 guest inadvertently corrupting its own state.

The NV1 bit is set to trap accesses to the registers which aren't controlled by
the TVM and TRVM bits, and to change to translation table format used by the
EL1&0 translation regime format to the EL2 translation regime format, which is
what the L1 guest hypervisor running with E2H = 0 expects when it creates the
tables".

> +			hcr |= HCR_TVM | HCR_TRVM | HCR_NV1;
> +		} else {
> +			/*
> +			 * For a guest hypervisor on v8.1 (VHE), allow to
> +			 * access the EL1 virtual memory control registers
> +			 * natively. These accesses are to access EL2 register
> +			 * states.
> +			 * Note that we still need to respect the virtual
> +			 * HCR_EL2 state.
> +			 */
> +			u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);

Nitpick: I think it would be better to name this variable virtual_hcr_el2,
because vhcr_el2 looks like a valid register name.

Thanks,
Alex

> +
> +			vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
> +
> +			/*
> +			 * We already set TVM to handle set/way cache maint
> +			 * ops traps, this somewhat collides with the nested
> +			 * virt trapping for nVHE. So turn this off for now
> +			 * here, in the hope that VHE guests won't ever do this.
> +			 * TODO: find out whether it's worth to support both
> +			 * cases at the same time.
> +			 */
> +			hcr &= ~HCR_TVM;
> +
> +			hcr |= vhcr_el2 & (HCR_TVM | HCR_TRVM);
> +		}
> +	}
>  
>  	___activate_traps(vcpu, hcr);
>  
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
