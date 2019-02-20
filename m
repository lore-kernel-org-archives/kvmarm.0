From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 12/26] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Wed, 20 Feb 2019 15:37:26 +0000
Message-ID: <20190220153726.GF4763@lakrids.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41F424A2E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:37:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EkMed1K5MoGq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 10:37:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6BED4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:37:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 18, 2019 at 07:52:25PM +0000, Dave Martin wrote:
> Some optional features of the Arm architecture add new system
> registers that are not present in the base architecture.
> 
> Where these features are optional for the guest, the visibility of
> these registers may need to depend on some runtime configuration,
> such as a flag passed to KVM_ARM_VCPU_INIT.
> 
> For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
> is not enabled for the guest, even though these registers may be
> present in the hardware and visible to the host at EL2.
> 
> Adding special-case checks all over the place for individual
> registers is going to get messy as the number of conditionally-
> visible registers grows.
> 
> In order to help solve this problem, this patch adds a new sysreg
> method restrictions() that can be used to hook in any needed
> runtime visibility checks.  This method can currently return
> REG_NO_USER to inhibit enumeration and ioctl access to the register
> for userspace, and REG_NO_GUEST to inhibit runtime access by the
> guest using MSR/MRS.
> 
> This allows a conditionally modified view of individual system
> registers such as the CPU ID registers, in addition to completely
> hiding register where appropriate.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> Changes since v4:
> 
>  * Move from a boolean sysreg property that just suppresses register
>    enumeration via KVM_GET_REG_LIST, to a multi-flag property that
>    allows independent runtime control of MRS/MSR and user ioctl access.
> 
>    This allows registers to be either hidden completely, or to have
>    hybrid behaviours (such as the not-enumerated, RAZ, WAZ behaviour of
>    "non-present" CPU ID regs).

Sorry for bikeshedding...

> +	/* Check for regs disabled by runtime config */
> +	if (restrictions(vcpu, r) & REG_NO_GUEST) {

Maybe it's worth wrapping this as something like

	reg_runtime_hidden_from_guest(vcpu, r)

... and avoid exposing the raw flags to all the places we have to check?

[...]

> +#define REG_NO_USER	(1 << 0) /* hidden from userspace ioctl interface */
> +#define REG_NO_GUEST	(1 << 1) /* hidden from guest */

Perhaps REG_USER_HIDDEN and REG_GUEST_HIDDEN?

Thanks,
Mark.
