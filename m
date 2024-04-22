Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9843245BEC
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 08:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773319; cv=none; b=hPF7dNy6ABDg4OE4noqXtQUz2NrPw8gTvDUapK16Av2d9xY1hAF2eQ2xvaJVS8nz/A97tgzmiyhuUloAGyK/u2FuQ43Rrj/xwM/5Etzo2ndOX/gSpbmI56NxCYtBcX51a7CDsLCY5Z+rAXFXjkQOZg8bjY4Tl9JsROINWrXYPWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773319; c=relaxed/simple;
	bh=McUvB3K50Z9YT81c0WuGo7vJ0JFdEK/9KsctSdSvIDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkhyyW9vsbMAtjgIST98JqobMHx6+uOZoJg3y9I/ziDmKxELR4hEh9faYr/P+3sEmp87sdi8lZAvbF0nT1xXxi3hm36IaZJam6DgF+ysgw/sZoP9yA84Phx5BsyWEWDVldn8uDmm93bDzZrUIzTq9H9iUI9VFYufDOHqXFPEj64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u9dX7guq; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9dX7guq"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7e043f577c5so2142523241.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 01:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713773316; x=1714378116; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJLR5aeVTeglPAMzKwK8IWu2w7OGXpr9NFj1otCwGN4=;
        b=u9dX7guqoXUeIrw5+sRLiKtUb7Lg61d5XaDqPstJmPApkDuq29/MsEETpX5n8iNO5Y
         Y1iArDnNB9QTwtGTFypxE5SacjpGKLyMVZZfKODil4/eCIItSIKBhn87Q9V5Wt30FJdz
         AyzdIRlK6gooUOXfru4HsiNSJreukgvOnxOdNO3t+HCM7rvMT93APg5vbtOXmlPqWHRP
         UfXHqezC0m0fwAGdwKHIBNA37h7cK8mH5gXavX+gQsaUu1eJZIwL7qukN9STlqBX+U8k
         dpTfPr2SsWf2e3Sct2d30JgCZkNJD35b3Dehh8tJEYyj+B/lQE0428rZF3TjzcRVF8WT
         Mmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713773316; x=1714378116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJLR5aeVTeglPAMzKwK8IWu2w7OGXpr9NFj1otCwGN4=;
        b=L1Ex/W730UbrWnLiA9LHeKhnKa4pmcMEr2IP7pAp8pZMjS08CZZiyNTHKHfbfCjF9Q
         mE6W8h2M960BywGNluHgMWMknmoZFvXAu6AvyaTvaZTIPHZbZljYN75dTujCP7f9KjpO
         9KtfjFwishT9pnMQS6D1lLcJiTcVbEALMFwPud3JigeqeKl6gCmuB9/pR6Q1g63/hhXw
         2L00QWy+EgRvIp2wcGg3h5Vflh1n+P1acJeWdp2c7xFZ+HWI1HH5XMLVwojeag+jdYrP
         eIv+oAHRCW5TBEbzMpEkVv5UU4t9ghOgnqlcLcFxMD7ypoD2NskKSZuHpAIIXiM3XUBW
         zojA==
X-Gm-Message-State: AOJu0YzpY9/Dh8YYj92oAGRYwMhAgJFa+5UchbZiWjwoFtPTDB/WkmsM
	gUo0yhmgocQd1sPNgoAM7nVR2U4pFT/OE2IW5k8VRpDiKsCkSC7wV8VBj6v1QDsxpsLtk3DQD9Z
	uVBA7+iz/p1sBFQx+5zIyanIhGPSho1FieEmU
X-Google-Smtp-Source: AGHT+IF8DMtGhm/sp3hfVo/1VWrROYXGQbRG6Q0Sku2Inb+2Du2fH3Lt+nocW5Coh55jn7GWNI78yWoOIx451WKTUVA=
X-Received: by 2002:a05:6102:2844:b0:47b:5f05:5a57 with SMTP id
 az4-20020a056102284400b0047b5f055a57mr16198260vsb.16.1713773315931; Mon, 22
 Apr 2024 01:08:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com> <20240419075941.4085061-32-tabba@google.com>
 <ZiLT60yvCMcJmK5T@linux.dev>
