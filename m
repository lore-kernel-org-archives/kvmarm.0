Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F382116132E
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724069944; cv=none; b=hIAv/cYE+fRN65Wxg7FDqvjk4LNf0FlMbfpT9vi9R7nBXY0K4phn86wXJi+xJMhQSzEaR+GhwsZ63paROZgrGMp+GjbsuD6GL7LDvraVjlWNFLIbaLao+gFQ5XE7qH3es534Y7gaJG2PwiMALWn/EIjy7OW6q/Qs4A2AxhGTpMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724069944; c=relaxed/simple;
	bh=OVUuDphKRX+9NR8bK/07mU2BsYGjbieYyOKc83Tblc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBi6m62jGj4A2qfSTK2qp1xwbTyBNxdnGZBXQEFos+R/Zw4V4xU5Td7fiuwcIw7DBEk+mfnrO+LkHfjzjkXmF99dRnf608m1iXxaX+1Zv85y60jmzYBhxgEOxg66xGJeVuZQIXl7owiOvZkdK+kc90ygwq0jMrYy7bsQSNIDhIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0xN76EFX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0xN76EFX"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5bebc830406so8141a12.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724069941; x=1724674741; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Db4hN2w3m7INit2SBeLbUeRnILkMZrxR2DmZlcKp+hU=;
        b=0xN76EFX+jW2ud5UcfD9MGdYkEKE1NO61tWVyMAI8g0/F576aLogr0UqDETNLosbw8
         FnP6PImuPstkgfz0GdMeDEQKMxNACs3xepvqg+tqCbkxUdDWjENTXRUe9KmSu5owcvlu
         Qkb1BtkOUk9QuTr6QMg2XPbFnydmVTGlb3oAp1Gl+CyygVyBHubCjCjLluZskrANceiE
         XnQlOSmNSLsGzvP9Gse/gXa7aPLq67VZedBQ8V1oYfekop3QwjVHuvyh8oDozlSddpK8
         ze/4aB00N6qsbtwZL4P3dC7Rpj6xAzY97ZqCvWMUDNTuzVJfmOws0a02laDIwS+ia3YB
         7fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724069941; x=1724674741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Db4hN2w3m7INit2SBeLbUeRnILkMZrxR2DmZlcKp+hU=;
        b=r/cSkkJM5VvVT4xBc4QbIOOlkXoU3vAGxYhd5zguHrNAddu/4AIwjDOn6mk5Z+AOtV
         cnT3/Q55i0G3TBSSsFwYtafZJ2BHGnMOOwoi5wddFFlASqP+V4wRFDcFpSmfgf90jlYb
         nws7Y/xCofzuTLxYXauIfDy2KLs9eZGNEQF3/P7o12w7hVuri49MISqNW52j5I/6EYdv
         lCGJhd6iG7DC+1cBgkGGdeZd+9Zt8TqYP7e+yQlBuUKemUHpzc0ljDq/76IsSRJaJWWR
         fixn+5tI5FpUKoIEYEqzFXPcaTsiJUI9YDZr+/EuF5rXZIdp7ZgDJAfOhfMU3fmdwcjl
         L7xw==
X-Forwarded-Encrypted: i=1; AJvYcCWJeoNjokk+ky+8ghBL2MrzUV1eoAIefNufO/CE7OlRmr8SOwWRpiHGSVepzA7pbn4JEThCJUk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxitioBtmFkwHlzQbMxaOk+kj4xIrDUGGmZfQjdT28taG29KI1Z
	Xoz9++U0ab55XG8sa9iuYMZLvr4Q2JqFHKg3HRvkcascrQ9XjdZvyQs4nhHSyg==
X-Google-Smtp-Source: AGHT+IEoH4NgDY0zYg9fqa4QM4SVY1O10WJ1j4848W30tFwb35xVV/g6Yfo36yCo36vqfTQ8XhRfwQ==
X-Received: by 2002:a05:6402:348f:b0:5b8:ccae:a8b8 with SMTP id 4fb4d7f45d1cf-5bede24bf57mr84286a12.3.1724069940865;
        Mon, 19 Aug 2024 05:19:00 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37189857069sm10401322f8f.47.2024.08.19.05.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 05:18:59 -0700 (PDT)
Date: Mon, 19 Aug 2024 12:18:57 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v8 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZsM4MacbOe7GLIKl@google.com>
References: <20240816123906.3683425-1-sebastianene@google.com>
 <20240816123906.3683425-6-sebastianene@google.com>
 <ZsMeQ8nAZLDhsBmA@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsMeQ8nAZLDhsBmA@google.com>

On Mon, Aug 19, 2024 at 11:28:19AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> > +static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> > +{
> > +	static const char * const level_names[] = {"PGD", "PUD", "PMD", "PTE"};
> > +	u32 i = 0;
> > +	u64 mask = 0;
> > +
> > +	if (start_lvl > 2) {
> > +		pr_err("invalid start_lvl %u\n", start_lvl);
> > +		return -EINVAL;
> > +	}
> 
> It looks like a duplicate of the if below.

I will drop this.

> 
> > +
> > +	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> > +		mask |= stage2_pte_bits[i].mask;
> > +
> > +	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> > +		strscpy(level[i].name, level_names[i], sizeof(level[i].name));
> > +
> > +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> > +		level[i].bits	= stage2_pte_bits;
> > +		level[i].mask	= mask;
> > +	}
> > +
> > +	if (start_lvl > 0)
> > +		strscpy(level[start_lvl].name, "PGD", sizeof(level[start_lvl].name));
> > +
> > +	return 0;
> > +}
> > +
> > +static struct kvm_ptdump_guest_state
> > +*kvm_ptdump_parser_init(struct kvm *kvm)
> 
> nit: I guess it's more a "create" than an "init" as we allocate the memory.

Yes, that should work as well.

> 
> > +{
> > +	struct kvm_ptdump_guest_state *st;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +	struct kvm_pgtable *pgtable = mmu->pgt;
> > +	int ret;
> > +
> > +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> > +	if (!st)
> > +		return NULL;
> 
> return ERR_PTR(-ENOMEM); ?

Yep, we can encode the ENOMEM in the ptr.

> 
> > +
> > +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> > +	if (ret) {
> > +		kfree(st);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	st->ipa_marker[0].name		= "Guest IPA";
> > +	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> > +	st->range[0].end		= BIT(pgtable->ia_bits);
> > +
> > +	st->kvm				= kvm;
> > +	st->parser_state = (struct ptdump_pg_state) {
> > +		.marker		= &st->ipa_marker[0],
> > +		.level		= -1,
> > +		.pg_level	= &st->level[0],
> > +		.ptdump.range	= &st->range[0],
> > +	};
> > +
> > +	return st;
> > +}
> > +
> 
> [...]

Thanks,
Seb
