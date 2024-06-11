Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2511417D8B5
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718114211; cv=none; b=idf0cDOUUNQFmTOa55aJVzD0mNE9XEkeYYKcn89v4+zwq2dU6ace013KWhlepyGqBGR6jmm85zxCfbIh5QpE932ANfruZ0LymbKvhdBomzLWC08F2n3e+QzAYnOigQ8esELlrqqpHKwo6mAcB0vqak33ITbKi21oUmC42pZcfp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718114211; c=relaxed/simple;
	bh=oxHliFsDe3L8DF5XtgttTdhKRbSX0s8UxxGfQ2cdprA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ibEeUfXnpKG0Amfq+1GP1g3dXt/o44zpkb2nUc+hlCRx3d9ZmMf1NKssDylpMcoXvnq9XYm8shxSMfLoPYtnnpAGrx8bXnUeL7f7frEiNGf1bk404XmIeNFarto+dGg0vpO98OEeyDTfUzOrjAzo62M4A5IypOuwDF9SAM/Qe7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MJ3fSfP7; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MJ3fSfP7"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42175bce556so58225e9.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718114208; x=1718719008; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bNs4f6KkzdoND96Om9u51cQHwE7THMPFJe5WQOvE0Us=;
        b=MJ3fSfP7EeRteFEnpuGobbrdnzLUfw53XatZYF6XArVS9Kk4UXS6OuYGmG3ZRg/sQg
         qtJPb1XJPKcppBEj7GB7rYeIP9DVbJPYT+J6bzSpopd39dbOCG9VFqSlum1vs4oVey6e
         oEoIHiWDDu9PFDAqfRNjvnjigdXkxIOR6RUXNJOyu3gaQLemI8Hwept26W9bpf52fZfd
         uRUFG3P6kr3l4MQLtucdjxNWQHS6/YXvH00go6edlOo21ViPbstC3Nvn1akAOamjKaHK
         9h3ARTzA+nf6IPj3TTKrPkdHT61MGGOYKfmct+kpWr7cq4D7APeFv4DNRHAuabgnHcA5
         ZFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718114208; x=1718719008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNs4f6KkzdoND96Om9u51cQHwE7THMPFJe5WQOvE0Us=;
        b=Bj6ixK/sKdvkjJiohZWp1MmMe22vtI0vmKcHE+iX6rG5YUPI1asCI3yWmOWxhwJfyr
         Krp5eqzh3tpgc0S1R2Z7zD3YBnOc3UfpyF75e7yvTMiAS1oatJc1NkWj9Da+6sKfjcWb
         48Ndwa7W8sUk1GEow6qE+QO2owOYe6fiGukNhXcHpxq4MOp8kFIoLCrvYpRzxhNAMMbq
         L5tIy/09AElI/QbYeIxirO/ph7UqqtA73t2Kg2OqnsYO9eli1+WX22Rpx/miGPIScs+/
         Xg5nBsZY5zhnvm7rbY5ZB8sBNH1p1K0VqegNhRTpaDWO722/cTvpzX+4kqsLkIEoK4/Z
         QMFg==
X-Forwarded-Encrypted: i=1; AJvYcCU2yrzeWUCAKsvybv21U6SVHpo8B76ZFsjdOaXuoNMTP/z9k5vs+KeuYQrpSZJdplkz9xOf4AcKK7y+RrVqhUtuVVSfsm0i
X-Gm-Message-State: AOJu0YxS6ARQXqHSaEUYgYNjd8rwHq5CxoTtYm9rBr7WP5Z+O5aa8MOE
	YJwc0HHSvzs9RsDeGFn/QneupuRKWwrKL9rkCwM3hobYaKCRVPTb5NkCG9HQxw==
X-Google-Smtp-Source: AGHT+IHrxnZpMaofCEPMIPgkh50ftY/UilMd2LpIHinhFHRgSwGMkJDMQJbDsDyhj10rSyoSp3kUig==
X-Received: by 2002:a05:600c:1e14:b0:41a:444b:e1d9 with SMTP id 5b1f17b1804b1-42244f4723emr1656375e9.4.1718114208215;
        Tue, 11 Jun 2024 06:56:48 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215c0fe4b3sm178946825e9.0.2024.06.11.06.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 06:56:47 -0700 (PDT)
