Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F5386545
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 09:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257356; cv=none; b=jeO4jQOyp7GpIx+AlFe3mZcn6OjzaaK0cKhSIrsIT2ZNiIcc81Xfpg/9O+3AxvitEXftvFfeEmsYFFSbyEnG/WruTsV2JGlzW+VFpthdGjg+MCJbBKU5Yq8Jm0h5fpce1ZmL1Twxb+F034h8nBfPDe7761yxJsjhI/IoMnS403w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257356; c=relaxed/simple;
	bh=j0lRr4uQumusVhShbHT3x45ZVIVLWydOil2E35eDUjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptpq1f6yWyGSWto7/bwYhoMDl4b5xfrujjTlpqYziiKO1giv5Q3IBke7kjBQ0L+TJux0rEmuBVX2mr7oeCg4NmBBammIcsYLFTeH5qR6afFPqz7Ano/J5iecHmzftsPr4flGoIf/ETdTTkb5tcS8za8LYKLBOc3SUkl7lPkEhEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W+MWTH6m; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W+MWTH6m"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-487012ce896so12573115e9.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 02:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774257353; x=1774862153; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YU6TG7BhEYw/Kb5KtuLrMQYWwx5oDAgZWzaduafFFDk=;
        b=W+MWTH6mwvl61PkvScWieRzW/9oghXA8FbAbOARgTjwYbiS5i30gCdD2i6KGjBlvy5
         p6BUTUEysrQFW9MWj6Gs7XdGC3ZvtOKJCLknjGwO/tiLBM5jY89OQ9gmGghfP2RQ/5+u
         C/ZmtsNepkeoAfIibLLcGiZlimPlKPT6kOZYseHHgZpORMLea9EX3NwOIDUFWikNsWN5
         yY2DXlRCmv4OV4ZddKE7G4oChxAY0h5bDoYhGx+oU+1noYrKdKyEAWaElc7RoavobWSr
         l2Qi5ceDwvS9apuOhEyvjRSTJGjH0F95BlQYfxVNccBIKn+R6yh86EvsDBRad7chct5f
         5VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257353; x=1774862153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YU6TG7BhEYw/Kb5KtuLrMQYWwx5oDAgZWzaduafFFDk=;
        b=rQMa2AQ9/GnrZ8n9IYM6ytk395MhnsYdiaEk4efpHkvUgCjZ/BSm5auMJGEcNfYe6L
         H6mwap6OgBRicIMQQ3EztD5DkGT9/rxyTV8VE3Uc0qh8Yhgv6/P4BYnagutur3Dayhx8
         daq2LrDu0My+sDpwZS0vv07VeD3WqZQt9KoWBtQ6zUytgLfPSTSNz5m0SwSWaH4PmhRT
         HIkmXy7ORryByMcx+/UUOKo6dl8QGFftPkSjL89fqDwHjesh10el5OlLIdrebb5Kgwmm
         cfNi8OZc8tNTJMfWITsryoeL1Mmsh9GAwrUmUaiifOLXqSpAL3E19RLzinhq+BAz0xDb
         hRkA==
X-Forwarded-Encrypted: i=1; AJvYcCUU8AMQKewH2qo1ZCvkmblGypPUKlrvAVPcZciiDiZb/9+EPkT//bl8GvhEDawbvzzSFiYpY5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRTsXAc37o4JZPT/sU+7YZ64UU3adLK0Ghc09WC0VWKzcwWIYU
	HkslgZ5abk2aAUhd1uBXhsTWIcAWR5bw0zGP8ZKKdwBrqQOPxrNmsy/xxHvsyEVFvA==
X-Gm-Gg: ATEYQzwZNZd/XHji9TrNLsDIV8gbqvcEdr4mfrdwL2YRvZBjUYFxnyoVkq9U46oTE7g
	ZuJzs2IzlRvRPTcoYyK886odvfPR3N4qt1sffj/1PAIBj7Q3jwFvbb8AdjwibOxm/x8ETx+F3pk
	1bCEDmPLS1wQHlWnuBgS7gXCNk9/AYo2bo9uCFJMFtJo8KLcZAw0Gf3Ud1syilhl9E+L0vjm3np
	IYAcnlbK6ce1OVqyRc8Uy6SZSnPRnR0ABZ30ZZKiwy84o2pRvl+yCqCQkDeAzvWU/YCexzKmAWZ
	hKE9oFhFHopFS4qUqx7B1LL8W4bciDyzJEiE8Jl0aeIr8qOR36Y2LSB3Y9X5P5a2GYl7V1Q0+GR
	hf+l8XvMxoY5fHOroxMKIJZDeqdcdtKY/D/mZwj2EcN0+P6lLjQWegchoCZRsjTxPnoFj4GjAwn
	WoW+lxEAyYqzJBET6hS9GH7qWAHqv9JamTEKBlWRA6JG41eEXNEThsKDacqf70TEYjaa0=
X-Received: by 2002:a05:600c:3f1b:b0:487:59c:2bb8 with SMTP id 5b1f17b1804b1-487059c2eb3mr76504415e9.27.1774257352602;
        Mon, 23 Mar 2026 02:15:52 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48703e26408sm277752545e9.11.2026.03.23.02.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:15:52 -0700 (PDT)
Date: Mon, 23 Mar 2026 09:15:48 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] tracing: Adjust cmd_check_undefined to show unexpected
 undefined symbols
Message-ID: <acEExHx9GPrhxHzk@google.com>
References: <20260320-cmd_check_undefined-verbose-v1-1-54fc5b061f94@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320-cmd_check_undefined-verbose-v1-1-54fc5b061f94@kernel.org>

On Fri, Mar 20, 2026 at 02:29:33PM -0700, Nathan Chancellor wrote:
> When the check_undefined command in kernel/trace/Makefile fails, there
> is no output, making it hard to understand why the build failed. Capture
> the output of the $(NM) + grep command and print it when failing to make
> it clearer what the problem is.
> 
> Fixes: a717943d8ecc ("tracing: Check for undefined symbols in simple_ring_buffer")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks!

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
> Commit a717943d8ecc ("tracing: Check for undefined symbols in
> simple_ring_buffer") and its follow up fixes are in the kvmarm tree so
> this should go there as well. This is the rebased version of my
> suggestion in the original thread:
> 
> https://lore.kernel.org/20260311221816.GA316631@ax162/
> ---
>  kernel/trace/Makefile | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index c5e14ffd36ee..d662c1a64cd5 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -174,7 +174,13 @@ UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitize
>  		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
>  
>  quiet_cmd_check_undefined = NM      $<
> -      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST))`"
> +      cmd_check_undefined = \
> +          undefsyms=$$($(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST)) || true); \
> +          if [ -n "$$undefsyms" ]; then \
> +              echo "Unexpected symbols in $<:" >&2; \
> +              echo "$$undefsyms" >&2; \
> +              false; \
> +          fi
>  
>  $(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
>  	$(call if_changed,check_undefined)
> 
> ---
> base-commit: e3d585ed3ff891a00c2284fef4be9cf8581735ab
> change-id: 20260320-cmd_check_undefined-verbose-7d15f13f615d
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
>

