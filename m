Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E78494
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721399772; cv=none; b=PGkefkS1txDTkALhb7lqAlDhDfxsX+f89jKvY22GW6nWDVbtXLX67xG4kpm9sMZURr0OX78ag4d0gN4wwzbsMhBaT2szmuhoDej95WbESOuV1w8lg+a/ZN9QBblUAei+Bh/kCfz6IUxyFFvcr2qDJFXzhLTaOmGK1l7j7r00hU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721399772; c=relaxed/simple;
	bh=mV+54FIRsUg1B7hA4c9KCJ84eNp6NIHFBQlVgTwp1XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pe5pad7CXayANaHZk6ZEO7EkLvkKC31YX+Notu3AMEU2HAo7v/T2HldsZOIemx+g/o3IgDnRNaxWSGI49i/7Qv1Sgt+/04Y5gwvFt9ka7sJ7vTt/IUSzfHbLanv5lW2q6ebJNueRVRENAK4WZbW+/YLUgBZ6tMQyNxfJIPKwUfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qAz+b256; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qAz+b256"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42726d6eca5so13239235e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 07:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721399769; x=1722004569; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XdlmiGKKf4P64YOv5lQSDuR8ybLle1v3kavGCeiCW+U=;
        b=qAz+b256aSwzDc6c77kxyif8t7rvcbjomh1ZBoi2BSPBr59rQlVpT4G5leaO9i2yR4
         +TvXdlpVndP7nrJlqM7+uOIL2ql6dCgXw18s5VOpdZIxwhz3s41Bx0kvxOma8TTOMdhb
         Eo1YgQjWC0Ri3CfHwja65xSGfBF4xFiUS9wK93rpuw7aWL7uAcycq1Yw5wv15ky40lcL
         SjeZDaRvCKp+Jpqq2yQUsKCenNFETP6zOCdr06xT4Uz/sdJEUtqlK0enySgdmIZW43Og
         N7wFAIodG2c8i10Btz51hmbQewolQhqEspCmWMdj3IYpzLZFvV+PFhKGMKV/+6ps2hA4
         MmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721399769; x=1722004569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdlmiGKKf4P64YOv5lQSDuR8ybLle1v3kavGCeiCW+U=;
        b=iXquwzolRgVwQSvyJBqGVl4vfoTvt2MEYTjx+bzXgea6g4B4ClWJaQsQEZFVGQchHF
         /DtqiwgHR4iw5qwXanELrlyYedXjRT7PVyNoJIH+O72fDwpGiCjKzJoSQECd4zGjAcJp
         aMbjMSTdoVkOZjkMYpi1koEcOFQKRv4QmRlCNVAOtQ74pF355xyZ/T2Fu59BEOlNyWbo
         b/BALDUxgvKsVA9LGNM7XVTDYuAQD4T2j/ZtP3800xVDicxBIHx9e2geH8h/f+89pAPS
         C4TOzuiqeFt2sXQQaY4459XfeQoM7g/0QEqcrTRFX09HAU7ejl4b+U5sDdSju7lOspVi
         CYNA==
X-Forwarded-Encrypted: i=1; AJvYcCXUNnd3X46x1nGxEJy+Rmia+A0BOkMWnqp9meCqxqLDXGWG7Ca/3lASSaVmw5LlzdLqcc/MZYlvBeUjWA6AQ1tW5Yk4BP1/
X-Gm-Message-State: AOJu0YyRkLL3+ZtZWPM42e3pFjnF5rnJQmqxTkFuq6T7y55/3a/xRmc0
	qyPQNSdpFaTJ8VhtFboArjBkJ1RVfL4wodumKOuLpXNn1h5mEacznh/Dr1a28g==
X-Google-Smtp-Source: AGHT+IFA/wA9e42Kh22TLUFramVCLKGDe8eWOeYO6wA/icFUlL9M4s7EtisnJ7yAOuE2+K35INQfAw==
X-Received: by 2002:a05:600c:4e90:b0:426:6326:4cec with SMTP id 5b1f17b1804b1-427c2ce8d0emr61277055e9.29.1721399768362;
        Fri, 19 Jul 2024 07:36:08 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d2a43034sm54732375e9.3.2024.07.19.07.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 07:36:07 -0700 (PDT)
Date: Fri, 19 Jul 2024 15:36:04 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <Zpp51BYWYFnZHVW1@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <ZoJsAyrmtge4mXJY@google.com>
 <ZoK6v2_pJnc57LHM@google.com>
 <ZpZEjW1m2LypTHjF@google.com>
 <Zppzj1oIDivlAFpP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zppzj1oIDivlAFpP@google.com>

On Fri, Jul 19, 2024 at 02:09:19PM +0000, Sebastian Ene wrote:
> On Tue, Jul 16, 2024 at 10:59:41AM +0100, Vincent Donnefort wrote:
> > On Mon, Jul 01, 2024 at 02:18:39PM +0000, Sebastian Ene wrote:
> > > On Mon, Jul 01, 2024 at 09:42:43AM +0100, Vincent Donnefort wrote:
> > > > O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> > > > > Define a set of attributes used by the ptdump parser to display the
> > > > > properties of a guest memory region covered by a pagetable descriptor.
> > > > > Build a description of the pagetable levels and initialize the parser
> > > > > with this configuration.
> > > > > 
> > > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
> > > > >  1 file changed, 137 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > > > index 36dc7662729f..cc1d4fdddc6e 100644
> > > > > --- a/arch/arm64/kvm/ptdump.c
> > > > > +++ b/arch/arm64/kvm/ptdump.c
> > > > > @@ -14,6 +14,61 @@
> > > > >  #include <kvm_ptdump.h>
> > > > >  
> > > > >  
> > > > > +#define MARKERS_LEN		(2)
> > > > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > > > +
> > > > > +struct kvm_ptdump_guest_state {
> > > > > +	struct kvm		*kvm;
> > > > > +	struct pg_state		parser_state;
> > > > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > > > +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> > > > > +	struct ptdump_range	range[MARKERS_LEN];
> > > > > +};
> > > > > +
> > > > > +static const struct prot_bits stage2_pte_bits[] = {
> > > > > +	{
> > > > > +		.mask	= PTE_VALID,
> > > > > +		.val	= PTE_VALID,
> > > > > +		.set	= " ",
> > > > > +		.clear	= "F",
> > > > > +	}, {
> > > > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > > > +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > 
> > KVM_PTE_LEAF_ATTR_HI_S2_XN is actually a mask covering 
> 
> It is not a mask covering here but in the ACK kernel.

You're right, I should have double-checked upstream.

That said, how about we move this __after__ RW ? and just use "X" on .clear
so we can have something R W X ?

> 
> > 
> > KVM_PTE_LEAF_ATTR_HI_S2_XN_XN, KVM_PTE_LEAF_ATTR_HI_S2_XN_PXN and
> > KVM_PTE_LEAF_ATTR_HI_S2_XN_UXN. 
> > 
> > I believe here what we should do is something like?
> > 
> > .val = FIELD_PREP_CONST(KVM_PTE_LEAF_ATTR_HI_S2_XN,
> > 			KVM_PTE_LEAF_ATTR_HI_S2_XN_XN) | PTE_VALID
> > 
> > > > > +		.set	= "XN",
> > > > > +		.clear	= "  ",
> > > > > +	}, {
> > > > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > > +		.set	= "R",
> > > > > +		.clear	= " ",
> > > > > +	}, {
> > 
> > [...]
