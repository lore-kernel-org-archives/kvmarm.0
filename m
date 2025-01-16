Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261361DE2B9
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737037525; cv=none; b=sFC6ZZJqaZZ3LbjmyFAFkAzSMV8xTiJdijhpzE7wwLs6/T10jZHq3jwzMLnc60dR3iI/NJrsTPJopfgOlfZL0lHskGovKIcAacRzqR1LQQJHlRxF9+xiL9HN0nNGB7T4o6lbwDyZdNAqe7ROlqQ2qNoNR8ht15OpRaGH4RCpv/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737037525; c=relaxed/simple;
	bh=PNtyIBG6bDjbGmxnlkS6bfveWSmGD7fM02aITudwhxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YPkW/uVnRSWyq2YImJxazx3JaAbbdLNxKUhSevzFjS5Wdrhuzz9Y1TBjq2vGCXJTbDdkRf5PK061aRj55b7fG5uqWkSXJNqqxlRWJdCMXxmxV2cRivitI712o9uSSYdvQdWBWogdOOI4+8HOuIuonW+xveeNvoVg/x3iij18z/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RInpwzCR; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RInpwzCR"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-30034ad2ca3so8101691fa.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 06:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737037521; x=1737642321; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CMm9oC8JLc9tH1UbysAyP6D76A9/5ushkDqcGo4ZtBI=;
        b=RInpwzCRzcjuyZQegsTU6V++rRQY0gmTOANBsTKtjMrzWFnnBB/yFQO5cxjbEeMY8A
         ualU11suls5ZHRLz5YJiVKtQritPG74On8t5KzNLAc+zQFl0teZwAHyk4R3aAgr9ZL6d
         Gt97mMlQwwK2zmVr6iI8x//YDssS3RWfvPjXvmt16J1iOanc8BIj0mn6mIrv7PEt5XoL
         2FVf0LrEuRL21tshSJEkCOpSjmeEaWrHqUpiVCoyg4M1pXpg5/xhmIy0ObSbB5hAU08z
         DlHOATocw3IIXMfY8z5FpMUmCACXZ+2jGnmULLV9Go3451xz3TaSALQ20QzZSuKSL9gX
         pxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737037521; x=1737642321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMm9oC8JLc9tH1UbysAyP6D76A9/5ushkDqcGo4ZtBI=;
        b=eZ5ZwyqtF0pGXqi0WpWi1AvKw9wPJaV34t1VLxgR9GBTgLkFu7vo/aZhxQfHSypUmq
         LlPMDDtOPprjw1KZ1YrvNuRkLuFfs3VUUvULf+z/MQGMcsOAFjjWir6UA7js6Ghex5tY
         h1oiUahuBw/zdFalrIBakn3tD8Kpm10RT/agMTmloCwxmCaQDQBRfYUsJAo4zPukEY76
         Wz6vxiW+1j3hWt6vySEHScGaYqzjhvsq3JFx57D6mk1ZRqq35+wEo+qZbz0jxoBiEEv0
         XwHs8CXwOoq5xgUs6WvlcXZDynIo+gPCXcpBQ165+LdNdCyp1E/NNOJJmJqme9iWHYza
         Ebnw==
X-Forwarded-Encrypted: i=1; AJvYcCVtxHiLo3caZ4AXObM9QIDpn+TeLT4fjrUTuSn1W31qF9vH5Txpgd4oZBe33T9QyR2yVG7zX+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOh+qAacYqD6RpqfVEbOk+t4VyZxdUnxgRdlXL513nuW97hZ1m
	JD3N2f0wotTK1Yxqb2FUhnMhCNKy54OBI2TCY8AXjIkY7o9JcSt4RJGnk0reVGcXy8jFUIoQ/Ik
	/5y/v4TNpeuV/Es+TfxZs0zb2xf8=
X-Gm-Gg: ASbGnct1gltEy6GaFW1TwC95sK9ZfB6WCDkaAMfVlhz2oW2IgUwYC6P1EBaU5BJyWg8
	U+Qc2hmFf/WTvfLNxS7hGnNLLCAZjHWQIhILAtA==
