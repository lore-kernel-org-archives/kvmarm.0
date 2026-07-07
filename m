Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38623EB0FF
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783449214; cv=none; b=oQN6OLUl/Ghnze0KJ5nd6zpWkq6rM/h9BaSk1sDjROawKAv17EdWE/GLAxUsQK6JM1YE5Jmh87VvCXnAnEWbO7Ll9DEDcA9fupm6G9S0Gzy5UMMlH4A7D/0SAZTfI73r2b7Jh0Wp8HRI7Rt5TgdtBU7gyJ7Zkqk7l+YcVbacCSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783449214; c=relaxed/simple;
	bh=07oZOUZ38vMsfwrR3MJQd6ZZkDtDMA10NSKo3X434LM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rbvG+Sc4QymNmJK76qiVVSALfqOqJys9gNOKaQ1hduvgy35AgLnj2UKTls4QCy+YMNsB3JzQGrgydpu2eKMAnFD3R+UUC0/yPBtcFXU8STBwmIPSgCGgX+0MHk47QRhFVGoGNmyqstglV7SKMF8OakxzuOot1cHmam17b+wa+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FpvxlIDL; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FpvxlIDL"
X-Forwarded-Encrypted: i=1; AHgh+RoiWYNCI9FcR0oiZ8b4yjyAsVjPZgQ3NRdxWBs+/854zpzinSoCo1gJd9gOaYk+qePoDaQb2io=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783449208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIzicJtgYbCKzLvSO/GpRAV4BTLl8KZx9Q+QcO5m+HA=;
	b=FpvxlIDLDMNfidk4ab1zivxRTuwCjokAfl61jaO1Qeu0TGdFBB4mTF1n3EkN03tfOCOLTb
	3F/sR44RJZcRmZ8uBF86o8aRRBMm3Oqb/KaR/Gcik121dwAXrd35iHTbcbgd/hiq/W03mc
	VOA0leSd2YPuy9TUlZTt4FGwA/YCHuI=
X-Gm-Message-State: AOJu0YyxfGWXz7liNrwga4qBajHUnsZmKq8uNtUQkGKw27KKcwm5e7+k
	QQq8uT9I3W69YLJNXJRInmKB7UKduKg4EM9ptXNK3B5RA673dLG/OT+G2Q6NyyOUQBajuZM+22j
	AC7TvYqrwKcSiqWJjTvMJIlRGAGJ6sWoh6kd/EvDR
X-Received: by 2002:a05:622a:145:b0:517:5c70:46bd with SMTP id
 d75a77b69052e-51c8875e1e0mr402291cf.11.1783449201189; Tue, 07 Jul 2026
 11:33:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260707165029.3410701-1-vdonnefort@google.com>
In-Reply-To: <20260707165029.3410701-1-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 7 Jul 2026 19:32:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx7C7BEmyoZgx6-PWvfAHpP8AWMOefTdwOQjw8NrPhLNQ@mail.gmail.com>
X-Gm-Features: AVVi8CdJn6U5iCpuDt2Eoj2HBtV5xWI7t-8BJNIztXKGfR-5BqWmyGW03nrfYJs
Message-ID: <CA+EHjTx7C7BEmyoZgx6-PWvfAHpP8AWMOefTdwOQjw8NrPhLNQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Vincent,

On Tue, 7 Jul 2026 at 17:50, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In the very unlikely event of a failure in __map_hyp, the allocated
> backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
> this by freeing the pages on error.
>
> Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932..5fbbfd40376f 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
>         int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
>         size_t backing_size;
>         void *start;
> +       int ret;
>
>         backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
>                                   num_possible_cpus());
> @@ -171,7 +172,11 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
>         trace_buffer->desc->bpages_backing_start = (unsigned long)start;
>         trace_buffer->desc->bpages_backing_size = backing_size;
>
> -       return __map_hyp(start, backing_size);
> +       ret = __map_hyp(start, backing_size);
> +       if (ret)
> +               free_pages_exact(start, backing_size);
> +
> +       return ret;
>  }

nit: would be a bit cleaner to do move the desc assignment to after
the check. Also, I think sashiko found another real bug, don't think
it's serious but worth fixing.

That said...

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

>
>  static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
>
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
