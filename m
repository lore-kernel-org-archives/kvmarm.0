Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0075E20CCD8
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744989293; cv=none; b=GRx8zeA/lGwsuWMOj2E29sosZ10G8XoLhU1kJk1Ng84FSurjZxOGAPzC+ILBiMccNUjp4+K+oWpUtarJU5Mp0uN8hYUUjZAJCF86yx1YRHPaW28AyqJyJaQVsWNi3S9oMfy8QLYKSw1Z9/A/T80AFevZA0Z9y66vJPCPVqhX7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744989293; c=relaxed/simple;
	bh=I8AmJAfFB1Br3VQWNtM8JST0BsY+1YK7YX16yQJsJTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrFiso7kTtMar8WTa5x11c1sV6AXTO4vGzh1w2ZneE4aubjRd+MQPwU71W4liEcYeyJGURZPj0dTBbQKhZiiA5WkLYBks3OwaNLkUMnWj8xFmQFX2Gw3czB9U0QCMEemWyB+ZzICnugeOZX16etjk2KklT7gaeKDSzw788D6qZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SeQEqact; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeQEqact"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-af590aea813so3064163a12.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 08:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744989291; x=1745594091; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tlr+U+ggvV9b6qUUYsEDpFnGs799KYouZS0u/xqDZw=;
        b=SeQEqactduixCDgtpc0JmRb9jFnMtzhCUW2lB88SxhK0fUFgXkUqAwRT74apF5nldg
         wIPYhwsPL0iBP01OqQiYrkb5zCXsIiSkqIiec/L6vJPS6y6lm9o2J52UB/wTQg9kkXLv
         eTK23i8i3XAi2+krari4Ozoz2Y8ZR2RdwbAosskvdG+ch4doyeT7J5+CwlS7/qupHzVu
         lCiDoPuf5EtZCrE2NyESDAatJlErOvq0XpFrP/IxLQA40RCmyY4jjaYZ2KbSQgXJBSxH
         80EmD9SfgN5R4jq1Yz+qsVT8bW1zWlRJIVRB9qPYvas8Ab0aP4DI6mFD3YAVdTUwOVjx
         7exA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744989291; x=1745594091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tlr+U+ggvV9b6qUUYsEDpFnGs799KYouZS0u/xqDZw=;
        b=bHycAkyG2TBOiaUMDqhWN/McLTHc2eOMQCEJIzaHu8hMZmjKgnKV+5+oMXWZmcrtUo
         D9te8AciLCj0BjSKuEz2OX9Jue2bQ/Qr8SR2+Vya6Ml8T38Rj0i7kkGLd6T70s46q8lc
         GXdkIyaaquGOPAqr8QAHdFn6jru+we8CELw+GQAD63KhLlI1mNQGRnNxmn3yyhOGrnWt
         x4c0JL2qffHW5NcHc6CDkCAMqEAhEmLVLV/0eWryrBhtnl/1bErKdO2jBd7XkuIwqlZJ
         e9ebzEJhTVzMgVj8nvTDyEgFQfroEQ+3TwpQN3Q5/Y+XqHNklZfiCBgd4w0upT9KvB73
         hIgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUJlwlHMqJarg2iUqF1oKeDhxYzPtqSHazNhrQrl9UOnwmNtjbICrY1mV6I5k6Ctxe7FQj2eM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAn4r51UufYv3Vah6/SEwKNcTnPAJbeRc0gyw/xUB8KgEybp7r
	+U9zm4hCOGnro4743AmMBIQYhEtBLhMDWNLQkOkQSdsou/b2uPHM
X-Gm-Gg: ASbGncvSSwXAiXUXU0MrPb1ZpHNryDpaYlPlAlkzELnb1RhzA8x/ZIkvdJ9NxNrRQjM
	jap4Q2PSPDqNOtpUPiBHU7tSBaPblSba2CikgZLbaB+WjuCDjHllHaCy21YrSkpklFgeuTc4+BR
	0+cE9JLgcErT+hmDPTltXEgVHbFA6nFo7UAFYCJL15reggJThBGH9iA2fLICVVXVOhVDd86Btq2
	pxhZiDTWd/SpgrceRgbx1r1flM7dkTO5zy0XqiYKoV4yFlOK3oF5SUMBc5+tL2dxJM+BoxxWu5z
	uzAL54FHxWfgTYG+njBVxAfU/IcMcHXqz3sswM7/
X-Google-Smtp-Source: AGHT+IFgH6kH8q8Ukkj38k3Ycwx8mgsM0+PlhclwOyMownQr5Lp6Z8YsDqQFALXwipkdJoGcEZeG3A==
X-Received: by 2002:a17:902:fc4d:b0:225:abd2:5e5a with SMTP id d9443c01a7336-22c50bd610fmr55082235ad.4.1744989291024;
        Fri, 18 Apr 2025 08:14:51 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb64fbsm17891505ad.158.2025.04.18.08.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 08:14:50 -0700 (PDT)
Date: Fri, 18 Apr 2025 11:14:48 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, andrew@lunn.ch, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 4/6] arm64: nvhe: Convert the opencoded field modify
Message-ID: <aAJsaNdznnz-1qap@yury>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-4-6f7992aafcb7@quicinc.com>
 <86r01rjald.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r01rjald.wl-maz@kernel.org>

On Thu, Apr 17, 2025 at 12:23:10PM +0100, Marc Zyngier wrote:
> On Thu, 17 Apr 2025 11:47:11 +0100,
> Luo Jie <quic_luoj@quicinc.com> wrote:
> > 
> > Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> > - reg &= ~MASK;
> > - reg |= FIELD_PREP(MASK, val);
> > The semantic patch that makes this change is available
> > in scripts/coccinelle/misc/field_modify.cocci.
> > 
> > More information about semantic patching is available at
> > https://coccinelle.gitlabpages.inria.fr/website
> > 
> > Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index 34233d586060..b2af748964d0 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -30,8 +30,7 @@ enum pkvm_page_state {
> >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> >  						 enum pkvm_page_state state)
> >  {
> > -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > +	FIELD_MODIFY(PKVM_PAGE_STATE_PROT_MASK, &prot, state);
> >  	return prot;
> >  }
> 
> Following up on my suggestion to *not* add anything new, this patch
> could be written as:
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 34233d5860607..08cb6ba0e0716 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -30,9 +30,8 @@ enum pkvm_page_state {
>  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
>  						 enum pkvm_page_state state)
>  {
> -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> -	return prot;
> +	u64 p = prot;
> +	return u64_replace_bits(p, state, PKVM_PAGE_STATE_PROT_MASK);
>  }

This is a great example where u64_replace_bit() should NOT be used. 

Thanks,
Yury
