From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 17/22] arm64/kvm: Make use of the system wide safe
 values
Date: Sat, 10 Oct 2015 17:17:28 +0200
Message-ID: <20151010151728.GD29128@cbox>
References: <1444064531-25607-1-git-send-email-suzuki.poulose@arm.com>
 <1444064531-25607-18-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1549411E2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 11:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Y7piaHv81ZK for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Oct 2015 11:15:08 -0400 (EDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
 [209.85.217.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD94741145
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 11:15:07 -0400 (EDT)
Received: by lbbwt4 with SMTP id wt4so107171952lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 08:17:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444064531-25607-18-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, edward.nevill@linaro.org, aph@redhat.com, andre.przywara@arm.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 05, 2015 at 06:02:06PM +0100, Suzuki K. Poulose wrote:
> Use the system wide safe value from the new API for safer
> decisions
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kvm/reset.c    |    2 +-
>  arch/arm64/kvm/sys_regs.c |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 91cf535..f34745c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -53,7 +53,7 @@ static bool cpu_has_32bit_el1(void)
>  {
>  	u64 pfr0;
>  
> -	pfr0 = read_cpuid(ID_AA64PFR0_EL1);
> +	pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
>  	return !!(pfr0 & 0x20);
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d03d3af..87a64e8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -693,13 +693,13 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_cpuid(ID_AA64DFR0_EL1);
> -		u64 pfr = read_cpuid(ID_AA64PFR0_EL1);
> -		u32 el3 = !!((pfr >> 12) & 0xf);
> +		u64 dfr = read_system_reg(SYS_ID_AA64DFR0_EL1);
> +		u64 pfr = read_system_reg(SYS_ID_AA64PFR0_EL1);
> +		u32 el3 = !!cpuid_feature_extract_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
> -		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> 20) & 0xf) << 28) |
> -					  (((dfr >> 12) & 0xf) << 24) |
> -					  (((dfr >> 28) & 0xf) << 20) |
> +		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> +					  (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
> +					  (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20) |
>  					  (6 << 16) | (el3 << 14) | (el3 << 12));
>  		return true;
>  	}
> -- 
> 1.7.9.5
> 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
