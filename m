Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3EA7E6
	for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 03:11:18 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1a1b23f49e2so353335ad.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 20:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681528278; x=1684120278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvRefNBdCntu+pZy/U4eeOw/+P3jSNTuSKl+Y+gg558=;
        b=OaOvmpDzv3+8A9qM0qt9IBR6/9mwsQAdQ1m6VNkf9JoXLA1xW95KIz9IV7p9qDwB/R
         erNPV+9DAqp+ny5DIU6YGDnc4QuaoBlrLXVS2UnfB/xrrNCTt5mXxPLgoqmj0sGQid7Z
         bFcyOanzbtEWTa65RmFlRPcWtTJM7yT/0GmKd9aSB8uKwlEKyS1cKPleQgMP3aKF+QmO
         8clATWzgmpwh8UlfmPMhTp42jUyrmvkuxTtu05CEfEJnK+WQUW+HHESiwPOOcmnt7QZ/
         OWizNb8hrGOWjopFvr5fje68NSgxCJAR9kX5Q8VLkO4W3HJWfxEjVksgzskzp3Jb/lbP
         aUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681528278; x=1684120278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvRefNBdCntu+pZy/U4eeOw/+P3jSNTuSKl+Y+gg558=;
        b=bP8Kd7ywdKNuEVXBVsVHllv6MBnEJneZ2YLrOy5801sKxZOQqdK6CkjkvFOexmOW9H
         HA9ue4Qf32Cl5jnDKIPP3KR4RNO0okjIpH8/sb9Qp9QXO2zWy0t3S7TVuUFqYACeyJx2
         IicOTTR9kceJIygUI+QQwu1GFQ/K1bdxQNsgwUYYXcEKGYkJCxlYcRQbsxu/aJVNZ8mY
         TI2Pl7VgU1oMW8eT09Ab1MWCxkdNGbuF9qXen/R44Vwf9286WDn5WdyvlvjIxWFUUdqw
         LL4xiFVEdRaZl8Y6ZSEkXrxmp60P3s9UgwHJ7Cph5Hm1IShpzoV0hiJoBV6MzSqKnhii
         caeA==
X-Gm-Message-State: AAQBX9fyveppvMDjApUzgvdYYp0Wv+1XFAyVq1c8XuXE1JiGHqQ5JDoQ
	Q4/mVAWyfICewu2B2JkpOSJBDQ==
X-Google-Smtp-Source: AKy350aoUX99YiXsrWHE9U96HGSkzRYFTGlU9fSvZAsPt4wh+G9nV4c/x4EB7232wRvYCSx1HZcJ0w==
X-Received: by 2002:a17:902:f0d4:b0:19a:5a9d:3c with SMTP id v20-20020a170902f0d400b0019a5a9d003cmr73915pla.16.1681528277707;
        Fri, 14 Apr 2023 20:11:17 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i12-20020a63cd0c000000b00517be28bcf9sm3412025pgg.86.2023.04.14.20.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 20:11:16 -0700 (PDT)
Date: Fri, 14 Apr 2023 20:11:12 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <20230415031112.gdb4vghgs3q42koa@google.com>
References: <20230408034759.2369068-1-reijiw@google.com>
 <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N>
 <20230412051410.emaip77vyak624pu@google.com>
 <ZDZ3xbSePtOD3CSX@FVFF77S0Q05N>
 <86v8i1l7ru.wl-maz@kernel.org>
 <CAAeT=FwUZ-TTn+4tt9pcesB59b7_=_zxkeRftMh5aQDUqnMz8g@mail.gmail.com>
 <86jzygkvmw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzygkvmw.wl-maz@kernel.org>

> > > > > Uh, right, interrupts are not masked during those windows...
> > > > >
> > > > > What I am currently considering on this would be disabling
> > > > > IRQs while manipulating the register, and introducing a new flag
> > > > > to indicate whether the PMUSERENR for the guest EL0 is loaded,
> > > > > and having kvm_set_pmuserenr() check the new flag.
> > > > >
> > > > > The code would be something like below (local_irq_save/local_irq_restore
> > > > > needs to be excluded for NVHE though).
> > >
> > > It shouldn't need to be excluded. It should be fairly harmless, unless
> > > I'm missing something really obvious?
> > 
> > The reason why I think local_irq_{save,restore} should be excluded
> > are because they use trace_hardirqs_{on,off} (Since IRQs are
> > masked here for NVHE, practically, they shouldn't be called with
> > the current KVM implementation though).
> 
> Gah. Indeed, we end-up with a lot of unwanted crap, and absolutely no
> way to locally override it.
> 
> > I'm looking at using "ifndef __KVM_NVHE_HYPERVISOR__" or other
> > ways to organize the code for this.
> 
> I'd vote for something like the code below:

Thank you for the suggestion.
Considering that we may have similar cases in the future,
I will implement as you suggested in v3.

Thank you,
Reiji

> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 530347cdebe3..1796fadb26cc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,7 +10,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
>  # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
>  # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> -ccflags-y += -fno-stack-protector	\
> +ccflags-y += -fno-stack-protector	-DNO_TRACE_IRQFLAGS \
>  	     -DDISABLE_BRANCH_PROFILING	\
>  	     $(DISABLE_STACKLEAK_PLUGIN)
>  
> diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
> index 5ec0fa71399e..ab0ae58dd797 100644
> --- a/include/linux/irqflags.h
> +++ b/include/linux/irqflags.h
> @@ -198,9 +198,10 @@ extern void warn_bogus_irq_restore(void);
>  
>  /*
>   * The local_irq_*() APIs are equal to the raw_local_irq*()
> - * if !TRACE_IRQFLAGS.
> + * if !TRACE_IRQFLAGS or if NO_TRACE_IRQFLAGS is localy
> + * set.
>   */
> -#ifdef CONFIG_TRACE_IRQFLAGS
> +#if defined(CONFIG_TRACE_IRQFLAGS) && !defined(NO_TRACE_IRQFLAGS)
>  
>  #define local_irq_enable()				\
>  	do {						\
> 
> 
> > Since {__activate,__deactivate}_traps_common() are pretty lightweight
> > functions, I'm also considering disabling IRQs in their call sites
> > (i.e. activate_traps_vhe_load/deactivate_traps_vhe_put), instead of in
> > __{de}activate_traps_common() (Thanks for this suggestion, Oliver).
> 
> That would work too.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
