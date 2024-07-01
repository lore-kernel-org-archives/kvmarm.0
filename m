Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE71C161307
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719843524; cv=none; b=CjAuuc9Gyd6s+4O2jJWGwaZffxkQI81uxJZtfDD7PDq3DtNsfQYmNA20MMOmFBTdr2VJaguaMueSAKpdxeICz9lSI/dx4ZGavJWCmBacfcHEKvth0Vlo7HIyKMTOP16kwn8Oz0axRNlOGvmWXQkJBogXy9pu/J6O9sSwtdEaHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719843524; c=relaxed/simple;
	bh=ylIjIytNCS6g+buHRSvJY443NgCMp6CLLYYSc8yrqsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vyq/sWTkxE3lJFkxIkAoeL688zAdt6bgpMpKTKkZk6TgP8a2y9eY5rIZ8nrSd6oDg+bXvtsyMDdj/nOcWWL2QFoRmbDYDd2wCk2BEs/uBH8rRfAkS733Y7CKCUpatZzzpYpV7VZ2qZoPfTqFtT425ppFGUvpNmF2BuBLb5vK0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dmoiQiKL; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dmoiQiKL"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-424a3cb87f1so88165e9.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Jul 2024 07:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719843521; x=1720448321; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4iRQeefAgXsUamr4Ot8CeDDrfz8J0bienc8DMyyz7CU=;
        b=dmoiQiKLpNw0g6D/csGAiQbT7tgxqa7bCl0YzdbN+1cn4uHndVWvbpfSd0WF3hX1IV
         FgpJNt6n7MCGw1pOPoQm0wzJXOufV5aTfWzLsz7UYVA7MUBgU1HRY3qMqeFs75OG2Z/u
         qslFHemOhR9ZkOjAKkj/7SqrZmyPis+0eouU0utGmRC66KXnt+cqk2BZ0297qCcCT7E4
         agGhsjGmVY/s/y5gegOegFcUiCSVGMaMHhQIDQaRkgkiBCPIJuNpx0MMMUGYSTCcsYxf
         7DzYAVk8ZW1sr6oxP/xyPcJB6HcU/H7hO8JzUJu/vwwFppGEyPqBQpjMuR+ijwaWUOka
         /aAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719843521; x=1720448321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iRQeefAgXsUamr4Ot8CeDDrfz8J0bienc8DMyyz7CU=;
        b=LIuWTk1i5GpePERjnxjaCDcSU8aZCCcLzTwSGDduyrxoWuKdzKi7WkbJDX9ikata+v
         w/egDbMR5D3nli/UUKCXJr6Xc9uvr16xeCrg/sR1vpdWqQ2Zr1uzcr/p5JTyersNDWL+
         61H0Yml6SwrVaFzzy8IVAFGsNerT4xtf1f4Pe0vY37p4/vciBVhSPC6wt2Nt2BRgSe3n
         fbiTWejXafFHY4Vv5f3wU30wE9jIfOc1kN7PVf6dq5CFoBbfv6OwyHk2UGe9ZgoF7Nco
         gzdovi+LtS2CEbgf3ja5Hgge4iV7WRIsGY9zU/ABth5VSxpjaidgl+2PV5o9fvsYRdRz
         C5lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ+Dk5ZK0niQrYOy1KAI4HGsvOFdo7Y+n5/KK1SjI5ME/PzcuDlMJvr+UsTS16smIBtFo1zl5wsFmDm86i/svl19dwNrkZ
X-Gm-Message-State: AOJu0YzOCZvePW2qru4G8kBkccmEOWWw2GEJ/y69dQocb5AQQCjdPiv4
	in/yxh/p6Q16jffScDuwVBUJfDzHI1yHI6rV3mnDndRPeq7aq12DqY38Bgu1Mw==
X-Google-Smtp-Source: AGHT+IEJSpUxXnzmaKpeXZ9ZNc9ay9XiJ8uD9AmMNUm7TYpCOsXMWXwD4qP0QOho6uCBNDDg/b3sMA==
X-Received: by 2002:a05:600c:35c5:b0:424:8b0c:156a with SMTP id 5b1f17b1804b1-425777d21e6mr3583315e9.2.1719843521026;
        Mon, 01 Jul 2024 07:18:41 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af54ecasm154237255e9.12.2024.07.01.07.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:18:40 -0700 (PDT)
Date: Mon, 1 Jul 2024 14:18:39 +0000
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
Message-ID: <ZoK6v2_pJnc57LHM@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <ZoJsAyrmtge4mXJY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoJsAyrmtge4mXJY@google.com>

On Mon, Jul 01, 2024 at 09:42:43AM +0100, Vincent Donnefort wrote:
> O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> > Define a set of attributes used by the ptdump parser to display the
> > properties of a guest memory region covered by a pagetable descriptor.
> > Build a description of the pagetable levels and initialize the parser
> > with this configuration.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 137 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index 36dc7662729f..cc1d4fdddc6e 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -14,6 +14,61 @@
> >  #include <kvm_ptdump.h>
> >  
> >  
> > +#define MARKERS_LEN		(2)
> > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > +
> > +struct kvm_ptdump_guest_state {
> > +	struct kvm		*kvm;
> > +	struct pg_state		parser_state;
> > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> > +	struct ptdump_range	range[MARKERS_LEN];
> > +};
> > +
> > +static const struct prot_bits stage2_pte_bits[] = {
> > +	{
> > +		.mask	= PTE_VALID,
> > +		.val	= PTE_VALID,
> > +		.set	= " ",
> > +		.clear	= "F",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > +		.set	= "XN",
> > +		.clear	= "  ",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > +		.set	= "R",
> > +		.clear	= " ",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > +		.set	= "W",
> > +		.clear	= " ",
> > +	}, {
> > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > +		.set	= "AF",
> > +		.clear	= "  ",
> > +	}, {
> > +		.mask	= PTE_NG,
> > +		.val	= PTE_NG,
> > +		.set	= "FnXS",
> > +		.clear	= "  ",
> > +	}, {
> > +		.mask	= PTE_CONT | PTE_VALID,
> > +		.val	= PTE_CONT | PTE_VALID,
> > +		.set	= "CON",
> > +		.clear	= "   ",
> > +	}, {
> > +		.mask	= PTE_TABLE_BIT,
> >
> > +		.val	= PTE_TABLE_BIT,
> > +		.set	= "   ",
> > +		.clear	= "BLK",
> > +	},

Hello Vincent,

> 
> When doing a kvm_pgtable_stage2_set_owner(), the walker will init a leaf which
> has both the table-bit and the valid-bit unset. I believe this would lead to
> spurious BLK annotations here.
> 
> The following should fix this problem:
> 
>   .mask		= PTE_TABLE_BIT | PTE_VALID,
>   .val		= PTE_VALID,
>   .set		= "BLK",
>   .clear	= "   ",
> 

Let me try this, thanks for the suggestion !

> > +};
> > +
> >  static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> >  			      enum kvm_pgtable_walk_flags visit)
> >  {
> > @@ -40,15 +95,79 @@ static int kvm_ptdump_show_common(struct seq_file *m,
> >  	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
> >  }
> >
> 
> [...]

Seb
