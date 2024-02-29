Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD5383B0
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709233351; cv=none; b=m+q3d/zDJElsPuJ4e62FqEDhtwtiINnPuJmGSsVU6O9t4pp9zUgk8LvB9Jqol3eJOxJ4ZvrpW0cm4E5Oht1xBYY6lKyh4ELZ44q8z6kRB+IJyVX7lHKf9NmDwVck0h0iiwFM+7N7wbu19cdT2qO6nh6bhfEAaNgNOMOI3ItV054=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709233351; c=relaxed/simple;
	bh=pt7yZBvUPdfzSzMJi8LqwDxlQORAqHqCD1eJ2pXenhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QeoBThW/qFp3jRni8fQjiUOuFL+npUMJtwGaa9S5hQS9mK1J3BHcP2B/VP2yRbcQJqvLPkDswCPKqdmP45JbaJU4Xh7k+YM4PXhUCnza1DPtQQl5bBoeMT+X+vLKpKJ9bXI2XxgTLgU8lbm7+drsDEDUQ2lZ2MgoXsoJYbpBhuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWIbzF1m; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWIbzF1m"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e47498f4a2so580953a34.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 11:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709233349; x=1709838149; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XvgXNeIlR2n0DZO5YewWXJGaSGLGyyFIo92YkUCmdP8=;
        b=pWIbzF1m3q+NJgiqOmcjMQZ4BL3SPdLHuaBJbVajKa92f9Xg49lWxvOD6VvNAtQj3P
         jxJGuLssF4qlNEadyps0gx8nOSac6tW0MtXSlgPTY6IKOeP6SE8NpCQwXP6r///GR2pW
         AxjAX5A97lAJHd4JnfQb5yEQuKwIAgsOC8y0Lt1P7V/p/Hy4hx9RS9OyCngf+7dYB5sy
         F0ICvdBel0xy58rHSRRZByK+gWpOCVdLboI2TuqiR/Rqvh3Ftn9w/0bjYqfEK7aTIU2W
         mRfDXaGWDWmoEUopGxn0SQmD9PMtKr6OjujXO7KyW/ecPYkCq+TDlmtQaN/lOdTpapLR
         sHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709233349; x=1709838149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvgXNeIlR2n0DZO5YewWXJGaSGLGyyFIo92YkUCmdP8=;
        b=K/WcM6l4r5Jenkn5eMAadc9DjLciqjPu5evUsgslggBmD0JZ89HqTsZ94q8nQDUjb3
         wR1BkBNVPHXjCi08STwKYoHmXsAL8D2T/NtRbb9EQJaNKLsBonE9HOYjaeACENovuTpC
         qtQmqeHjY0oiBpfknzTiMUZWB87t/iOGectp37ty/YjUVgRxtt2CW5exsDDXbtrcJg0P
         AG8kbVce+PGtDs2KnDGPVeJlt1VyxM3l6v8bIgoDjqLhZo3xJzBb7p16JtHAWwLApWDy
         u835miOjDUVBj3uoPkDg7oYK4O//eU4i4hGd8PqHRKVZxAE/f5EsM2Mh1FE+3x0iZdE0
         SFuA==
X-Forwarded-Encrypted: i=1; AJvYcCWeziBB0ltvMnnwK1GIrIAJvqpwwS5Hdjfw47FKk9b6475zf5h4fLmnDH3xbIAsEwbbR/3xRhue7pWMH7cHvzWz+tsEhYfT
X-Gm-Message-State: AOJu0Yx6+Y6uGSy9yhSYK4BiVPHDmLI4ieD16jk5/rrQHtRXBNxVfRtz
	UUCjzawQpon06KSjMpHcr0+TZrvnGDnQhBK1n4hY/Mkz7lU9q8EOaFLELdbTHrI77hC/XftcFCF
	LV+SQ/xdgqTblSlEkU4BrY7uOZLDYiJTS6iC5
X-Google-Smtp-Source: AGHT+IEI/pY59xJ10obQoL/tRxHmG9mjs+ibck4DhVV7ENtA+Z0m9kxA/TZwJEny/i4GFd0l0C4j2gpkUzoeJyDFa2s=
X-Received: by 2002:a05:6870:4582:b0:218:d445:78f8 with SMTP id
 y2-20020a056870458200b00218d44578f8mr2983698oao.9.1709233348773; Thu, 29 Feb
 2024 11:02:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org> <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com> <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com> <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com> <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
In-Reply-To: <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Feb 2024 19:01:51 +0000
Message-ID: <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
Subject: Re: folio_mmapped
To: David Hildenbrand <david@redhat.com>
Cc: Quentin Perret <qperret@google.com>, Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com, 
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Hi David,

...

>>>> "mmap() the whole thing once and only access what you are supposed to
> >   (> > > access" sounds reasonable to me. If you don't play by the rules, you get a
> >>>> signal.
> >>>
> >>> "... you get a signal, or maybe you don't". But yes I understand your
> >>> point, and as per the above there are real benefits to this approach so
> >>> why not.
> >>>
> >>> What do we expect userspace to do when a page goes from shared back to
> >>> being guest-private, because e.g. the guest decides to unshare? Use
> >>> munmap() on that page? Or perhaps an madvise() call of some sort? Note
> >>> that this will be needed when starting a guest as well, as userspace
> >>> needs to copy the guest payload in the guestmem file prior to starting
> >>> the protected VM.
> >>
> >> Let's assume we have the whole guest_memfd mapped exactly once in our
> >> process, a single VMA.
> >>
> >> When setting up the VM, we'll write the payload and then fire up the VM.
> >>
> >> That will (I assume) trigger some shared -> private conversion.
> >>
> >> When we want to convert shared -> private in the kernel, we would first
> >> check if the page is currently mapped. If it is, we could try unmapping that
> >> page using an rmap walk.
> >
> > I had not considered that. That would most certainly be slow, but a well
> > behaved userspace process shouldn't hit it so, that's probably not a
> > problem...
>
> If there really only is a single VMA that covers the page (or even mmaps
> the guest_memfd), it should not be too bad. For example, any
> fallocate(PUNCHHOLE) has to do the same, to unmap the page before
> discarding it from the pagecache.

I don't think that we can assume that only a single VMA covers a page.

> But of course, no rmap walk is always better.

We've been thinking some more about how to handle the case where the
host userspace has a mapping of a page that later becomes private.

One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
to the host with a meaningful exit reason) until the host unmaps that
page, and check for the refcount to the page as you mentioned earlier.
This is essentially what the RFC I sent does (minus the bugs :) ) .

The other idea is to use the rmap walk as you suggested to zap that
page. If the host tries to access that page again, it would get a
SIGBUS on the fault. This has the advantage that, as you'd mentioned,
the host doesn't need to constantly mmap() and munmap() pages. It
could potentially be optimised further as suggested if we have a
cooperating VMM that would issue a MADV_DONTNEED or something like
that, but that's just an optimisation and we would still need to have
the option of the rmap walk. However, I was wondering how practical
this idea would be if more than a single VMA covers a page?

Also, there's the question of what to do if the page is gupped? In
this case I think the only thing we can do is refuse to run the guest
until the gup (and all references) are released, which also brings us
back to the way things (kind of) are...

Thanks,
/fuad
