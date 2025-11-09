Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96720A5E5
	for <kvmarm@lists.linux.dev>; Sun,  9 Nov 2025 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762717950; cv=none; b=A3LXG93DCUcPi/hlkoeR7jN3uAwGynFBn5CDkNtafldsm2lV48u6uptQB880CDqLzCM/z3uX3KTb0BoPVuq2TXFz5ftWou89jh4EMuIL11HMGpaoUKcTafbdapz8MRlNmn7dwxJmzOqDKiuFzVTSNy1FP0ZjXw+5ZEcghaRWXW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762717950; c=relaxed/simple;
	bh=CGzhRtRTj/6mpi/QLfNxFwycc9UdPhBSdpXLE8Fd/II=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DfLsQqN+c17bB1Jqsu47kLD2urHOS8DEWVUNN2EjDBz/ia/IEyKoDXKSyCeI1iY1VkIPf+3gIcqjdWzjU+Z+Jg9m4PK0X0AcSuh/WHC+xQgorP7q5ic2LEgVCogoq9aNlPEvL+DKOM7Guddprcd5s7RGr/dFiS7opqSgvc8FOI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IHLGDeHw; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IHLGDeHw"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso317601cf.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Nov 2025 11:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762717947; x=1763322747; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xxR6AO2B/jl6sBl+TPdH+gIFub+ESvkBEdXOIWya/Nk=;
        b=IHLGDeHwRJhjJ8oJj6Mpn3nPNWqYroEDRGqj2Dsinv234XP6kkZr3NsADlwfRZsYae
         yhz1j2ev2PIbv0f+pk+pCyCZLAgku4kXGdt3TZchV54hNof5QJ3+RV3WDkoMVuyOn/O+
         mOFJnH5o+IsEtHBh5loUN4iisb6U1zGvBjjuvPbGlC/j3kD5zrWNYZx/uRZ8zCfXyEJu
         FV+/ILwUTf6kJLvqagz5LzQZdX11WXEwCNDscyqDHwc//U2fW8FK5zw+k4sJcWQp1ji3
         2/0h7lOEi1oPBmV1q3nFUoMxYytph6zTnze6KMm8wuwDi4IwI4TDJMLrHonSffWbnqMA
         JlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762717947; x=1763322747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxR6AO2B/jl6sBl+TPdH+gIFub+ESvkBEdXOIWya/Nk=;
        b=PvNhZknJW4NQko9lAu1UcZD2wxHKz+tOfT+W2m8MbxcvCYODDQUjFK75UABo6D692k
         Pyea0nmA9GESvXBc1IcJS7ujPhSWwcqYFrpFh4GW7IuoTtZ2nFYZb0702GNsCFb7Vkdl
         jFMBa9DfXmvF24PrT0h7h9u8Do+5mfKkeeE6qct5HkC2xMHb7PG4Ob09BpG8JZQzD4tX
         HkLU6d/5xsy5yQJA4qP7yhWBzdL3PkV0IFTG2ixOQtrAAGFm3LUjXupuI0MIoXQxSmfL
         if6oVigYlqX6iDzEGz8biesUahUn8AFDdlE9+G6uSyGucpH35g5QOOjWi9JqXbdhQHu0
         GptQ==
X-Gm-Message-State: AOJu0YwKpHPRldSdZd+1Y53nfrs9N4LnGP2I95PqY5LxHcVWE21oXkRl
	ct/65bJBF8qTYBTtCbJyqB/nAsdUUf3G/sJx+RHwL4I6/uFf62H07nJyWYzf0cTczPZoRhKJ9HB
	q3aRWRaeFQ5YE5/bXi4PYZiFh/I5SfcDMjHv/HpCH
