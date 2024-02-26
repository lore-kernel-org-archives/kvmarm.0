Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05BC6A01D
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937934; cv=none; b=ZN/3yvy9YNLh4aHXaFLJPVWbAVlWUl7RK2YObJL2k/6EmDAT5btKUoTQ1rQOVX137oZgmghoa2N1ZwCBZ3FbFiLDaT6ZhCly5fNP7JToTMTQqfoNhLTqCsPn9fbLJwJu09DcyG7oXcFjcVdNjWy3Fipmi0kCSMlUmTcKvmW044k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937934; c=relaxed/simple;
	bh=oRe0qnXLfntPxezGQlL0FgbrraxE9KD4t753iLi4vJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCdo3tbeDSXv8O9wRa7hDcgnk9Js0VsAOnRWZqkOPnTsKBqlBJaOaP9pdXI76YIzQad/HwA8w2xDmT25m3y86BBMkQ2oYHbH6unjFDmYQIGPY92ICOPYfM4Jm2+V4oE1IFKccrNuMtgM8mEkH9Nyx4UGV1e5Xz6BqR66oZtk7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nWLeduTQ; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nWLeduTQ"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-471e395f6baso101086137.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 00:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708937931; x=1709542731; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9U5JeY4K4lhWUcooGtJNIKDdAgad5+rJlROqa9Ssovo=;
        b=nWLeduTQ6db8lVQfmT2s6n8Ewh7pcTsFZtdLW8MYGikVc5luDBahFYW0cuh6GYRMAa
         AEXwfZ/kbBnLqME9W7QgnHVBAspGEx8ne8tlyWYZGF61L/KUPNRQaIhHQsKkAXLmIog/
         h2OnvV40mr+magpiQqe2wJ24APRiF3G87tw+LTxTIQitRfV1vURzsdprJDwBraqCqz6x
         ceiey4n7X5X8IvIE8mZqvJ/m02HJDnebeD5j9UpJWHAGOAeJBR0DpfmUWhhSNltCEEEW
         SGy4Y4m8uHgL+rrwU3U2EEhoLPwy3V+nSnmPZc3vhYvNRoAj2gAEP3ahy6AMnib6mXhn
         ZN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708937931; x=1709542731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9U5JeY4K4lhWUcooGtJNIKDdAgad5+rJlROqa9Ssovo=;
        b=PJRjBcU30Zq5Wt8E24zC9o3zKpQZ33i/f4edOtBMEY4VqmJSw2kDlFtCHfFDj4xmVR
         3efkS/jV/01GCJRnSX110ld3UvU/MXmScVvy33zR+X6qIF3HU/ZM6ANUEKHPMNxkgRJB
         Z+vrYFRWv59aDMTa8vcWAjdt1uONuj8gjgI/hL/VF2UPYW4/IhVYNFeezoGu6DqUWqv2
         IznK3KkbYrp9xc6GqpUXd0yO7z99UHk5xkdxF7wVZlzqSwUCIY57UIHGiCSWHLy4oDUX
         jTLpHHVxA3gMCqPYdBhEj/f9nCXbTZQwJN8gXB77tsqvBS7WZ2gADetfUghXa9qv1eRx
         ZbkA==
X-Forwarded-Encrypted: i=1; AJvYcCXFYlNECbLhNKxvl85i6N0LvUFjQ4xuRY40raG2kmJ9CtzZ2ENwRYGW9xWvufZ2eMaN569LocPpk5jnP8S5WLySIk47Pcdk
X-Gm-Message-State: AOJu0YwzVr34Mc4rssYr4jw1A5Q2QOPtT5tPIg333TJ2BfbSOifVK2yR
	9fmJoDK96/YptFBSweK2C070K02Ka1cdTq34ghxwHXLIGMSs9VLfUrb2h1/KvUX0xslpBiWPlns
	aNw5UJWULDZPweDGth7ppF677S/ocJ80cuKKw
X-Google-Smtp-Source: AGHT+IG85xMFFFXpIF/7pLhNnGD1E7F7LalAUcPFH59zJnBbm6zxfKv2RuWOntbLuG2WkYsWfNdsAbzFeWuZ5K32FPA=
X-Received: by 2002:a05:6102:34cf:b0:470:575d:4c2c with SMTP id
 a15-20020a05610234cf00b00470575d4c2cmr3713136vst.34.1708937931407; Mon, 26
 Feb 2024 00:58:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222161047.402609-4-tabba@google.com>
 <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
In-Reply-To: <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 08:58:14 +0000
Message-ID: <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping
 guestmem by the host
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, Feb 22, 2024 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> > +{
> > +     struct folio *folio;
> > +
> > +     folio =3D kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->=
pgoff);
> > +     if (!folio)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     /*
> > +      * Check if the page is allowed to be faulted to the host, with t=
he
> > +      * folio lock held to ensure that the check and incrementing the =
page
> > +      * count are protected by the same folio lock.
> > +      */
> > +     if (!kvm_gmem_isfaultable(vmf)) {
> > +             folio_unlock(folio);
> > +             return VM_FAULT_SIGBUS;
> > +     }
> > +
> > +     vmf->page =3D folio_file_page(folio, vmf->pgoff);
>
> We won't currently get hugetlb (or even THP) here. It mimics what shmem
> would do.

At the moment there isn't hugetlb support in guest_memfd(), and
neither in pKVM. Although we do plan on supporting it.

> finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(),
> getting the rmap involved.
>
> Do we have some tests in place that make sure that
> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unmap
> the page again (IOW, that the rmap does indeed work?).

I'm not sure if you mean kernel tests, or if I've tested it. There are
guest_memfd() tests for
fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) , which I have
run. I've also tested it manually with sample programs, and it behaves
as expected.

Otherwise, for gunyah Elliot has used folio_mmapped() [], but Matthew
doesn't think that it would do what we'd like it to do, i.e., ensure
that _noone_ can fault in the page [2]

I would appreciate any ideas, comments, or suggestions regarding this.

Thanks!
/fuad

[1] https://lore.kernel.org/all/20240222141602976-0800.eberman@hu-eberman-l=
v.qualcomm.com/

[2] https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/




> --
> Cheers,
>
> David / dhildenb
>
