Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB51448EE
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721398164; cv=none; b=lrtzk8ihQA20IKP95Ko/kqMgKW4cPfQVOlfLweACM5BKVdWEA0yctQVy0nQEGEtJt42TgyTax4Mh/DQ01XrnDYfxnjnIG0cyvOcETrrU5vgtR236/hWAVcARLSbgIINVEl7BWClSCsXS2l5l0pf0w1kkkUjZI0OkEpS6phts7jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721398164; c=relaxed/simple;
	bh=yrT+Bc+klEJuHiw98KfpGH71hLcGRLqA81h5h2dy/zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlVZLG2uCxBZYQGuUEv33MA+akY+q9LYHVzNZ92MCAtLWr7aae/HcmsBW81z5A6A4AZ0Dd+M1iEAjaryzt0YuV2jG0XNB2r2yqGJVuXxuRTEsJO+a3tcOi4osf3whWRfLpxvaXtJDJPV8Tb65jKMVK9rus2AMRdroNYlJGz2GEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CMPyBBk6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CMPyBBk6"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a1b073d7cdso16220a12.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 07:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721398161; x=1722002961; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPrxOA5Jo5X8ogv77DWTSjqpheBlFxY6lo9/95nhICY=;
        b=CMPyBBk6YsRGM+4iwCSGMkVbYzERFmrI58zwZ7C//jgty0Sfxk6zO8N0EIvcgyKryW
         Pzn9IigmCC3KsgvWJckBHMxEi9JP2YWI3AF4dQ+bKngobbneoGROEcfPycxx4vwOyz/d
         66jyQmB+R34mIUnPpu/TM8NzXUttoMN4jhCOH+qe6devlgy8mvKu6lPJdCSGRGoacVr9
         URfZKi9+kColeoDWcqBrBTj7+s7cTX5Xz4eLCOV2UIGcJZ1Q3eXyB4pXK6x5mE9gli2H
         pCzUoUu4t0sgNhkURhXwt86kY3+cpx+u+Ym/O6FajRAio64MuiMNRyRmgf/JzP7jgara
         7yyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721398161; x=1722002961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPrxOA5Jo5X8ogv77DWTSjqpheBlFxY6lo9/95nhICY=;
        b=jutr3T3DMvyhbQNBBey1vJhWtzINMOyvQ5HuAox8bjOpYTd3OnRLxKj3VkMzF/0eVs
         vs5wBmFSb14IV2jBRgwL+sAYK5P/wbbcmJ5IWJcwD756LK2VKhzG/zfxh0H9YaUJLUCv
         GM8h6KjE2z2XxFkQl1x7eEd5JrUlEtiGSHpo9vk/l7yQbcTPdk3IasuLIev0erPZmtFI
         HMHE4tigZYfncY5CgQeTPTAFtAdJtoQ60T8IXHmZ/VkoNp73R4SzM6ZXFZK0U5QGUXJA
         VmJOAICfSN3thJmkyPnZWwVypSPYJHfRFJf9+F1DS46jkvRNdNcoXaIxlfIjUkFBdaMr
         07QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrwYrvL4qcFficm8dw6OyoI+sE/J+zmAPVUkehlx8zEoLQ9xP0wjjO6NJp1AxzfdHsWRw4RhQh1pBrkUlo5t19GkdoURXQ
X-Gm-Message-State: AOJu0YxEvnFn37VeW6p3VwxLt7gu9tHbbWDBT2/MVjhBHra/YxZdjLqV
	3eHPrjJsJ7lZ2C9bProaxRextuvXjx+L8fMYhEhpYfBMqmomS+LZgR/G7VxcRg==
X-Google-Smtp-Source: AGHT+IGnXJyyFRlm/DzULfk3KGAkpy7LZO4NL6G+C38+3NI6Cxge1cG7pYzTXj+BCtoveuiX65kSqw==
X-Received: by 2002:a05:6402:50c9:b0:57c:c5e2:2c37 with SMTP id 4fb4d7f45d1cf-5a2f262b220mr155977a12.3.1721398160978;
        Fri, 19 Jul 2024 07:09:20 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com. [34.77.222.49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368786848f9sm1722929f8f.1.2024.07.19.07.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 07:09:20 -0700 (PDT)
Date: Fri, 19 Jul 2024 14:09:19 +0000
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
Message-ID: <Zppzj1oIDivlAFpP@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <ZoJsAyrmtge4mXJY@google.com>
 <ZoK6v2_pJnc57LHM@google.com>
 <ZpZEjW1m2LypTHjF@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpZEjW1m2LypTHjF@google.com>

On Tue, Jul 16, 2024 at 10:59:41AM +0100, Vincent Donnefort wrote:
> On Mon, Jul 01, 2024 at 02:18:39PM +0000, Sebastian Ene wrote:
> > On Mon, Jul 01, 2024 at 09:42:43AM +0100, Vincent Donnefort wrote:
> > > O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> > > > Define a set of attributes used by the ptdump parser to display the
> > > > properties of a guest memory region covered by a pagetable descriptor.
> > > > Build a description of the pagetable levels and initialize the parser
> > > > with this configuration.
> > > > 
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 137 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > > index 36dc7662729f..cc1d4fdddc6e 100644
> > > > --- a/arch/arm64/kvm/ptdump.c
> > > > +++ b/arch/arm64/kvm/ptdump.c
> > > > @@ -14,6 +14,61 @@
> > > >  #include <kvm_ptdump.h>
> > > >  
> > > >  
> > > > +#define MARKERS_LEN		(2)
> > > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > > +
> > > > +struct kvm_ptdump_guest_state {
> > > > +	struct kvm		*kvm;
> > > > +	struct pg_state		parser_state;
> > > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > > +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> > > > +	struct ptdump_range	range[MARKERS_LEN];
> > > > +};
> > > > +
> > > > +static const struct prot_bits stage2_pte_bits[] = {
> > > > +	{
> > > > +		.mask	= PTE_VALID,
> > > > +		.val	= PTE_VALID,
> > > > +		.set	= " ",
> > > > +		.clear	= "F",
> > > > +	}, {
> > > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > > +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> 
> KVM_PTE_LEAF_ATTR_HI_S2_XN is actually a mask covering 

It is not a mask covering here but in the ACK kernel.

> 
> KVM_PTE_LEAF_ATTR_HI_S2_XN_XN, KVM_PTE_LEAF_ATTR_HI_S2_XN_PXN and
> KVM_PTE_LEAF_ATTR_HI_S2_XN_UXN. 
> 
> I believe here what we should do is something like?
> 
> .val = FIELD_PREP_CONST(KVM_PTE_LEAF_ATTR_HI_S2_XN,
> 			KVM_PTE_LEAF_ATTR_HI_S2_XN_XN) | PTE_VALID
> 
> > > > +		.set	= "XN",
> > > > +		.clear	= "  ",
> > > > +	}, {
> > > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > > +		.set	= "R",
> > > > +		.clear	= " ",
> > > > +	}, {
> 
> [...]
