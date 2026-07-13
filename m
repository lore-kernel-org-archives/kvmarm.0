Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D6236897C
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783930756; cv=none; b=tV1TSXMVBZaQ1PQJkdXuhnmZFPNObpvoePJAVEKyWSLr9ewMvvNSPqLKqUlf8wzt/aYSl5M7rx0RF4CWB0tDAMAY+IRjaMeHl8dDsOa1kFYbw27c4oTjG0cLl2SaCSbMm6ZpHuX+oQb3Lng5MpYA7q9F+eQyguG3rl3W5hVD8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783930756; c=relaxed/simple;
	bh=rP/RkM2dxwEf7MZOOKY+BHF3arlyhEjPq6JFCLv1B6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYl4aD7PUOovwa4CdUjTjpATp4Kaotzny3+IwfzJTZ+H33qqduy+/lyX1buovG+yZnENtt5NURANwwpbRrQdG8g6zOWik7h59EoPiwA6cEkf5yZ+jwNSPYfaim84MtTtWQxCX5ARgkfsy8svYK1S6CGJUiLIKTn+ERUlHwMWB5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bZOLYGIc; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZOLYGIc"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so81625e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783930753; x=1784535553; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nMhxQOXCpwevLLjNsS6PfLbFdbbTa/KxMnyYoWQBg4g=;
        b=bZOLYGIc7gn2DkdpJt5sHDGIpBM4vGODG1D+4Vo5HvV8fF6T/5LkaTR+4xC0/zVcBt
         haUIj/7dHGeyLi5I6bs78Max4gdAiRFEC/ogFy6DThWiN7/E5IEmT3eCtaCY/mwaYoZt
         8OoDb3jc2ICPCVS93vjj+bpaBGoKlR0uXsk30LZYU6Z5DNp/DeYFQhSs9194++CfU4C7
         akQedHEM3/uUeJT1/D9NYrY+pAkP93UiVfpY1/IE/euAcv4C/W8KTFILY/CxnnAnFH3p
         NtOlI9PHQ0cN0loxzJEHDBw/HVIdPfQFIN2SDXUT2oPOhdTrDPTVx1uPBmVz56PG8Gki
         tJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783930753; x=1784535553;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMhxQOXCpwevLLjNsS6PfLbFdbbTa/KxMnyYoWQBg4g=;
        b=ZASMoC/hHmSYe3ua1auknqJH6svMZySDUqwxXIpilcpSkTni/U5teSnXx2lE/wioJf
         68B2DMWzPo1nt7pe+zRBp1bkwho/AQ0dPg5ulX/j3c8i5IfxiWiHVZZx5qX71nIfux0p
         VoR7WYGIDQYXRgmpR4BQd1B0yPTWWdycgDjkiy1zRzp2YMaL90FZiObt/3rB709IJeEQ
         ncpTJDMZkO6mu35pSTGvNsGajULCf2ZeaA+r+uXOhVbsee1IzxLBjvQ1401iyvvgsAsm
         ZHDXOe4At86rIehJfSIvO4l2jaHcmlfk1/4Kwros0rRxyA1SnCLSq4xESyv3PbTBBezd
         IYmg==
X-Forwarded-Encrypted: i=1; AHgh+RoczXAun390I92EVkKCAaVEAhAE8DLEEJii3ESpn9DPZJsXVA3UzwECK8EJVppf1tTV+Gy0Bmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlV7qwRUibTAQ/IcoI/501RnxDBwE0DqrWfniqLYZmPL3B0bZX
	1tJgb5m2l6HiToYttEQ1MTKG23te8yeFKSXrBv2pv5SzkGz2oVNcOJz5/dWxPTfYLA==
X-Gm-Gg: AfdE7ckq7m6C+Yv5t7w6YNOlSPLSPg1I7U6bjVGblaxWkdr12eHpmqp31LV7CPD+vNj
	9cb4aZlWRsbxe3Xm7aIaxCQi1NyJkIkbRwHn6tXAHc19E4JdCwOMpp8hCxrJ+t/D2739dvBp8FV
	HUxrKV4tnW2ESI23Od41HYqX/yqUC/TaDaHrZ0wRusDScoNFBvVdsQSRAa4nWlS1gq60IUVnBgh
	gH57WzbMq5wL02vmL22aRKHi11f9znct4okyeXIIDLfgGfx+6lrKy7IfRuAvEVPDCoGcIjw3Ajc
	puAwj3/p+Ve0q3x7V1xyv79kZ0PpnsJWhrJJGjungfmlrBUqosKffO3R6yEgqNm9SY5cYi6byL4
	7sDQx0j5GAV21FXRGp03+esl5+U9CUb/ixCK4mqLoLYpzyRIbVD0uiniwnkjAQLE5k1rIP4U5ZH
	wK/J9baiUZ6MX4z6HSrywGJRRtbec3/La0hKPYx271DPUEzy7I
X-Received: by 2002:a05:600c:8b6f:b0:492:668f:410c with SMTP id 5b1f17b1804b1-494688928b1mr23245e9.10.1783930745452;
        Mon, 13 Jul 2026 01:19:05 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a558easm85288536f8f.27.2026.07.13.01.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:19:04 -0700 (PDT)
Date: Mon, 13 Jul 2026 08:19:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSfdL3acSXm8cP-@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <alSbqDyV3Koez--u@google.com>
 <alScY4MJFILO9-xO@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alScY4MJFILO9-xO@google.com>

On Mon, Jul 13, 2026 at 09:05:55AM +0100, Vincent Donnefort wrote:
> On Mon, Jul 13, 2026 at 09:02:48AM +0100, Vincent Donnefort wrote:
> > On Sun, Jul 12, 2026 at 03:38:35PM +0000, Mostafa Saleh wrote:
> > > When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> > > defines a static inline stub for trace_clock().
> > > 
> > > However, trace_clock() is already declared as an extern function in
> > > linux/trace_clock.h which is pulled in EL2 compilation.
> > 
> > I am completely unable to reproduce that. CONFIG_NVHE_EL2_TRACING, isn't a
> > selectable option, it depends on NVHE_EL2_DEBUG.
> > 
> > How does your .config look like?
> > 
> > > 
> > > If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> > > is disabled (by including it manually in setup.c) it will cause:
> > > In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> > 
> > nvhe/clock.h seems already included in setup.c
> 
> Ha no appologies, I was looking at the wrong branch.
> 
> However I am still enable to reproduce this issue. So I am still interested in
> knowing your .defconfig

It is just defconfig (CONFIG_NVHE_EL2_TRACING is already disabled).

If you attempt to include <nvhe/clock.h> in another file:
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f4..ca91e453fb10 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>

+#include <nvhe/clock.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>

With GCC: make ARCH=arm64 CROSS_COMPILE="aarch64-linux-gnu-" -j`nproc`
It will show the above error.

With LLVM, you have to include it in more than one file, which results
in:
>>> defined at clock.h:14 (./arch/arm64/kvm/hyp/include/nvhe/clock.h:14)
>>>            arch/arm64/kvm/hyp/nvhe/hyp-main.nvhe.o:(trace_clock)
>>> defined at clock.h:14 (./arch/arm64/kvm/hyp/include/nvhe/clock.h:14)
>>>            arch/arm64/kvm/hyp/nvhe/mem_protect.nvhe.o:(.text+0x0)
>>>

As the compiler would convert the function global.

Thanks,
Mostafa

