Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2927FB37
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161533; cv=none; b=qk242stFGdJrpXV1vRptS9xKo3WcxnUPtl2ifLPP7OzPBQEJYY0gdu29NIAlSNfIG+d17/SRcuWBLAQwR2qsEhJz943MUsof8YaqX9Tzt7rlX2WnvtXIcXDidtgzTFD9uajGMhBz6yeC2yhc1GSFHzPDR0Rhnb9HFxNH89QHos8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161533; c=relaxed/simple;
	bh=PANd58hPjbNPTHa4l705McN2EG5oD6B2hiBJ/vJO2es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tae9317L6GiJdCvyrnvhGfgI80EKRNewvgM59jP284BRE+9VWDudG7brTjJF+hH+eOdDVFEE4xinWdypeW5FCssYpVe9l9dngiUk52tg3M8Ug/hcY0b+tdNBjx6wDHb3bDTsNBlhCDCuoKhxgD+QnvE5uY1otIhFJ/gERvk4AHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QtRaqv3g; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QtRaqv3g"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b16b35ea570so1356877a12.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749161531; x=1749766331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+jOw1rIAPgLJUVWv/cCmbdBlNLRTe06PSJ8KQ26TsDA=;
        b=QtRaqv3gipSmpYpqOhes9vQIOQOqvyFFPUA8JF+7nF+lB355pXuSgblpOMjZ2VjT3w
         LNHCASkxaV+9QY//XLc54DxoC2DsyoY8zlAhmdS40y2ujzmT5LLkxNfua6hzw1RPbuNL
         cib88GfbFG3bkohH4lQi4fz2H2l0sRAQX44cLhESR4SY8oe+1cr6kCQdf/puryFXptEB
         3jouyzFOyFOT/Kj4u57cnpvsrDFEUeWHo0tk0GkWAwvm6HtlT4KIzaLIF4+a5nggplIG
         Ujr/d5Zv40mmbWEEShjyxDsT/msd1iUJKnB6IXpvcJNs16kPcDIRm/MtB6MFpP8yMOEE
         FdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749161531; x=1749766331;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+jOw1rIAPgLJUVWv/cCmbdBlNLRTe06PSJ8KQ26TsDA=;
        b=jeLXheTaj4zciKEIPqkAOeH6g8tgFyFaJDwfGr7JLYG/bmqSNWhu9vxKoC7qwHR00m
         58mBxtv9pjGpM+rIEolJwOu7v9iMrZoWZHgEkP9BVhVpPzMQ080VTVKbf+WdVThRlaGB
         5NuQpWOhxAmdlJnaeLiKs08Jwt69qoyxc5YBGVqk2vsRZUwlS2WU8EV+HUNXIqv3IkvF
         Q4WeF1NvaZM5kGwI9fT3Bhlpry8XJuzBU5tP5Jt6EFWU6XhOWqpbVD43Utqii39MguVj
         8JHwUAQ+Yus3MEC7Dfq0sMP6M3IOnNYcCCRvINb4817oNCjgkleQ/++Zb9vNqPKqE/k+
         C7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+IqU7U78AUUspP2HK8V0MCWP0RcyONVzoA0R1+uwKLHrYIyJ3VtmcQWLC8Ag+hnQsuFDBxPU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2HuQY7UgtNo36XyeaZJtA0vTcpBY9FpuW35yK6z1g0iHkHyDY
	eXL12A6J2dwpYa+qkp0iPrF1v4QqmSbx1KkRI8tgHbBrhr/enWO17IjLq13/UgpT0S4Q2OmVKib
	hmBKXvQ==
X-Google-Smtp-Source: AGHT+IG6LzfASe3puScn/Qv3ruREwfR064s8V+HL6PEjTR9Oas02f/m6vRYzgkbGrD2ayUhiXQ3k4vsZIjY=
X-Received: from pfbli4.prod.google.com ([2002:a05:6a00:7184:b0:746:301b:10ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431f:b0:21a:da01:e0cf
 with SMTP id adf61e73a8af0-21ee261054cmr1284527637.22.1749161530718; Thu, 05
 Jun 2025 15:12:10 -0700 (PDT)
Date: Thu, 5 Jun 2025 15:12:09 -0700
In-Reply-To: <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <CADrL8HVn_qswsZgWwXcBa-oP61nbWExWSQAKeSSKn2ffMTNtcg@mail.gmail.com>
Message-ID: <aEIWOSyFADsfXZnZ@google.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2025, James Houghton wrote:
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> > @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
> >                     "pwrite on a guest_mem fd should fail");
> >  }
> >
> > -static void test_mmap(int fd, size_t page_size)
> > +static void test_mmap_supported(int fd, size_t page_size, size_t total=
_size)
> > +{
> > +       const char val =3D 0xaa;
> > +       char *mem;
>=20
> This must be `volatile char *` to ensure that the compiler doesn't
> elide the accesses you have written.
>=20
> > +       size_t i;
> > +       int ret;
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIV=
ATE, fd, 0);
> > +       TEST_ASSERT(mem =3D=3D MAP_FAILED, "Copy-on-write not allowed b=
y guest_memfd.");
> > +
> > +       mem =3D mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd, 0);
> > +       TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() for shared guest memor=
y should succeed.");
> > +
> > +       memset(mem, val, total_size);
>=20
> Now unfortunately, `memset` and `munmap` will complain about the
> volatile qualification. So...
>=20
> memset((char *)mem, val, total_size);
>=20
> Eh... wish they just wouldn't complain, but this is a small price to
> pay for correctness. :)
>=20
> > +       for (i =3D 0; i < total_size; i++)
> > +               TEST_ASSERT_EQ(mem[i], val);
>=20
> The compiler is allowed to[1] elide the read of `mem[i]` and just
> assume that it is `val`.

I don't think "volatile" is needed.  Won't READ_ONCE(mem[i]) do the trick? =
 That
in turn will force the compiler to emit the stores as well.

> [1]: https://godbolt.org/z/Wora54bP6
>=20
> Feel free to add `volatile` to that snippet to see how the code changes.
