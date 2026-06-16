Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8315835DA64
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620334; cv=none; b=duE7Ey0LASlcSdDu2lPHcHLd+S9sU5bOLwGDgMRawDMsKk3yJJo2GcRR2KN7wfWbMeypqntskXoZmG7ua0hQaVBWPXEWrSzjWvQD80iBMfpuExsZxzHMu5YI7BmaJwGig12Qp2MKs2nyhQde4um6agRAqudlS53lSD4KYHjzn/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620334; c=relaxed/simple;
	bh=+rhMBDhmOVgjCabl31Hjhb5/AFO+Bz+8U3GfV3m9AFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WR/yE60VVMFquBo2gYx3yxV039ON4eCK9A6gcjpgA9YlHSdVdOiB9D1Qg4jUebqSwmoRGBnGjfJxmy4wK3YqFQQ0TCP67bqF7N1vGV/YN09VDP+nfR0MUqN/9hEhic37sAxK28WNGIF82CekCv/4fbWTD3/M9uiBnThjWm/h2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pg2VFngZ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pg2VFngZ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b23c828aso47655e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 07:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781620332; x=1782225132; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n3wvzxcpQU0Ik+95S3dasptB+RwKMZZavChVLbzx6Es=;
        b=Pg2VFngZQLnwUWVKqZSi14N6woEYRxi8jrqDkyQAD+ksmgLmP1tpTkLu108Ogbrj12
         p17WsUTK25fk7k0v80S5JY6LXHemDPO8FVN03CVntUayJH8NJ0xGmnwaSRrDGM84C2vv
         ZBvzqs1dTYRQ9yqpLuIG1XGymn3EBTqq9Fiwt62TkHVKIj30srcN+7Um6xBywL58VGVT
         ++Nm0HY9u3unUiEdW8A9MLSPx2zdO3lfqBiyaby94O2Pp46U7lDBT+olbLqPWq8WTEhS
         C+heki6s3MuKw2rcejkzJTyCrxYWzi/ZqhE+vRc1lKX62FHHpPmMgVOanl6HY10Mwm6s
         i6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781620332; x=1782225132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3wvzxcpQU0Ik+95S3dasptB+RwKMZZavChVLbzx6Es=;
        b=bFqo8vVtT4vvURJ+6SFNrBBp3c5F2sASGTGwjquSfACWiZaG8Z6wcrEctvRV/p6P5z
         VeEAos7f07ZMZjkl40aVjKJiVTs4a/0DDLs0V9RHQlHJVJxyDzuygnK9CwEk5AQTnCUL
         CXpn1dTv9AL5EGbabxDHOonaUAe6rK1fguzhQ8iIWppAL6F6uMBOBjOGPz2ko6qTudHl
         iXG+cRvyu8+euHXEU2n/CP99Qul+B3KqNR4AAC97KPqCbP54bwJRnqseUDFk/PKGrgxr
         woQJSB8Q0ls0wZWOhkltjwvIwILv8B0jBAFl3EE+u4Vkn4c2sHbuhYNp4M8Sds4HtEUF
         Uung==
X-Forwarded-Encrypted: i=1; AFNElJ8AkwIQWwSv00yy9tWJawNlFdwzSYWqv+BBnUADYI+EB+YSsy7H/uemdqkqHPS6ut63OAsK+SA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6E0Du21wJG2lsBS0/9cSDyzNG5b+aeWQEio4KwrnL5RZr4yjL
	enRjA+vFuVf+KshIgn8fI7jh3VXgtM1mf5dN8qSHA/CdrFe2Pe0eHDeSdkav9ACCbA==
X-Gm-Gg: Acq92OFnDae1DbXQAF81rjClWS7Iu1j1vo8HYgs/blapAD9e0plIEtDqljxkIcu33oI
	au0eBWybGxa66uCjIaRvh9Pm1gSCD94YnDrGZCIYPq5zAl7C/fU/Sx5ksmEonQ/GjPq4jYY0/UX
	sOqVLb5kxvwMZYWY5DP7iuUhvDCTrF7+lJLksmok9PhsnA4l9S3LNwQ60a7jgtwBBQJVK6rYvJt
	aE8tyax4brncL+LV+Olpw+NG0ENgCQVEywYKFYzQLppdtNrHn2y0KC40y/IWDCZOEKNA4eRyG+V
	fx/CIV+LAgmXCsiz3dRKMFPK1OeyuXUUO+1v/UMqjoL7vIvVu5d1pVKngq1avLX8H50VCwZxB5o
	6lIewUKCBncGNxvR2ml+W1JWy40tk26e/NK0kn+6fVcEhfhe5I9yFjj7guoLrU4jEfJpL8kCezD
	LOS2mLa8BCl5txbJYzE19o+Efes8GBHxMb9BOUJD2+9i7AXix/3MqXVwOmCPqt6ene8bBrgQ==
X-Received: by 2002:a05:600c:15c3:b0:492:203f:a378 with SMTP id 5b1f17b1804b1-4922ffdc0f7mr882935e9.8.1781620331294;
        Tue, 16 Jun 2026 07:32:11 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47d1csm83331255e9.4.2026.06.16.07.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:32:10 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:32:07 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <ajFeZyMZfRaaHuxm@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-2-sebastianene@google.com>
 <ajFI95hZJxZfFg5q@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFI95hZJxZfFg5q@google.com>

On Tue, Jun 16, 2026 at 02:00:39PM +0100, Vincent Donnefort wrote:
> On Tue, Jun 16, 2026 at 10:54:08AM +0000, Sebastian Ene wrote:
> > Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> > arguments checking when the hypervisor acts as a relayer between the
> > host and Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 47 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..c723a21006aa 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
> >  static bool has_version_negotiated;
> >  static hyp_spinlock_t version_lock;
> >  
> > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > +{
> > +	int reg;
> > +
> > +	for (reg = first_reg; reg < 17; reg++) {
> 
> Hum, should it be reg <= 17? 
> 

Right, I think 17 including. Thanks for pointing out.

> 
> > +		if (cpu_reg(ctxt, reg))
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> 
> [...]

Sebastian
