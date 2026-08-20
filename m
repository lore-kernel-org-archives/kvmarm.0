Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF039CD01
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269038; cv=none; b=Gbjd2L39X1aSNRabYh9HVv2+jkaEQ9Qv5xG+1QzjNZJwl7qo9fkqoze5W6m8EaHRHZSgZ/qpyMDeUndmWsh6jgaof+wZbmBBRK46GolP+zZi7iQgvfOrDyemm6WgXYDwBg2xjcQfVo2EF1T+LCM/Q5yGnHS7JfVS0LxGqV+ocAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269038; c=relaxed/simple;
	bh=v7O/Xv2cRLoJQi9cE/u6B3o+EIuWA6AO+/EbZpuhtaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8BMEjG77jAHcrA5caiXxnvVGKOwLZhUQodfq2yqJXVrWtA9grgVWaTd0GnMcig8m4/Sffzv1FWnEMdwyFTwxn9f7EbyusmBmZfvlwk5dfZHrPhDCl61dmaZFBCbapFwb8UDMrTKz5d77PdBYxIN5+k2d8GlcITnhReLLFUvCw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DLn1aRIQ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DLn1aRIQ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdf36f63dso40275ad.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787269037; x=1787873837; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k+xmfX7DA1IMWAYKfjmQ/Aix3ZtqaekUVXRTDYfDjog=;
        b=DLn1aRIQI0CJlWZY5GOKtm92Sb328HmhOASQqkKGCDcRd7xyL802DB1OB4YKxlWn0O
         7I/d+XFX9uZ29pamcnv/igSRl+Fqa0gYGG4dTEQsX1f/18BlOnwp78VnRARdpRiwAouf
         bTm7uVocWYU3QqN3vrHUy9t6sN7d44GQQMgyXkgnXhwY6t7NL/yYX9sDpKKR+vopZxsK
         dZUt5+gluXiRPIBadPUdXcVl+WXX0fMw0z0svsyj8TjFUU2oxWa9Cxmrcqgbmfsu55J4
         1vkixd+hb6iw8dI+C9VFiOhakKw7K2InqLonIQsTp7ZQnJpJFDwh7ZbqhwqhLapnAZ3D
         MH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787269037; x=1787873837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k+xmfX7DA1IMWAYKfjmQ/Aix3ZtqaekUVXRTDYfDjog=;
        b=rO+4DP8X5lwcNYFcUUmBigy54CodnvQKlC3R7/BWnvDQ/G7bc0Jiy3oK2y0Sd1+Lds
         gAzKbP/d/N/LwWAiQptulpCzbLdukv29JANKQ/swz+/bs6k+kJD6wpDVf0yKkUprTWr6
         wUYuHJMcQIsN7EdhYmD72GBu9pqtrXtdNfywk3uKo6yGey1RsL0UJR9WYqxcW0wdz8Mq
         ZZy00dpFv1b6WsgOPjwzjk4XV+reWditoyVjnGxhfj0dEm1aAifQAYjG2JtO68Tizbla
         jsCm41HxHlmxJz3z4ch6tTVl2b4ELHBHJIfp5LW3LRDzYXGb+DJpOeqrVMW0iHCpGm6w
         OGpA==
X-Forwarded-Encrypted: i=1; AHgh+RqUGfzF8xqfJHIJGmqODTnO5OkTiC1I9YiB9JAfohvNrezS0/4V+UOZoY0wmd8zYpDbXtBqNbY=@lists.linux.dev
X-Gm-Message-State: AFuF++lGql1IosC4rbdhoMvOfLVqcHncU8OzxkceEV/fSxlZMyE1UF1Z
	+MxlHQRzIcTr/oPaiAHmzt8+tBRNNnVGLGHxER6AhsNo0VZaPcuwiHJa/uePE8Y7Fg==
X-Gm-Gg: AR+sD13dhBsex4TwndQz8pjl79GJ7PKLkq5LDUKJdkTgHHrZx2lHjeQRDlqA/LiuTRt
	U196umaveYq/ulbkLnmw9JbV1e3YHPvatQQdV7k5+A5RFnBt1UIOQbTxsfNhKOzY2Y6qJ+7B7Z7
	uwy+uRUgnsAN3tP7+41iWGqJvp9UZxmwclh4KDqjWuAlT2KjgMgP2QI9C2UHV7ROZa7z1ktmpIn
	iNq/Hf6wULxDQfox1iGePF3Jr6TD45aKHVCmg+9WaHrpfMqKIP3SLLDHFQySzdrUDCV5efcKOHl
	zZvgP+n/PnXcV0888dB0HTxl86RGNFDqB/JmNq8/YB4drySKx8EtiYo2jVdDjf4QwTRTbg9qZn+
	iX0RdSOHpGeIKQU4LWIHF3Ey5YWknBNzkh5WZ5KbO97kvK5WSApfoFz45tTAHwHc3/l8wen3/uc
	6+GWfC3n44hYlAHniszRNJc4BGMesQF5WRqPSvcmBhpTXRP1uf9wVyxEHrYLfmmbp3DUHtkL6sn
	HHloZFeK4AgWVOHII5paEDxdLb2cvWSHE5s
X-Received: by 2002:a17:903:40cf:b0:2d3:153d:acae with SMTP id d9443c01a7336-2d64aaf3497mr3577045ad.0.1787269036513;
        Thu, 20 Aug 2026 16:37:16 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c8e2d7e0sm116103a91.0.2026.08.20.16.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 16:37:15 -0700 (PDT)
Date: Thu, 20 Aug 2026 16:37:11 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Subject: Re: [PATCH v4 6/9] KVM: selftests: Add various print flags to KVM
 selftest runner
Message-ID: <20260820233637.GE618052.vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com>
 <20260331194202.1722082-7-vipinsh@google.com>
 <ampREGtEqKh8_-Ua@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampREGtEqKh8_-Ua@google.com>

On Wed, Jul 29, 2026 at 12:14:24PM -0700, Sean Christopherson wrote:
> On Tue, Mar 31, 2026, Vipin Sharma wrote:
> > @@ -27,10 +34,14 @@ class TestRunner:
> >          return test
> >  
> >      def _log_result(self, test_result):
> > -        logger.info("*** stdout ***\n" + test_result.stdout)
> > -        logger.info("*** stderr ***\n" + test_result.stderr)
> > -        logger.log(test_result.status,
> > -                   f"[{test_result.status.name}] {test_result.test_path}")
> > +        print_level = self.print_stds.get(test_result.status, "full")
> > +
> > +        if (print_level == "full" or print_level == "stdout"):
> > +            logger.info("*** stdout ***\n" + test_result.stdout)
> 
> IMO, when the print_level is exactly stdout or stderr, the runner shouldn't spit
> out the "*** std{out,err} ***" line, as it's pure noise.  E.g.
> 
>         print("\033[2K", end="\r", flush=True)
>         if (print_level == "full"):
>             logger.info("*** stdout ***\n" + test_result.stdout)
>             logger.info("*** stderr ***\n" + test_result.stderr)
>         elif (print_level == "stdout"):
>             logger.info(test_result.stdout)
>         elif (print_level == "stderr"):
>             logger.info(test_result.stderr)
> 

I agree.

