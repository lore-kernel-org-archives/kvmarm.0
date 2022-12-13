Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58498C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 18:22:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5D54B93F;
	Tue, 13 Dec 2022 13:22:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FX8lhjfQy7Pc; Tue, 13 Dec 2022 13:22:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3544B908;
	Tue, 13 Dec 2022 13:22:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434B34B908
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 13:22:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3VWXHHlSxqJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 13:22:51 -0500 (EST)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED6F54B839
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 13:22:50 -0500 (EST)
Received: by mail-pg1-f174.google.com with SMTP id f3so419287pgc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 10:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=s2Mk746DNefLFIHMPGAave2iFDkNoKxxYDbIfxj0zO8CnmFqk234Le+b50BvC1Rs0J
 q6RA+SCw3OuTN7Nk62tME9XL6haA3AvqIKDGdc9tNW6Cnm/BjuY8Cj+V0/ZL/MPMQcGm
 ivZBsjND5dHmwCFVkdniiiSUv5HoIsAxgHKqF0vPychojL86E9ag54Nv8pF+QwILefyq
 WElB+ZujcjWKTFWJPLXbk30BYprSNb2BvQtwyJa7/v/CtYcdUBfXiM5le+oh6/E+8UO6
 eTviajuicfUsNRjm2z3Bd1l9z+7TAgbDXHPhs1qCeIRYuWatJj2IuKaIx4IIKfDpfFoN
 vUsA==
X-Gm-Message-State: ANoB5pnHktQHPlShkRLkZ1hXVZTz2+w5aj0AqoJU9/1qbaTfzrW6y8gF
 tblDszxJ/4Gym88REjKvKnoLMA==
X-Google-Smtp-Source: AA0mqf6Soby8rd6m9EytXXHvJpT4TDAOmpLAofqH3m8MSRCn4y3bZNlZuKdxW3txtw47z8Dx4bLf1w==
X-Received: by 2002:aa7:9697:0:b0:576:9252:d06 with SMTP id
 f23-20020aa79697000000b0057692520d06mr371181pfk.0.1670955769814; 
 Tue, 13 Dec 2022 10:22:49 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 g74-20020a62524d000000b0056bb4bbfb9bsm8195038pfb.95.2022.12.13.10.22.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Dec 2022 10:22:49 -0800 (PST)
Date: Tue, 13 Dec 2022 10:22:45 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Message-ID: <Y5jC9bAJ08xW1ZIA@google.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
 <20221209164446.1972014-2-james.clark@arm.com>
 <Y5N3R+w3GF94hxHa@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5N3R+w3GF94hxHa@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 James Clark <james.clark@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
