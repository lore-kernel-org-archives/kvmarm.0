Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC7D2F2C
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807051; cv=none; b=FEUZB5lj7mPFQksrODeV34hvOAFdrqyrknoOZj/C3LKSXMFJF+yM9shrgZD+ut1lPqLoqsI6nCtTW9uX3T5Vrl/4xVYYEZ4nxl+TSVs2DchovRNgHEJiuZuIbqbOKiRllcIFgWI8DGwbM0VBT7gnDPCeRLwmPbBXh5QCKw2P8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807051; c=relaxed/simple;
	bh=PtnUNRKUKmU0roY3+tMx6rbvVlXM6qrLVRtwdiYhmwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=avrbIWN4FsbKl5FtGfeSPYR+mBXgFvZ1Keu8OCPuarYKj1LUJKlgnxDO9rTNYiVMSDxVVH/ZIqtcSq4bB50Zc5lUiFXIEI7M8dGb2fU37OWFPfIzvQ4p2fB/aAyDDMKF7l06lZuxWkolTetJIDA1XB319xcW91oahrDNgZAXwcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ko15eu7X; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ko15eu7X"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so8753228276.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 17:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710807049; x=1711411849; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVOcK8wb3sXGFyuNatUw0hEIoH+aEIoBNqkWidxVNDc=;
        b=ko15eu7XDwzj14nk0XJNSmzXgdYwmowwiCMvKos9OISDpgDHcjmNtjhftHekHJdDta
         EGqoMzT4dxIur4YbQ5joct/JSnl0JmN76PMeEcKiFF+Afk30vLdtsRFbaT6JxTJRePEj
         PBY0i8ByoZocVMlUm2S+v8TcrDIhBn9vAjNQBAcxx6F3F2Lp2v67LGk6Q73rVkWtyrgL
         ++JNKA5SVT6oENF6UydDfv3a9C+Fo+bhAp/EnkoQm10HdYFNJS5TjevqKx16nqB6RJIo
         KV+dkADaSpAreNrd0u2qGRrLz0B/Eh27R2EP8yxRNueY/RZRb8Zj8UxFnlnw7jujAVbq
         P7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807049; x=1711411849;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dVOcK8wb3sXGFyuNatUw0hEIoH+aEIoBNqkWidxVNDc=;
        b=qjrKlSkGxM3sLwbA0KIU+gTY/ZGZXvYsfTJ2DxS8jUg6PksH5pqrNMRF/PF3XQ4Z2G
         7OtKXNrRQStx0m4P4vRnZE9OMubXH88YuW7QOVln7nu36bkp+F15P9VYyMs+ZNArF2B3
         0pdcgWQmQ/FOR74DYOEvhIcbcP4lOFBh5q5noIkkziC50PoBYgLLSqxG0I6z9goJQ1C9
         r4wkpLdpqB7t3eN3p3CxJyscp1vTcTLuEASkB0paJHiNtRiLDGl0P4aXhIwQOTmZ2zNT
         JqppATOQFPQWsJ+6ehUXTmju0E3TopAAOGXYlNDrmr4MeUg0R2WhArxwuAal9DLS1GiB
         antg==
X-Forwarded-Encrypted: i=1; AJvYcCWH8kXZnnb+/1+84KkHARqvGePS/AO1AVjezZxGDIs4aVuVDCDxKs76ZlhebDVa6fvAQVPeHUrOOBb9jPSv8ZP5a/R/uH+9
X-Gm-Message-State: AOJu0YxvYIS+/UEijXWt3vYq1POhtgudN7G22/Bkr2bKZuRv+m+iKlNy
	sTwkFKreMjrKXNGOmMosHDoxjtNQRm5WdZPmqdcfKi7lo6/c0zpz1xQXMf0dAglqeYEGtAXsQQS
	4yQ==
X-Google-Smtp-Source: AGHT+IG8o0R1VQ3cJvZ6rxzM7gbl6TSbT5OoWu6Hsm5q28r6QLtwJIp7eVHhB3U032wtW5rGR7bg0RFXNqw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1144:b0:dcb:abcc:62be with SMTP id
 p4-20020a056902114400b00dcbabcc62bemr3472520ybu.6.1710807048787; Mon, 18 Mar
 2024 17:10:48 -0700 (PDT)
Date: Mon, 18 Mar 2024 17:10:47 -0700
In-Reply-To: <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Zd8qvwQ05xBDXEkp@google.com> <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com> <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com> <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com> <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
Message-ID: <ZfjYBxXeh9lcudxp@google.com>
Subject: Re: folio_mmapped
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> On Mon, Mar 18, 2024 at 3:02=E2=80=AFPM David Hildenbrand <david@redhat.c=
om> wrote:
> > Second, we should find better ways to let an IOMMU map these pages,
> > *not* using GUP. There were already discussions on providing a similar
> > fd+offset-style interface instead. GUP really sounds like the wrong
> > approach here. Maybe we should look into passing not only guest_memfd,
> > but also "ordinary" memfds.

+1.  I am not completely opposed to letting SNP and TDX effectively convert
pages between private and shared, but I also completely agree that letting
anything gup() guest_memfd memory is likely to end in tears.

