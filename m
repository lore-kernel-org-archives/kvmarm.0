Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0310313A240
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725897793; cv=none; b=ksMMXXXrjpUKx8OhLmuF7+4netjLbcsTkN4p8EnKrPDxUA5ms88ViIOuAq1HtN+hnpublYYHAC0vpDnkhDUWhwag6l2iKbN7jVTbU2HxQl4eaFcjGE1IgegDz08ShAeEjAY2VN98sdUYW9o89JdhRFYjRMqA7TNdqbB9bFgFf4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725897793; c=relaxed/simple;
	bh=88lo47xg3yelIsFsDGWArcwQDElF+OmnZMG5ZVOeu2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1Saoqr+INzVFJgR36EerLyS5ztEdVJo+qp7EQNgePYHI1LYavr+MEOb5wqYwWk/xMzokvSRIe5Z+MW1zcxbNoaCSeoVAOV/lRinM0DgXLS6t7y+KzgTwHn1IrOEXShBj6N7B2+opMvV3kKlVCNlpsm20RxueBsx6wEhIQNcDVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hf3aKKkq; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hf3aKKkq"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5356a2460ceso14521e87.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 09:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725897790; x=1726502590; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fracQuYtQaObjYrVhxRAFzJFryVoL/0p6ZImg0NJDKk=;
        b=Hf3aKKkqksBZbqSrO9UGmPcyBhN0oPg5LY4l9U7dmcFa0luiaQiOBBkfpamafoVWNe
         RhGll2zVcjC9cCpl2dggKnTfKnNdHXRA6cH6+py1H3KChdpMoOsv+bBUuNrS2YolkcSd
         OUUJp4ILiDzIFnsnwpXKqI1fmVXRSRNzhMPDL0ZYaDZ4TP0j3K4o5/y79/8I/6s+m0Oz
         SKvkrfB2SJOAMCCc+vrXv+NxYWjRCLxCTBdT6uK3vb5CI1c2ix45Aiab/eOmBuRPMpiz
         7KfmZk60kXf9yq1gzsziUZy2QbjJ+r/V+KpjWbzfxP5WKHigrf2rwTKFh3vcAifhh9e5
         Efpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725897790; x=1726502590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fracQuYtQaObjYrVhxRAFzJFryVoL/0p6ZImg0NJDKk=;
        b=exhxy9ukaMF9v/a0gimjJU+aytI5wElrxXAtrNfa8Dp3ewvfCvPsAxVtxjza7kXkdC
         +g8itAo/i3dL9C8Oos6qUvC0Xz74bePmr513RfVedOUNh5OQwBcRTaEUhFZBMzS3bifi
         GDzJpwGPeeJs3teF1TOX4hzo5/YDTgN9NDYOjPFLXgispJ9boZ0nD0SJI7H0AGfJxC9F
         5opK6jEQkEvQzJxXpMpKC7AbFF+GAgBLhLl+p31d/BSeMXDJP2NrIF2m8SadbP2O4OPL
         lNGoSti/0Ndz3iVXZhdQftCaV9K6a8K+6Ki6i10rN4fdC2zAho5pGDy/YpYq7Z95WDRN
         JI+g==
X-Forwarded-Encrypted: i=1; AJvYcCWxznEHEHChkwvXEoakJ1TJwQgQHmQ8Fn9EIFKrZ5cmYm4bbgTnVF3/PJxxzqyNZvJKLSTOINk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyp3X41Y4mmgs2JsG/Ee92zfAsb0zrByJd0Oarobflh8vPZXTMX
	NFd1CgYEXk41JX+zjU1ScYvNjvQoxTeYMEbHYqVVMeUZIGjCrvul27q6dstqHQ==
X-Google-Smtp-Source: AGHT+IFWWF4zQGbIYhYU4tYtK4Cq/myRRd+dsd+RU2EiYcad8RSM6sP31Dr6sN0cwJxGzs0Gz5dgqQ==
X-Received: by 2002:a05:6512:3a95:b0:533:4620:ebe6 with SMTP id 2adb3069b0e04-5365debfedamr337407e87.4.1725897789707;
        Mon, 09 Sep 2024 09:03:09 -0700 (PDT)
Received: from google.com (93.20.140.34.bc.googleusercontent.com. [34.140.20.93])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956dbf42sm6355955f8f.102.2024.09.09.09.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 09:03:09 -0700 (PDT)
Date: Mon, 9 Sep 2024 16:03:07 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Snehal Koukuntla <snehalreddy@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Add memory length checks and remove
 inline in do_ffa_mem_xfer
Message-ID: <Zt8cO8aKS64_FW1W@google.com>
References: <20240909130832.1203849-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909130832.1203849-1-snehalreddy@google.com>

On Mon, Sep 09, 2024 at 01:08:32PM +0000, Snehal Koukuntla wrote:

Hi,

A couple of nits which weren't addressed in the first version.

> Check size during allocation to fix discrepancy in memory reclaim path.
> Currently only happens during memory reclaim, inconsistent with mem_xfer
> Also  do_ffa_mem_xfer() does not need __always_inline
> 

Please enhance the description in the commit message as Mark suggested
previously. Something like this should work:

"""
When we share memory through FF-A and the description of the buffers
exceeds the size of the mapped buffer, the fragmentation API is used.
The fragmentation API allows specifying chunks of descriptors in
subsequent FF-A fragment calls and no upper limit has been established
for this. The entire memory region transferred is
identified by a handle which can be used to reclaim the transferred
memory. To be able to reclaim the memory, the description of the buffers
has to fit in the ffa_desc_buf.
Add a bounds check on the FF-A sharing path to prevent the memory reclaim
from failing.

Fixes: 43609000177625
Cc: stable@vger.kernel.org
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
"""

Otherwise, Reviewed-by: Sebastian Ene <sebastianene@google.com>

> Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index e715c157c2c4..637425f63fd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -426,7 +426,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
>  	return;
>  }
>  
> -static __always_inline void do_ffa_mem_xfer(const u64 func_id,
> +static void do_ffa_mem_xfer(const u64 func_id,
>  					    struct arm_smccc_res *res,
>  					    struct kvm_cpu_context *ctxt)
>  {
> @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
>  		goto out_unlock;
>  	}
>  
> +	if (len > ffa_desc_buf.len) {
> +		ret = FFA_RET_NO_MEMORY;
> +		goto out_unlock;
> +	}
> +
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
>  
> -- 
> 2.46.0.469.g59c65b2a67-goog
> 

Thanks,
Seb

