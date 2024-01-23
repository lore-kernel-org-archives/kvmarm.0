Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08E2129A91
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706027852; cv=none; b=rtlAGPe9yAow70KEyJxwcO2Xe6cdNJnnqndry2pnIZoFMYmrR/A2/vO6AL+qEyn3+3fCbCnFXCOSxglxfNO4nfuSOKmoHkwkRESPKI6x3G7fc+8iBjWCe+Hoq4FmxqjCbSVCV6MNlJ+DI1SkwCYrBAEb75hW6oJE2Vi6L80B6ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706027852; c=relaxed/simple;
	bh=W44UldmfjZqnNNQFDiA8mfbdtaahD03uSiYlaP+QRWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rd1Qg35W9mciFdQT0TD3JVCcpWgS8Si2tczniJkhI7NPAdBAVScUSre86PlQ3ABItbDA6I4GWY7AoyI0qsclJ3q3z0hooepnguZDW70tgA841eXHTa3oGLeUOMFsNGmTREC+ykGteEQHYOfSgRWXDDaspOyTYKJr3ib+19KtDPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E84921FB;
	Tue, 23 Jan 2024 08:38:13 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EC973F5A1;
	Tue, 23 Jan 2024 08:37:27 -0800 (PST)
Date: Tue, 23 Jan 2024 16:37:25 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 10/25] KVM: arm64: nv: Turn encoding ranges into discrete
 XArray stores
Message-ID: <20240123163725.GE1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-11-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:37PM +0000, Marc Zyngier wrote:
> In order to be able to store different values for member of an
> encoding range, replace xa_store_range() calls with discrete
> xa_store() calls and an encoding iterator.
> 
> We end-up using a bit more memory, but we gain some flexibility
> that we will make use of shortly.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index ef46c2e45307..59622636b723 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1757,6 +1757,28 @@ static __init void print_nv_trap_error(const struct encoding_to_trap_config *tc,
>  		err);
>  }
>  
> +static u32 encoding_next(u32 encoding)
> +{
> +	u8 op0, op1, crn, crm, op2;
> +
> +	op0 = sys_reg_Op0(encoding);
> +	op1 = sys_reg_Op1(encoding);
> +	crn = sys_reg_CRn(encoding);
> +	crm = sys_reg_CRm(encoding);
> +	op2 = sys_reg_Op2(encoding);
> +
> +	if (op2 < Op2_mask)
> +		return sys_reg(op0, op1, crn, crm, op2 + 1);
> +	if (crm < CRm_mask)
> +		return sys_reg(op0, op1, crn, crm + 1, 0);
> +	if (crn < CRn_mask)
> +		return sys_reg(op0, op1, crn + 1, 0, 0);
> +	if (op1 < Op1_mask)
> +		return sys_reg(op0, op1 + 1, 0, 0, 0);
> +
> +	return sys_reg(op0 + 1, 0, 0, 0, 0);
> +}

I like this function, aesthetically pleasing!

> +
>  int __init populate_nv_trap_config(void)
>  {
>  	int ret = 0;
> @@ -1775,13 +1797,8 @@ int __init populate_nv_trap_config(void)
>  			ret = -EINVAL;
>  		}
>  
> -		if (cgt->encoding != cgt->end) {
> -			prev = xa_store_range(&sr_forward_xa,
> -					      cgt->encoding, cgt->end,
> -					      xa_mk_value(cgt->tc.val),
> -					      GFP_KERNEL);
> -		} else {
> -			prev = xa_store(&sr_forward_xa, cgt->encoding,
> +		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
> +			prev = xa_store(&sr_forward_xa, enc,
>  					xa_mk_value(cgt->tc.val), GFP_KERNEL);
>  			if (prev && !xa_is_err(prev)) {
>  				ret = -EINVAL;

The error handling looks a bit weird here, the full context:

                for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {                                                                     
                        prev = xa_store(&sr_forward_xa, enc,                                                                                                   
                                        xa_mk_value(cgt->tc.val), GFP_KERNEL);                                                                                 
                        if (prev && !xa_is_err(prev)) {                                                                                                        
                                ret = -EINVAL;                                                                                                                 
                                print_nv_trap_error(cgt, "Duplicate CGT", ret);                                                                                
                        }                                                                                                                                      
                }                                                                                                                                              
                                                                                                                                                               
                if (xa_is_err(prev)) {                                                                                                                         
                        ret = xa_err(prev);                                                                                                                    
                        print_nv_trap_error(cgt, "Failed CGT insertion", ret);                                                                                 
                }  

I would maybe expect some 'goto's after setting ret? It looks like the ret
would still be returned properly at the end of the function at least.  We also
don't check the return value of xa_store() in the encoding_to_fgt loop further
down, which seems worse as that could affect VMs if some encodings failed to be
stored for some reason.

Thanks,
Joey
