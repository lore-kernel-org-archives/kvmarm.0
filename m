Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8DC17AE11
	for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752834183; cv=none; b=fK1PWftZktRFmrv7pSnPAu/FlonAUrFzes8cbtXpPF4UYY9abl0Z+kR8ktMH1fPVBFeR+Mnh+9ExXfTafVIzucqf2XyE2gH9gdrAKurZMaPpTly3YxDeqRjOcdTzs8virf0RKQ/8s2spnDNA3aHLCnwUeoro3c11pu+y808GZr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752834183; c=relaxed/simple;
	bh=0K+PWnlknbuLrkGKVE9wT/E+DryHu1Blg4zLy/8QVAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4MTfszoIFY5zP/Kc9l4/p268gFyXNLRF+nIlfs4yA0pe4DjPBS1yR29xqzXQsyEltyltpdkbejl1p2Sbqa8Xb5wv9biakoWfqlzRsn5VzzP3N//zO1eBl7Ch+frasxIT6obtzM+tNGdjBp2qwkr9OogGTVEFHVqCNhDp3A8iaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsU5Hqw3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsU5Hqw3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4561b43de62so71575e9.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 03:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752834180; x=1753438980; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kvcvr0AK6YSE0JbmZUfdczos7CJhlpqAGW0SyiAlvmQ=;
        b=jsU5Hqw3DOuDpD/JLBx4HOVed00AMbvhuHXaCw43+k8sORdFQoG+nCkmbYZmUMclsR
         WMR3gws2J/4ptzE+qiOl+l6+p8CddXT/OrXfBTGyS4+8MWLdVqRTfHsOdMkxXIsJZjea
         imB3zQftxOI6CwnJsn1tUtSR8uTrtXZEGXvlMGDkf9ZfBIlC8n8nQaZ+yI5BhfqxCbqw
         d1+6qTHkX0U06BNMYnGrd4WcjmWzpXH35/WDnG71hj1SaMZgNIqVAhdvVwaHg983U+36
         7W3LHghul7VEoFY/YxAtGCwKt5pJLBKg/T1rWLWNxwzLrDuHczcxoFK4C1tqKWqWXC80
         BfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752834180; x=1753438980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvcvr0AK6YSE0JbmZUfdczos7CJhlpqAGW0SyiAlvmQ=;
        b=vjqFkcTrPiElhQHtyAaLy6CqELV+DzShssmIXO8K/E967/pLe5qjYGFooAYPkhE3M5
         aM53GWPQ5rY4JfC6nAm+NXpz8feC7JW5nh+WMZCRp1tPsg+o/0Nh/tHxyDxDIMRZ3KDM
         HD4kvPEUgPK0thpC9IQv8v0ZqlGsPQ83crxEXZgL666Mdy3GfYwAuXO0YKHMYy+DENqR
         PHbXSxFassJVWNuQfC5vO9+l8fQr1H+fudu4mpr0wFzp10KYSFh3PVqBHUALzYvvKAjf
         EgSSifOSGjyepHdNB9oNPJ3o+slti+RzTc+5Hf3L9R31MCNhXQk5Qvdz4kx6ksRUeEvU
         vfSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDAPQvt5FCOyGFIcvMXFCNILuQV+1WwXTULDmTYJ28R3WOWodkXPA1tqvD/G0gYrjATb3+Sr4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7GS5ocwYHp3SY8AEBEm4VWJ7j7U3CocPq2xV64X4XKgM3AuO0
	FI/gZqhZcRYknBLXld7/MXbOUcUJZ5Us/8uNrP85sS86DCK+lvMh48dlPouJrwlBdw==
X-Gm-Gg: ASbGncvraRdTl1uftjUBfiN4U2TMULfp5J2XDFlPl3rCA+e0fLTLtZbDXjCykx79Axe
	Ozp5+DxkkiNCT9/vrwSdXBspiWxml86vDpwkeP9QctWIdfC4IxhGQAdKeqGKkR0JF88y0f4Zn3y
	QJFWOQlzrmWxbw0KJCnw7jYT1l8i/oGXoIiuHTytDgN9BcaQaYWfPBW+Boa2f2kjoH9rFj/y12h
	OcRmJ9Xz+7Foiu3GJeTfgZ+nmpRiCx1mBOLKcXKQNPo6emoH950+1IZDbhx17eGZxjQ64C54IWI
	UgwahkzxheRgN+votwVGdsyLDgyZDwexD/RNPbnbDiMiEQ+TjGLUlcMTLfhdiC8UALluDZMo6On
	ewz/e2OjgQd5rlMWxRNHJRxpLVGH7SwNT9xWPAnMFESPd+e1+DVuGTws5Djcd9kD5zGi7