X-Gm-Gg: ASbGncvsOHp0AeF1RqsguMYQl3OHV4AfavEM2Yu36O7sUUuWCVXKa6HalEh7GVv8BRe
	nXrjdYrcr+jm2fpfY4usyfnm2bW+fyBAhaxFWlc225yPo7JmcNuZMaMzpsRbwg/XsCWKe50cT19
	9jLbcWlnxpdaHJGvRAoSb5RRNzCcE25z1xotUxXSTNkMuHy+Jb1KORlYwIG+uqzY6iu0pETLSnQ
	D5+03aJwLxHY9KHVJLhm0I89bvmyiqQMYpuglzsuz2CXX6pmy4vlmrsOQ2T
X-Google-Smtp-Source: AGHT+IHJSNuyAe+Uxnb5byLMLhBxTCB9wY6uFCm/p+xazecRp4xYXv0GsvkhIaq1bmYoMG8A6aq02n8SHCv+pR7YX+Y=
X-Received: by 2002:a05:622a:2cc:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-4eda4e2c1abmr10604291cf.12.1762717947186; Sun, 09 Nov 2025
 11:52:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com> <20251106144418.2847443-6-tabba@google.com>
 <aQ580W6SU1lGbd_D@kernel.org>
In-Reply-To: <aQ580W6SU1lGbd_D@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 9 Nov 2025 19:51:50 +0000
X-Gm-Features: AWmQ_bkltSpteSq6mNSrRDyI0IRhsoYujO6S4KSBeDrZfrq3926fOivxRsnvq9c
Message-ID: <CA+EHjTxwGEb0vPWNT7C8Gg6zhETk1C_dGhJ2+a9E+eJ84hvshA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Define FAR_MASK for fault IPA offset
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 7 Nov 2025 at 23:12, Oliver Upton <oupton@kernel.org> wrote:
>
> On Thu, Nov 06, 2025 at 02:44:17PM +0000, Fuad Tabba wrote:
> > This 12-bit FAR mask is hard-coded as 'GENMASK(11, 0)' in several places
> > to reconstruct the full fault IPA.
> >
> > Define FAR_MASK for this value in the shared header and replace all
> > open-coded instances to improve readability.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h         | 2 ++
> >  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
> >  arch/arm64/kvm/inject_fault.c            | 2 +-
> >  arch/arm64/kvm/mmu.c                     | 4 ++--
> >  4 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 1da290aeedce..e995e9b3a0c4 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -343,6 +343,8 @@
> >  #define PAR_TO_HPFAR(par)            \
> >       (((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
> >
> > +#define FAR_MASK GENMASK_ULL(11, 0)
> > +
>
> This seems really confusing to me, since FAR_MASK sounds like it
> represents the meaningful bits of FAR_ELx. Perhaps something like the
> following would better represent intent:
>
> #define FAR_TO_FIPA_OFFSET(far) ((far) & GENMASK_ULL(11, 0))

Sounds better. I'll change it.

Cheers,
/fuad

> Thanks,
> Oliver
>
> >  #define ECN(x) { ESR_ELx_EC_##x, #x }
> >
> >  #define kvm_arm_exception_class \
> > diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> > index 78579b31a420..22898ed4dd6f 100644
> > --- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> > +++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> > @@ -44,7 +44,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
> >
> >       /* Build the full address */
> >       fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
> > -     fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > +     fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
> >
> >       /* If not for GICV, move on */
> >       if (fault_ipa <  vgic->vgic_cpu_base ||
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > index dfcd66c65517..8ef3453696a2 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -258,7 +258,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
> >       unsigned long addr, esr;
> >
> >       addr  = kvm_vcpu_get_fault_ipa(vcpu);
> > -     addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > +     addr |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
> >
> >       __kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7cc964af8d30..21a9442f9b1e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1959,7 +1959,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >
> >               /* Falls between the IPA range and the PARange? */
> >               if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
> > -                     fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > +                     fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
> >
> >                       return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
> >               }
> > @@ -2059,7 +2059,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >                * faulting VA. This is always 12 bits, irrespective
> >                * of the page size.
> >                */
> > -             ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > +             ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
> >               ret = io_mem_abort(vcpu, ipa);
> >               goto out_unlock;
> >       }
> > --
> > 2.51.2.1041.gc1ab5b90ca-goog
> >
