Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2EE30506A
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762787075; cv=none; b=RGRiFDmT7mdmwClukpllGzA7AFUsK/zW3LaJzQKZWZbJoPjV0deNPucsLaDMSIMj2vDzpHlh9YL4roWD3EjicU+qYJB/IikkfuiEBHjaW/hQZ7u4u6X0u2Cpcmls/g+p+SFTe1Sm3qigmmcLE0s/yZ77F1Z1cPZJ1gIecHaqi8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762787075; c=relaxed/simple;
	bh=hlp92FoWkCvhMy/WOgj245t8m5LSGL8kjyjvRN8gA3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=afa3ElnMBfuuV+oUb2BFUp5b2VKAgOTeQgkmWhZc76UDs02nTZdWrDriN43Fee+7st4wBtUIQZ2bWmPUfHtYJEbLWt79NIEQ1Jw1NuYN50pDuvo7we7jml9OEuV5PNjpzvWr13XrF3C0Sme4tRtJkbViNZZkYQvwz3OZ1Rz6nBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sUQxoH4U; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sUQxoH4U"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb59dfda5so324761cf.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 07:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762787072; x=1763391872; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xbx1jZ5ZtDZQNw/mTpWHRsEOAMqWoM+Ba2UTcs6fjM0=;
        b=sUQxoH4UD0wde4hzbn9jzrFvQLQSxIPeM4BlCQZU1QQ5vJnPl/0577Wb+7wJICMZcQ
         nmgQeGGWmW/+BUpBtzYg3lUMLZX6TVXLA5QbyaY1oa7GPP/RtQIbDV9W2iuzGuLzzsxc
         C26rPsT2D2uQaLj8CcMjaAyE2QBKKUqrdMgwfKz5ObnVFYuae81OyLQPPCrY2vbyfAyz
         oCFRQEqZ0/t9zwhqLpz6RhlKN8hb1ABGezMZYNWlzAz5PRfpcZzTMpXYCVQbvPp2pThm
         YDXkMKSvN6VpuExaYP5Lo7FDAw4LLvy753ItRX5lPBuDHjCzGnvCFweKKXZcrI+i+ocV
         7b2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762787072; x=1763391872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xbx1jZ5ZtDZQNw/mTpWHRsEOAMqWoM+Ba2UTcs6fjM0=;
        b=Hvvxlpz/369/ax/aPtm/uAZj2T5vYY6TRnZfYsZUgEYBZFfbvnz1bq/WGG7UkQ8MNI
         hLjKVSmiaa0bEW1jroSLjs09vmHweQqhoRSeJJMYangKU5NE/Fs3Hukk6mW1iLqAQ3rV
         8qg6dWDuvZ6LfMIwhmkLkXseDwGGHU+q8XY8/zWHUIG/CF9N6NRMTmp+/9MiVDDQYLll
         0Q0mEpJBdID8l3eE3EfXmD+SED92O/T2DkAJr1mTW/eyPUNhiksETrBPLVLlp1RuFYwN
         iWhL8uOhw6mgFW7Ve5gwRXDArFlkTeIP0nTDLc/wohQaZBfLc7QqAwLD99qMZBGqa+dg
         TiaQ==
X-Gm-Message-State: AOJu0YwiiyJxQikgDUzlW0mByKCkiWbyTw+m34auu1mjX3zFnrAUb39c
	yG+7QVaCWg4Pc4VzxTG9jyBxk8Z6OlU9NVDYy5RHT5pp++cBBPb94cYjsnyqxR4kWKfQ2Amp6Iq
	VvhIxAU9Cf01WVNb0eLG3+u0MPo5h5Vk3LLuH9CWe
