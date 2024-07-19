Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4442AF12
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721406451; cv=none; b=lxEdcc82K7060chLiu2lDi2YCuvP17cVn4Mvp2EZjqTCPMP4uqvIDjkjyMYgN1bC077tLGVXjht5agHsFnPSLw58u6Na4wrY93wy4eYQmMibw9doCF+KPQSALeZ/2WUmdVuAB+ODJVlLLUeM8QtqMOT4TawrjVXkeka549I5mh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721406451; c=relaxed/simple;
	bh=1dmbpNdF8tQ+ese8igkpCby0IKOV/lsKj0bq8yiRx3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLSrlcIJOb+ythyVyrf9K9fNIUhQu7ITPbXNVG43u9H1et2pDzrdhcg5BWxbJc570TQ1vICmYTNnjm5INO2Hjn2CxO9TUpkPke+suv296OXFwhgnbkJ8ehmZbf/ggZBLT/Rdf9TDCsW3dUaSkVjdwsHl0xWcpoJ77ybQjn4WoKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZS46L56h; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZS46L56h"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5a18a5dbb23so15198a12.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 09:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721406448; x=1722011248; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGU8cW7/Khkrbfb/2lGIxZ/ZxfwEJyBEaz42JmsrIJk=;
        b=ZS46L56hUYFOAVoa02M/idw0UJAvsGBnBMtYFxibPwKsv6SVAGpGHCc9seKp0nYJJ6
         aAXC2YZ7WLR03PaWTkHcMiVpF3tyXeHImaoPOrrD5i572sBl1yhdZdvAJ7XrFhYIPny7
         /ji597iMK8VTABDnQUPj84IBOQuRWYZ4strWYOVyKjQ7V7op2BQ/QYBhSAB7GH/0RU9Z
         s4fz0qZK6Xxm9fWZVyKkzK4+oOw/BYwzFhnCPbIZ4CXXObz3MkI7cTwXuRbctHUHW+az
         X0UD2THQjbeUwizp6X5V75guGcXO83N8sCGTOK8RzLYCfBdaYSqLqTD9KfJ9/ezBbpID
         LP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721406448; x=1722011248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGU8cW7/Khkrbfb/2lGIxZ/ZxfwEJyBEaz42JmsrIJk=;
        b=FVB2GnjsRO2ecEiEH2xJ32N0VawvVfL0NzHszusIuOTwTzjaARMcXxcQHY8ha+5yI1
         ud6TYe+k0VDorjtOwbUoaRtGElXwPvFbuyF99oROPoY9baMm0S2CH3wRne0ROLyY14Ah
         jPb9gTbArJbjVIAGk/za1NJPQbCO2LMINtF9NTCIpnYDeYhZuZsWjrez/oM8jYwhS3Jq
         gd/izGbyql0ODTEYrlYix1VFX4ncsesuhLZ/zbQcwEVSMmiL1RsJSoFwjQ58ljQlyVeJ
         /ANTjxGENWADZDUBbUwRhqdwkXGhXOVGE0VRKOpFsIQpOrkklOucdkVoe4JYf8ikJYx7
         s14Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbLxeJiGFem5FV78/D6FV3/BKcVmM7TsuB8WMGOAnhkAoS6CRKuAMvLxAJJvcrRZXVyVdnkXxeGGHpsyoFQrrYigIc4r3d
X-Gm-Message-State: AOJu0YwBV1pWbYIyjPT/1fPgWkm16bd7kRMpuxBcR0k2vDt38TDMfJzE
	Cj3J9sVWpvPq9LHxuooEqZQFelDLwNKHSs9tjx2mzqS9ygbab1ZsCSJM2MU3fA==
