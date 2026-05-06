Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A3A3F23B2
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778079831; cv=none; b=q66TMb85UQFeqLyG+HasxDeK/LQns/FL8kKKpjuk/9FW4lMZPg6ahbr/bbIS+wknlHCHG/nor6ICk+ueg6cVUcqBlHSD6QnOKaShv7jiyVAbbcK5NLB+0Tryqxj+YETf/wvjg2uh/+Pv81mhvmzNloplxM1EIl6GitAUZyZwSP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778079831; c=relaxed/simple;
	bh=Ct1xfBRKSQ/KPsXPmmNT+q/a4D3C9TqoNeH2NmQsQFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QscldVTfppznewK6iyjCrVarL4sYI9yILCSyFH0YyMjmqJsbQzN4/JFtCW7WGMJnLI+f40JbveZoyyozDtB2fJeOFxn1zMulcT7APJSqVK+/O3AxZP/YQihJGbv5uJveQqxcUIQDohF/Q97HLiF2uADarkyGcUyytrl/p2eKcG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CVZ++cml; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CVZ++cml"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48e56c1bf5dso3809155e9.3
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 08:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778079828; x=1778684628; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6lCUuXDcwuMuvkw++7nOHtFX8FGwzsSx+p3o4zIoa/I=;
        b=CVZ++cmlKKWAV7srhTIgN0AV/IrM3Jn44xATKptQ5ITzNZd03dqkYPMBVRmjahLXxp
         eo8Fj8330OqFCoKfexD0G+O3dYtOP4eBxcOcw1/k6KPznwbqliudDfyHdQmSRZTXouGj
         R6VtY0V/rqrdS168iqLe5JFGysJpAgEigiardEn+GbDayj9ZcL+vFM3/6Gz87j025VUQ
         NEyG8GhxVYrGTqO1BhEJ72/Q11R87u5ea1O9tRQSCWfxbbBqre13n6my5aOFX8pwAUMu
         NNWZa3es3giFxcAxkGF+oGtaw7ltkFB0vvcH4Mw2HPQAum73Nu7SopWtD3ZNWRx8iBX4
         pHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778079828; x=1778684628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6lCUuXDcwuMuvkw++7nOHtFX8FGwzsSx+p3o4zIoa/I=;
        b=Q2/WlMjqrPw4QvmVCWYYgatySneP5DjkBfP2hUijw7NfEewrPqpUT9qcHLC+/+qemc
         +GDxN9NIg1DMspJgUNFgOtYa9FV0OsnUfH7VjCeN9MYmnh02bb6gUYAt5/a0hn2ANKyG
         K4qLJu+R1JaWMIS2SVF5IMAzXYDro+RND4wEFtBBrT7o7bh9BQgq9YhXTbxjiK7vYTgx
         ILVacZ1lA4a/fxAE8gNZa9jT86GjQCF3VPMdxSWC6SEoFsqA2bGx5P30jfkeAG46Ktqc
         Zko58vdwFNGYNJv6AQ7kD4eKknK60/Mkk/J/0M2DXs4fOZL7GKQC6enSkKttNK1ayCku
         cWAA==
X-Forwarded-Encrypted: i=1; AFNElJ80UwHk+5si6lA5WssAnSNOJQIFKnoez4M2a9LJxhw41DbS6h8B+iRcwwhjh+yBMnXXcFAq5YY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyau3okb2X4Ip2nN1sUQ6JEI5kqramDuFmhY4DDeGVTAUWrVtKt
	kMTtGlvFxWSDICk1uhHRrYuTetdZLMOvNQ0zxdhThZN43xcJj3iAs/slGEUu1RswXA==
X-Gm-Gg: AeBDieuY57eEkAnHDA92lrQ7vS+iTDYia/TzJb4ZtfRKQlG4wClpYMxaIYtrznmzBAB
	/R2LIIPU5n02sPMqUT1+E1f3EuknFcWlYg3pXjFkXgNtfmrQBSZTCH4UX2gUTSvUwkus54/0Q5w
	LnCPokwbY0pnDjwPj5X5TEUCHK2ZXyYPSVnAs7/nniqgm0bDvpFQWbP9auxO6HfjR8jSezGhTo1
	kKIHv7YwSkqz8FbY2pHxCFigCVRmX6yfA/C3wz4IR0HgFOccvGyYIClG98r5/QKdF4hFHtYQVi2
	Kh2POWN43axHmgaOgC7MwUCJ4QbiVt7eVcRq+Lh89BgwjjtBoIW5nR7Fy86JI0GxuAVgcXldJfX
	+ltDtDCLFrItgOeIMWdC3s7x32eADA7zOQ8RmY+jLQaSQ24Ow/trK7pZi5dq0WJ6x6V7DpVWyXi
	X7xVgbZGvANUuXqmcWHBeH7wwmR8YSDekkAA6R/ItPvITM/nbyXSN+pLgvFsYsbSQJ2ZsAxl34Z
	kHT0KOAdE2zzxSP
X-Received: by 2002:a05:600c:3e8d:b0:48a:6268:18a9 with SMTP id 5b1f17b1804b1-48e51f32797mr69446495e9.13.1778079827439;
        Wed, 06 May 2026 08:03:47 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524834eesm12653531f8f.4.2026.05.06.08.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 08:03:46 -0700 (PDT)
Date: Wed, 6 May 2026 16:03:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Harden clock for nvhe/pKVM
Message-ID: <aftYT7BY_9ZdGxmA@google.com>
References: <20260430103724.2151625-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430103724.2151625-1-smostafa@google.com>

On Thu, Apr 30, 2026 at 10:37:24AM +0000, Mostafa Saleh wrote:
> Sashiko(locally) reports possiblity of division by zero and
> out-of-bounds bitwise shift in trace_clock_update().
> 
> Although the clock update is untrusted, we should at least have some
> basic checks to avoid the clock value getting out of sync if the host
> is buggy.

I am not sure about the gain here. The host can still write values that will
make it out of sync anyway.

The timestamp is ultimately fed and read by the host.

> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/clock.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> index 32fc4313fe43..a7fc61976fd0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -35,6 +35,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
>  	struct clock_data *clock = &trace_clock_data;
>  	u64 bank = clock->cur ^ 1;
>  
> +	if (!mult || shift >= 64)
> +		return;
> +
>  	clock->data[bank].mult			= mult;
>  	clock->data[bank].shift			= shift;
>  	clock->data[bank].epoch_ns		= epoch_ns;
> -- 
> 2.54.0.545.g6539524ca2-goog
> 
