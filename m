Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED812C815
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708968666; cv=none; b=DYQiGXg++0pKNTJfATJIBYVmU+GscDy8tzFBiq26OG/dLPqbh5CRc2vOiWjwJZJ8V8rhYusEJ/+cHDflGGn1bBmevPancK+9rJSyc+8Ser+5I4ookSIm6p5XN115k4l9NUnya+C6n5c2aV3Uam8vXWHux8Bl7g3lyCulqvz6W+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708968666; c=relaxed/simple;
	bh=qzUx/v73ePBDko5B8i6pYW8Eb/6CxuJNu/u618UjmJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sHUi+ZHtQwgEljMdnA4QX95bkt3r8kWPb+9e6OwGeD0KBSUj+xxIqxO+RuWm30wTLC5cSlQOgzF/uhktBl6Ew+vyqMbe49yubQRKosko4BjhtkbiJLXft1+M0a9pd9UTBFow5bANkLMQxeXfJPcCQ5BftwLhtfwEHaWmeH7/+3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4JtcsSv1; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4JtcsSv1"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-214def5da12so1825314fac.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 09:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708968664; x=1709573464; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UBnrEA2tSIUvL9mO5pXyp+1auPx8/c3XfpRfcC1pgQ=;
        b=4JtcsSv1SYNVVRo1B5XGmsPGhJxQqj8mn1WRSmiKOFVFtgsOBrHDagVFVA38takAmC
         l4cXikC3qlktNOuQy6MYhyva57HCB2Y060QD5fHdXqUUFtQRjXxDStTaVZaFyn/zwbtb
         zf973wmptWLhxM9XzWN0F1P5osOOZmVUGhbFoy96UoYzOzBjoH2ooTUu5uume81CTWDH
         Vj3JW8pLoW/DqsOR5Gau24+m94bpw454AT5jvahph+wWJPGFzQalkvav9ZSQGpe/A0h4
         MWV/2BqZ5MFoSyhG1Yr9ULLElZ4b2YXwSr+XtBqn4fczpdUIJhkRRrEJWdg5XYFI/HXM
         0qkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708968664; x=1709573464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UBnrEA2tSIUvL9mO5pXyp+1auPx8/c3XfpRfcC1pgQ=;
        b=xExO4f1END655iif9EZrAxfUwDsARWMpmlHxltL49ttMwChisKiKIVwlUpQ3HmYH1b
         raIvLrN7mlETWFGC6P+djHXWrK2Y3KPyuGh5PYFZHJ5HX6u9JFMVnPUEifQkVnTCITEK
         tXVKzNNXrs80R52t29+G0ZwQpQrQDgz3tGwJSM8tPRA4Tv0LckWs8GcJCv3S+Sc9xYMM
         klz9PdxPrh7Mf+GYOYIE/quOZe6IMt9suyVEvFR7hnP9qKtCUe4wb+8b1U/gqiACZQ+V
         NIfGsYjLDInSNtmr07EYuIqNlDf0MxPVwb70Y6hfpB8bPpKLSDQ+KXd7In6pSlOvET1q
         MzRg==
X-Forwarded-Encrypted: i=1; AJvYcCXa8odwDcEPO5w671rxKR5B4KqsgIxplTlAgYpk1ftuC7wxH1qEontKxE2BcnlOahivaBdsEAAGw23gbS+yX5oUGP8s4iS2
X-Gm-Message-State: AOJu0YywDMQ2mr67sqfigSd1MZd72vS8TFJ1g5Gn0vvmiPT6129ijqNd
	ZwKWTI3eV5FNYCrlFmhg79pQFiSO3pE4YhQ/Z4GjWjM5IbdIqrF8wvcyuJX0uYxrEu35h05t6lR
	eu0B7VVi2p1dCyagbDyPMGu16Qeiu3RtWfFar
X-Google-Smtp-Source: AGHT+IENRdHZwcvqAxsDmdU8/wnXEjN7lZWWrdz7t/TlvytWnl4RXSqIon3tixHjo4zYgspZK8zAvC6GztFhv43qIhQ=
X-Received: by 2002:a05:6871:228c:b0:21f:17b4:3842 with SMTP id
 sd12-20020a056871228c00b0021f17b43842mr9242720oab.45.1708968664065; Mon, 26
 Feb 2024 09:31:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222161047.402609-4-tabba@google.com>
 <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com> <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
 <83d6edb8-bfd0-4233-a4cf-b573fa62c8d9@redhat.com>
In-Reply-To: <83d6edb8-bfd0-4233-a4cf-b573fa62c8d9@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 17:30:26 +0000
Message-ID: <CA+EHjTwtWiCML0X_4Erx5m__DE1Ja4i5BBZtLQRn9dnLWFahPQ@mail.gmail.com>
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

Thank you very much for reviewing this.

On Mon, Feb 26, 2024 at 9:58=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 26.02.24 09:58, Fuad Tabba wrote:
> > Hi David,
> >
> > On Thu, Feb 22, 2024 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >>> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> >>> +{
> >>> +     struct folio *folio;
> >>> +
> >>> +     folio =3D kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf=
->pgoff);
> >>> +     if (!folio)
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     /*
> >>> +      * Check if the page is allowed to be faulted to the host, with=
 the
> >>> +      * folio lock held to ensure that the check and incrementing th=
e page
> >>> +      * count are protected by the same folio lock.
> >>> +      */
> >>> +     if (!kvm_gmem_isfaultable(vmf)) {
> >>> +             folio_unlock(folio);
> >>> +             return VM_FAULT_SIGBUS;
> >>> +     }
> >>> +
> >>> +     vmf->page =3D folio_file_page(folio, vmf->pgoff);
> >>
> >> We won't currently get hugetlb (or even THP) here. It mimics what shme=
m
> >> would do.
> >
> > At the moment there isn't hugetlb support in guest_memfd(), and
> > neither in pKVM. Although we do plan on supporting it.
> >
> >> finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(),
> >> getting the rmap involved.
> >>
> >> Do we have some tests in place that make sure that
> >> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unma=
p
> >> the page again (IOW, that the rmap does indeed work?).
> >
> > I'm not sure if you mean kernel tests, or if I've tested it. There are
> > guest_memfd() tests for
> > fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) , which I have
> > run. I've also tested it manually with sample programs, and it behaves
> > as expected.
>
> Can you point me at the existing tests? I'm interested in
> mmap()-specific guest_memfd tests.
>
> A test that would make sense to me:
>
> 1) Create guest_memfd() and size it to contain at least one page.
>
> 2) mmap() it
>
> 3) Write some pattern (e.g., all 1's) to the first page using the mmap
>
> 4) fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) the first page
>
> 5) Make sure reading from the first page using the mmap reads all 0's
>
> IOW, during 4) we properly unmapped (via rmap) and discarded the page,
> such that 5) will populate a fresh page in the page cache filled with
> 0's and map that one.

The existing tests don't test mmap (or rather, they test the inability
to mmap). They do test FALLOC_FL_PUNCH_HOLE. [1]

The tests for mmap() are ones that I wrote myself. I will write a test
like the one you mentioned, and send it with V2, or earlier if you
prefer.

Thanks again,
/fuad


> --
> Cheers,
>
> David / dhildenb
>