X-Google-Smtp-Source: AGHT+IEXgWSB+NQ1xhdND89MDLioany2VPotHUOmf388VpQypRg114G/u7aLbJeTYE+lqaAILAgn1Q==
X-Received: by 2002:a05:600c:1c11:b0:450:ceac:62cf with SMTP id 5b1f17b1804b1-4563a79cddbmr1480885e9.5.1752834179584;
        Fri, 18 Jul 2025 03:22:59 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca48991sm1423585f8f.44.2025.07.18.03.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 03:22:59 -0700 (PDT)
Date: Fri, 18 Jul 2025 10:22:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	keirf@google.com
Subject: Re: [PATCH 2/2] KVM: arm64: Map hyp text as RO and dump instr on
 panic
Message-ID: <aHogf50CvjeSklRo@google.com>
References: <20250717234744.2254371-1-smostafa@google.com>
 <20250717234744.2254371-3-smostafa@google.com>
 <38b08607-b9d9-425b-81c4-b227dda427b3@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b08607-b9d9-425b-81c4-b227dda427b3@arm.com>

Hi Ben,

On Fri, Jul 18, 2025 at 11:16:18AM +0100, Ben Horgan wrote:
> Hi Mostafa,
> 
> On 18/07/2025 00:47, Mostafa Saleh wrote:
> > Map the hyp text section as RO, there are no secrets there
> > and that allows the kernel extract info for debugging.
> > 
> > As in case of panic we can now dump the faulting instructions
> > similar to the kernel.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   arch/arm64/kvm/handle_exit.c    |  4 +---
> >   arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
> >   2 files changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index de12b4d4bccd..d59f33c40767 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -566,9 +566,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> >   	kvm_nvhe_dump_backtrace(hyp_offset);
> >   	/* Dump the faulting instruction */
> > -	if (!is_protected_kvm_enabled() ||
> > -	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
> > -		dump_instr(panic_addr + kaslr_offset());
> > +	dump_instr(panic_addr + kaslr_offset());
> This makes the dumping in nvhe no longer conditional on
> CONFIG_NVHE_EL2_DEBUG. A change from what you introduced in the patch.
> Perhaps it makes sense to reorder the patches; do the preparatory work for
> instruction dumping before the enabling.>

Yes, I thought about squashing both patches, but I was worried this patch
might be more controversial, so I split the code into 2 patches, where the
first one can be merged separately if needed. But no strong opinion.

Thanks,
Mostafa

> >   	/*
> >   	 * Hyp has panicked and we're going to handle that by panicking the
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index a48d3f5a5afb..90bd014e952f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -192,6 +192,7 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >   	enum pkvm_page_state state;
> >   	struct hyp_page *page;
> >   	phys_addr_t phys;
> > +	enum kvm_pgtable_prot prot;
> >   	if (!kvm_pte_valid(ctx->old))
> >   		return 0;
> > @@ -210,11 +211,18 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >   	 * configured in the hypervisor stage-1, and make sure to propagate them
> >   	 * to the hyp_vmemmap state.
> >   	 */
> > -	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
> > +	prot = kvm_pgtable_hyp_pte_prot(ctx->old);
> > +	state = pkvm_getstate(prot);
> >   	switch (state) {
> >   	case PKVM_PAGE_OWNED:
> >   		set_hyp_state(page, PKVM_PAGE_OWNED);
> > -		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
> > +		/* hyp text is RO in the host stage-2 to be inspected on panic. */
> > +		if (prot == PAGE_HYP_EXEC) {
> > +			set_host_state(page, PKVM_NOPAGE);
> > +			return host_stage2_idmap_locked(phys, PAGE_SIZE, KVM_PGTABLE_PROT_R);
> > +		} else {
> > +			return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
> > +		}
> >   	case PKVM_PAGE_SHARED_OWNED:
> >   		set_hyp_state(page, PKVM_PAGE_SHARED_OWNED);
> >   		set_host_state(page, PKVM_PAGE_SHARED_BORROWED);
> -- 
> Thanks,
> 
> Ben
> 
