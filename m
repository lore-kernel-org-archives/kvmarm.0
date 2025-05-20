Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454262609D3
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 23:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747784361; cv=none; b=t3TgKdnNAr9QvCVlCrdCekpAOGPoEWwOk0shUo6jAzOQBgh3Cv72dkKuFEGXxBX/LVWEnFVbvmeNEOHWrYKjiroGmXDKhd9A5jkN+vEvesDjRAZq7Uv6AOYAJVem5uxf1tgQ5pIFYndEd3QHKOA8VjTwyeBiz5qmFZb3ZTkdURM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747784361; c=relaxed/simple;
	bh=qNW0arWXlRmhF4tOVFZz0ZKha2LDMSjtrVhlYdBNed8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YEfDOYF3jHJr+9L3Kg7Fxs41IoBhmdcdjuNkQqs27Jp2oRhwYeFSBE08h4JsauLJFRQazQLb5S8SAov6ZNC3Yh1+4agdZn60pQYWwhJC8GuSbHoQseoyj+KCPWvKbRtxKI++W62dEA0hI5Nd5zwI3AZyzOshOHG7a83pIOWKqGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Js2UTyBq; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Js2UTyBq"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-443d4bff5dfso222945e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747784352; x=1748389152; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRuU/m5dc5FtJi/f3Rrw2anhfRohi0i8yf3iq1OlqJ0=;
        b=Js2UTyBqFr4A+VF5PU12PCcmDXzeMxP/i55njGdIdyif9ASia+uzV0VOG/yJ5mLYMk
         kWBiTAnODSWdEZAY/b7nD4OXz+pG/+mY2m0wNNpay9VsVHlCYqfCjsb2rxjMx1r5CWYk
         UAccGEcm/L7kZUF4/JfWTYKafquJyKnb4PwhigqRU8uy7ua0u3zSQerc6hNm/YnA6voI
         +K6Au/wVp6SfoEqCvke2voi5BZp+j0urTzbolTbPiTnhPkQ8Ujqo/kvf6VcHiB4GHqQB
         Y9s9JHWe+TKHrd5Zq5Ar1TucjwGUOWgL0Nim8/r4qDGZ52Zn9Sxe5jgbTnE4Cfr5dd6/
         VJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747784352; x=1748389152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRuU/m5dc5FtJi/f3Rrw2anhfRohi0i8yf3iq1OlqJ0=;
        b=U9BTHgl9hxSNINe42DUBeTSlba8xu/T5PZACHAJqoukipNfIwFWbkYwVRtC7+OsJUW
         q3JE33sx1fQqfIeTZGHCOepWdwiQ6GFtvRmuFR9h+ss1NxNFOfRCk3WiudPPDD9nXHQq
         XX6Fhd5vzRXpg2easNhGVokEYpdBtDn5vtWL166/PN8HZoaZ0UjgEtRw+BiyE1NodMON
         RWbyForMMLcYfeIFI2vsDak6jbcIrNeM9wlfq+cvUwCc5fcEr38PiQkMKyRHBQ5cW+GL
         DruR2pQto5EoTOZeYxd0KGn+9h/6KJ7XnrLjnjQLwlFMpM3fMqjy73Euvv68uGwwy8Y8
         x7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf4ygY0QTp0z6bmhflObWRHqpuPK48yuZwvkMsFOJotK7s4OkAizeaw89i8IrYUnZyW0aFvGg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1t4TJSni4Rv9W8DgArunmgCC5OCrcngkLhsB1drNTB2ZUJ/dd
	82QFLJocHzkYpf0ZajN8DoU8lLtVxaliPDLlYaNPoxXe0H9llrCAnWjAkPyXp/X8Yfx7XXM4PfZ
	YFqApg0A5mcvG1EIE2xT/19EUhirt4QUhybXUGZU2
X-Gm-Gg: ASbGncuEUA1lOKwZa9PlJ0g0Ukbf18o0Fs72wWXX8BTR2Kp+jnc/bDC4OZiBMAQrBAe
	/3W6gHA5xXRLYf7BL8QmnWr1io+60wamKuXlJbtNYcCmYAQ1ukvWMgHTvQZ6GNV2fd8QFTIheKd
	q3YH0lUCc2/A0vjYlVoOVjOcXCzCWfC0rBi6GiVYfTWvao2/YJF4FRfCBBRp975VBwQYrvGL4k
