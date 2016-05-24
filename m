From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/7] arm64: KVM: Make ICC_SRE_EL1 access return the
 configured SRE value
Date: Tue, 24 May 2016 14:45:09 +0200
Message-ID: <20160524124509.GE3582@cbox>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
 <1464007023-11736-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC1649BA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 08:41:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id giMryhywEzNn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 08:41:39 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C5D249B9F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 08:41:38 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id a136so71874075wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:45:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1464007023-11736-6-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 23, 2016 at 01:37:01PM +0100, Marc Zyngier wrote:
> When we trap ICC_SRE_EL1, we handle it as RAZ/WI. It would be
> more correct to actual make it RO, and return the configured
> value when read.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

>  arch/arm64/kvm/sys_regs.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7bbe3ff..a57d650 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -134,6 +134,17 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_gic_sre(struct kvm_vcpu *vcpu,
> +			   struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
> +	return true;
> +}
> +
>  static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
> @@ -958,7 +969,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_gic_sgi },
>  	/* ICC_SRE_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b101),
> -	  trap_raz_wi },
> +	  access_gic_sre },
>  
>  	/* CONTEXTIDR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b001),
> -- 
> 2.1.4
> 
