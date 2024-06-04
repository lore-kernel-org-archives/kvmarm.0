Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F3F145B15
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517089; cv=none; b=ChnSSly8UwP9hqt5JEDE5lXPlh/PO7ePa5ZYRZdgqrntrZzzeczCkrhVDR5dW+G1gdSgfJZ27GPj59M9UTS9kXV08n0wXD5ETA2YtS83AIK+2Y8ti0eostpLwVymGDEvJJRPyYtd+FXS/+aJb5KFCr+qQ/YQk/mDHFyNvE8SVi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517089; c=relaxed/simple;
	bh=TuVYZmXd02wbEklbfC5WAvOqMWKiRbjiXfc+JoeuUhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQP1Wxxg0mKvOh7ug48yQ0dVlhpuhWuzEBVqITzji93fFnhgcgZHFbuey+DyO/VZdTv1fMp9CJt/BXes8XCNn7h1gs4i7k/Rg29/XUyp8rhf6l5gmQbeHiquCkW2GOhdFTc/05Fshh01Q6XBucOq7YLse6WbbqI/VNHYFPaXct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bu4zOncB; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bu4zOncB"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a68b54577aaso370378666b.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517085; x=1718121885; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Cruorfn7NoREOjiMGGn/cp+VaqblM1rLgighQuS1JLA=;
        b=Bu4zOncBqVT2dUPjlZBPJJw0g3GeI84UISh9+4PK2Amzn1QuzFxCLixPUNmI/5KSPp
         4KwV8UYcjGc1q7RTrRrE7gLebu9GLJeQaqUJE2eRV11onq8xj5lPMXe+fOz8ANRGLrVF
         k7amvDf6+uZAqRlarKARW9FLDVoEKJ2+xMuUTcq14hmn0aop0p8REi7WSmyaowDh/3Da
         Wf2c2FaE7k7xyyttDRMAxNfaf4evZDPvPibuZWykIEkfrclDjcJvfoSAY/z6PTGAhsOE
         HfrS+UKcsr6JA/fnWE2EOl47HVt5hXsAGJT3jHOalmQM1pRD6WNVoHrum0wHdRbt4hXY
         Xpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517085; x=1718121885;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cruorfn7NoREOjiMGGn/cp+VaqblM1rLgighQuS1JLA=;
        b=JGaxaysJuk/86AMOOlshFr7WieWo/cHFEt3COaKnzlZ0/1qi8V4xh5SkYi/AQkBJaS
         QGeLp8wyYUvXAI6QQGote/GhQR6sEOiRRJv+SE0H/C3AWSWax5qC6ylpyzVzbv0Fu+fB
         kB6cBie6+BRggUwc+mLSVVi51OQ88TPAAA2T8lR7uPiKU7kpTHHQKq3MLAyO/Vy7L2sF
         BcDrgsi7vGE4CjPz8Pq6Z+Zp/hymJnPx1wl6p++8uZLB6VG5sEJN7SvIgmoSCSPnZibm
         zX4C0oDBpBQgUeGK4q9dMvVLw/8q61NXZCNKI4pMtHn8F4u+yu7OZ6ELtRbXpOg8Dg8l
         vC9A==
X-Gm-Message-State: AOJu0Yw+mqp3CeTpfzfwtp+xRP5vxqV+GhLTxs2rE8kiBKuglS1vF7uZ
	WbQwWxixiV6fa+PQ4kSdnAUu5amOj4hrKStB3yCfHdFxy1rgN+g6MMliW22nNhTVr/HV9R/2al2
	TjuqF
X-Google-Smtp-Source: AGHT+IGInW6fKvSmBsK5Zli+h9BQYP14HAX01lASA3eX37L7IrTgDRmIzyPqKYNdoRF2r9nIA1b23g==
X-Received: by 2002:a17:907:b010:b0:a59:c209:3e33 with SMTP id a640c23a62f3a-a681fe4bc4bmr607698766b.15.1717517084985;
        Tue, 04 Jun 2024 09:04:44 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68c5c523b4sm478543266b.11.2024.06.04.09.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:04:44 -0700 (PDT)
Date: Tue, 4 Jun 2024 17:04:40 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <ucvvmwiur2qhagm4tcsbffftzaktthqnryi74k5ajtolhx4qor@via5txfexwlc>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-11-ptosi@google.com>
 <20240603144530.GK19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603144530.GK19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:45:30PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:16PM +0100, Pierre-Clément Tosi wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index d859c4de06b6..b1c8977e2812 100644
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
> > @@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> >  
> >  /*
> >   * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
> > + *
> > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > + * using a physical pointer without triggering a kCFI failure.
> >   */
> > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> >  	/* Turn the MMU off */
> >  	pre_disable_mmu_workaround
> >  	mrs	x9, sctlr_el2
> 
> I still think this last hunk should be merged with the earlier patch
> fixing up the prototype of __pkvm_init_switch_pgd().

Unfortunately, this is not possible because

  SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)

makes the assembler generate an unresolved symbol for the function type, which
the compiler only generates (from the C declaration) if it compiles with kCFI so
that moving this hunk to an earlier patch results in a linker error:

  ld.lld: error: undefined symbol: __kvm_nvhe___kcfi_typeid___pkvm_init_switch_pgd

OTOH, moving it to a later patch triggers a kCFI (runtime) panic.

As a result, this hunk *must* be part of this patch.

> 
> With that:
> 
> Acked-by: Will Deacon <will@kernel.org>

As I haven't followed your suggestion, I'll ignore this.
