Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40751684B0
	for <kvmarm@lists.linux.dev>; Tue, 21 Oct 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761063250; cv=none; b=aTSdJaVqqJC2+imYZrA/0vhfAUDO+zqnQ39MZ5PrtlcJEESTVzzIMwl5/UekLGOlme1xAX1Bhs3Sq35L0ybLyXt8FW8mRdgI8HwaiAE+I2qclai1px/egqh+/h3Iixn4npj88tEmWxFCa6NhLVJXAsqv8+lsH+Xo9xspdAR23d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761063250; c=relaxed/simple;
	bh=jwALCPRFruFeYmRfrp9Ri+SEZYzWo8ADyILKji9+IIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fo0vYAT5/XSv6kNO1ExNCaayhOSSBLN3uvIdv/vcdGr3MlVRbOZISBVKmkiDVSeaLIG9NejFOfawB20GtAyhV+QmHu0rAQDtIZ2g3HY02oOvIwunB81wWagOlL4yg60e1IB0brqA0arfcETPxoSTnjiW3ts+M94oNiL35Yn52Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0jKZsX/N; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0jKZsX/N"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47101c27c9cso75905e9.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Oct 2025 09:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761063247; x=1761668047; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzW2rY1I2AKLs/LU+wRizdzQ22+SHdlJ/3qusxmFBDE=;
        b=0jKZsX/NgJg1rVubDgNyR9iWvcYj30K+IgatK5EePiF4TMrFUDFTS662eEHo5TWs0a
         QGAu58c3nfeP1g7BfMHPGBG7XtKCjHjnkbKP+/vUtDFQ/bZ45daVWSaZGYWqxSeJlHwl
         RxOunJdE4oRk4pQjmUO0M4U5O3kSgGziGU4It5f8lVRDNxBbhXo1O+1QISOhzgFyc1iJ
         ua5wOQPXGwT4lsB8tejcTPREbtT0MfrdsVM1Au0krvTLSBnwQj8qa7R951pAJ80O4V+L
         0b0ad8U+/AUr/apMli2lIxh3ndyFQ7TpNar0kDQXBQMdtP1eOjI2AtEGxKIsfsAS+rls
         R/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761063247; x=1761668047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzW2rY1I2AKLs/LU+wRizdzQ22+SHdlJ/3qusxmFBDE=;
        b=IxlQDhuzMPehh199t9++qN3A1tbPg69Xu1kw+owhFJrkBB2EFILwjUFFloicvQaKEu
         +uuOwVz1EyazYVqp/pm2NnTzjo1T+ZeHUAhjOCR8IiSiQPWXqcA7BWJhtg/lHSFhFW53
         Gtw+M6zzBcx6CdVhUoHEQKkRQtJYSVZGCm+h/UwXLv7Gj2yZM16w6R8czptQ2eDwA563
         ySCrKXWYIjm3tnW4YTXJ3NI3vqNY+t9tscqUiWLNmOc46fcb/CZa+/s8XRn1e03GFR8m
         NnHhdGierw2uRT1gO4b99LKEB9W3/FaiCm55iXcOBauxvEBt+0CPYdzzMYHyEI31hTgT
         /J6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC0tPqdOzvWvBv0c5CpWOLhdSTpXKdDEHD35oLIUiqAJ/VVALYKBoGTvJfkt9bAIkkG7iU7HM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyAC9N8LykVYcSfxwk2vNIw49J7BJUsMopHZjSwD7IdvjlXxD7
	NoWvKaADp4slC0tM9urWv6GplzHDmUptJ/UMQmglmPb5EunLrBYKnGreSjDEVc4C98J1cf+BQc4
	ZM/mk+0bsOtmooIhdCwZ5dowGhqcufdVwzFbyL+s4
X-Gm-Gg: ASbGncuozSqeMhAXKIfM91sIU0NRAVx8hny9zAlpIchun0qsLtVJDmX5DybYHChmQuh
	jElp72FXcanVeGjVLQuc/1Hqh8MrHZdzoZKV5Rd4dZKz875MaWvO5lm0dGPCVJmlkE30IRUaQLc
	jVtCw+Xu8Lri11yBidhpSmSwHiR0vuEW+p87kxM6hSG34T0LNA7B+VIhJg0nH4T6xgpAXcgQkXm
	MJzZel/JOl4t4WRN32K7xAoo2077K7wr6TYapiz8yzHLoU7RlW8id0+uNEPTCapFXHSmRRtheQB
	h60h8OZ+oZhGwxKB
X-Google-Smtp-Source: AGHT+IE14qTEBghQgzjgcliX4306euS6iolIBF3AxWlF2cEnTAIMms5VkABvdFJelKcvqwketyvRe6yUthJZ0L6j/JI=
X-Received: by 2002:a05:600c:8719:b0:46f:aa9f:e345 with SMTP id
 5b1f17b1804b1-47497744bccmr724965e9.7.1761063246555; Tue, 21 Oct 2025
 09:14:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <20251013185903.1372553-4-jiaqiyan@google.com>
 <3efcf624-58f1-4390-b6e2-a0aa5e62a9a3@infradead.org>
