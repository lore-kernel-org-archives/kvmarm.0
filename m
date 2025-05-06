Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2416A27FB03
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746533814; cv=none; b=m8HfZ85LRs5iQvZ/ubsfac2PkDlqL/QnmRKJnbJpJ+gb6KtlY6SmiITCn/+7zoEj1D+oh1Qj/KZSnoaTsVadnxuxuDD89+jhNYZysToqPXG8lrKC9ezRluY7rcHaDB4OJdPEufhs59ZCX5sC4RKz9K2+Q95Sy90b2PHgSAwFtYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746533814; c=relaxed/simple;
	bh=28bm2lz6nrAKK9UAhh7rr1Tj60SFzKcxLaxFc2JgOx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Av3G/WT9kS/ngA3gUtSkdYi30mIlOB3JIgxzpHMFvTptgD+u5mFg/w1tqTO9gNKHR9pwGtt3w6UFf+T1GSzBOy8B5f1rdPtQjzoUT/+F+/KSK1zCakpK/KRR/VZkG8C3UsjwimydrxLap8lFqlBHwWfycROXj+C81prnulnVqtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YolsChS1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YolsChS1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfe808908so57065e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 05:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746533810; x=1747138610; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kO+JIG55K7wbG0qihfpLAhhBwuPCPUUUJ6Q0SZcQ118=;
        b=YolsChS1u1E4OkTsRU8ERL+K1dvIZflAVHIXV9KiYI5UgIfQHtrhW7bLB/ffaS6zJz
         0HTOd7hVL4hgY/h7ppLGjMhb3/eqktc+1gTb7J2OlW9jAl55NHrT7R0zBU/0anBaCHfP
         ecEoDcwfUKJwZrW1QFzslEXs/0s/qRsAcUj8IQ2a3N68zBBaQosiJl6eJDyFxV99Ytea
         Grl6CNAWWaEfzyA245+ex74yUpQo+sq8yHwWP8NsOepbG4PuWsxsOt7pzqXzH17WsL0H
         DBhTrijMiXeIpvl+8IG1gxHnnPaqeivcH3l7E1hZHDNyAs+1CbcNdXC9ImLnkut4Yo7B
         1doQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746533810; x=1747138610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kO+JIG55K7wbG0qihfpLAhhBwuPCPUUUJ6Q0SZcQ118=;
        b=ldAZdlpxN8O/lpxY5TDxcPXb1axP8cYK3a+WIWOcjl5EznB1Wh8KlWbM2K3DtOiXaS
         u3ClN5hr7Ie2QfL1Vx1XLWHNA3frDDxGop/f3wBM+S3ENSvpUkl0OCCC1RjQoTXPZJV9
         MamxDwTAkFwMhlzamabtSMaXwVhjVdoh4HncwcF9xLLc35+yqk5UhNYU9van/eXsmZsb
         HPHeZWUR0H+3zuc+YiWGwHAuiu5Cu91TOtrj7FCa1b2qcJ1LQnAvPfVy8mAZhJnBAlc1
         KOx1OWsD026qopJyIQC4hi8lhGhhMR2V1M2VwZPDLmj7M2tTdm9kBQFw6vBOAbdVyNtf
         erqw==
X-Forwarded-Encrypted: i=1; AJvYcCWG4XRDNdaUxTGu0Ow79ljrdSTV81xkQhExRJO72QzlOovyaeTxibEtdtOK6Nb/4m96FYGJ58w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8g1DrMkhm8aKyUkJsVietSu04rKhmgf1gzfqo405q5fSbZVIz
	/HaPVONlaqrilVkmZ/NPYA9COpVSGd1yQA6hv0ZlXjAoLF+sTlJ3Xa+3JkPUKg==
X-Gm-Gg: ASbGncsvPGQNor5FiiKiLh/L0h0zkD0lCuXqX5yi6zSaXq82ZJe5/q3mePuyFW0LXlW
	cvAbTb3Swn94ipUseh0sYXuLnexVKv++Wa0QzbYoOAcMC2/Z21Ve61rBukohH4gq9m+HX+h5fe7
	DsqRb20Hn46PyUFPIdxaIy72L/SE639CfTMRQY4F7h5c4cXezqOjk2Jr0DlqYXx2Wqt7ya+eaN/
	e02aXfgkp3Z3SVVmDo6DhTtN4breLjmtz5SR15TWUlV5EjUxObZPzEvY53/PULp16TKpbgtWc35
	XdtsH9nxa9A9UirrjcWBmTHc0yXyDkMiOUHb+Hg9o42FqZflm4Ns2pqH1ofMMSBwcf7WSklcehl
	um0tt8nHrNKhFTpqY
