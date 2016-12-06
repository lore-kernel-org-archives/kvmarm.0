From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v9 03/11] arm/arm64: vgic: Introduce find_reg_by_id()
Date: Tue, 6 Dec 2016 14:27:01 +0100
Message-ID: <f8e4e42e-e298-f4ca-a958-3be48fb39736@redhat.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-4-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0E440419
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 08:26:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83bsnHlfwWVI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 08:26:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 689D2403F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 08:26:08 -0500 (EST)
In-Reply-To: <1479906118-15832-4-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijay,
On 23/11/2016 14:01, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> In order to implement vGICv3 CPU interface access, we will need to perform
> table lookup of system registers. We would need both index_to_params() and
> find_reg() exported for that purpose, but instead we export a single
> function which combines them both.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 22 +++++++++++++++-------
>  arch/arm64/kvm/sys_regs.h |  4 ++++
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f302fdb..1330d4c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1789,6 +1789,17 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
>  	}
>  }
>  
> +const struct sys_reg_desc *find_reg_by_id(u64 id,
> +					  struct sys_reg_params *params,
> +					  const struct sys_reg_desc table[],
> +					  unsigned int num)
> +{
> +	if (!index_to_params(id, params))
> +		return NULL;
> +
> +	return find_reg(params, table, num);
> +}
> +
Can't you use find_reg_by_id in index_to_sys_reg_desc too?

Besides Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>  /* Decode an index value, and find the sys_reg_desc entry. */
>  static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
>  						    u64 id)
> @@ -1912,10 +1923,8 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
>  	struct sys_reg_params params;
>  	const struct sys_reg_desc *r;
>  
> -	if (!index_to_params(id, &params))
> -		return -ENOENT;
> -
> -	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
> +	r = find_reg_by_id(id, &params, invariant_sys_regs,
> +			   ARRAY_SIZE(invariant_sys_regs));
>  	if (!r)
>  		return -ENOENT;
>  
> @@ -1929,9 +1938,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
>  	int err;
>  	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
>  
> -	if (!index_to_params(id, &params))
> -		return -ENOENT;
> -	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
> +	r = find_reg_by_id(id, &params, invariant_sys_regs,
> +			   ARRAY_SIZE(invariant_sys_regs));
>  	if (!r)
>  		return -ENOENT;
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index dbbb01c..9c6ffd0 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -136,6 +136,10 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  	return i1->Op2 - i2->Op2;
>  }
>  
> +const struct sys_reg_desc *find_reg_by_id(u64 id,
> +					  struct sys_reg_params *params,
> +					  const struct sys_reg_desc table[],
> +					  unsigned int num);
>  
>  #define Op0(_x) 	.Op0 = _x
>  #define Op1(_x) 	.Op1 = _x
> 
