From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] arm64: KVM: Demote SVE and LORegion warnings to debug only
Date: Tue, 17 Apr 2018 13:25:50 +0200
Message-ID: <20180417112550.GA62042@C02W217FHV2R.local>
References: <20180417082356.19492-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6884A09A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Apr 2018 07:17:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jveJ3pFBWbQQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Apr 2018 07:16:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774974A055
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Apr 2018 07:16:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180417082356.19492-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 17, 2018 at 09:23:56AM +0100, Marc Zyngier wrote:
> While generating a message about guests probing for SVE/LORegions
> is a useful debugging tool, considering it an error is slightly
> over the top, as this is the only way the guest can find out
> about the presence of the feature.
> 
> Let's turn these message into kvm_debug so that they can only
> be seen if CONFIG_DYNAMIC_DEBUG, and kept quiet otherwise.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  arch/arm64/kvm/sys_regs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 806b0b126a64..6e3b969391fd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -996,14 +996,12 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  
>  	if (id == SYS_ID_AA64PFR0_EL1) {
>  		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> -			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
> -				    task_pid_nr(current));
> +			kvm_debug("SVE unsupported for guests, suppressing\n");
>  
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  	} else if (id == SYS_ID_AA64MMFR1_EL1) {
>  		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
> -			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
> -				    task_pid_nr(current));
> +			kvm_debug("LORegions unsupported for guests, suppressing\n");
>  
>  		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
>  	}
> -- 
> 2.14.2
> 