X-Google-Smtp-Source: AGHT+IEUqOQN9tee1kxirMRrJrS9/mWRcggk23cxyeNJT6T7FSNwCIyP8+ehQ+VVuCmQMo3UzSHE4A==
X-Received: by 2002:a05:600c:3b8c:b0:43b:df25:8c4 with SMTP id 5b1f17b1804b1-441d07b1637mr1330795e9.4.1746533810196;
        Tue, 06 May 2025 05:16:50 -0700 (PDT)
Received: from google.com (207.57.78.34.bc.googleusercontent.com. [34.78.57.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0fe92sm13701288f8f.68.2025.05.06.05.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 05:16:49 -0700 (PDT)
Date: Tue, 6 May 2025 12:16:44 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Per Larsen <perl@immunant.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, jean-philippe@linaro.org,
	kernel-team@android.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, lpieralisi@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	armellel@google.com, arve@android.com, ahomescu@google.com,
	Per Larsen <perlarsen@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host
 handler
Message-ID: <aBn9rMiVI_7CcdED@google.com>
References: <20250502092108.3224341-1-perl@immunant.com>
 <20250502092108.3224341-4-perl@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502092108.3224341-4-perl@immunant.com>

On Fri, May 02, 2025 at 02:21:08AM -0700, Per Larsen wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
> uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
> argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
> in the host ffa handler.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> Signed-off-by: Per Larsen <perl@immunant.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 111 +++++++++++++++++++++++++++++++++-
>  include/linux/arm_ffa.h       |   2 +
>  2 files changed, 111 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 8102dd6a19f7..d8c066f3c5c9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -79,6 +79,14 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  	};
>  }
>  
> +static void ffa_to_smccc_1_2_error(struct arm_smccc_1_2_regs *regs, u64 ffa_errno)
> +{
> +	*regs = (struct arm_smccc_1_2_regs) {
> +		.a0	= FFA_ERROR,
> +		.a2	= ffa_errno,
> +	};
> +}
> +
>  static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
>  {
>  	if (ret == FFA_RET_SUCCESS) {
> @@ -89,11 +97,26 @@ static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
>  	}
>  }
>  
> +static void ffa_to_smccc_1_2_regs_prop(struct arm_smccc_1_2_regs *regs, int ret, u64 prop)
> +{
> +	if (ret == FFA_RET_SUCCESS) {
> +		*regs = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
> +						.a2 = prop };
> +	} else {

NIT: no paranthesis needed here

> +		ffa_to_smccc_1_2_error(regs, ret);
> +	}
> +}
> +
>  static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
>  {
>  	ffa_to_smccc_res_prop(res, ret, 0);
>  }
>  
> +static void ffa_to_smccc_1_2_regs(struct arm_smccc_1_2_regs *regs, int ret)
> +{
> +	ffa_to_smccc_1_2_regs_prop(regs, ret, 0);
> +}
> +
>  static void ffa_set_retval(u64 func_id,
>  			   struct kvm_cpu_context *ctxt,
>  			   struct arm_smccc_res *res)
> @@ -127,6 +150,29 @@ static void ffa_set_retval(u64 func_id,
>  	}
>  }
>  
> +static void ffa_set_retval_smccc_1_2(struct kvm_cpu_context *ctxt,
> +			   struct arm_smccc_1_2_regs *regs)
> +{
> +	cpu_reg(ctxt, 0) = regs->a0;
> +	cpu_reg(ctxt, 1) = regs->a1;
> +	cpu_reg(ctxt, 2) = regs->a2;
> +	cpu_reg(ctxt, 3) = regs->a3;
> +	cpu_reg(ctxt, 4) = regs->a4;
> +	cpu_reg(ctxt, 5) = regs->a5;
> +	cpu_reg(ctxt, 6) = regs->a6;
> +	cpu_reg(ctxt, 7) = regs->a7;
> +	cpu_reg(ctxt, 8) = regs->a8;
> +	cpu_reg(ctxt, 9) = regs->a9;
> +	cpu_reg(ctxt, 10) = regs->a10;
> +	cpu_reg(ctxt, 11) = regs->a11;
> +	cpu_reg(ctxt, 12) = regs->a12;
> +	cpu_reg(ctxt, 13) = regs->a13;
> +	cpu_reg(ctxt, 14) = regs->a14;
> +	cpu_reg(ctxt, 15) = regs->a15;
> +	cpu_reg(ctxt, 16) = regs->a16;
> +	cpu_reg(ctxt, 17) = regs->a17;
> +}
> +
>  /* Call SMC64 using SMCCC 1.2 if hyp negotiated FF-A 1.2 falling back to 1.1 */
>  static void arm_smccc_1_2_smc_fallback(u64 func_id, u64 a1, u64 a2, u64 a3,
>  				       u64 a4, u64 a5, u64 a6, u64 a7,
> @@ -681,7 +727,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
>  	/* Unimplemented interfaces added in FF-A 1.2 */
> -	case FFA_MSG_SEND_DIRECT_REQ2:
>  
>  	/*
>  	 * FFA_MSG_SEND_DIRECT_RESP2 is not meant to be invoked by the host or
> @@ -709,6 +754,20 @@ static bool ffa_call_supported(u64 func_id)
>  	return true;
>  }
>  
> +/*
> + * Must a given FFA function use the SMC calling convention v1.2?
> + */
> +static bool ffa_call_needs_smccc_1_2(u64 func_id)
> +{
> +	switch (func_id) {
> +	case FFA_MSG_SEND_DIRECT_REQ2:
> +	case FFA_MSG_SEND_DIRECT_RESP2:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static bool do_ffa_features(struct arm_smccc_res *res,
>  			    struct kvm_cpu_context *ctxt)
>  {
> @@ -882,9 +941,47 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
> +			      struct kvm_cpu_context *ctxt,
> +			      u64 vm_handle)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	DECLARE_REG(u32, endp, ctxt, 1);
> +	DECLARE_REG(u64, uuid_lo, ctxt, 2);
> +	DECLARE_REG(u64, uuid_hi, ctxt, 3);
> +	DECLARE_REG(u64, x4, ctxt, 4);
> +	DECLARE_REG(u64, x5, ctxt, 5);
> +	DECLARE_REG(u64, x6, ctxt, 6);
> +	DECLARE_REG(u64, x7, ctxt, 7);
> +	DECLARE_REG(u64, x8, ctxt, 8);
> +	DECLARE_REG(u64, x9, ctxt, 9);
> +	DECLARE_REG(u64, x10, ctxt, 10);
> +	DECLARE_REG(u64, x11, ctxt, 11);
> +	DECLARE_REG(u64, x12, ctxt, 12);
> +	DECLARE_REG(u64, x13, ctxt, 13);
> +	DECLARE_REG(u64, x14, ctxt, 14);
> +	DECLARE_REG(u64, x15, ctxt, 15);
> +	DECLARE_REG(u64, x16, ctxt, 16);
> +	DECLARE_REG(u64, x17, ctxt, 17);
> +
> +	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
> +		ffa_to_smccc_1_2_regs(regs, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	struct arm_smccc_1_2_regs args = {
> +		func_id, endp, uuid_lo, uuid_hi,
> +		 x4,  x5,  x6,  x7,  x8,  x9, x10,
> +		x11, x12, x13, x14, x15, x16, x17
> +	};

Maybe use cpu_reg(ctxt, ) to avoid copying two times the values and drop
the DECLARE_REG ?

> +
> +	arm_smccc_1_2_smc(&args, regs);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_res res;
> +	struct arm_smccc_1_2_regs regs;
>  
>  	/*
>  	 * There's no way we can tell what a non-standard SMC call might
> @@ -940,14 +1037,24 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ2:
> +		if (hyp_ffa_version >= FFA_VERSION_1_2) {

The version is accessed without a lock.

> +			do_ffa_direct_msg2(&regs, host_ctxt, HOST_FFA_ID);
> +			goto out_handled;
> +		}
> +		goto out_not_supported;
>  	}
>  
>  	if (ffa_call_supported(func_id))
>  		return false; /* Pass through */
>  
> +out_not_supported:
>  	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
>  out_handled:
> -	ffa_set_retval(func_id, host_ctxt, &res);
> +	if (ffa_call_needs_smccc_1_2(func_id))
> +		ffa_set_retval_smccc_1_2(host_ctxt, &regs);
> +	else
> +		ffa_set_retval(func_id, host_ctxt, &res);
>  	return true;
>  }
>  
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 5bded24dc24f..4d541cf12ceb 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -268,6 +268,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
>  	(ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
>  	 !dev->mode_32bit)
>  
> +#define FFA_SRC_ENDPOINT_MASK	GENMASK(31, 16)
> +
>  /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
>  struct ffa_send_direct_data {
>  	unsigned long data0; /* w3/x3 */
> -- 
> 2.49.0
> 
