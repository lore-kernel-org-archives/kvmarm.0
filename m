Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68993B3BF2
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 12:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780660894; cv=none; b=WljoP65sBssGJp5t2rv57c6kcqq4SxQjQ41gxfvkoCpMmcMlBeeU+Z9IRJG9yFauAxo8G3LSax+xhAOlj4po9zE8w3IbQR/ano/1mlzNzvT/pFD2z880a+QpwC3QjWvszsFQcqJ9lGovZqwUOiaLYfewOs4Ol6H2lHwuMXJQ5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780660894; c=relaxed/simple;
	bh=2Hu0OODba5Q6ygSS5Y6An9Vqwxw+RqBSG+XtkbbFEcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7YXrWBHUMriATrOf9p44VArKPmzrhr4Fc8uml8vOi24vIjf1MVDnYTNGvxnGuHDq0sd3pnmPFpoOKrWEQMMYwWUubUZXe8cq/cJ561/fb4VhxnJKZO7ZnbwrQyZYVP2Cve934iLiO9w2SoCN8dW4XeWPQxoDkj7GRMuXa8H3dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JtM+7qkd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JtM+7qkd"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso68675e9.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Jun 2026 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780660891; x=1781265691; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eaRVw0ksze4pMdMwnejVPQNu/p5iHH1dKv1uIsvyi/U=;
        b=JtM+7qkdLNl2VIy0/7PwzO1fQ+yNvwvAmOrAWnY32esJw/xv4exQTsLo1yINe3YowG
         Fw4OkiWDlxSwpR88jLbeVmxFLnBwV5roBmvxQH2AEDeAzqT5wxdZEtf9OJHXw6Os7bmZ
         fF8JSLzVRLP4ygrqxbh/PUpJJzYNP1XF7BLXDASMApvQ0PyNtecz8OtaDQVqV7HnX862
         krW5RfvG5rBGC/w5wpYcBF56FSmi7v9/9zJo1qd94Uowhibr+WmGjjPO73Yct+kLR91J
         UYlh4X9YkWFLvp33jCh3ugI0PLejRX9FCmzWQ+asKdiEdAnvlKVT6NzjKy8X3u3536PO
         7H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780660891; x=1781265691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eaRVw0ksze4pMdMwnejVPQNu/p5iHH1dKv1uIsvyi/U=;
        b=cYgNuJ35RGHEyUT1CN3G0iBo/wm/n6JPkWNKNU2Dt4mE2hIroVWEHc0HJf7ZRPqON+
         MQHz/UVcwaftChDLOXnnlNrPFxlzZ2q+qWhSqy0xVCMqlEPjZkvkV2jbaGiK9TGuPr+8
         3NimwFfnwvkSYaEDWPcz527qlmn2ylYG+Twvc0O4XSKJODDnvKalEELBQ4KQP5KfQzR6
         7BJDBRZrmB0RAtWOcURLHMw3dbMGzUUoTle6WKioVemOx+UJYWL2xSkEFQiiM7DuFJIY
         uaSUKbD/oZZw2mRnrqRVtuj49TUJYwHS08zjxZgaKKtAE4EPGb/RrzrKipQb6Oph2Zp7
         IEAw==
X-Forwarded-Encrypted: i=1; AFNElJ8Z/vQnV6KEZGy6ASyozcIwYzFpfCFC7WW2jn4S7HQgZMDFvw75dXnwepp0ja0ByEoz2Pz/uoA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQokMExsOe80k9W1EftToXcYlDd5kMIAioAza62/bf90cQa68u
	dNnAaLdtLWHmUsU4x/Sh0gCPZ40Q9PW9d22ej5XzoTEVOjckOZ9N7FRR7fPh2Tij2Q==
X-Gm-Gg: Acq92OEgu7wRVisK9FJNdy5OicLuDmFxe4dX+WUpDm4yuvAD2SxINGsaJnLA3UYdauB
	VRZEADAqiSIyLPocGzV5WMDzNa4oceMu/JACL93fCz7S+mESeFdfBKdA5l/Nc0eZhNTz7gdqRK1
	g229YP6z9w0dm0QqU4FaWI3Mg22swvc2dxdocw0o++ji46Imhi9pGW3fxFG2wkSliNz3N24siUX
	8IyWxop2rYzEg34PA7tMLtQdovr5OZUjIUP0WItQ3n32Yvk9IvRsCE4/uJUbFZaHipE83NpHAer
	4OLlFrIq5vl1zORANOT79XJTPSYBbNrr3XE03ysiea//WUAh8g2uDaXnnIfdF59HZJNqK0NphFZ
	8x0GL300sBPbDYRZ3cfmY8AclfAZ1rFshqQQACf31uduYoLkNXzOqOAK8GUqZ549H3ZcLuyVFrV
	+uuQn74LLR0gEjnc4L1WR/zeREwGaUzvDiMpAoHfsW7mjpkY43QX3f3Si3xiJOI+aCB9hSGJvAG
	92Cnbso
X-Received: by 2002:a05:600c:896:b0:490:ab15:b9e8 with SMTP id 5b1f17b1804b1-490c2c782fdmr493135e9.2.1780660890657;
        Fri, 05 Jun 2026 05:01:30 -0700 (PDT)
Received: from google.com (220.71.199.104.bc.googleusercontent.com. [104.199.71.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc4082c3sm144221845e9.13.2026.06.05.05.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:01:30 -0700 (PDT)
Date: Fri, 5 Jun 2026 12:01:26 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v5 1/6] optee: ffa: Add NULL check in
 optee_ffa_lend_protmem
Message-ID: <aiK6lgW5YFWSMTxf@google.com>
References: <20260526151934.3783707-1-smostafa@google.com>
 <20260526151934.3783707-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526151934.3783707-2-smostafa@google.com>

On Tue, May 26, 2026 at 03:19:29PM +0000, Mostafa Saleh wrote:
> Sashiko (locally) reports a possible null dereference under memory
> pressure due to the lack of validation of the allocated pointer.
> 
> Fix that by adding the missing check.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/tee/optee/ffa_abi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index b4372fa268d0..633715b98625 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
>  	int rc;
>  
>  	mem_attr = kzalloc_objs(*mem_attr, ma_count);
> +	if (!mem_attr)
> +		return -ENOMEM;
> +
>  	for (n = 0; n < ma_count; n++) {
>  		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
>  		mem_attr[n].attrs = mem_attrs[n] >> 16;
> -- 
> 2.54.0.746.g67dd491aae-goog
>

Thanks for fixing this and for including my other patches in the series
Reviewed-by: Sebastian Ene <sebastianene@google.com>

Sebastian
