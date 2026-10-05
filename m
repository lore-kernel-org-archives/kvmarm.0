Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0117C30F7EA
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791185104; cv=none; b=YohbUXp1U9wZ+gISU3HVm0U5GNBEsM+snP0QOduBf2Dz9ftzt8SLoC2ToPLl11MYkBH/yMKLC4qTmxgHI62YXs7AcuN14HqPf6egJRzXHpCeVpq5zi6NtrvpvEtEw+nFbUht8M7cHmrGSemXQjV4p2f/avZcTOIx6IbnoHblDZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791185104; c=relaxed/simple;
	bh=uD8Ku/7Qa9xnckRpqY4kacFtVFeiLz5uhXJR3plqRB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haY6U5QVWVsx1Ema9FRD6VGo8ImdHKV4kwMZTKBU3mpl060UEyiQgK9Q3gF2A/lN/B51F+wjeowYS5Frri/oYJ/MltHzGdhlwFoQgyF0DFgbWd5wUeM5ajV7RrEX4AM5nqpN94pLq4e9eM2w56fQVmkmr5+jnOpZdHP7UmHCxwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qnd+yIzV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qnd+yIzV"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a16c1608faso7538685e9.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 00:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791185101; x=1791789901; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Anf5KHHXmIQryXJL7OjihtFBWm+PJQaijP7bg/SprY=;
        b=qnd+yIzV9XwlOnY87yc9BtSMryhBpNM6RpZf2i4M5kZFLaEXdFm96IH1lzQFazCGjb
         LBu9o8iKSEMxmfsAXcYgC0a9Vxaw3enmVauGVwmUkXsjNLIeQ0uPwEViVoW73RZTJqlv
         vMVfzZ1s1TxLj9/VwLLa3vEjxu+latlFd0gqX4uz6I4mI62fWguxwXG4IgJ2yxqh7DWb
         8WEF2haQKEvxtLhBQHe3IoIPIEr/hHeD400FCsTZVExKJgNtP1rtc5XiNnmTabardhrB
         nBz4lLSiCGV37N++j7QsJT3h2yark835XsA8uEvlv56ULwY+WJ3YB8iYRxDiQL/+KBrJ
         uRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791185101; x=1791789901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Anf5KHHXmIQryXJL7OjihtFBWm+PJQaijP7bg/SprY=;
        b=BGqiOEheje9f1jORb4MwmkS0zEruqlEs65L9aOPMFdV4TIZ07clo3ryZy/98foLsYT
         hzNe32r5kjlyaOuD7aTp+/u6dxvuZ25uUUTHAeE68CbUWkhMhV/jW0Y3/LK7LvxnaQkH
         /7n2EzMxEkF1ZeCT38MLHPCwcHVkJBNZ7kzI2WVXJ7Tez2dDY3xszlBuRGJpUuiS5rNZ
         C3+7jL5BVe2yZMxK9JQuma5bWIxzukXkp9GytKav8G/T9NwzS9MlIji/uFTs1P9vkjlx
         6DN1wEOjQFcrK4ihMI0GNUDQPsqtlwCMz4eI9o9wyEBzefAUhAae+IqYC1z6sGWuIInM
         5b9g==
X-Forwarded-Encrypted: i=1; AKwUvBxoL+LnreOyWiYo+ck4lzGjuJfT3NPkDH7IeMFfLidV+dlMiQ85p3E/cjgwioRuQDR/dlXRr8Y=@lists.linux.dev
X-Gm-Message-State: AFuF++nBxjBC35Ao1TCXZFVNXlor1oUSG1ZBR/4itxjDu0AzwBdOrQEb
	qhHO+Esery++lpcb5CPlVv1NVsTHy4WDD953VbRvIFSnEw2DiW5HMf6ZtgDdgpOAD2k+7eIxpVB
	T+ZZpmA==
X-Gm-Gg: AYBFou086OWDatgzUErh2Ob6/i8ddPHGjnILONsxTxwjTKANdOfEM1v8PDzQI+47Pq3
	ekzc2xXnak4DRye/0oXFoVw1PwE+CuiA7nd4LNUJ2TVuKEUPcynFz6V5T7h0Ix6XFtrT/BNm+BA
	Nlo1xNz52vK10QyIPq3FfOpbXKWKMf89sAgXBIVOcZMxHhbGsZ2xvGfSl64G/7I0aozSj2q81Ze
	4Wl6DhsMkNel1JoJotJbnj2bhKy0bK0KVLkocuwUiPXkyiQYSp2OxlmXPnSgbGN8v6Um+O4pAQP
	Supa0o8VG6vnPwyvWMW6wVj+tSiKaWsj/qnjL7GxRaOav3XHHJQ5oRacG4T2p+/Yx0vwhQbPQYl
	Qh+MpdWuGTqr6LTPaFNDq6l/uHiQ7mPoC+kFImM4/gv2FZm3t5WFJ7mgOPKX5KhVRPx2BgrAwM1
	SmrHE17OD8/Gu5QUiRgJVBe8+8jWNzPgYAuB50LRlQmLbuzhgPmoSRDbJRnRYGQJjvW9UJ2Rdx5
	oXxmaCzSgODV6x9+qXj0l9m6D2hL4p4cM9SljOjMrY=
X-Received: by 2002:a05:600d:8645:10b0:4a1:7366:6c7c with SMTP id 5b1f17b1804b1-4a173666cdcmr14240555e9.5.1791185100477;
        Mon, 05 Oct 2026 00:25:00 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c63904832sm1218489f8f.14.2026.10.05.00.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 00:24:59 -0700 (PDT)
Date: Mon, 5 Oct 2026 08:24:56 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	kernel-team@android.com, fuad.tabba@linux.dev
Subject: Re: [PATCH] KVM: arm64: pkvm: Drop keneldoc markers for the
 allocator structs
Message-ID: <asNQyNI6nPcNuxwm@google.com>
References: <20261005072046.2246900-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005072046.2246900-1-vdonnefort@google.com>

On Mon, Oct 05, 2026 at 08:20:46AM +0100, Vincent Donnefort wrote:
> chunk_hdr and hyp_allocator are private. Their description is not
> exposed to the API documentation. Drop the kerneldoc markers.
> 
> While at it add the missing description for chunk_hdr::data.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

I forgot the relevant tags

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610041002.Yvw5qUrt-lkp@intel.com/

> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
> index c1881c0011c9..e1e6dd21cda1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
> @@ -28,13 +28,14 @@
>   */
>  #define MIN_ALLOC_SIZE 16UL
>  
> -/**
> +/*
>   * struct chunk_hdr - Chunk header
>   * @next:       offset from this chunk header to the next one.
>   * @prev:       offset from this chunk header to the previous one.
>   * @__unmapped: Internal field containing the offset to the unmapped page
>   *              boundary, multiplexed with the allocation state flag.
>   * @hash:       Hash computed over the chunk header.
> + * @data:       Chunk payload.
>   */
>  struct chunk_hdr {
>  	u32			next;
> @@ -45,7 +46,7 @@ struct chunk_hdr {
>  	char			data[];
>  } __aligned(MIN_ALLOC_SIZE);
>  
> -/**
> +/*
>   * struct hyp_allocator - Heap allocator
>   * @start:		Start in the allocator's reserved virtual address range.
>   * @end:		End in the allocator's reserved virtual address range.
> 
> base-commit: f0406245cb9855e6318335a8a223551354291a46
> -- 
> 2.56.0.rc1.315.gc6ed9934b7-goog
> 

-- 
Vincent