In-Reply-To: <3efcf624-58f1-4390-b6e2-a0aa5e62a9a3@infradead.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 21 Oct 2025 09:13:55 -0700
X-Gm-Features: AS18NWBrgiqcwjUkY7yriOgg09EsrU9gzSKpZPzp6diSIUTDX5ipeIw05uqw6vQ
Message-ID: <CACw3F53cqiwtGyeJw+baS23sK3byenC8R5ddzW6Q1e_Bzk8tJA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] Documentation: kvm: new UAPI for handling SEA
To: Randy Dunlap <rdunlap@infradead.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, jgg@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 6:51=E2=80=AFPM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
>
>
> On 10/13/25 11:59 AM, Jiaqi Yan wrote:
> > Document the new userspace-visible features and APIs for handling
> > synchronous external abort (SEA)
> > - KVM_CAP_ARM_SEA_TO_USER: How userspace enables the new feature.
> > - KVM_EXIT_ARM_SEA: exit userspace gets when it needs to handle SEA
> >   and what userspace gets while taking the SEA.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 6ae24c5ca5598..43bc2a1d78e01 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7272,6 +7272,55 @@ exit, even without calls to ``KVM_ENABLE_CAP`` o=
r similar.  In this case,
> >  it will enter with output fields already valid; in the common case, th=
e
> >  ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_U=
NSUPPORTED``.
> >  Userspace need not do anything if it does not wish to support a TDVMCA=
LL.
> > +
> > +::
> > +             /* KVM_EXIT_ARM_SEA */
> > +             struct {
> > +  #define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID   (1ULL << 0)
> > +                     __u64 flags;
> > +                     __u64 esr;
> > +                     __u64 gva;
> > +                     __u64 gpa;
> > +             } arm_sea;
> > +
> > +Used on arm64 systems. When the VM capability KVM_CAP_ARM_SEA_TO_USER =
is
> > +enabled, a VM exit is generated if guest causes a synchronous external=
 abort
> > +(SEA) and the host APEI fails to handle the SEA.
> > +
> > +Historically KVM handles SEA by first delegating the SEA to host APEI =
as there
> > +is high chance that the SEA is caused by consuming uncorrected memory =
error.
> > +However, not all platforms support SEA handling in APEI, and KVM's fal=
lback
> > +is to inject an asynchronous SError into the guest, which usually pani=
cs
> > +guest kernel unpleasantly. As an alternative, userspace can participat=
e into
>
>                                                                          =
  in
>
> > +the SEA handling by enabling KVM_CAP_ARM_SEA_TO_USER at VM creation, a=
fter
> > +querying the capability. Once enabled, when KVM has to handle the gues=
t
>
>                                                                      gues=
t-
> > +caused SEA, it returns to userspace with KVM_EXIT_ARM_SEA, with detail=
s
> > +about the SEA available in 'arm_sea'.
> > +
> > +The 'esr' field holds the value of the exception syndrome register (ES=
R) while
> > +KVM taking the SEA, which tells userspace the character of the current=
 SEA,
>    KVM takes
>
> > +such as its Exception Class, Synchronous Error Type, Fault Specific Co=
de and
> > +so on. For more details on ESR, check the Arm Architecture Registers
> > +documentation.
> > +
> > +The following values are defined for the 'flags' field
>
> Above needs an ending like '.' or ':'.
> (or maybe "::" depending how it is processed by Sphinx)
>
> > +
> > +  - KVM_EXIT_ARM_SEA_FLAG_GPA_VALID -- the faulting guest physical add=
ress
> > +    is valid and userspace can get its value in the 'gpa' field.
> > +
> > +Note userspace can tell whether the faulting guest virtual address is =
valid
> > +from the FnV bit in 'esr' field. If FnV bit in 'esr' field is not set,=
 the
> > +'gva' field hols the valid faulting guest virtual address.
>
>                holds (or contains)> +
> > +Userspace needs to take actions to handle guest SEA synchronously, nam=
ely in
> > +the same thread that runs KVM_RUN and receives KVM_EXIT_ARM_SEA. One o=
f the
> > +encouraged approaches is to utilize the KVM_SET_VCPU_EVENTS to inject =
the SEA
> > +to the faulting VCPU. This way, the guest has the opportunity to keep =
running
> > +and limit the blast radius of the SEA to the particular guest applicat=
ion that
> > +caused the SEA. Userspace may also emulate the SEA to VM by itself usi=
ng the
> > +KVM_SET_ONE_REG API. In this case, it can use the valid values from 'g=
va' and
> > +'gpa' fields to manipulate VCPU's registers (e.g. FAR_EL1, HPFAR_EL1).
> > +
> >  ::
> >
> >               /* Fix the size of the union. */
> > @@ -8689,6 +8738,18 @@ This capability indicate to the userspace whethe=
r a PFNMAP memory region
> >  can be safely mapped as cacheable. This relies on the presence of
> >  force write back (FWB) feature support on the hardware.
> >
> > +7.45 KVM_CAP_ARM_SEA_TO_USER
> > +----------------------------
> > +
> > +:Architecture: arm64
> > +:Target: VM
> > +:Parameters: none
> > +:Returns: 0 on success, -EINVAL if unsupported.
> > +
> > +This capability, if KVM_CHECK_EXTENSION indicates that it is available=
, means
> > +that KVM has an implementation that allows userspace to participate in=
 handling
> > +synchronous external abort caused by VM, by an exit of KVM_EXIT_ARM_SE=
A.
> > +
> >  8. Other capabilities.
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
>
> --
> ~Randy
>

Thanks for your quick review, Randy. I have queued fixes and am
waiting for reviews on other commits in this PATCH.
