Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE303BD22B
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334531; cv=none; b=CDRw2ZDWCPMwMCtfNdUWVKN2HVWYUKRzB1B6gMfiM14Fn2Fwcur1wzfgsFeBQaqCmu1Eo6UYswk0EdIqr9Txpt2hZOk36nPu9dtt1uWpoTT9dIKc8yiYRxuHqi+NnXgCRsMxQzrwgVk0Tn2IlzIHmNgImY6ok9WhLfjBFGpYO3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334531; c=relaxed/simple;
	bh=KfTYKj+lZLN2LhtlKXAUB7TQrI5mlOEDuZ2IB9Jfhp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DsO+2U9Yb+7nBfnRVvSldbUSTfOrm1fFr2BJT1KBqlhDq/KI4jGsTU01CX0/a3frL2lhpmGoDuVIIR9j43xZu56Bvd9uz6ZfSCsK6Ky4M9nSmo55Sj4YuAMG4SFeVkG3YpaS8n9IjkFbREUEkBDB3nxmLTkrSWFEZxckXui0ZLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Adys5vKo; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Adys5vKo"
X-Forwarded-Encrypted: i=1; AHgh+RrhcrmYRcMHA1k6QZET0kwj4WzJI+QlVmeFOpntP1kShR0e/5gtGwx7aXL8lHovqWhPth5Td04=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783334526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2MrO46WcW/eT/nIXvgXIv30AaHJGF7753Sjqr/5EqeM=;
	b=Adys5vKorFLYR3Upp+asrDJ52XUa1twmier3A2E3gfdMAjV4vWX9omiuSVYc+QV6QUDNW+
	0XtQE0QMqvp2wS74C42Jae1GUvphx36tPyL6blOUgKKc14Zc5cWy3ZNP8sGpmlQsK2CqkD
	YNzy2o7qUZV4MFZhqvFd9nIr7iitXs0=
X-Gm-Message-State: AOJu0YxBx1TvjIykHhbqCxK5AcW7uTVaPHxZKpCRMIYOu19MVrRlVzoq
	1dfyhnthrm8SYqIN5b3A/dtD+LThxeeFYGlbpGYBR87OBzwez2uHCV2Lqi2VEg3WCZRyWPCjTyW
	F6xM8sfsVcTPl6GiMszwOeKNbSfJg386Var9DPRXt
X-Received: by 2002:a05:622a:254:b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-51c4bfa0b5fmr16022321cf.6.1783334518140; Mon, 06 Jul 2026
 03:41:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-4-fuad.tabba@linux.dev>
 <556ab72c-f440-434b-a24d-84200bd25842@arm.com>
In-Reply-To: <556ab72c-f440-434b-a24d-84200bd25842@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 11:41:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwA1w3eE-mn2r9DCCduFQuoRn_usPO0pxGf1k-jzLsDyw@mail.gmail.com>
X-Gm-Features: AVVi8Ceeij0EvNcVjL34byFUgSH0rVyFks1d71upJAeGiHZe4P9wi8o9zrsK10g
Message-ID: <CA+EHjTwA1w3eE-mn2r9DCCduFQuoRn_usPO0pxGf1k-jzLsDyw@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Suzuki,

On Mon, 6 Jul 2026 at 11:25, Suzuki K Poulose <suzuki.poulose@arm.com> wrot=
e:
>
> Hi Fuad
>
> On 06/07/2026 09:35, Fuad Tabba wrote:
> > Switch kvm__register_mem() and kvm__destroy_mem() from
> > kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> > KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> > superset; when the extra fields are zero, the ioctl behaves
> > identically to v1.
>
> Doesn't this break using this on older KVM implementations ? Not that I
> care, but do others care ?

KVM_SET_USER_MEMORY_REGION2 goes back to 6.8, so this would break
kernels older than that. I can gate it so that REGION2 is only used
when --guest-memfd is requested, keeping REGION for the default path.
But like you said, do others care for kernels that old?

Cheers,
/fuad

>
> Cheers
> Suzuki
>
>
> >
> > This prepares for adding guest_memfd support.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >   kvm.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/kvm.c b/kvm.c
> > index 95ccfcb..8a7fd09 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -189,7 +189,7 @@ core_exit(kvm__exit);
> >   int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >                    void *userspace_addr)
> >   {
> > -     struct kvm_userspace_memory_region mem;
> > +     struct kvm_userspace_memory_region2 mem;
> >       struct kvm_mem_bank *bank;
> >       int ret;
> >
> > @@ -213,14 +213,14 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_p=
hys, u64 size,
> >               goto out;
> >       }
> >
> > -     mem =3D (struct kvm_userspace_memory_region) {
> > +     mem =3D (struct kvm_userspace_memory_region2) {
> >               .slot                   =3D bank->slot,
> >               .guest_phys_addr        =3D guest_phys,
> >               .memory_size            =3D 0,
> >               .userspace_addr         =3D (unsigned long)userspace_addr=
,
> >       };
> >
> > -     ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > +     ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
> >       if (ret < 0) {
> >               ret =3D -errno;
> >               goto out;
> > @@ -239,7 +239,6 @@ out:
> >   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >                     void *userspace_addr, enum kvm_mem_type type)
> >   {
> > -     struct kvm_userspace_memory_region mem;
> >       struct kvm_mem_bank *merged =3D NULL;
> >       struct kvm_mem_bank *bank;
> >       struct list_head *prev_entry;
> > @@ -320,7 +319,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_ph=
ys, u64 size,
> >               flags |=3D KVM_MEM_READONLY;
> >
> >       if (type !=3D KVM_MEM_TYPE_RESERVED) {
> > -             mem =3D (struct kvm_userspace_memory_region) {
> > +             struct kvm_userspace_memory_region2 mem =3D {
> >                       .slot                   =3D slot,
> >                       .flags                  =3D flags,
> >                       .guest_phys_addr        =3D guest_phys,
> > @@ -328,7 +327,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_ph=
ys, u64 size,
> >                       .userspace_addr         =3D (unsigned long)usersp=
ace_addr,
> >               };
> >
> > -             ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &me=
m);
> > +             ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &m=
em);
> >               if (ret < 0) {
> >                       ret =3D -errno;
> >                       goto out;
>
> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.
