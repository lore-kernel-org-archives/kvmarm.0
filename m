Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7363C09F9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782511154; cv=none; b=AGzvtClOK3rI6vljL7fB3GGWAab/fYxsAVL9yT2rBwdqYQfcYolxsjuekYHDlH1599u+9n9t9v3he551TUmUdWuJ4BTCiulc/r1aLLABSkApEJHSpx15XGWE9mLiMkFmouuGYTDi6FEAX9ZwAAhyRKQFOZ95OmDF+NNCwhdOCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782511154; c=relaxed/simple;
	bh=2ZSje1GLJDCobStX5wOp+GMYTYNmrNuHVry91rZPLtc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JNbq4SFAbfd+kg9BkHZan4m25p/2X/8Sq9f4lVTqtnpdOGzzew5Ixu7yj7IifOA/YC81g3Cft8wBbF91p+dG/ik8sa71ZL7vHl98Vzoi9oGht4KtFjTiKMviwfAmhTwPk8BhM+T5EVeGxt3XvAWm7Ue+w6rhZXRXHw83S0wvg28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c8EdNENj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c8EdNENj"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c82843005eso8814605ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782511153; x=1783115953; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JDQlpzOhBh6kY656CwR9WiBjifQ7cM+pBied073IksM=;
        b=c8EdNENjny4tupXExHPnYYdW2KkB6riU+G648vO4afsiE2VaMOe7SsBvwS+5gZRsHH
         if8uiyeytM2KcyK6XpYwhBr9tKFvXpOyPGs5mLdth5tiDO10kxVhr4XsaCe7Q1wkTiXA
         qYwIJws8MSZB1W/CdHm4CCH/oba4c/ZvGOMDW3xADnnuD2VAaSSfEHVgRLjVP9YRvoXd
         hSqrJILi77aUMhz5DEPHr0E/smeKNUD7M80B6m2CHfv3ABba5iWl2f06aMG3MCl9S1v8
         VwstwHEvpHqEHYJa4rNjbers+JVTQa3GGCz+q4UL1Umg+I6/R6FhEY6pG36NRVD75MKk
         ghng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782511153; x=1783115953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDQlpzOhBh6kY656CwR9WiBjifQ7cM+pBied073IksM=;
        b=iKmWEMvUrVVbi/DY97+O8fFpO11Xt1QcOPqBgBNgzmFrgJJHCHzjNN8/uf4+kiqT23
         9kjFj+17QIE4ShaCUXS5HjhZqiaJswNq7LC7HEedhib/am9B6+Zgr/YrxRehmKDj2ADa
         bOT+paf+Vc8KyLZDb6+jH4mGKkjvW7tKmgSbO29jxVRhpJ12kwslsRcwyRdUdePIRrjo
         ZCylnktuzKK0lsM1qBAfQeNt/JsSDlhxHpmxnJPzD1J9V8XRZsW8of1uRVoP2cydLLPT
         1Il+LN3K/xYFGJN8zHnJ5QVQwpgtDswqaMSLht9Z9UeyRn+br6W0wyte0JkDrd+eQo5n
         ItIA==
X-Forwarded-Encrypted: i=1; AHgh+RqP0rSM4hqo6K5z02FxlwvYuObavj4f9myOALv/btwGWGlOqXUP95KCroalHwRWha+xuFBLM5A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9lfA+8s0bPKY+ZplTTy2kfZtY6FTuKywlNyHC3pinRFNziNa8
	FR5wNwVukuje8WQbUR71QYjQWh/LhV5W2IKNKxKpPE8fgHLnEP5Dg9Yeg9gNzmsOAMPfLRPIKZQ
	JHjKQpg==
X-Received: from pllg5.prod.google.com ([2002:a17:902:7405:b0:2bc:c1af:322f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf07:b0:2c3:5683:9acb
 with SMTP id d9443c01a7336-2c7fccc7b6bmr106313045ad.32.1782511152670; Fri, 26
 Jun 2026 14:59:12 -0700 (PDT)
Date: Fri, 26 Jun 2026 14:59:12 -0700
In-Reply-To: <20260626214819.EC79B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com> <20260626213534.3866178-5-seanjc@google.com>
 <20260626214819.EC79B1F000E9@smtp.kernel.org>
Message-ID: <aj72MFxS7XinmNrB@google.com>
Subject: Re: [PATCH v8 04/20] KVM: selftests: Initialize the default/global
 pRNG during kvm_selftest_init()
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 26, 2026, sashiko-bot@kernel.org wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 875030c22d07b..1016865d3f7a2 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -24,6 +24,13 @@ u32 kvm_random_seed;
> >  struct kvm_random_state kvm_rng;
> >  static u32 last_kvm_seed;
> >  
> > +static void kvm_seed_rng(u32 seed)
> > +{
> > +	kvm_random_seed = last_kvm_seed = seed;
> > +	pr_info("Random seed: 0x%x\n", kvm_random_seed);
> > +	kvm_rng = new_kvm_random_state(kvm_random_seed);
> > +}
> > +
> 
> [Severity: Medium]
> Does making this function static prevent tests from reseeding the PRNG
> early?
> 
> If a test draws from kvm_rng before __vm_create() is called (for example,
> generating gsi and vector at the start of main() in irq_test), the test
> will use the initial seed from the constructor.
> 
> Since kvm_seed_rng() is static and only automatically reseeded during
> __vm_create(), how can developers override the seed to reproduce CI failures
> for these pre-VM random variables?

By hacking selftests.  Yes, it's ugly, but AFAIK we haven't yet had a failure
that's actually been dependent on the RNG seed, and plumbing in a way to set the
seed for every test would be painful.
