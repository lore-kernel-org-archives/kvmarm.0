Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213613D8BE
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712679328; cv=none; b=e2lUd58h7spNMnVrVtU1w1/V91lmQJE+44LXiaIF3KOGkGBp0ED/AiGgIkkpAltcfRrMWnAWgAV9Jhw+y+0Fgga+ZNXYzUVDPJfcXOdhWLfMtpKDImowpYRjBXr7Os1ZhTvnpr5reMgDtPzDLPPTlmFToXleD4/nH/95RqzEfvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712679328; c=relaxed/simple;
	bh=X2xmHqO8gXKhPjxwaeID/utS/X/th0bZq4WUqjIW2sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sliRqhR/A4nVTxC6XDaTOQ6xg711UD13GdIbyr29Bt4nK0TE7QUjpU9LSaWIwV6R5QQ7l85Nc/aGFl6ENI1q12oA7Mv9SgsLtYiFfFsMm1vSCfb7Lq1Ki4E2JOcLkajiEymVMOA2qNGjXgpLDlf4vbWG8SP7d+HPIJjihg0w/RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dleumD3G; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dleumD3G"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-416920b1a2aso11568795e9.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 09:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712679324; x=1713284124; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NdZtD6irNdlXhmhm1A43aB93TmxueujQEV4FlCrB2O0=;
        b=dleumD3G+rf7ekRAhcRiuNcFoklkU6vAWdsSF96gZiNCaN6WLUNbq0FnNoCsB5PL4N
         mr31rkp+ztPRYzQlK/nmGSsLrchuahXWqDAq+9DTcuxwNAaovCHggG8kIsTwV/CVbrXi
         gQJ6COUqNp9XfqsgfoA+ilw8qXpruk57zuLtEvbiFk4jdUaS1E0IAKk0w7yobvouA1FO
         dGel/e6srp4RGLuay28l4YQL4htWItpptt/4uWtCX92lf+RxfxQBYQznu78lxjP5SSYf
         qjy5wpbHgKWsyQkUikEkf11dQSLCdNT8dcJz0I4n9aceCkpNR0KSscQ0sJ38e6j9Stv9
         gklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712679324; x=1713284124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NdZtD6irNdlXhmhm1A43aB93TmxueujQEV4FlCrB2O0=;
        b=anBD51/nlDb6WDCpDueZRpIjSXJescxvhdw7vYaeeAAEcIvAyg3h8niPRbRt8z4tAL
         bCPVFsU+EkyUCIa0aZfLEX8ZQdwthVkcRSYn/jJGcp5qxQfipTU+vT7rhMRAskFMSvvn
         97VdprM/Gftk98Hs0Rv5oqvfSZL1YIGww9E6ynmB3o9Z5Kn1rkaSPDTkOIo819o0Mp8L
         PByG/shbheCMVz19z4aV/rx4BC+cDlTla9cIP1OBNHdRoWP8ucfm3pbaGdi6eijQBv6u
         j3llbB5SIjjFQqRmOtFHwSrpfGlLr0PH21BRbBtE4kL4fHjp+V2ZBkM3+bqdu/kQwArF
         xfZA==
X-Forwarded-Encrypted: i=1; AJvYcCVEgkecDpw+B/rRkvlIecXVAyFnXBQHGD+ayeA0cSXSsJVDCcjPQLhQd3c/ncRpL7YAP0cVElnJbGoOfOZyoEca9LBQiU5D
X-Gm-Message-State: AOJu0YynYzDg85Aw+OZrckxTiUOvFtqFEti8chBoKC7CxwiT7z65p3LT
	xV2VNdCZiGkjq2EAv1iIPRIRxQyMqpqPYBuFEBUfJzhk3B+hSYfpDziew02ixw==
X-Google-Smtp-Source: AGHT+IGGfIBhxH5DQCjXOXjwLQSpl49ieGPZM+MwVbQZknp7RGIYrhHK/YQcv5YCidu4HTjG9iIDmQ==
X-Received: by 2002:a5d:5185:0:b0:33d:b376:8a07 with SMTP id k5-20020a5d5185000000b0033db3768a07mr118036wrv.8.1712679324100;
        Tue, 09 Apr 2024 09:15:24 -0700 (PDT)
