Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FFC748C
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 18:22:50 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id x66so2798927pfx.3
        for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 10:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbt0meIgNn6WBG4YKbNfGi1T3PYNH2tI0RABGm6MAIY=;
        b=clVFCd5NAswd0cV5yiJ07YbrMqm/CoMDjz7XOZ2ww7a9GYyW5vk4yywNHRG5Ad+WXB
         hbq44pfn7aYqEIVVmUQsFM6Y8CxcJlw3QXr/qCvnKCNZBr8PzznZVoNkfZNbn1xITgwW
         +nBS4O9SzJ/7RuXokUHopQoBRfoB75i29p7cO2lqearialjc2gIWpVxIy1tX/nmDQgwc
         W58XTPAQZgCLDbxqZzXtl1PCpopHaxD1OtIsbXSLCYd76Ow533MgDCL5mG6/XVENGbWF
         ZfNmBf8gS0lPgVdqVkKxH6lghccfPJyKH2BL2/y9fbgiRx549qyPOE9NiT9AsmrxddrV
         KhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbt0meIgNn6WBG4YKbNfGi1T3PYNH2tI0RABGm6MAIY=;
        b=udm40L7L/MZJkcwkBqfqThg9aezD2cd8o/RvKKL5ow9p+kKqdxmMNI4wapGvKMLuD3
         tnqcmplbBpeL2sZyopTNCNX27jUhTYQt97oZEDjrMKGukynnkPnuo6xmtUgV80l1RPWB
         lbSkLEAQLLO4MK/p0EtPJDtkC/7DQh62poicwyJorKaDGOa4t918+/GmjNiMwbOWBPU0
         PZyIt3u/+IKkC5D3DYHaZH8Q1fXKh210uZBfjLBKkEVVN/Bj6Is4a5zKIabcpr4DcMlQ
         Z379oUSLYECoUiog5McVVB9GxzwbkYEfDNoNe/4BzjGvLZi1RENnaHiVqN5voul6QsGd
         0j+w==
X-Gm-Message-State: ANoB5pkxqZV11oRYCc1/8j9lnL++FNpFL22SYyRCEHY6G/kofpl3US+k
	kr3TVERQPiRyslp9b+h6Z/fU3A==
X-Google-Smtp-Source: AA0mqf6Soby8rd6m9EytXXHvJpT4TDAOmpLAofqH3m8MSRCn4y3bZNlZuKdxW3txtw47z8Dx4bLf1w==
X-Received: by 2002:aa7:9697:0:b0:576:9252:d06 with SMTP id f23-20020aa79697000000b0057692520d06mr371181pfk.0.1670955769814;
        Tue, 13 Dec 2022 10:22:49 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id g74-20020a62524d000000b0056bb4bbfb9bsm8195038pfb.95.2022.12.13.10.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 10:22:49 -0800 (PST)
Date: Tue, 13 Dec 2022 10:22:45 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Clark <james.clark@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Message-ID: <Y5jC9bAJ08xW1ZIA@google.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
 <20221209164446.1972014-2-james.clark@arm.com>
 <Y5N3R+w3GF94hxHa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5N3R+w3GF94hxHa@google.com>
Message-ID: <20221213182245.TQAgiYgXMDKYikD4rLqILgJw0hWiE-0ol1rcFqO6C-U@z>

On Fri, Dec 09, 2022 at 05:58:31PM +0000, Oliver Upton wrote:
> On Fri, Dec 09, 2022 at 04:44:46PM +0000, James Clark wrote:
> > ARMV8_PMU_PMCR_N_MASK is an unshifted value which results in the wrong
> > reset value for PMCR_EL0, so shift it to fix it.
> 
> That's just mean. *_MASK tends to be a shifted mask, although it would
> appear that asm/perf_event.h does not follow this convention. Fixing
> that would be nice (as I'm sure somebody else will get burned by this),
> but for the sake of an immediate fix:
>

Even kvm-unit-tests does this:

arm/pmu.c:
#define PMU_PMCR_N_SHIFT   11
#define PMU_PMCR_N_MASK    0x1f


> > This fixes the following error when running qemu:
> > 
> >   $ qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -kernel ...
> > 
> >   target/arm/helper.c:1813: pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
> > 
> > Fixes: 292e8f149476 ("KVM: arm64: PMU: Simplify PMCR_EL0 reset handling")
> > Signed-off-by: James Clark <james.clark@arm.com>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> --
> Thanks,
> Oliver
> 
> > ---
> >  arch/arm64/kvm/sys_regs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index d5ee52d6bf73..c6cbfe6b854b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -646,7 +646,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >  		return;
> >  
> >  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > -	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
> > +	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> >  	if (!kvm_supports_32bit_el0())
> >  		pmcr |= ARMV8_PMU_PMCR_LC;
> >  
> > -- 
> > 2.25.1
> > 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
