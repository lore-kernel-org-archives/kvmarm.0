Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C096016130C
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719843479; cv=none; b=j0QO00RliiVIDq+qidSfOLwpsUjQX9BGvdTY2w+U4nNoJAasffHG5u39y38e+iXdMwz6toivzL+WQDMGv1EA6jBzlcFWK9aaHLHFsscJIkLBnmK0njNhOQfxvb8AvjSJUFK70s77HiCAewSvC0xllcN10R5Srsf/+c2wapkC/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719843479; c=relaxed/simple;
	bh=ByUipo6NI4twoXX3FJEhTf56pTaBT1SvmjQW1UTK5HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F85GFIOdgFrghNRfAa+Ht5Y12NWRWgZxujLwFKEh9wNKdAuv4E7mLtxhxhzOKVIqSn7+xLT189AdO73ieY9wK003Qub+Q5eeXAaxjNJml/B8RPIOkZTLDgYR+2BJnbDDNDXTfwjHtzSoBujHd/G0ldD9IiNvfyJ2daTPWkwoDec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BMj09iVp; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BMj09iVp"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4255f915611so89325e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Jul 2024 07:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719843475; x=1720448275; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WymdYrRd4sfynUljCpNE7J7SqQR5T/ssE9OoWrI41/0=;
        b=BMj09iVpyZNeT2FPiUNeNcHpjIGYTG4AOHhEyRnkJjlZcjxU/rht6ZgUwkubDaAR3y
         Gga0iRQhUiNKEhjjgROqk0N7A7pclnQBHldrUU2dWEuZOz91V1D7mnaewGUEa+hqp2/5
         ECBW6WRxI478ANA3nkipP7qd+8nSDTIKXJvdL+vsTumWqJpUIrxdMtNsC9jUVRgpPBht
         OueNFmVi3YsXjIr+eLeK8jlLHZ3RfheTxfV22eZf1zNlFBnM/wqmFYwLt/Rhu1R3utF8
         9QZ+ilTR/O5u5D48r2fAxRgrj/kU/2ECADEIN0EcHblmM7SQll5u+dLZze/64cqUdDj7
         U+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719843475; x=1720448275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WymdYrRd4sfynUljCpNE7J7SqQR5T/ssE9OoWrI41/0=;
        b=P1sQUsr2tV2oPlVGDHFbIGWC9JDOOlwqmOqDylls/35RTxGY37ocR9zsTFjfx91KZk
         9DXgEzYDrUCxlUGDGSTTxlsh7J4W3cmTwgYXsety/Ey+GEAmTe5pEYuM8DS2782RfINT
         Ns+Hxo+gD6CN0ay2kinFTqLRKVdwnpGzybn3IEGtsW1Q1rCvoUj8lBs3+dEvjEjFYSNl
         ZjdOroilaJJOjRT+l85LIHe4pffBfnPgkBXWdKEEboeLdRpBf7CMytS9bZWGk/c2bHNI
         PK1s/htaRBSLM5b3GUDbBDteEQfyXctLzCCx8BKaoop81YlkczeJUNXtLrrxGZKCWbK9
         GJ+g==
X-Forwarded-Encrypted: i=1; AJvYcCUH3qCRAuBPM0XAFfk16dIKYRlqPZrFRi26Gby6zvleiIjNgJedWXh0/lZkld5FNWRhyfySRCA11m7rn5asj2Ma5afq5kSu
X-Gm-Message-State: AOJu0YyjVHDkGPgND06D08ahQ7sz1tWGxuKPqUfZH7bVf4cL8157ovVH
	go+e7T3nDRIqn6AsXbOkUTapzA5LS5VfElR+7xARWvtQg7pMuXVNUIFJmjFQKw==