X-Google-Smtp-Source: AGHT+IEmTo+oS9URXfIuKouUY0B0Y62o5TMKaVmZC8slqtUcsFC1AZMBLwucs8WQvvTTsv5lG6xeERtZDgSchwhBuX8=
X-Received: by 2002:a05:600c:2e49:b0:439:961d:fc7d with SMTP id
 5b1f17b1804b1-443ae3dbdfdmr4250875e9.6.1747784352208; Tue, 20 May 2025
 16:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250505161412.1926643-1-jiaqiyan@google.com> <20250505161412.1926643-3-jiaqiyan@google.com>
 <86zffcefk9.wl-maz@kernel.org>
In-Reply-To: <86zffcefk9.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 20 May 2025 16:39:00 -0700
X-Gm-Features: AX0GCFtfiDim2rVM9--MtRE7iY2zI_cJEhnOXz73-OdjqCpU57FjKEAM9M0zDCo
Message-ID: <CACw3F52v_WSR=HkmeW7be+YRFkUzA-n-=mVHHw4wvJK7ongkYQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 8:33=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 05 May 2025 17:14:08 +0100,
> Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > Certain microarchitectures (e.g. Neoverse V2) do not keep track of
> > the faulting address for a memory load that consumes poisoned data
> > and results in a synchronous external abort (SEA). This means the
> > faulting guest physical address is unavailable when KVM handles such

Actually this is not relevant to the code, I think it is just
sufficient to say "This means that FAR_EL2 holds a garbage value and
therefore kvm_vcpu_get_hfar holds a garbage value too".

> > SEA in EL2, and FAR_EL2 just holds a garbage value.
>
> I don't understand. FAR_ELx holds a *virtual* address, and never a
> physical address (that'd be PFAR_ELx).

Sorry my writing is misleading. If you are still interested, the
scenario I meant to describe is
1. There is a SEA taken by KVM when memory load from the guest
consumes poisoned data.
2. The guest physical address (or IPA) of the poisoned data will not
be available in HPFAR_EL2 per architecture register documentation [1].
3. Although HPFAR_EL2 is unusable, KVM can still attempt address
translation with the guest virtual address in FAR_EL2 to get the
poisoned IPA.
4. However, FAR_EL2 is not valid on certain microarchitectures (e.g.
Neoverse V2), so in the end it is just impossible for KVM to know the
poisoned IPA.

Does this clarify things? But again, it is confusing and will be removed.

[1] https://developer.arm.com/documentation/ddi0601/2025-03/AArch64-Registe=
rs/HPFAR-EL2--Hypervisor-IPA-Fault-Address-Register?lang=3Den


>
> >
> > In case VMM later asks KVM to synchronously inject a SEA into the
> > guest, KVM should set FnV bit
> > - in VCPU's ESR_EL1 to let guest kernel know that FAR_EL1 is invalid
> >   and holds garbage value
> > - in VCPU's ESR_EL2 to let nested virtualization know that FAR_EL2
> >   is invalid and holds garbage value
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  arch/arm64/kvm/inject_fault.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_faul=
t.c
> > index a640e839848e6..b4f9a09952ead 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -81,6 +81,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool =
is_iabt, unsigned long addr
> >       if (!is_iabt)
> >               esr |=3D ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
> >
> > +     if (!kvm_vcpu_sea_far_valid(vcpu))
> > +             esr |=3D ESR_ELx_FnV;
> > +
>
> I don't understand what this has anything to do with the uarch details
> you talk about in the commit message. If the VMM inject an exception,
> surely it has populated the exception context itself. I don't even see
> how we'd end-up here (__kvm_arm_vcpu_set_events? seems unlikely).
>

KVM_SET_VCPU_EVENTS is indeed the case this commit wants to fix.
Instead of populating the exception registers itself, VMM can use
KVM_SET_VCPU_EVENTS to let KVM do that per existing KVM doc [2], e.g.
when VMM handles the KVM_EXIT_ARM_SEA introduced in the previous
commit. The intent is to tell guest, for example, to not use FAR_EL1.

[2] https://www.kernel.org/doc/html/v5.10/virt/kvm/api.html#id3

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