> I need to dig into past discussions around this, but agree that
> passing guest memfds to VFIO drivers in addition to HVAs seems worth
> exploring. This may be required anyways for devices supporting TDX
> connect [1].
>=20
> If we are talking about the same file catering to both private and
> shared memory, there has to be some way to keep track of references on
> the shared memory from both host userspace and IOMMU.
>=20
> >
> > Third, I don't think we should be using huge pages where huge pages
> > don't make any sense. Using a 1 GiB page so the VM will convert some
> > pieces to map it using PTEs will destroy the whole purpose of using 1
> > GiB pages. It doesn't make any sense.

I don't disagree, but the fundamental problem is that we have no guarantees=
 as to
what that guest will or will not do.  We can certainly make very educated g=
uesses,
and probably be right 99.99% of the time, but being wrong 0.01% of the time
probably means a lot of broken VMs, and a lot of unhappy customers.

> I had started a discussion for this [2] using an RFC series.=20

David is talking about the host side of things, AFAICT you're talking about=
 the
guest side...

> challenge here remain:
> 1) Unifying all the conversions under one layer
> 2) Ensuring shared memory allocations are huge page aligned at boot
> time and runtime.
>=20
> Using any kind of unified shared memory allocator (today this part is
> played by SWIOTLB) will need to support huge page aligned dynamic
> increments, which can be only guaranteed by carving out enough memory
> at boot time for CMA area and using CMA area for allocation at
> runtime.
>    - Since it's hard to come up with a maximum amount of shared memory
> needed by VM, especially with GPUs/TPUs around, it's difficult to come
> up with CMA area size at boot time.

...which is very relevant as carving out memory in the guest is nigh imposs=
ible,
but carving out memory in the host for systems whose sole purpose is to run=
 VMs
is very doable.

> I think it's arguable that even if a VM converts 10 % of its memory to
> shared using 4k granularity, we still have fewer page table walks on
> the rest of the memory when using 1G/2M pages, which is a significant
> portion.

Performance is a secondary concern.  If this were _just_ about guest perfor=
mance,
I would unequivocally side with David: the guest gets to keep the pieces if=
 it
fragments a 1GiB page.

The main problem we're trying to solve is that we want to provision a host =
such
that the host can serve 1GiB pages for non-CoCo VMs, and can also simultane=
ously
run CoCo VMs, with 100% fungibility.  I.e. a host could run 100% non-CoCo V=
Ms,
100% CoCo VMs, or more likely, some sliding mix of the two.  Ideally, CoCo =
VMs
would also get the benefits of 1GiB mappings, that's not the driving motivi=
ation
for this discussion.

As HugeTLB exists today, supporting that use case isn't really feasible bec=
ause
there's no sane way to convert/free just a sliver of a 1GiB page (and recon=
stitute
the 1GiB when the sliver is converted/freed back).

Peeking ahead at my next comment, I don't think that solving this in the gu=
est
is a realistic option, i.e. IMO, we need to figure out a way to handle this=
 in
the host, without relying on the guest to cooperate.  Luckily, we haven't a=
dded
hugepage support of any kind to guest_memfd, i.e. we have a fairly blank sl=
ate
to work with.

The other big advantage that we should lean into is that we can make assump=
tions
about guest_memfd usage that would never fly for a general purpose backing =
stores,
e.g. creating a dedicated memory pool for guest_memfd is acceptable, if not
desirable, for (almost?) all of the CoCo use cases.

I don't have any concrete ideas at this time, but my gut feeling is that th=
is
won't be _that_ crazy hard to solve if commit hard to guest_memfd _not_ bei=
ng
general purposes, and if we we account for conversion scenarios when design=
ing
hugepage support for guest_memfd.

> > For example, one could create a GPA layout where some regions are backe=
d
> > by gigantic pages that cannot be converted/can only be converted as a
> > whole, and some are backed by 4k pages that can be converted back and
> > forth. We'd use multiple guest_memfds for that. I recall that physicall=
y
> > restricting such conversions/locations (e.g., for bounce buffers) in
> > Linux was already discussed somewhere, but I don't recall the details.
> >
> > It's all not trivial and not easy to get "clean".
>=20
> Yeah, agree with this point, it's difficult to get a clean solution
> here, but the host side solution might be easier to deploy (not
> necessarily easier to implement) and possibly cleaner than attempts to
> regulate the guest side.

I think we missed the opportunity to regulate the guest side by several yea=
rs.
To be able to rely on such a scheme, e.g. to deploy at scale and not DoS cu=
stomer
VMs, KVM would need to be able to _enforce_ the scheme.  And while I am mor=
e than
willing to put my foot down on things where the guest is being blatantly ri=
diculous,
wanting to convert an arbitrary 4KiB chunk of memory between private and sh=
ared
isn't ridiculous (likely inefficient, but not ridiculous).  I.e. I'm not wi=
lling
to have KVM refuse conversions that are legal according to the SNP and TDX =
specs
(and presumably the CCA spec, too).

That's why I think we're years too late; this sort of restriction needs to =
go in
the "hardware" spec, and that ship has sailed.
