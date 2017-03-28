From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 3/9] arm64: KVM: PMU: Inject UNDEF on non-privileged
 accesses
Date: Tue, 28 Mar 2017 14:45:01 +0200
Message-ID: <20170328124501.GC31156@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A6340C2D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:43:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J4I3y1l9xujs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 08:43:05 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12E0240A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:43:04 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id w11so85483182wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 05:45:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-4-marc.zyngier@arm.com>
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
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27, 2017 at 05:03:39PM +0100, Marc Zyngier wrote:
> access_pminten() and access_pmuserenr() can only be accessed when
> the CPU is in a priviledged mode. If it is not, let's inject an
> UNDEF exception.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/kvm/sys_regs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d98ce9a52291..5e3ce7890b35 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -709,8 +709,10 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	if (!kvm_arm_pmu_v3_ready(vcpu))
>  		return trap_raz_wi(vcpu, p, r);
>  
> -	if (!vcpu_mode_priv(vcpu))
> +	if (!vcpu_mode_priv(vcpu)) {
> +		kvm_inject_undefined(vcpu);
>  		return false;
> +	}
>  
>  	if (p->is_write) {
>  		u64 val = p->regval & mask;
> @@ -780,8 +782,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		return trap_raz_wi(vcpu, p, r);
>  
>  	if (p->is_write) {
> -		if (!vcpu_mode_priv(vcpu))
> +		if (!vcpu_mode_priv(vcpu)) {
> +			kvm_inject_undefined(vcpu);
>  			return false;
> +		}
>  
>  		vcpu_sys_reg(vcpu, PMUSERENR_EL0) = p->regval
>  						    & ARMV8_PMU_USERENR_MASK;
> -- 
> 2.11.0
> 