X-Google-Smtp-Source: AGHT+IGkFz0RMmxkJaef0KKHUfdBO3MeBkXE9GcdBHKQysEzkpnZ9bsPIAQbPAPkDVAaI+FNmhLSXg==
X-Received: by 2002:a05:600c:35c5:b0:424:8b0c:156a with SMTP id 5b1f17b1804b1-425777d21e6mr3582325e9.2.1719843474910;
        Mon, 01 Jul 2024 07:17:54 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42577a0c286sm75266945e9.0.2024.07.01.07.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:17:54 -0700 (PDT)
Date: Mon, 1 Jul 2024 14:17:53 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZoK6kW1FJiQ0ip0e@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <Zn8omLmCSIHun1uq@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zn8omLmCSIHun1uq@linux.dev>

On Fri, Jun 28, 2024 at 09:18:16PM +0000, Oliver Upton wrote:
> Hi Seb,
> 
> On Fri, Jun 21, 2024 at 12:32:29PM +0000, Sebastian Ene wrote:
> > Define a set of attributes used by the ptdump parser to display the
> > properties of a guest memory region covered by a pagetable descriptor.
> > Build a description of the pagetable levels and initialize the parser
> > with this configuration.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> 
> This patch should come *before* patch 4, no point in exposing the
> debugfs file if we aren't ready to handle it yet.
> 

Gotcha, let me try to reorder them.

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
> 
> <snip>
> 
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
> 
> </snip>
> 
> Neither of these bits are used at stage-2, why have descriptors for
> them?
> 

Atm, we don't make use of the contiguous bit in stage-2 in upstream (but
we have it in some experimental patches). I can remove this, no hard
feelings for them.

> > +static int kvm_ptdump_build_levels(struct pg_level *level, u32 start_lvl)
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
> 	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
> 		return -EINVAL;
> 

I will include this validation, thanks !

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
> > +		strscpy(level[start_lvl].name, level_names[0], sizeof(level_names[0]));
> 
> This should pass the size of @dst, not the source. This becomes slightly
> more self-documenting if you use a literal for "PGD" here too.
> 
> 		strscpy(level[start_lvl].name, "PGD", sizeof(level[start_lvl].name));
> 

Will use this, thanks for the suggestion !


> > +	return 0;
> > +}
> > +
> > +static struct kvm_ptdump_guest_state
> > +*kvm_ptdump_parser_init(struct kvm *kvm)
> > +{
> > +	struct kvm_ptdump_guest_state *st;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +	struct kvm_pgtable *pgtable = mmu->pgt;
> > +	int ret;
> > +
> > +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> > +	if (!st)
> > +		return NULL;
> > +
> > +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> > +	if (ret)
> > +		goto free_with_state;
> 
> I don't see any value in the use of goto here, as there isn't any sort
> of cascading initialization / cleanup. This also presents an opportunity
> to get an error back out to the caller.
> 
> 	if (ret) {
> 		kfree(st);
> 		return ERR_PTR(ret);
> 	}
> 

Let me remove that goto; statement.

> > @@ -57,22 +176,34 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> >  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> >  {
> >  	struct kvm *kvm = m->i_private;
> > +	struct kvm_ptdump_guest_state *st;
> >  	int ret;
> >  
> >  	if (!kvm_get_kvm_safe(kvm))
> >  		return -ENOENT;
> >  
> > -	ret = single_open(file, kvm_ptdump_guest_show, m->i_private);
> > -	if (ret < 0)
> > -		kvm_put_kvm(kvm);
> > +	st = kvm_ptdump_parser_init(kvm);
> > +	if (!st) {
> > +		ret = -ENOMEM;
> > +		goto free_with_kvm_ref;
> > +	}
> 
> (with the earlier suggestion)
> 
> 	st = kvm_ptdump_parser_init(kvm);
> 	if (IS_ERR(st)) {
> 		ret = PTR_ERR(st);
> 		goto free_with_kvm_ref;
> 	}
> 
> Otherwise genuine KVM bugs (-EINVAL) are getting lumped into ENOMEM.
> 
> -- 
> Thanks,
> Oliver

Thanks,
Sebastian