Received: from google.com (161.126.77.34.bc.googleusercontent.com. [34.77.126.161])
        by smtp.gmail.com with ESMTPSA id z13-20020a056000110d00b0034174875850sm11895914wrw.70.2024.04.09.09.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 09:15:23 -0700 (PDT)
Date: Tue, 9 Apr 2024 17:15:20 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhVpmF2js1NJp1qF@google.com>
References: <20240409151908.541589-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409151908.541589-1-sebastianene@google.com>

Hi Seb,

On Tue, Apr 09, 2024 at 03:19:08PM +0000, Sebastian Ene wrote:
> Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> and copy the response message back to the host buffers. Save the
> returned FF-A version as we will need it later to interpret the response
> from the TEE.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 49 +++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 320f2eaa14a9..72fc365bc7a8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -67,6 +67,7 @@ struct kvm_ffa_buffers {
>   */
>  static struct kvm_ffa_buffers hyp_buffers;
>  static struct kvm_ffa_buffers host_buffers;
> +static u32 ffa_version;
>  
>  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  {
> @@ -640,6 +641,49 @@ static bool do_ffa_features(struct arm_smccc_res *res,
>  	return true;
>  }
>  
> +static void do_ffa_part_get(struct arm_smccc_res *res,
> +			    struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, uuid0, ctxt, 1);
> +	DECLARE_REG(u32, uuid1, ctxt, 2);
> +	DECLARE_REG(u32, uuid2, ctxt, 3);
> +	DECLARE_REG(u32, uuid3, ctxt, 4);
> +	DECLARE_REG(u32, flags, ctxt, 5);
> +	u32 off, count, sz, buf_sz;
> +
> +	hyp_spin_lock(&host_buffers.lock);
> +	if (!host_buffers.rx) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		goto out_unlock;
> +	}
> +
> +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> +			  uuid2, uuid3, flags, 0, 0,
> +			  res);
> +
> +	if (res->a0 != FFA_SUCCESS)
> +		goto out_unlock;
> +
> +	count = res->a2;
> +	if (!count)
> +		goto out_unlock;

Looking at the table 13.34, it seems what's in "count" depends on the flag.
Shouldn't we check its value, and only memcpy into the host buffers if the flag
is 0?

> +
> +	if (ffa_version > FFA_VERSION_1_0) {
> +		buf_sz = sz = res->a3;
> +		if (sz > sizeof(struct ffa_partition_info))
> +			buf_sz = sizeof(struct ffa_partition_info);

What are you trying to protect against here? We have to trust EL3 anyway, (as
other functions do).

The WARN() could be kept though to make sure we won't overflow our buffer. But
it could be transformed into an error? FFA_RET_ABORTED?


> +	} else {
> +		/* FFA_VERSION_1_0 lacks the size in the response */
> +		buf_sz = sz = 8;
> +	}
> +
> +	WARN_ON((count - 1) * sz + buf_sz > PAGE_SIZE);
> +	for (off = 0; off < count * sz; off += sz)
> +		memcpy(host_buffers.rx + off, hyp_buffers.rx + off, buf_sz);
> +out_unlock:
> +	hyp_spin_unlock(&host_buffers.lock);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_res res;
> @@ -686,6 +730,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_MEM_FRAG_TX:
>  		do_ffa_mem_frag_tx(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_PARTITION_INFO_GET:
> +		do_ffa_part_get(&res, host_ctxt);
> +		break;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> @@ -726,6 +773,8 @@ int hyp_ffa_init(void *pages)
>  	if (FFA_MAJOR_VERSION(res.a0) != 1)
>  		return -EOPNOTSUPP;
>  
> +	ffa_version = res.a0;
> +
>  	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
>  	if (res.a0 != FFA_SUCCESS)
>  		return -EOPNOTSUPP;
> -- 
> 2.44.0.478.gd926399ef9-goog
> 
