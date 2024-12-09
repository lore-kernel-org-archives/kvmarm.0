Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D02F5FEE6
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732095; cv=none; b=Y7agVxhA+rcI85UUcG8Q5TFrW7Bc7wGf+OFkHsCZykkol77xqgkXe14qvBb4DbTJ7LV+NWQBYKEJoBxZ+cht7TUHPkOKiwnsxT382uUgswZTu58Xpdua3hAjSiS30t/Acg7F9eJqFNbAdMlKWfTfsrEz29mRzikT7FTAXvg7Kyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732095; c=relaxed/simple;
	bh=yuiimQnXJRE9YVLq4TC6OObCfEIzIrjQVfgH38AYD2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LMqCilsFMilbGIS2dN3qumebyMAWA5oBI7dd5Toqf6gjtvvn3LLuZqoD9sxzHaOBDKQ89v3g981p0kx5OwWciFgCNzf5485QkFswCtzhJrdkc5aHeoI4XBIMLY1VoMU7uRM/xbz+i5a12MvED/1XfI+lfJ5/NsyeE0OobfxTxzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rV8/LTuS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rV8/LTuS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-434ed674047so62825e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Dec 2024 00:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733732092; x=1734336892; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=38VOcmtNIf+FGDDeC2rlfe3RwwgSY9ulk0n9SpJxDqk=;
        b=rV8/LTuSx5kayoVxAgNnaARGExl+KwJzD69TyiH4150oFZyDyTYkozQPHrFcAtmb4a
         4YTU6pPnkpjjwKef2s5i9eMXlt8l7lhkxAIKoyLiQ18OaTkXyeALOnqDO24lcw1zrEfP
         uN0zGA92HRUwCZlx8QvGpHV7LL41jHLOomIxfH51UzgL1jKDoFd/O+PxDwITE06D4gqW
         9H3ry+3+ukBWSNoXWAXDIB7tskIlIdRkQsMJgKuWC4QPSOu3ITyRFgQpBtaxGSHvN1O0
         jI28eBWbJiRCKoHh0Q6zTijR1sl40fCm3PdvwfrchVxOb3GROB2iIT5dlvGPVGl2vtqb
         YHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733732092; x=1734336892;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38VOcmtNIf+FGDDeC2rlfe3RwwgSY9ulk0n9SpJxDqk=;
        b=eRZ5QAh8xLi6bh8JM/NwlqMVTNer/8xBeajmSysIcG2j4wLABTm9BMI8xkzs1HXfJo
         iY2n1Op6K078Rtq8T3hx2niUuQw50DGrHrHX3RYMnyhgEMQzCv5bTrke8QBR7RbRZTNi
         bI6hhbwMvqqxeEaON5hHDiF+9q6hHkmfU1FT3MDBmDCEOuM26r9v5xnRx0JeYM55w1mH
         zY8Mkdt89G9Db66+atWANtcS43CFa799sDpQwlZZYG/+UsdQhvRTgshAixO5I2nNEjeF
         8ps/YpeQ+wyCPl1qxJUDYij3JOXfhO7RFozotqyPEf2KL7gbq9VkwGrKQ70gyTCafF0Z
         bQeA==
X-Gm-Message-State: AOJu0Yxtxn3KZ45kodQ22O3S3pKEMm30NTFuSnJfOfMu3rWhOz7edV/K
	KHXRqwbEHJy8rIPjDP1ZLea3XIVO1j5xYiY5NbiQxKPvppLMX7ZVkjlsR9WhZHsre+B6ELAnw8t
	EDvqN59+x4i4hHSywAS/ylpgMKGz3mNuqHFmw
X-Gm-Gg: ASbGnctQRDHYnhN/v9rKKa/Lvizo0m1L4W/nRaYJEyzbDjoziKeM3G9feegSDmYtn1B
	w31590royj/aKZIMbI4sx5VcrV98wqg==
X-Google-Smtp-Source: AGHT+IECcCGIULUtAZnSfmvAEsNbU/UmcoDuc/+jvY7I76xPVuvbxulGInOe9FXP6l0BfMl0Nn0opoQej/DRcojogCg=
X-Received: by 2002:a05:600c:6c4e:b0:434:9fac:3408 with SMTP id
 5b1f17b1804b1-434e8347d19mr2398065e9.2.1733732092346; Mon, 09 Dec 2024
 00:14:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-5-tabba@google.com>
 <Z1MwAomiLhnMn--k@google.com>
In-Reply-To: <Z1MwAomiLhnMn--k@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Dec 2024 08:14:15 +0000
Message-ID: <CA+EHjTy6Y6w9RyU2Vn8O+DDviSJf=P-Y4c+xVFqY-3GmHBv3kQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] KVM: arm64: Use KVM extension checks for allowed
 protected VM capabilities
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Fri, 6 Dec 2024 at 17:10, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:31 (+0000), Fuad Tabba wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index fb733b36c6c1..59ff6aac514c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -329,34 +329,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >
> >       bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
> >
> > -     /*
> > -      * For protected VMs, always allow:
> > -      * - CPU starting in poweroff state
> > -      * - PSCI v0.2
> > -      */
> > -     set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
>
> For my understanding, why do we drop this bit?

Since the hypervisor is responsible for the power state of protected
VMs. This should either be a separate patch or I should explain it in
the commit message. Any preference?

Thanks,
/fuad

> >       set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
> >
> > -     /*
> > -      * Check if remaining features are allowed:
> > -      * - Performance Monitoring
> > -      * - Scalable Vectors
> > -      * - Pointer Authentication
> > -      */
> > -     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), PVM_ID_AA64DFR0_ALLOW))
> > +     if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PMU_V3))
> >               set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
> >
> > -     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), PVM_ID_AA64PFR0_ALLOW))
> > -             set_bit(KVM_ARM_VCPU_SVE, allowed_features);
> > -
> > -     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_ALLOW) &&
> > -         FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_ALLOW))
> > +     if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_ADDRESS))
> >               set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
> >
> > -     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
> > -         FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA), PVM_ID_AA64ISAR1_ALLOW))
> > +     if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
> >               set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
> >
> > +     if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE))
> > +             set_bit(KVM_ARM_VCPU_SVE, allowed_features);
> > +
> >       bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
> >                  allowed_features, KVM_VCPU_MAX_FEATURES);
> >  }
> > --
> > 2.47.0.338.g60cca15819-goog
> >
>
