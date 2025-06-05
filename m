Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AF527FD54
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161885; cv=none; b=Nh2miqvdseFob9Pcy/3kiFU1xty9qQFpojsn3gJPuf/YcR7L8zAd1v1++wgIQ5ZVj5DwrNF4ALQxcOlqFTHqp3/1bp0VFgXQ/dx2lf0N2L0cDdLlbArV5GvwNa6U0vO6VLDWtHttNpmE00TKFTy6e5g6ZeSvUw5fZVxy1dpDwhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161885; c=relaxed/simple;
	bh=yMhu9sPuYCqwJcCgHx9xGE7CfhUndVPmqZ3Gefo96po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJWx7BCVYx0ycV5gHVERoSOdzVZwJxaz2WFTnTd8XQKlS+5Omcja+ZLKtPAiDdQR+AZJVLT68gfH+agAGwV5kJj5Op66Bkt1NCGjPLwRsGmEUteddBuwy8x1XCOyy93As+NFDi3Ceqt0sHfnT4dk3SlQdS1Acktpkv1j1dQWDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BnRrnWJ7; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BnRrnWJ7"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e733e25bfc7so1403575276.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 15:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749161882; x=1749766682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQ/uGyCTZOS6KpI/fI0NUJbZvrpPuXcuakWk65q+Vo0=;
        b=BnRrnWJ7aEklIAw4Qvco+6t31nbjw+6mA0esYqoRoj9IDy46IE3iZw/QuvzYrmFTLO
         CY44HeHSYWfnXLjxufWbOWUFumhj7nhjzkzrndHoFt6X1SLZBJ1hXqn1kBP12h9vnPkl
         +M8UUeLd+2wb90eNIpou4T1Uqaux+dpiH6P1dO2EekIKQXruMR4smkBnM02OjIsX4zHH
         wrzMEUkMQac96VY3YcH+efE/rY76L6bRDmWytIq0VlH+YG67bJ6nvP5FNLss2XJn/meO
         3damifidZ83C+vDzUmh2onY7PMyjwRQsUWpCi55f5ittDzWDjWTVWBmM+nFzHWBV7m0d
         Vs2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749161882; x=1749766682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ/uGyCTZOS6KpI/fI0NUJbZvrpPuXcuakWk65q+Vo0=;
        b=vXZ9WCSPp1mPOqa1qsSA5Rw5b/fbqnF/XGbffW2F4rX1cl/WPm3xjpxIfGdz9jDIwk
         g177CIzWMUQy1a7r8HUW1EyjuTAgQzLci/W+8AKHJMJ4YBVNTur2ulKE6sKotj8suEV/
         fcI706yU9p4CJlUKvXIZ5qNNHLqBuz3m3fu4b+umMIa8/RskuZYIGtwe3n7/4FRWgKJ/
         T0phfWIXwVkpzw9MHqV1/96WDoIF6b0FNScv/jR4M9uajxWG8VxY3GlEmNBKAkEGiNtM
         65o5O+TqXaj9UHlPStvIU6aEQLiqT9UgKXQRUf0pwRa+Ay7tL1uoaqQsPvThJehGk3Kg
         ekeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeXU3NQm/9SlXxDi61JIqHkxRYpohdIthQSHMv3j5u7ybti3I/hwcgnfyqUXX+wwcgpvtkbYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YypkyZC/F6etvS7dWk16ISIauSbsBcjPX14ss0AKufjIN8nTKZh
	IA6716j9RUlar7eYDHDLM4U7h49LsH7oV5862ELLn9zBJklGSMjeq3eFhFIfy0r0UXKKZ5UaleE
	YOGYSkz8SyIdFIDcC4lHJ+I6aF7zQZeLt95mrJlTv
X-Gm-Gg: ASbGncvOGDVjZ1udlfBjIFBGnrMNV2vhsaOsDdFgBo2zbkJRPUGWu/WVSjTzWlHT1nk
	F4e+GjegVVKlQtvXsPcUSjfFsBuWPy9XtjPKJ1Usnph2BDmPXd6q9juR/w3YmDERC/E+OMekkjr
	cJllqqVyOt5Rl5FqS9cMYGXEQ8KnrPs26teotk8sDBO/Y7lNkbizMvhNsZlWPFdavBaqsSguia
X-Google-Smtp-Source: AGHT+IEp6IGPuzz6J/+BpJ6aDeMRiVbGyP9uhXLN3ZH8ojjYUdl2R1SNFOG6TloGaR9kARIO3zOdCXd1Ty9ye/gS72k=
X-Received: by 2002:a05:6902:1881:b0:e81:5197:3dd5 with SMTP id
 3f1490d57ef6-e81a2276cfdmr2085466276.1.1749161882078; Thu, 05 Jun 2025
 15:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com> <aEIWOSyFADsfXZnZ@google.com>
In-Reply-To: <aEIWOSyFADsfXZnZ@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 15:17:26 -0700
X-Gm-Features: AX0GCFusmx5LnqBezumi2CBPX3jBsMOV_ncGvRUPGLV-0hofjeATZJ_DcmP1Prc
Message-ID: <CADrL8HV86-8cODX7Qn7U2ULCG8Gm0ym9c30NAnf5sqZo_GD1iA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 3:12=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jun 05, 2025, James Houghton wrote:
> > On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wr=
ote:
> > > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> > >                     "pwrite on a guest_mem fd should fail");
> > >  }
> > >
> > > -static void test_mmap(int fd, size_t page_size)
> > > +static void test_mmap_supported(int fd, size_t page_size, size_t tot=
al_size)
> > > +{
> > > +       const char val =3D 0xaa;
> > > +       char *mem;
> >
> > This must be `volatile char *` to ensure that the compiler doesn't
> > elide the accesses you have written.
> >
> > > +       size_t i;
> > > +       int ret;
> > > +
> > > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PR=
IVATE, fd, 0);
> > > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed=
 by guest_memfd.");
> > > +
> > > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SH=
ARED, fd, 0);
> > > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest mem=
ory should succeed.");
> > > +
> > > +       memset(mem, val, total_size);
> >
> > Now unfortunately, `memset` and `munmap` will complain about the
> > volatile qualification. So...
> >
> > memset((char *)mem, val, total_size);
> >
> > Eh... wish they just wouldn't complain, but this is a small price to
> > pay for correctness. :)
> >
> > > +       for (i =3D 0; i < total_size; i++)
> > > +               TEST_ASSERT_EQ(mem[i], val);
> >
> > The compiler is allowed to[1] elide the read of `mem[i]` and just
> > assume that it is `val`.
>
> I don't think "volatile" is needed.  Won't READ_ONCE(mem[i]) do the trick=
?  That
> in turn will force the compiler to emit the stores as well.

Yeah `volatile` is only needed on the reads. READ_ONCE() implies a
`volatile` read, so if you want to write it that way, that's fine too.

I prefer my original suggestion though; it's less likely for there to
be a bug. :)

> > [1]: https://godbolt.org/z/Wora54bP6
> >
> > Feel free to add `volatile` to that snippet to see how the code changes=
.
