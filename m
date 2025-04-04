Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29A920E339
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 17:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743786497; cv=none; b=dEdSgHyMt/TRkfNAcuyCAWIcMNJpMSss68a9d2gZZ9GjYAldKTr9pwCALgElyO017tBbTAbrqpARF2urHBfTJMmA4uyVUNDDBA6IQYFW0Cqp2gR8NHKnBq4nq9gOn64WuLX2pf6Aiql6OeAUnyqmVnK6Cehnhy2Kgkp3yDmic4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743786497; c=relaxed/simple;
	bh=KCcZLLVuoSdc3w18qTEjWe86uuWT8hoT8Z8E6CPkYsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLq1U7r/v+AKxpWiR2DWqp/uxI+l/QXmQeWBt8yn3Srt10llc37t1ri7EfD3l0KaOZt7lpAEYVQxxNAL21CZmCem8U5q0ONihnQVm1v48a2DH4Q1XGkJKailTi627zapiKLjbZ8H+j+aWs9wQX+DCEifFzeD65Ec9b5Wp6g6j0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gt2b47Ym; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gt2b47Ym"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso22983845e9.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 10:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743786494; x=1744391294; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4k6IoGtIEG6cR51zQzmX/5gWxNHbCnuUK9lpXUrxdQ0=;
        b=gt2b47YmCManGB3C/Wl4z4l/uPLZR6tUsGWmUORbPVGFWQ02TO3xcpuiLDJnVy49IA
         SkwTk4wboqS99QYP3Wfs+W4Sea1tzCCF68oGmAfUum8vSlVC84STol8Ts6o/Q6FMxXer
         3hhOkXArLXR3CsTjy/ecXbR+D17WJFD6AxwgcrrgAUdGmyHL/o1RBJ/g5i3ZsLLjEbx9
         nvKvuHXrH1KUqo8m8nGCx7jw+J4hC7vBN2Ynb3NNtBjB0Gmyue+r08iRMLRBMTlDP2Af
         lfmAuvBLbYidtig61ZBdbDq20cZc0Gu8q3YjvNTHmofus8tANJi9avc/qREhqxBqUGqI
         6+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743786494; x=1744391294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4k6IoGtIEG6cR51zQzmX/5gWxNHbCnuUK9lpXUrxdQ0=;
        b=PtWrMXwHaLMt3Z7oCC7umZlMeVp4w69XlkPGXtLJWVkxNVhXrBoEq9udIjzyQBYV6y
         dpaLYzrV9ZfI5pK2nPJnzzz1WsKW2+ThtRZPfOLymo36joC8ZTosyNs9+Bx59PfdI8Gy
         rcUpamPANk8zpSmzG6qvl+vfa2ttN0Wtbgs0scO35Az0LN1R+/lRHXSk14gjrp+0ZQiT
         aTnX9AFBA75f5zD6A5M4e4j5j/T4b1Sn0BZdZ4jIfquIWCcjI6ywuEtG/1JX0KNBpBDI
         ukLPuBvvsXbRg8PQxS1HAZZlJkIuw7wrrQNvBYXeoat/elmW94vJr+phS4/pUIIrmqEX
         w1TQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4XRuP7xRB3ieoQw9Q0Mh/FMnyEshwc7fHe9JP/MAojNkqEfylNg+SqhYkEEK7KlfqM6de8j8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwC4JntHojeUYpXR5UyH15IBJ8aXXTeWCiTkMKdiR5V3EK9jdAO
	Igjs+5EWD3O6cXnY05h3J6msy4mCA7aAr0GfkGeRXZJMlm8dSw0LgQbSAP6raw==
X-Gm-Gg: ASbGncsVtxV3/La6WBSPfosdpCB2eOfqWkhTnI0ac2UqsVT8LnViG6dmXFlrdVQLrqz
	r5viTfHeoqf2Fu0O6EPDSzEJ4uRDl+Reej09XN7p8GtGm5hlH6yx3ziNxkT12PzRc+XaBNT/oyI
	iW33HO2I9q2t4ZeMZfrL2mQTYS+Y7eZb9quXzTxMZentp/LJCo6yXiRShzDzkD5rbiYHCx3KfUi
	0B2Q1fKacMdqYM2SKaEca3eI3+Ln9JIF+VuqU9a3l0TobsyEaY0rfKncK06g2nHtm+mzNNmpsav
	64khnm0E1Ge4KiICLqBziaeG7JAcb3WlWVFhfAy/MPSCaykGDL0+LyW4FeL0qtxM98z3BJk1Unp
	G1BEvfoQ=
X-Google-Smtp-Source: AGHT+IF6UPxO13DnLOo0uQMw2P2nlLBQDZOGt8vDi72vp60MMU8fX0APY0XE/2SORIk1/20Jd4eB7w==
X-Received: by 2002:a05:600c:3484:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-43ed0b80b30mr37929175e9.2.1743786493987;
        Fri, 04 Apr 2025 10:08:13 -0700 (PDT)
Received: from google.com (35.157.34.34.bc.googleusercontent.com. [34.34.157.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34bbc64sm50289385e9.21.2025.04.04.10.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 10:08:13 -0700 (PDT)
Date: Fri, 4 Apr 2025 18:08:10 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 8/9] KVM: arm64: Stage-2 huge mappings for np-guests
Message-ID: <Z_AR-jwodVPT5oOg@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-9-vdonnefort@google.com>
 <Z-6ZU7DWkxnVIbff@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-6ZU7DWkxnVIbff@google.com>

On Thu, Apr 03, 2025 at 02:21:07PM +0000, Quentin Perret wrote:
> On Thursday 06 Mar 2025 at 11:00:37 (+0000), Vincent Donnefort wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1f55b0c7b11d..3143f3b52c93 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1525,7 +1525,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	 * logging_active is guaranteed to never be true for VM_PFNMAP
> >  	 * memslots.
> >  	 */
> > -	if (logging_active || is_protected_kvm_enabled()) {
> > +	if (logging_active) {
> >  		force_pte = true;
> >  		vma_shift = PAGE_SHIFT;
> >  	} else {
> > @@ -1535,7 +1535,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	switch (vma_shift) {
> >  #ifndef __PAGETABLE_PMD_FOLDED
> >  	case PUD_SHIFT:
> > -		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> > +		if (is_protected_kvm_enabled() ||
> > +		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> 
> Should this be
> 
> 		if (!is_protected_kvm_enabled() &&
> 		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> 
> instead?

Duh! Indeed that's what it should be! 

I'm going to send a v3 addressing all those comments of yours. Thanks for
having a look at the series!

> 
> Thanks,
> Quentin
