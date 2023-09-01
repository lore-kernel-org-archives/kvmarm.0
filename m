Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA32572
	for <kvmarm@lists.linux.dev>; Fri,  1 Sep 2023 11:57:17 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4005f0a6c2bso37505e9.1
        for <kvmarm@lists.linux.dev>; Fri, 01 Sep 2023 04:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693569436; x=1694174236; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=reCEJHqFLA1tTH9reQV/iOmfsI77/ReXtaNhrLBR2u8=;
        b=EbL2zvgFaik9GEAAxi1NZknA03u/9LX/Zi8wqBXeumb4TMTPyY9CbXK5mB02QNggCj
         1KYHflWHHqKkE3/vCQ9VuvxCFpDqr6bQyuGiCS7PoiPt1NzARf+UhApeT+8lmTkJKi3Y
         9wOLWA03Jlp1NSKfgieYxV8mHgbc77loDmjKfUZEq0Gfw31uE1tJxP3ebbTcexbqjBQ+
         abc5CAtpJPZnJhlvG5L5juD4rJwlrBJj62P/pBUKO2LIE14ydZA073GpslkPnNH3EZeW
         Em+8Q5Vz0MmayfXnmhappNFCXdk/D70MyzExfQe4Ckkb7OvAq1N6KswTK0pHEeQJwzn6
         MQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693569436; x=1694174236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reCEJHqFLA1tTH9reQV/iOmfsI77/ReXtaNhrLBR2u8=;
        b=V4nnscWTBVCyiHDkX2FRUWhocrrq+JOz9r+a2QUrcHk9D1Sn4IcMaqSFxBJbbzJxFx
         tw5NsEAvozGgyGmV+CULdIzz72JTohonaU30BxiZ3rL6OaQ9akEJH3x7CWVlErLcNVMb
         ZoaRuibJxpn2Wag7DC+oRTN3dzqaO8Mm6lQ8UykgdajRKWNvjxUoYNUcvbSWPAQDv4/Y
         LgSZGgWywnmTtRsP0qt/AEnuHHsjwUKIv4OJnVLarObNshqeokfrMhVTT3ZXunSl3pba
         Ct4PWWfQNh2W19xjw4WeFBXKpw2h7WPJUO656Mo/3kUV/5J53sRIY/m+/QPcn6xzkspy
         XuYQ==
X-Gm-Message-State: AOJu0YzS/39DW9PAvyD4IM6QegH7loY5nq5AaUU2ieNMf8Xb0No8G3VF
	EpeVOaX0/kjmwweZMu+FC0r5ew==
X-Google-Smtp-Source: AGHT+IEYiE6an4LNNFzm40rOnWJRJuiTxTl9AnhfNz3EZyquRjhGbZh6SZsUE3rD71zSk7VBKYlW6w==
X-Received: by 2002:a05:600c:282:b0:3fe:dd72:13ae with SMTP id 2-20020a05600c028200b003fedd7213aemr134365wmk.0.1693569435651;
        Fri, 01 Sep 2023 04:57:15 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id t4-20020a1c7704000000b003fefe70ec9csm7783182wmi.10.2023.09.01.04.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 04:57:15 -0700 (PDT)
Date: Fri, 1 Sep 2023 11:57:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	oliver.upton@linux.dev, kristina.martsenko@arm.com,
	broonie@kernel.org, quic_pkondeti@quicinc.com,
	justinstitt@google.com
Subject: Re: [PATCH] Revert "arm64/sysreg: refactor deprecated strncpy"
Message-ID: <ZPHRlmBHZnFAeBeI@google.com>
References: <20230831162227.2307863-1-smostafa@google.com>
 <86v8cudtky.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v8cudtky.wl-maz@kernel.org>

Hi Marc,

On Fri, Sep 01, 2023 at 12:24:45PM +0100, Marc Zyngier wrote:
> Hi Mostafa,
> 
> On Thu, 31 Aug 2023 17:22:27 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > This reverts commit d232606773a0b09ec7f1ffc25f63abe801d011fd.
> > 
> > Using strscpy is not correct in this context and the commit
> > assumption is not right "strncpy is deprecated for use on
> > NUL-terminated destination strings".
> > 
> > strncpy is used here to copy parts of the string(cmdline) separated
> > by spaces into the buffer and not a NULL terminated string.
> > 
> > This breaks the arm options "kvm-arm.mode=protected, arm64.nobti ..."
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kernel/idreg-override.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> > index aee12c75b738..2fe2491b692c 100644
> > --- a/arch/arm64/kernel/idreg-override.c
> > +++ b/arch/arm64/kernel/idreg-override.c
> > @@ -262,9 +262,9 @@ static __init void __parse_cmdline(const char *cmdline, bool parse_aliases)
> >  		if (!len)
> >  			return;
> >  
> > -		len = strscpy(buf, cmdline, ARRAY_SIZE(buf));
> > -		if (len == -E2BIG)
> > -			len = ARRAY_SIZE(buf) - 1;
> > +		len = min(len, ARRAY_SIZE(buf) - 1);
> > +		strncpy(buf, cmdline, len);
> > +		buf[len] = 0;
> >  
> >  		if (strcmp(buf, "--") == 0)
> >  			return;
> 
> Instead of completely reverting the patch, maybe something like the
> hack below (completely untested), so that we can still get rid of
> another instance of strncpy(), and yet bring back some sanity in the
> logic?
I was thinking of something similar, but I see we limit the len anyway
by the buffer size - 1 and force the NUL at the end so it should be
safe, unless the goal is to get rid of strncpy all the way, in this
case we can do it as you proposed.

There is also a V3 of the original patch which uses memcpy instead.
https://lore.kernel.org/all/20230831-strncpy-arch-arm64-v3-1-cdbb1e7ea5e1@google.com/

> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index aee12c75b738..be5c778a3f14 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -262,9 +262,8 @@ static __init void __parse_cmdline(const char *cmdline, bool parse_aliases)
>  		if (!len)
>  			return;
>  
> -		len = strscpy(buf, cmdline, ARRAY_SIZE(buf));
> -		if (len == -E2BIG)
> -			len = ARRAY_SIZE(buf) - 1;
> +		len = min(len, ARRAY_SIZE(buf) - 1);
> +		strscpy(buf, cmdline, len);
>  
>  		if (strcmp(buf, "--") == 0)
>  			return;
> 
> 
> -- 
>

Tested-by: Mostafa Saleh <smostafa@google.com>

> Without deviation from the norm, progress is not possible.
> 
>

Thanks,
Mostafa
