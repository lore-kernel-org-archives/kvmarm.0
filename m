Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC335FF6E
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783929962; cv=none; b=u8tMBY0S6Z28Tv3uLVHDKtr06UK6PAqk2W9Gmyxp14A9dJOvVXhuR9kzf5UR0/XYP0bFW+sByp9P6hnCIo17EDoytFaKeX5hRcwxSWzjqF9AgG4NJxmrrEC9yzL2ALyoCHYe/9y5QxnVGH1nBGiZ5qgXBUelet4ey4iT18TZY84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783929962; c=relaxed/simple;
	bh=rfOt4jyberQp4CJcTQa8rA0qEsOHKM63rerhgeYik78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVpTh/qhfUdqT512yWCng+YHl1o2nPgAiHSio3EprMIfzlrxnHpPiD81NWee22Y4Jm1YyYr6KnXouV05MhOQOmlC5m+PAIiy06HbpOAaDXdglxQ1oGtoriSHwYU3EMqr/rJje8GZSK/HqfiQn9Pv/eov0LkZxTF/mH/VN5LoKVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJvjPCEF; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJvjPCEF"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493f60208a5so24134795e9.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783929960; x=1784534760; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ClffvjIACe8ETchiqiqAYna+AICp1RDo+AuLSafnSLc=;
        b=EJvjPCEFBax24huDiCnMTgUU2SYtOv31cVaL02ljUY9IX6Bx9tGLaryrBEOJy3szsG
         UxL08KUgPNJ4Yasmcb6BAZyvFnfIb3fb1N+qR+dLwBQoka1QT6UQP28pPb8ztNHjrIkA
         JANNK8LD7e1TpofLyKKBuV5m3KcSOjh2FDhKMHzu7Tf0LRhAG3DdvmBhitwXWeDo0Oc+
         7E8ljyycGOm7Exw1FPs8DkuusQWC9pLIk3qT+/SodZje7JCyK929q5QekG6ESZOjKLSN
         PHCuL/l4W0OI2333y4cagI/i3KDSCHg+CuoNuFHkSol7qF2xKf8Qq+wlDs1iSBYCABqT
         aS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783929960; x=1784534760;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ClffvjIACe8ETchiqiqAYna+AICp1RDo+AuLSafnSLc=;
        b=CVS9lrxgrCIssnotBh89CGEiXeni72aJ04Bg1T3lpn0Nb7u+Yg1xE0bmDhcuE6mpdH
         cnseTG5FN9J95Eii1u9vLSCEQ4r2mNnU1+tpnyaajfbzXH7BFasx6yIcfAFb0qzc1Mi+
         qnIQFSx0TrLgZeRa9LCzFN3dcBCVhzf0J9YxZTXUUZz86GT8+cMyCf84rN/frs3dxbW1
         niiLiR3s1fRE7C/3bG9SXNJs+OAORzVjjYphMS24rWJ7yBKWlfQ7TYlIij3xWQpY0uEJ
         56bGaszscumWn8HS1sMKIoEJ8PSZPn32JdZRV2mOwMBkptqgMakcjs5oZ38Nji3Kij/1
         Aa5w==
X-Forwarded-Encrypted: i=1; AHgh+RrumcDyFC5NgLMbrOkZPR+wJZ7zTbDfSJR9wVhJVnUWByePZIhxx+kXYpytX7319az7MetR1jY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/fiVdogXzwhptA2bOJI+Z1hXU8RgBFVs+HYp9tgxgQaWyRtay
	96B9xm2ffr90wHAZLsNS+0J/4jHreoOQKUkKPpBbLUvdyHBjI3TLjbnO4ODc6ZYMVw==
X-Gm-Gg: AfdE7ckNrwIOjX58hQjLh+O33hm6QrrvDKIatc195vGIyB1IuHZFVWdaGekxBrXjKKi
	/JPOeyUCQlCiFPhsIfDl3BXoj17ZbXzg/iowNwCJ0p4BoYVKSdC85UYgkuujy6xa1vtUWqVUDWW
	BEfozet1M/HdxcoUfyqTTSZheSo3iu3SeHNOegjhj6WeM4UsIHJ8xuywlRdJL3wM9bpJr/GuX7B
	+zMwFo7IvbjK+uJPgph3HhMw6w0u2C+pL0ffgFWnDEzZ2IoNRx3VWleSNmR7j/pCUyRTa5xS5MK
	6YhHwZzdEhGJUDy2MzJeRssLtxVkztjKEXdAY6eY6mShDI+ULclIuoth+7O/CX/73OvZgQv0K2H
	D1ddkbxRcAS0SoGTXmlkKFOAbqLWKjR50xyCk1UUxjalv0uuOwk/fw//5UqncuYDvfdjW5ySB6+
	AKT8XIU2ICMaiCFGzCQ+0OMZZ0ySImF/wuG/SsblgpgONOgJaRmic=
X-Received: by 2002:a05:600c:2247:b0:493:e79e:da63 with SMTP id 5b1f17b1804b1-493f8834ea6mr57976005e9.34.1783929959307;
        Mon, 13 Jul 2026 01:05:59 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ad69519c2sm87654632f8f.37.2026.07.13.01.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:05:58 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:05:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alScY4MJFILO9-xO@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <alSbqDyV3Koez--u@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alSbqDyV3Koez--u@google.com>

On Mon, Jul 13, 2026 at 09:02:48AM +0100, Vincent Donnefort wrote:
> On Sun, Jul 12, 2026 at 03:38:35PM +0000, Mostafa Saleh wrote:
> > When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> > defines a static inline stub for trace_clock().
> > 
> > However, trace_clock() is already declared as an extern function in
> > linux/trace_clock.h which is pulled in EL2 compilation.
> 
> I am completely unable to reproduce that. CONFIG_NVHE_EL2_TRACING, isn't a
> selectable option, it depends on NVHE_EL2_DEBUG.
> 
> How does your .config look like?
> 
> > 
> > If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> > is disabled (by including it manually in setup.c) it will cause:
> > In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> 
> nvhe/clock.h seems already included in setup.c

Ha no appologies, I was looking at the wrong branch.

However I am still enable to reproduce this issue. So I am still interested in
knowing your .defconfig

> 
> > 
> > ./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declaration of ‘trace_clock’ follows non-static declaration
> > 
> >    14 | static inline u64 trace_clock(void) { return 0; }
> > 
> >       |                   ^~~~~~~~~~~
> > 
> > on GCC and a linker error on LLVM (it seems to change the linkage to
> > global)
> > 
> > Although that is not a problem at the moment, as no other files
> > include <nvhe/clock.h>. That does not seem to be the intent of
> > this code and that will cause issues with more users as the SMMUv3
> > driver.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > 
> > --

[...]
