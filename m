Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508F016D9DC
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712761116; cv=none; b=iu6CGvuBAt/Eg+nJZrJYzTB9STuwVTfCKaDyjG1JaBXvCBqS9YPgyASxgIChXL9CxP7YWs5pgG/wA+zy9axbGZMXgB++jNEyTQ9pqQVNQRQW7IobFjde5RxIcj+XCpZ9iX3KAvBZcIDBmXIWnXZRwPcsvSCEQZ4bWAfl0YbtQ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712761116; c=relaxed/simple;
	bh=00Xa6iFnMvbGxEV531Uu6QW+AHOlKNX+7VruQWKeLFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtfoHV2RJJuOCTFWlCkCU1Ks4kJPxCVfh9h51b4brMfHmnza2d0g457+4+Uutakjb14PJY5WnqJEOr9ZRs65F/KvM4PH5qjwQA/JZAzbqYmhfPxOwsStM+IKQRvbIXL42kdalk8us9x1GFDL83aVyVv6hCNij+CzCoVd8OC7k1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DfrEjnL4; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DfrEjnL4"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a47385a4379so1443086566b.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 07:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712761112; x=1713365912; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a+lUzni7TzWu0rqTW7fX9uV9u5HrWnKkbBdqc1sVWyc=;
        b=DfrEjnL4WyX8S4WPhda+H1roRj2c6TKtn9byT3BbN3epI54Tcjt0Hud7mMGXhPEL8l
         kCGkISDLPwhGpo3KeRBOfNF6wToCSztvuFMUhvhmvUmOMIiW7fryrJ77XEsLD7ltV+yy
         Lq8MBPiJAxAelbX7/bKl7SuNO85WP6iyJqfAUScVLNW2ihDlDxAU9DkUOlP6Uy8Kji0D
         GWzmtrfueR9C1SPH3N64Lxw2+34otU4b4hWOHrfkQdLB59MNxvCbrERvSJNVv9Zsk2Y8
         nyjtHKUyuSMxRRKy6rNyOw+bXVsNliVOIICUjbEMST3rQ7hSv0CIxOcSzb3H2HWq3PYv
         DMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712761112; x=1713365912;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+lUzni7TzWu0rqTW7fX9uV9u5HrWnKkbBdqc1sVWyc=;
        b=Xol5+GOB4mTPsfdYVJa+CT9dJaoFUpdh0LBUqmL5JKBt5pJ2kikbjD+RY2/ILQvmqD
         ycC9ek7XdNLPc2QVqokZtrUY54kIPHRVr/L+wDMkHhDhiit5rtal9oinqtBj93VbqmT+
         NDzwdmePF0AdNewSoGj4msHnzofxiwiR4sFwMmbmtJW4yN5YDgp8XgDtm0hzpVKLhVxt
         +qNhQmh5NB31rBdQl5t+BsDMXct1ckCQY4Dil2OGHKJI11+Cba1pu4XXcO0Hvtm/lu3y
         YN+CHadRf4a8dbFBTPsYGOUI26Ppv+JaBA1HlSEBsTjJUDlYpinqq3n/TBsC4axf5TIa
         TWbA==
X-Gm-Message-State: AOJu0Yz8JvglI+BXoo57zcTibrgITNn6HpZfOC5dch5Y0r3yrVrFwKe1
	gK4CzBCF+H4YH0yWVuGANCdiIHLB3KCPV9Kty5P+AcgROaZu18B/CexbPLoLSQ==
X-Google-Smtp-Source: AGHT+IE0cwIVEElcQzHdIKATSqutSBDpZ72ZjzKt7zWwl3UbiHIAD7/L9swYNZrp/FBAOSjh55ADvQ==
X-Received: by 2002:a17:906:e002:b0:a4e:410e:9525 with SMTP id cu2-20020a170906e00200b00a4e410e9525mr2371506ejb.30.1712761112346;
        Wed, 10 Apr 2024 07:58:32 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id dl5-20020a170907944500b00a51bf97e63esm5420445ejc.190.2024.04.10.07.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 07:58:31 -0700 (PDT)
Date: Wed, 10 Apr 2024 15:58:28 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 09/10] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
Message-ID: <5pgvud47ohozxjnbzs2ei5jc5imoabcc7x2c6dbcvrmtopgn2g@dglnupfwwaec>
References: <cover.1710446682.git.ptosi@google.com>
 <87885c41627a033d9772dd368049e7f8f5fd4ef7.1710446682.git.ptosi@google.com>
 <867ci10zv6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <867ci10zv6.wl-maz@kernel.org>

Hi Marc,

On Sun, Mar 17, 2024 at 01:09:01PM +0000, Marc Zyngier wrote:
> On Thu, 14 Mar 2024 20:25:43 +0000,
> Pierre-Clément Tosi <ptosi@google.com> wrote:
> > 
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index b0c23e7d6595..281e352a4c94 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -397,6 +397,12 @@ static inline bool esr_is_data_abort(unsigned long esr)
> >  	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
> >  }
> >  
> > +static inline bool esr_is_cfi_brk(unsigned long esr)
> > +{
> > +	return ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> > +	       (esr_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
> > +}
> > +
> 
> nit: since there is a single user, please place this helper in handle_exit.c.

I've placed this here as I'm introducing a second user in a following patch of
this series (in the VHE code) and wanted to avoid adding code then immediately
moving it around.

I've therefore kept this part unchanged in v2 but let me know if you prefer the
commits to add-then-move and I'll update that for v3.

> >  static inline bool esr_fsc_is_translation_fault(unsigned long esr)
> >  {
> >  	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index ffa67ac6656c..9b6574e50b13 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -383,6 +383,15 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
> >  }
> >  
> > +static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
> > +{
> > +	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
> > +		(void *)(panic_addr + kaslr_offset()));
> > +
> > +	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
> > +		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
> > +}
> > +
> >  void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> >  					      u64 elr_virt, u64 elr_phys,
> >  					      u64 par, uintptr_t vcpu,
> > @@ -413,6 +422,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> >  		else
> >  			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
> >  					(void *)(panic_addr + kaslr_offset()));
> > +	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
> 
> It would seem logical to move the IS_ENABLED() into the ESR check helper.

I suppose it makes sense for a static function but, given that I've kept the
helper in a shared header and as it essentially is a straightforward
shift-mask-compare (like the existing helpers in <asm/esr.h>), wouldn't it be
confusing for its result to depend on a Kconfig flag?

Anyway, same as above; left unchanged in v2 but happy to update this in v3.

-- 
Pierre
