Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B882AE6A
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 09:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721123989; cv=none; b=Fp8HyemT6LKR5PmqS6ltfB3tP5TQqBX8MGI22/pJ3KgCdG8/L+/hXhkRfIDGdfS+4TgzN6CY+f0jVXplFe4mjxnzFEZdO6S7OPCMGXYA0W3pjNcqXO1dFrmptxof0fMBIjKv8ZgRX5dbbCZibxEJWQdmWgwB7kquI8HdfHOpFrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721123989; c=relaxed/simple;
	bh=t8aLSjzjauG7Ud/wMgIkxjFDcS/pCbqDGOTsvtDGzbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPbYzuspNgxAhoo5T6EnZU+tNjpOzF+G+czZA+A9/BdRKHVBBTtixLX2xSJiGi0hyq3e3BVk5h/3yQcJGubzPDx+Evmu/9WokQSGUKGSMHte0EXbKhTfQ74WyLnruwsf0xDG6aG/rnkMU5XLE4LlGdQ48r95uCk9oVAHu8UeLkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kur4lAc/; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kur4lAc/"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-368255de9ebso338701f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 02:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721123986; x=1721728786; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UB06lOjeb/uE3iisxwCP6Tm1CK/MivC/LclbamO9xAM=;
        b=Kur4lAc/kd2GxeTRAM4R6TXv8E4eTDB3E3NNhC0BobfDJlhxPG+FP7qVIQf9lPZmPN
         YXa2xraq2Sr2Jv6X51ZsvtPrpG3I2pGuGWPsrQyK2FKnrveJcmDLavG74d9jFaWNp4xc
         mt3TGn8sXUgjrFkIyIYSTHvw+Jz3i3jR6pqdqg5hPSMK5s7X+BzQ6OkdR9K60N6qqSBM
         JhyNAGKOe77op7oS6a1fxLnLofVRpEFbLFAiRnmWeLtixWgyWPgrXd9PdkmsD4fOb5Os
         SyGWmkIB1moWBrbkMBYUPR96ObOdizTKc8h2fnfGjlUZhb+RNDqQz8NJO29QCBqAGZcn
         UWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721123986; x=1721728786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UB06lOjeb/uE3iisxwCP6Tm1CK/MivC/LclbamO9xAM=;
        b=KE3Hm/gwPHEDP6WSmtcII66pTfdnGIRxzu5BwM13YmoMlFcVXEjGP4L2JGRDBW50TG
         DQueaRnSnSdyQLObakO6qcTqQlvKs1Xn80NB2990uSVrdBHRXWJGuCykZYfJ5AnGsOsq
         j+W4+whbZ72uFZ0se2aNdtCucFoT3L3NVuaYoW1KNnWVskZYQW+wcQ/FmTiBBY5jrQ5h
         Pv/TI06fxLt/v6i8i5XJ3klqHeUGZK7zTH1FkyTOj7qmxkPPRfYPsXgmLTRgsd34Mhch
         t3aQEe89BrubpXJvbDbBUNXQvSwp8gEmXIp4EPfGDMLRmlK0OC6Rww8iZNTGmm4okmuz
         hbHg==
X-Forwarded-Encrypted: i=1; AJvYcCXmiquly046JI2S+2J7+boHanfu2TbZmNnAeBM3TjWtYenk30DgiMhkeavv33wUQW7KuEFMxHS5xvC+BPDDoaRtm56/se7T
X-Gm-Message-State: AOJu0YxiIo4T3NIgkSyaQdP9499b340iOfID0JqegtVo1ycAktdD7uqQ
	XkL4ul9pxdD0JLjDaiZHkVVfiVIqqzPMABTkmyfwEddALUTlR70hQRwdRfpklg==
X-Google-Smtp-Source: AGHT+IF69v24Yzf9m7VOZnyEAWiFMAW/hbg7ZrSdOQ+vI1WyHZxOGGlPFzoPDdIVKnZQD4NsWWgIYA==
X-Received: by 2002:a05:6000:1e4e:b0:362:69b3:8e4d with SMTP id ffacd0b85a97d-36827498d65mr1116597f8f.25.1721123985921;
        Tue, 16 Jul 2024 02:59:45 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafbe9esm8515847f8f.78.2024.07.16.02.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 02:59:45 -0700 (PDT)
Date: Tue, 16 Jul 2024 10:59:41 +0100
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
Message-ID: <ZpZEjW1m2LypTHjF@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <ZoJsAyrmtge4mXJY@google.com>
 <ZoK6v2_pJnc57LHM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoK6v2_pJnc57LHM@google.com>

On Mon, Jul 01, 2024 at 02:18:39PM +0000, Sebastian Ene wrote:
> On Mon, Jul 01, 2024 at 09:42:43AM +0100, Vincent Donnefort wrote:
> > O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> > > Define a set of attributes used by the ptdump parser to display the
> > > properties of a guest memory region covered by a pagetable descriptor.
> > > Build a description of the pagetable levels and initialize the parser
> > > with this configuration.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 137 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > index 36dc7662729f..cc1d4fdddc6e 100644
> > > --- a/arch/arm64/kvm/ptdump.c
> > > +++ b/arch/arm64/kvm/ptdump.c
> > > @@ -14,6 +14,61 @@
> > >  #include <kvm_ptdump.h>
> > >  
> > >  
> > > +#define MARKERS_LEN		(2)
> > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > +
> > > +struct kvm_ptdump_guest_state {
> > > +	struct kvm		*kvm;
> > > +	struct pg_state		parser_state;
> > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> > > +	struct ptdump_range	range[MARKERS_LEN];
> > > +};
> > > +
> > > +static const struct prot_bits stage2_pte_bits[] = {
> > > +	{
> > > +		.mask	= PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= " ",
> > > +		.clear	= "F",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,

KVM_PTE_LEAF_ATTR_HI_S2_XN is actually a mask covering 

KVM_PTE_LEAF_ATTR_HI_S2_XN_XN, KVM_PTE_LEAF_ATTR_HI_S2_XN_PXN and
KVM_PTE_LEAF_ATTR_HI_S2_XN_UXN. 

I believe here what we should do is something like?

.val = FIELD_PREP_CONST(KVM_PTE_LEAF_ATTR_HI_S2_XN,
			KVM_PTE_LEAF_ATTR_HI_S2_XN_XN) | PTE_VALID

> > > +		.set	= "XN",
> > > +		.clear	= "  ",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.set	= "R",
> > > +		.clear	= " ",
> > > +	}, {

[...]
