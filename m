Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A3CC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:14:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDCB664F53
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDCB664F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D9B4B468;
	Fri,  5 Mar 2021 04:14:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nbJ08Rb+TQhm; Fri,  5 Mar 2021 04:14:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB5A4B3D4;
	Fri,  5 Mar 2021 04:14:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BDD04B39A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:14:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PbA4H146dbtl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 04:14:49 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15F0D4B38A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:14:49 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id n22so769685wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 01:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NiGdJYWOwk1ggBwvtk4IUuiZlQG7Jo/ZpYTDhsXbulA=;
 b=oygQwv/uuVsd5nAZHELl0vYZAwL1bEnGaj9F3FXEjO1aDtyUsCLlSZH4VFoz/BZ23Z
 7JIaatV3Cn/gtHUE7gdSWrBwMvwL/NvBQK1PMENx0Wir+Tc6ixUoZc4M5AY2FQw9GKY4
 W8HXdZ8mlFrB0aEfVyFtMhMjYrgcDEXeh9i4/7fOtRGgGfEEK5hhkjJCRtSKHd7Swo47
 z8/GZ+YMn11E+eKb7xKCqzlCyzhXX3fVVGmHj3/EGo42mar1WRyA3AstJ3TTywM7X1ZK
 87XFFzISGMbXifIvG3xDD9g9dMcbvJlF67H3BiIcQHg6xDxPNr6QrjHzDHGWfdaeeJEa
 eR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NiGdJYWOwk1ggBwvtk4IUuiZlQG7Jo/ZpYTDhsXbulA=;
 b=DitFo38FHVjGruDBbEK/ZKPzv3ak6JqF6JjugRV7JFYADCT0hl1pZy2T2uvQgD1BnE
 6mXHGcZz/tNWuWhv7k3TJeYauP0K9vhdFqpHo77djdi20mWab/I34RGDqR9fUJHC4mRA
 igEBCSFEoidBRVMmWKqDklbzPurp8gnx9Wcg0L/KYt5RQKr2JCmVRTEtLmkweu6spC3r
 2hRLnHnx9XCDH2ehvdUFkoPC6SNMmFanuHwFurjk4oRyqyIdX8nV9FfHeCawARWFmvih
 POm7C8EhWGV1sKcwpPxjXGrxXX++J+yJkBmU/HAqPv43e6u0j6/pDGjHCavIhC+ZPeGK
 on1w==
X-Gm-Message-State: AOAM530JsUJopMZqVYPeybqoREqP5NqhU0uyfGeKlx0b9KfUW735cvr3
 mVPiKry6C3XprtwC5lIEgeh7QQ==
X-Google-Smtp-Source: ABdhPJyhmE/fuJuG/SeC3BKpW8cT6v1DcHKNo/NjdhJ2SUdl9YVtwJAipHAm0jYNcM/x6WsfP8i8wQ==
X-Received: by 2002:a1c:17:: with SMTP id 23mr7928664wma.6.1614935687986;
 Fri, 05 Mar 2021 01:14:47 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id m3sm3355609wmc.48.2021.03.05.01.14.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 01:14:47 -0800 (PST)
Date: Fri, 5 Mar 2021 09:14:45 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 16/32] KVM: arm64: Elevate hypervisor mappings
 creation at EL2
Message-ID: <YEH2hf4MWiMkHnwN@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-17-qperret@google.com>
 <20210304192540.GE21795@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304192540.GE21795@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Thursday 04 Mar 2021 at 19:25:41 (+0000), Will Deacon wrote:
> > +static int do_pkvm_init(u32 hyp_va_bits)
> > +{
> > +	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
> > +	int ret;
> > +
> > +	preempt_disable();
> > +	hyp_install_host_vector();
> 
> It's a shame we need this both here _and_ on the reinit path, but it looks
> like it's necessary.

Right and I want this before the KVM vectors are installed on secondary
CPUs, to make sure they get the new pgtable from the start. Otherwise
I'd need to do the same dance on all of them to go a switch TTBR0_EL2
and such.

> > +	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
> > +				num_possible_cpus(), kern_hyp_va(per_cpu_base),
> > +				hyp_va_bits);
> > +	preempt_enable();
> > +
> > +	return ret;
> > +}
> 
> [...]
> 
> >  /**
> >   * Inits Hyp-mode on all online CPUs
> >   */
> >  static int init_hyp_mode(void)
> >  {
> > +	u32 hyp_va_bits;
> >  	int cpu;
> > -	int err = 0;
> > +	int err = -ENOMEM;
> > +
> > +	/*
> > +	 * The protected Hyp-mode cannot be initialized if the memory pool
> > +	 * allocation has failed.
> > +	 */
> > +	if (is_protected_kvm_enabled() && !hyp_mem_base)
> > +		return err;
> 
> This skips the error message you get on the out_err path.

Ack, I'll fix.

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 4d41d7838d53..9d331bf262d2 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -221,15 +221,39 @@ void free_hyp_pgds(void)
> >  	if (hyp_pgtable) {
> >  		kvm_pgtable_hyp_destroy(hyp_pgtable);
> >  		kfree(hyp_pgtable);
> > +		hyp_pgtable = NULL;
> >  	}
> >  	mutex_unlock(&kvm_hyp_pgd_mutex);
> >  }
> >  
> > +static bool kvm_host_owns_hyp_mappings(void)
> > +{
> > +	if (static_branch_likely(&kvm_protected_mode_initialized))
> > +		return false;
> > +
> > +	/*
> > +	 * This can happen at boot time when __create_hyp_mappings() is called
> > +	 * after the hyp protection has been enabled, but the static key has
> > +	 * not been flipped yet.
> > +	 */
> > +	if (!hyp_pgtable && is_protected_kvm_enabled())
> > +		return false;
> > +
> > +	WARN_ON(!hyp_pgtable);
> > +
> > +	return true;
> 
> 	return !(WARN_ON(!hyp_pgtable) && is_protected_kvm_enabled());

Wouldn't this WARN when I have !hyp_pgtable && is_protected_kvm_enabled()
but the static key is still off (which can happen, sadly, as per the
comment above)?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