In-Reply-To: <ZiLT60yvCMcJmK5T@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Apr 2024 09:07:59 +0100
Message-ID: <CA+EHjTzVx8DAaAUcFo90-p_MxfZu-RpMhJxQM0Tr03456k+t7w@mail.gmail.com>
Subject: Re: [PATCH v3 31/31] KVM: arm64: Force injection of a data abort on
 NISV MMIO exit
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Apr 19, 2024 at 9:28=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Apr 19, 2024 at 08:59:41AM +0100, Fuad Tabba wrote:
> > From: Marc Zyngier <maz@kernel.org>
> >
> > If a vcpu exits for a data abort with an invalid syndrome, the
> > expectations are that userspace has a chance to save the day if
> > it has requested to see such exits.
> >
> > However, this is completely futile in the case of a protected VM,
> > as none of the state is available. In this particular case, inject
> > a data abort directly into the vcpu, consistent with what userspace
> > could do.
> >
> > This also helps with pKVM, which discards all syndrome information when
> > forwarding data aborts that are not known to be MMIO.
> >
> > Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
> > protected VMs, and document this tweak to the API.
>
> Are there going to be more KVM caps that we hide from protected VMs in
> the future? If so, it might be better to have a common helper that
> enforces a denylist of capabilities not supported by pKVM.
>
> That way we can avoid adding kvm_vm_is_protected() checks all over the
> shop.

Yes there will be. I'll add a patch to do that and rework this one.

> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 66301131d5a9..750386a84968 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -80,9 +80,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >
> >       switch (cap->cap) {
> >       case KVM_CAP_ARM_NISV_TO_USER:
> > -             r =3D 0;
> > -             set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> > -                     &kvm->arch.flags);
> > +             if (kvm_vm_is_protected(kvm)) {
> > +                     r =3D -EINVAL;
> > +             } else {
> > +                     r =3D 0;
> > +                     set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USE=
R,
> > +                             &kvm->arch.flags);
> > +             }
>
> nitpick: initialize r =3D -EINVAL and get rid of all the error-path
> initializations in kvm_vm_ioctl_enable_cap()

Ack.

> >               break;
> >       case KVM_CAP_ARM_MTE:
> >               mutex_lock(&kvm->lock);
> > @@ -237,7 +241,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_IMMEDIATE_EXIT:
> >       case KVM_CAP_VCPU_EVENTS:
> >       case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> > -     case KVM_CAP_ARM_NISV_TO_USER:
> >       case KVM_CAP_ARM_INJECT_EXT_DABT:
> >       case KVM_CAP_SET_GUEST_DEBUG:
> >       case KVM_CAP_VCPU_ATTRIBUTES:
> > @@ -247,6 +250,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_COUNTER_OFFSET:
> >               r =3D 1;
> >               break;
> > +     case KVM_CAP_ARM_NISV_TO_USER:
> > +             r =3D !kvm || !kvm_vm_is_protected(kvm);
> > +             break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> >               return KVM_GUESTDBG_VALID_MASK;
> >       case KVM_CAP_ARM_SET_DEVICE_ADDR:
> > diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> > index 5e1ffb0d5363..75e1072948cd 100644
> > --- a/arch/arm64/kvm/mmio.c
> > +++ b/arch/arm64/kvm/mmio.c
> > @@ -133,11 +133,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr=
_t fault_ipa)
> >       /*
> >        * No valid syndrome? Ask userspace for help if it has
> >        * volunteered to do so, and bail out otherwise.
> > +      *
> > +      * In the protected VM case, there isn't much userspace can do
> > +      * though, so directly deliver an exception to the guest.
> >        */
> >       if (!kvm_vcpu_dabt_isvalid(vcpu)) {
> >               trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu=
),
> >                                   kvm_vcpu_get_hfar(vcpu), fault_ipa);
> >
> > +             if (is_protected_kvm_enabled() && vcpu_is_protected(vcpu)=
) {
>
> You can drop the is_protected_kvm_enabled() now that it got folded in to
> kvm_vm_is_protected().

Ack.

Thank you!
/fuad

> --
> Thanks,
> Oliver