Date: Tue, 11 Jun 2024 13:56:46 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, sudeep.holla@arm.com,
	will@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: FFA: Release hyp rx buffer
Message-ID: <ZmhXngA1lYfYoz72@google.com>
References: <20240530131734.2724454-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530131734.2724454-1-vdonnefort@google.com>

On Thu, May 30, 2024 at 02:17:34PM +0100, Vincent Donnefort wrote:

Hello Vincent,

> According to the FF-A spec (1.2 BET0 7.2.2.4.2), after a producer has
> written into a buffer, it is "full" and now owned by the consumer until
> it is read and "empty". This must be signaled by the consumer with the
> RX_RELEASE invocation.

I agree the spec is a bit unclear in the ownership transfer of the buffer:
- it mentions that the producer owns it when it is empty (I think it is
  a separate state the ownership transfer than being "full"). Some FF-A
  ABIs do the ownership transfer when they are invoked, but not all of
  them and this is why we need calls like RX_RELEASE, to signal the
  availability of the buffer and to transfer the ownership from the
  Consumer to the Producer. Can we add this explanation as part of the
  commit message to justify why we need this ?

I think it is also worth mentioning that this is how TF-A (Trusted
Firmware) deals with the ownership transfer of the buffer.

> 
> It is clear from the spec (7.2.2.4.2), that MEM_RETRIEVE_RESP is
> transferring the ownership from producer (in our case SPM) to consumer
> (hypervisor). We must then subsequently invoke RX_RELEASE to transfer
> back the ownership (i.e. to let SPM mark the buffer as "empty").
> 
> It is less clear though what is happening with MEM_FRAG_TX. But this
> invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
> RX buffer. Also this is matching the TF-A implementation where the RX
> buffer is marked "full" during a MEM_FRAG_RX.
> 
> Release the RX hypervisor buffer in those two cases. This will unblock
> later invocations using this buffer which would otherwise fail.
> (RETRIEVE_REQ, MEM_FRAG_RX and PARTITION_INFO_GET).
> 

Thanks,
Seb


> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 02746f9d0980..efb053af331c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -177,6 +177,14 @@ static void ffa_retrieve_req(struct arm_smccc_res *res, u32 len)
>  			  res);
>  }
>  
> +static void ffa_rx_release(struct arm_smccc_res *res)
> +{
> +	arm_smccc_1_1_smc(FFA_RX_RELEASE,
> +			  0, 0,
> +			  0, 0, 0, 0, 0,
> +			  res);
> +}
> +
>  static void do_ffa_rxtx_map(struct arm_smccc_res *res,
>  			    struct kvm_cpu_context *ctxt)
>  {
> @@ -543,16 +551,19 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
>  	if (WARN_ON(offset > len ||
>  		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
>  		ret = FFA_RET_ABORTED;
> +		ffa_rx_release(res);
>  		goto out_unlock;
>  	}
>  
>  	if (len > ffa_desc_buf.len) {
>  		ret = FFA_RET_NO_MEMORY;
> +		ffa_rx_release(res);
>  		goto out_unlock;
>  	}
>  
>  	buf = ffa_desc_buf.buf;
>  	memcpy(buf, hyp_buffers.rx, fraglen);
> +	ffa_rx_release(res);
>  
>  	for (fragoff = fraglen; fragoff < len; fragoff += fraglen) {
>  		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
> @@ -563,6 +574,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
>  
>  		fraglen = res->a3;
>  		memcpy((void *)buf + fragoff, hyp_buffers.rx, fraglen);
> +		ffa_rx_release(res);
>  	}
>  
>  	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
> 
> base-commit: 6d69b6c12fce479fde7bc06f686212451688a102
> -- 
> 2.45.1.288.g0e0cd299f1-goog
> 