X-Gm-Gg: ASbGncuchCwuTz4glFm3iU1TSIK1BwGJgX++1rf+BlttIMLpcgZRd8sZdPTkvikPkAJ
	iAR9Uli6NELxpOCbEKXB1zOt+fyH+QhYPneoT5WqrW9zJb3K6x4zSbsG5Gjt3RjEEw1B1F9r9s0
	Rzzy0Bw78FwRNSdHus6WKHOG0VLaK0KhJEYJflLYEf1TtY27PJ5B/ZxIH8IGQioUb+a5AkwO6Y5
	b5SdpXsGBlbvrhECILwWP7EUwk/M+6Mn1PZT5MndBSFeQWE11dEKajhjtf/
X-Google-Smtp-Source: AGHT+IEhj4deaDzdMbqhfKu1Xfh8nGslbXskec6lqQWbXZ4RiM6ounrrTFI5pFrD/dIUOXGWVk8xRUBXDzBAL5EHkw4=
X-Received: by 2002:ac8:5808:0:b0:4ed:b4e3:cfa9 with SMTP id
 d75a77b69052e-4edb4f31b23mr8209791cf.5.1762787071367; Mon, 10 Nov 2025
 07:04:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com> <20251110134525.3768197-4-tabba@google.com>
 <bc25a11a-d5b7-45de-bb99-c78100e5055d@arm.com>
In-Reply-To: <bc25a11a-d5b7-45de-bb99-c78100e5055d@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 10 Nov 2025 15:03:54 +0000
X-Gm-Features: AWmQ_bnuzcmegBE5AU2g4oiIJKzzJSl7fV2EZbDb74iGF0ObJPvV6Janjbuy0xU
Message-ID: <CA+EHjTzW1Mj6yCY8_L83s5B_LvuzbbVs=0p83t1W7zahEs_PaQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] KVM: arm64: Fix MTE flag initialization for
 protected VMs
To: Ben Horgan <ben.horgan@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

On Mon, 10 Nov 2025 at 14:51, Ben Horgan <ben.horgan@arm.com> wrote:
>
> Hi Fuad,
>
> On 11/10/25 13:45, Fuad Tabba wrote:
> > The function pkvm_init_features_from_host() initializes guest
> > features, propagating them from the host. The logic to propagate
> > KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
> > has a couple of issues.
> >
> > First, the check was in the common path, before the divergence for
> > protected and non-protected VMs. For non-protected VMs, this was
> > unnecessary, as 'kvm->arch.flags' is completely overwritten by
> > host_arch_flags immediately after, which already contains the MTE flag.
> > For protected VMs, this was setting the flag even if the feature is not
> > allowed.
> >
> > Second, the check was reading 'host_kvm->arch.flags' instead of using
> > the local 'host_arch_flags', which is read once from the host flags.
> >
> > Fix these by moving the MTE flag check inside the protected-VM-only
> > path, checking if the feature is allowed, and changing it to use the
> > correct host_arch_flags local variable. This ensures non-protected VMs
> > get the flag via the bulk copy, and protected VMs get it via an explicit
> > check.
> >
> > Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index f6f8996c4f97..7e370e31260d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -337,9 +337,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >       /* CTR_EL0 is always under host control, even for protected VMs. */
> >       hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
> >
> > -     if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
> > -             set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
> > -
> >       /* No restrictions for non-protected VMs. */
> >       if (!kvm_vm_is_protected(kvm)) {
> >               hyp_vm->kvm.arch.flags = host_arch_flags;
> > @@ -372,6 +369,11 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >               kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
> >       }
> >
> > +     if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE)) {
> > +             set_bit(KVM_CAP_ARM_MTE, allowed_features);
>
> Isn't allowed_features a bitmap for the KVM_ARCH_VCPU_ defines? I think
> MTE is treated as a property of the VM.

Right! This line should go. The check should only be to propagate the
flag to kvm->arch.flags, i.e.,

+       if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+               kvm->arch.flags |= host_arch_flags &
BIT(KVM_ARCH_FLAG_MTE_ENABLED);

Thanks for pointing this out,
/fuad

> > +             kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
> > +     }
> > +
> >       bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
> >                  allowed_features, KVM_VCPU_MAX_FEATURES);
> >  }
>
>
> Thanks,
>
> Ben
>
