Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C22635
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716985824; cv=none; b=Epc9e1MqTcwjj+GhQdoSwaN1HOY38qejuX/E9Mstx7QxFVDbeQIfvDHkrqUCNIKqEIYttjN/31xUbFOjPpcXVA2KkjQ42Xt7gIEeoviPg+aY32fkklaYJYw488VlAmT81oBXRM3JZu16wPJDosyRplSU53e2poP90nL8xDZGrC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716985824; c=relaxed/simple;
	bh=gcXS9jLJSZWjAWlbQbdUOaZ2nz7/IfF2IriZ5nAD9xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOlm39a4SOW1wnR4EIgXIzasYT/OA9vyCzcrP9ElgyVe/HLBCvQN8yRRhSavmzY42bOWbwSPhKm0rw4hVLzwAa+eEFe0QXKdFXOC2oXs8ctWdzBMi8ynm0rLeRaqVXp5B/4gI4zb3KEN3qpMhWoS45+P4ghWHFNfds4pCEjM/QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KL5r632J; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KL5r632J"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a630ff4ac84so225456566b.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716985819; x=1717590619; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2LXZ9wqthbTQhc7QRlnA0utzKwKCI8VLIKqeGLoEf8o=;
        b=KL5r632JDZ41jWG4SsL4Dtz60Ws11RdLYhlnlGlX4NxMnJ7HwTJpHabsc1n2Z7X0BG
         utbZOywfKUU1fbcVq42MB2kx2Rvnp+Yj3JitofMcrWbMZ6JGZc3QqxADb2yMjD/BFtjB
         tRQfEpUlEVC9W96emfhhRcCCLoKEtKoc9yXUbL3CGEGNT8C4IIJivJb5B52TtErRVCmh
         yZvTamXxspPCW/vVEMs87URCnsuK7cq3Jxzliktg8L0+jxttVOS66lPEdFp5x9fdOZV0
         9MeNJyFl1Zjpo/HA3vL2kkLpc8bvop3ZB3LW8Gv+RKdxhDW+J0XxyFq5TEdIeOLlIEJh
         6jIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716985819; x=1717590619;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LXZ9wqthbTQhc7QRlnA0utzKwKCI8VLIKqeGLoEf8o=;
        b=gAQ0e8JxtkJLINwedsAt0T6xduhoTwU/tQ1r8/JZagZOxLlRDTi14X1ppAAOxQd0r6
         YETky68fwVF1+K4TMlcekqi251lWVclcravIlCRzXS6SdzNMyZDo9oYTX7vRY9JbrAgF
         wibKGaYwCoUb3JHYf7eHl6ABJ8Ng+fUbsIIHj5lCmW40Yhx50w5yngrRq8ocoxYAmr6l
         zQPN3FvUxHpLrY/s76p4Z2NwD1FgDVKsOGPfNjA8kDFabeX5G+tG0m4KOPTQ1dH/9RJ7
         rudC5LmHfWZoy7T2/WNfPaw75UkY51PW01LQP92iJrVkcDTj1+ZmrOVOh99yadjZs/WE
         uZnw==
X-Gm-Message-State: AOJu0YyFklzwpWxV7n+vmgx+eHLYtpb8+sSAPL06zYL18cSfsTMUGCii
	qcH2VeFgYIT7YrBz8PB6XqmUNLMtfssLxeRhUiUTIqSH1+kqeP9duL14qohYaA==
X-Google-Smtp-Source: AGHT+IFROfs0Pam4Y1EffkR7Vgq8UzsI4afoBVYuqf4XpoEh6dk7KzH/TKYs/1/Lt8AHYYLxKWPW/g==
X-Received: by 2002:a17:906:a391:b0:a65:ab74:1e8d with SMTP id a640c23a62f3a-a65ab743299mr47596066b.59.1716985819350;
        Wed, 29 May 2024 05:30:19 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626cc4fedesm703808866b.118.2024.05.29.05.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 05:30:18 -0700 (PDT)
Date: Wed, 29 May 2024 13:30:15 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <vk4jfrmlxyoav365rti4rent5ptmxis5d6vjlynr6xs3s4k7h7@2j2dyv6lhcbr>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-11-ptosi@google.com>
 <20240513173005.GB29051@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240513173005.GB29051@willie-the-truck>

Hi Will,

On Mon, May 13, 2024 at 06:30:05PM +0100, Will Deacon wrote:
> On Fri, May 10, 2024 at 12:26:39PM +0100, Pierre-Clément Tosi wrote:
> > [...]
> > 
> > Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
> > call it directly and must use a PA function pointer from C (because it
> > is part of the idmap page), which would trigger a kCFI failure if the
> > type ID wasn't present.
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/include/asm/esr.h       |  6 ++++++
> >  arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
> >  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
> >  4 files changed, 25 insertions(+), 4 deletions(-)
> > 
> >  [...]
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 5a15737b4233..33fb5732ab83 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -5,6 +5,7 @@
> >   */
> >  
> >  #include <linux/arm-smccc.h>
> > +#include <linux/cfi_types.h>
> >  #include <linux/linkage.h>
> >  
> >  #include <asm/alternative.h>
> > @@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> >  /*
> >   * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
> >   *                             void (*finalize_fn)(void));
> > + *
> > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > + * using a physical pointer without triggering a kCFI failure.
> >   */
> > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> >  	/* Load the inputs from the VA pointer before turning the MMU off */
> >  	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
> >  	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> 
> Unrelated hunk?

No, this is needed to prevent a kCFI failure at EL2.

Please let me know if the comment and commit message aren't clear enough.

> 
> Will
