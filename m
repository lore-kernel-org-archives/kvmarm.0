Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2B48124E
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 12:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784120132; cv=none; b=DX4H4U16Um7UNK/CnHUmWz4vpdr/uGqPa0VyXbImBhVQQzhj4Rf+Kv1Wl353tEetNpcXXvE9RVIgjqmUb3cs1ixpkEDKje2zb+1T1MYYHTs2UPp2RQbkJqrxuGlskIgUACbBTXKH4Rw6O48VsC3yuwud2Ypxa3zeLjdnCY1Vzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784120132; c=relaxed/simple;
	bh=SSZdoUwSB6ScZO9efgT73NU/st+wovAAct7MS20ttBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLh8hSP7PyCIbf9AE6CCBMuKddFu3t0OM/csNhO3LfV1lY1ggVzEeXwThe2aqCS1R8fOlKSJnwaZyVxukpHV8MLCopxnRv5i2Bf1ZE/pPCg18RWmu5jaRCaDKEJv6QKqc4Dwq6PW2B12nP+bvtV7yoNwTrJMFjDbdlHcKWLN+ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/hDi9dd; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/hDi9dd"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c52cde9eso46515355e9.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 05:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784120127; x=1784724927; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R0eO5p/+72zQTpxbfV2SGsUBVNXRFtxhqKdi0S5oNCk=;
        b=B/hDi9ddsJ3wTQz+fCgqiOj0yVgA/hycLEgdiXnXgr6x4Qkk5zclCtxXGh8YkkYfiP
         QJpwBv7mcQGFyYMHPXuH8jWlT/cyZQG328o0s5feNTMO8yqwomxi7nALLHHtmbRukBDA
         fcHqeeGUG/WF7ixrnE58RekeWlbORacNVXLOl026cL7JW99fQlkEvjymDYT3iphwhDqW
         8/oaiFKw0KUQ2Bk1fkH78W+E+4Tjn2uhbxtVslhzkCah1NSVfwfTbUEQFZQdy2q+j27Y
         jYenu2NK+KilqqHEJTu/cXb+ZUDzOvloFxfJWhkaBeL+FoBAJv9fdkM1EXYE/GbsxAdx
         Z2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784120127; x=1784724927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R0eO5p/+72zQTpxbfV2SGsUBVNXRFtxhqKdi0S5oNCk=;
        b=Y7u5yG7v7YGrwwbXjUuOrVP/HBe4O3GBd1sMD7GdbjVI9QI2e3bK0HhQ8RddRxEnel
         l7izpMlyIOz8ZUqe6I4xbnF5srDm6kAXYWluKyvjf6biyLKbz9PzryDXDR2v5eFND7tD
         lVyjuV920daKtIxlKS98Tggg4GElsjpiEjGJpd7PxxK7AohxzkjLIB3SR1qXI0QAqoUP
         2idz/cxmEmaKjVuZ9ZjdcYW15yQn/POYja8DzQoCDWgD3GJDkhrakqM8rmefOCO7ujSj
         YGCbh6zRJB0YY6b760K9+5k0xFCngitd+Ka0PLrdw1BfXl/1RmR/kFVKbUqgwnACE5fZ
         29LA==
X-Forwarded-Encrypted: i=1; AHgh+RrD7p5TcUo62q/Td8SNLLKXLsKW4oRvLkEKHFe2ILcrTOxY7diK9ffkxsuREoOFikxvME2JvUs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyB66ey4iM8EcGwBfaZ2iMm1GUma7edTsVu9/Z7PDPEOzX6w7s8
	hELr/1w3eofiSo/7YVtfy7iLqke1e+ELh4owtFE1bCA+xOm1w98RBuN0U0IvL4z3yw==
X-Gm-Gg: AfdE7cmVQT+hB9DSiLHdFkjd78eJ3VsSFyoji3oUiwKkfrtglWUzNYFo9imDpmX6juN
	8Q0prApMRHBmrY+S6F2JGjMEJEZQdDCuos15vcAgvMjk5SoPcppNmipuQ99sfY1Emi/b1Q2N0tj
	ii8tQ27JbjXZXC8BB3Y8GL6GK5qEsdCMnZN6YuQkg7247df14SHcHUr8Bk1j9CXJSOPxFZ8YMpD
	Bkf7NW6imRSvk2HBB7lFIIUOQdsDqvGzb/2n84+7yiW1O8ASSHgbEVMaHnvbB+PyZYp/aO4CyFT
	l4N2+iPJpbTi5W1SSK613gD2ej8J1b/8nZkUVdkZzCWRZ8dofBTux1tzCMhiHrqhmwYju+IbVwF
	Bx6BaunOjqP3Ithv6ciBZne1yNU6AlsLjzDpgj6Nw6oGrD/G+zdV4llvJEXe0AwXSVZ4qlZtunr
	IlA0Lxbpb+Q9uPs1W5URKE8TcpAglJH2AYEcNAmSSBObs5Lq8gqKg=
X-Received: by 2002:a05:600c:524c:b0:494:df:8895 with SMTP id 5b1f17b1804b1-49538a0251emr73180985e9.24.1784120127010;
        Wed, 15 Jul 2026 05:55:27 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a9879sm17168794f8f.22.2026.07.15.05.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:55:26 -0700 (PDT)
Date: Wed, 15 Jul 2026 13:55:23 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 15/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Message-ID: <aleDOyiP5E8TcoZg@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-16-vdonnefort@google.com>
 <CA+EHjTzNMCMAt=VDnCuR2+Pfz9Qh5HmbEm6tdjpdcPBO+UchEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzNMCMAt=VDnCuR2+Pfz9Qh5HmbEm6tdjpdcPBO+UchEg@mail.gmail.com>

On Wed, Jul 15, 2026 at 01:33:00PM +0100, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 18:54, 'Vincent Donnefort' via kernel-team
> <kernel-team@android.com> wrote:
> 
> ...
> 
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -191,8 +191,8 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
> >   */
> >  static int __pkvm_create_hyp_vm(struct kvm *kvm)
> >  {
> > -       size_t pgd_sz, hyp_vm_sz;
> > -       void *pgd, *hyp_vm;
> > +       size_t pgd_sz;
> > +       void *pgd;
> >         int ret;
> >
> >         if (kvm->created_vcpus < 1)
> > @@ -209,28 +209,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
> >         if (!pgd)
> >                 return -ENOMEM;
> >
> > -       /* Allocate memory to donate to hyp for vm and vcpu pointers. */
> > -       hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
> > -                                       size_mul(sizeof(void *),
> > -                                                kvm->created_vcpus)));
> > -       hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
> > -       if (!hyp_vm) {
> > -               ret = -ENOMEM;
> > -               goto free_pgd;
> > -       }
> > -
> > -       /* Donate the VM memory to hyp and let hyp initialize it. */
> > -       ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
> > +       ret = pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);
> 
> Sashiko might be right on the memcg point: hyp_vm used to be
> GFP_KERNEL_ACCOUNT and now comes from the heap unaccounted, while pgd
> next to it is still accounted, so it's inconsistent.

Yep that is correct but there is no way around that:

 * Donated memory can now be shared be shared by several VM (or other parts of
   the hypervisor)

 * Donated memory is also not reclaimed until the shrinker fires.

So we don't really have a way to account for that meta-data anymore.

(I should at least mention this in the commit message)

> 
> If we do want to fix it, would it go in pkvm_hyp_topup() to cover all
> consumers rather than here?
> 
> Cheers,
> /fuad