X-Google-Smtp-Source: AGHT+IF72w7nkWrKqo33SiqqgvDUo7jNwSKOMGsRU7zBoVw32YikfiO+r/b2VLJAOhl5RiyEVCCe1A==
X-Received: by 2002:a05:6402:5204:b0:5a0:d4ce:59a6 with SMTP id 4fb4d7f45d1cf-5a2c888c3d0mr284589a12.2.1721406447882;
        Fri, 19 Jul 2024 09:27:27 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com. [34.77.222.49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3687868bc21sm2007071f8f.39.2024.07.19.09.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:27:27 -0700 (PDT)
Date: Fri, 19 Jul 2024 16:27:26 +0000
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
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZpqT7raWOhb3xQ12@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <ZoJsAyrmtge4mXJY@google.com>
 <ZoK6v2_pJnc57LHM@google.com>
 <ZpZEjW1m2LypTHjF@google.com>
 <Zppzj1oIDivlAFpP@google.com>
 <Zpp51BYWYFnZHVW1@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zpp51BYWYFnZHVW1@google.com>

On Fri, Jul 19, 2024 at 03:36:04PM +0100, 'Vincent Donnefort' via kernel-team wrote:
> On Fri, Jul 19, 2024 at 02:09:19PM +0000, Sebastian Ene wrote:
> > On Tue, Jul 16, 2024 at 10:59:41AM +0100, Vincent Donnefort wrote:
> > > On Mon, Jul 01, 2024 at 02:18:39PM +0000, Sebastian Ene wrote:
> > > > On Mon, Jul 01, 2024 at 09:42:43AM +0100, Vincent Donnefort wrote:
> > > > > O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> > > > > > Define a set of attributes used by the ptdump parser to display the
> > > > > > properties of a guest memory region covered by a pagetable descriptor.
> > > > > > Build a description of the pagetable levels and initialize the parser
> > > > > > with this configuration.
> > > > > > 
> > > > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
> > > > > >  1 file changed, 137 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > > > > index 36dc7662729f..cc1d4fdddc6e 100644
> > > > > > --- a/arch/arm64/kvm/ptdump.c
> > > > > > +++ b/arch/arm64/kvm/ptdump.c
> > > > > > @@ -14,6 +14,61 @@
> > > > > >  #include <kvm_ptdump.h>
> > > > > >  
> > > > > >  
> > > > > > +#define MARKERS_LEN		(2)
> > > > > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > > > > +
> > > > > > +struct kvm_ptdump_guest_state {
> > > > > > +	struct kvm		*kvm;
> > > > > > +	struct pg_state		parser_state;
> > > > > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > > > > +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> > > > > > +	struct ptdump_range	range[MARKERS_LEN];
> > > > > > +};
> > > > > > +
> > > > > > +static const struct prot_bits stage2_pte_bits[] = {
> > > > > > +	{
> > > > > > +		.mask	= PTE_VALID,
> > > > > > +		.val	= PTE_VALID,
> > > > > > +		.set	= " ",
> > > > > > +		.clear	= "F",
> > > > > > +	}, {
> > > > > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > > > > +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > 
> > > KVM_PTE_LEAF_ATTR_HI_S2_XN is actually a mask covering 
> > 
> > It is not a mask covering here but in the ACK kernel.
> 
> You're right, I should have double-checked upstream.
> 
> That said, how about we move this __after__ RW ? and just use "X" on .clear
> so we can have something R W X ?
> 

Yes that's a good ideea to improve output format, let me move it.

> > 
> > > 
> > > KVM_PTE_LEAF_ATTR_HI_S2_XN_XN, KVM_PTE_LEAF_ATTR_HI_S2_XN_PXN and
> > > KVM_PTE_LEAF_ATTR_HI_S2_XN_UXN. 
> > > 
> > > I believe here what we should do is something like?
> > > 
> > > .val = FIELD_PREP_CONST(KVM_PTE_LEAF_ATTR_HI_S2_XN,
> > > 			KVM_PTE_LEAF_ATTR_HI_S2_XN_XN) | PTE_VALID
> > > 
> > > > > > +		.set	= "XN",
> > > > > > +		.clear	= "  ",
> > > > > > +	}, {
> > > > > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > > > +		.set	= "R",
> > > > > > +		.clear	= " ",
> > > > > > +	}, {
> > > 
> > > [...]
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
