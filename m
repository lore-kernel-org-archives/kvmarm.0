From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH RFC 7/7] ARM64: KVM: Add user set handler for
 id_aa64mmfr0_el1
Date: Thu, 9 Mar 2017 04:52:18 -0800
Message-ID: <20170309125218.GD114809@lvm>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-8-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3495A40AE8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 07:50:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o2hD2tg4b-l2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 07:50:56 -0500 (EST)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D6E340A66
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 07:50:56 -0500 (EST)
Received: by mail-wr0-f175.google.com with SMTP id g10so44365964wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 04:52:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1484559214-2248-8-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 16, 2017 at 05:33:34PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Check if the configuration is fine.

This commit message really needs some love and attention.

> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f613e29..9763b79 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1493,6 +1493,35 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u64 val, id_aa64mmfr0;
> +
> +	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)) != 0)
> +		return -EFAULT;
> +
> +	asm volatile("mrs %0, id_aa64mmfr0_el1\n" : "=r" (id_aa64mmfr0));

Doesn't the kernel have an abstraction for this already or a cached
value?

> +
> +	if ((val & GENMASK(3, 0)) > (id_aa64mmfr0 & GENMASK(3, 0)) ||
> +	    (val & GENMASK(7, 4)) > (id_aa64mmfr0 & GENMASK(7, 4)) ||
> +	    (val & GENMASK(11, 8)) > (id_aa64mmfr0 & GENMASK(11, 8)) ||
> +	    (val & GENMASK(15, 12)) > (id_aa64mmfr0 & GENMASK(15, 12)) ||
> +	    (val & GENMASK(19, 16)) > (id_aa64mmfr0 & GENMASK(19, 16)) ||
> +	    (val & GENMASK(23, 20)) > (id_aa64mmfr0 & GENMASK(23, 20)) ||
> +	    (val & GENMASK(27, 24)) < (id_aa64mmfr0 & GENMASK(27, 24)) ||
> +	    (val & GENMASK(31, 28)) < (id_aa64mmfr0 & GENMASK(31, 28))) {
> +		kvm_err("Wrong memory translation granule size/Physical Address range\n");
> +		return -EINVAL;
> +	}

This really needs some explanation as to what it's checking and what the
logic is.

> +
> +	vcpu_id_sys_reg(vcpu, rd->reg) = val & GENMASK(31, 0);
> +
> +	return 0;
> +}
> +
>  static struct sys_reg_desc invariant_sys_regs[] = {
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
>  	  access_id_reg, get_midr_el1, MIDR_EL1 },
> @@ -1549,7 +1578,8 @@ static struct sys_reg_desc invariant_sys_regs[] = {
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b001),
>  	  access_id_reg, get_id_aa64isar1_el1, ID_AA64ISAR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b000),
> -	  access_id_reg, get_id_aa64mmfr0_el1, ID_AA64MMFR0_EL1 },
> +	  access_id_reg, get_id_aa64mmfr0_el1, ID_AA64MMFR0_EL1,
> +	  0, NULL, set_id_aa64mmfr0_el1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b001),
>  	  access_id_reg, get_id_aa64mmfr1_el1, ID_AA64MMFR1_EL1 },
>  	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
> -- 
> 2.0.4
> 
> 

Thanks,
-Christoffer