X-Google-Smtp-Source: AGHT+IEN3o/uKUe8sAJeF8y+RZ7VmfjTzka5mMUZSRGrctHFErqfQ8UZaQGq95WFGmwt8fYxKJIHiiG4zY8SoxFaik4=
X-Received: by 2002:a05:651c:1545:b0:300:2524:84f2 with SMTP id
 38308e7fff4ca-305f45324b0mr111390931fa.2.1737037520803; Thu, 16 Jan 2025
 06:25:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213145809.2918-1-ubizjak@gmail.com> <86bjxfsdw0.wl-maz@kernel.org>
In-Reply-To: <86bjxfsdw0.wl-maz@kernel.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 16 Jan 2025 15:25:09 +0100
X-Gm-Features: AbW1kvYklpOf0q0rjC_Uwf-POYuajHKr5oRd1-oyGpfHb4KzOgc8ghKB3RkZwwE
Message-ID: <CAFULd4Zf4=bh6X+xg+0i5jE8doyD_ffpaWOhsdHciVHRrQj+9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: timers: Fix percpu address space issues
 in kvm_timer_hyp_init()
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Content-Type: multipart/mixed; boundary="00000000000063b351062bd390d3"

--00000000000063b351062bd390d3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 6:15=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 13 Dec 2024 14:57:52 +0000,
> Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > Cast return value from kvm_get_running_vcpus() in the __percpu
> > address space to the generic address space via uintptr_t [1]
> > to fix a couple of:
> >
> > arch_timer.c:1395:66: warning: incorrect type in argument 2 (different =
address spaces)
> > arch_timer.c:1395:66:    expected void *vcpu_info
> > arch_timer.c:1395:66:    got struct kvm_vcpu *[noderef] __percpu *
> >
> > sparse warnings.
> >
> > There were no changes in the resulting object files.
> >
> > [1] https://sparse.docs.kernel.org/en/latest/annotations.html#address-s=
pace-name
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Joey Gouly <joey.gouly@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arch_timer.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 1215df590418..a13bb9e8dc19 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -1392,7 +1392,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
> >
> >       if (has_gic) {
> >               err =3D irq_set_vcpu_affinity(host_vtimer_irq,
> > -                                         kvm_get_running_vcpus());
> > +                                         (void *)(uintptr_t)kvm_get_ru=
nning_vcpus());
> >               if (err) {
> >                       kvm_err("kvm_arch_timer: error setting vcpu affin=
ity\n");
> >                       goto out_free_vtimer_irq;
> > @@ -1416,7 +1416,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
> >
> >               if (has_gic) {
> >                       err =3D irq_set_vcpu_affinity(host_ptimer_irq,
> > -                                                 kvm_get_running_vcpus=
());
> > +                                                 (void *)(uintptr_t)kv=
m_get_running_vcpus());
> >                       if (err) {
> >                               kvm_err("kvm_arch_timer: error setting vc=
pu affinity\n");
> >                               goto out_free_ptimer_irq;
>
> I think the fix is worse than the current code, because there is no
> real semantics behind the pointer being passed to
> irq_set_vcpu_affinity(). All that is required is that it is a non-NULL
> pointer.

If this is the case, we can just remove dependence on the pointer in
the called function.

Something like in the attached patch.

Uros.

> I expect the following hack to work just as well and not suffer from
> any sparse indigestion. Untested though.
>
>         M.
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 1215df5904185..8058d92048fb4 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1391,8 +1391,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
>         }
>
>         if (has_gic) {
> -               err =3D irq_set_vcpu_affinity(host_vtimer_irq,
> -                                           kvm_get_running_vcpus());
> +               err =3D irq_set_vcpu_affinity(host_vtimer_irq, info);
>                 if (err) {
>                         kvm_err("kvm_arch_timer: error setting vcpu affin=
ity\n");
>                         goto out_free_vtimer_irq;
> @@ -1415,8 +1414,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
>                 }
>
>                 if (has_gic) {
> -                       err =3D irq_set_vcpu_affinity(host_ptimer_irq,
> -                                                   kvm_get_running_vcpus=
());
> +                       err =3D irq_set_vcpu_affinity(host_ptimer_irq, in=
fo);
>                         if (err) {
>                                 kvm_err("kvm_arch_timer: error setting vc=
pu affinity\n");
>                                 goto out_free_ptimer_irq;
>
> --
> Without deviation from the norm, progress is not possible.

--00000000000063b351062bd390d3
Content-Type: text/plain; charset="US-ASCII"; name="arch_timer.diff.txt"
Content-Disposition: attachment; filename="arch_timer.diff.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_m5zf9nx60>
X-Attachment-Id: f_m5zf9nx60

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYyBiL2FyY2gvYXJtNjQva3Zt
L2FyY2hfdGltZXIuYwppbmRleCAxMjE1ZGY1OTA0MTguLjEwYzI5M2MyZDJmNSAxMDA2NDQKLS0t
IGEvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hf
dGltZXIuYwpAQCAtMTIzOCwxMiArMTIzOCwxMCBAQCB2b2lkIGt2bV9hcm1fdGltZXJfd3JpdGVf
c3lzcmVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAl9CiB9CiAKLXN0YXRpYyBpbnQgdGltZXJf
aXJxX3NldF92Y3B1X2FmZmluaXR5KHN0cnVjdCBpcnFfZGF0YSAqZCwgdm9pZCAqdmNwdSkKK3N0
YXRpYyBpbnQgdGltZXJfaXJxX3NldF92Y3B1X2FmZmluaXR5KHN0cnVjdCBpcnFfZGF0YSAqZCwK
KwkJCQkgICAgICAgdm9pZCBfX2Fsd2F5c191bnVzZWQgKnZjcHUpCiB7Ci0JaWYgKHZjcHUpCi0J
CWlycWRfc2V0X2ZvcndhcmRlZF90b192Y3B1KGQpOwotCWVsc2UKLQkJaXJxZF9jbHJfZm9yd2Fy
ZGVkX3RvX3ZjcHUoZCk7CisJaXJxZF9zZXRfZm9yd2FyZGVkX3RvX3ZjcHUoZCk7CiAKIAlyZXR1
cm4gMDsKIH0KQEAgLTEzOTEsOCArMTM4OSw3IEBAIGludCBfX2luaXQga3ZtX3RpbWVyX2h5cF9p
bml0KGJvb2wgaGFzX2dpYykKIAl9CiAKIAlpZiAoaGFzX2dpYykgewotCQllcnIgPSBpcnFfc2V0
X3ZjcHVfYWZmaW5pdHkoaG9zdF92dGltZXJfaXJxLAotCQkJCQkgICAga3ZtX2dldF9ydW5uaW5n
X3ZjcHVzKCkpOworCQllcnIgPSBpcnFfc2V0X3ZjcHVfYWZmaW5pdHkoaG9zdF92dGltZXJfaXJx
LCBOVUxMKTsKIAkJaWYgKGVycikgewogCQkJa3ZtX2Vycigia3ZtX2FyY2hfdGltZXI6IGVycm9y
IHNldHRpbmcgdmNwdSBhZmZpbml0eVxuIik7CiAJCQlnb3RvIG91dF9mcmVlX3Z0aW1lcl9pcnE7
CkBAIC0xNDE1LDggKzE0MTIsNyBAQCBpbnQgX19pbml0IGt2bV90aW1lcl9oeXBfaW5pdChib29s
IGhhc19naWMpCiAJCX0KIAogCQlpZiAoaGFzX2dpYykgewotCQkJZXJyID0gaXJxX3NldF92Y3B1
X2FmZmluaXR5KGhvc3RfcHRpbWVyX2lycSwKLQkJCQkJCSAgICBrdm1fZ2V0X3J1bm5pbmdfdmNw
dXMoKSk7CisJCQllcnIgPSBpcnFfc2V0X3ZjcHVfYWZmaW5pdHkoaG9zdF9wdGltZXJfaXJxLCBO
VUxMKTsKIAkJCWlmIChlcnIpIHsKIAkJCQlrdm1fZXJyKCJrdm1fYXJjaF90aW1lcjogZXJyb3Ig
c2V0dGluZyB2Y3B1IGFmZmluaXR5XG4iKTsKIAkJCQlnb3RvIG91dF9mcmVlX3B0aW1lcl9pcnE7
Cg==
--00000000000063b351062bd390d3--
