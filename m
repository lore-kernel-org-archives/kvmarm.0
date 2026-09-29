Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDBD48EC94
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790716865; cv=none; b=t92idXHnB+Pf3DHKiiRWNNNtmP+vVD4uKTrWXCuIbqedLcc76Jkr3l0eZEDM5zRnw1nwEaWpk9u4bacd5irQYztfpuiY+//GH5oQNdVYMILXMGaymkiMV8sh4gY9zw6M+IKI7YiyqpVFCdS8uw9G+msf2KE/b0mIjyF02cPXGro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790716865; c=relaxed/simple;
	bh=6BHhuneI2m6PepV2hBBz3P939R94zEXTyStwRvRBf9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxP7Lt387W+c5/NW16gsL/vF1NQ/JnfCtYM4KZ3RqZnnmnP/41AXEB6MyNXBc8cm1IAfaxtjQ7IY9CZ4Qccddz03m487cPXajES+HUNOO5LLKGwbbKBGb2+SYoosCIAHS+MYqmMN9UQ2JkxFBUGh9UK1rnyUbc42RQ8HnHA8WWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CDOAYEie; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDOAYEie"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28dbf4197so8423962b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790716863; x=1791321663; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lDp8WWU/0UlLYBNjAv5MLJXqSdTj0yxp/bLRhzLI/Qc=;
        b=CDOAYEie55YwfOlqWsj2kw5it8yoP5qJVQ+ZVLr859ZR5wY/GVsrxI/9RTzC4IYsVm
         /knj6zE0mUaUGc8fS/O3OKX4BNl9y/AdpZpm6tO1YADiGuxhV+zqg6oTMezy5fg3plOM
         Srmwum4uyJ88WaXEqy+KV8ZMvDtnX07VXvIEEp023lKqQYls/xeKqq7xpaw8aD9S75L9
         ukEXeBUyGobU2CzT/6W0Fu9aCv6icbxBlJASHYe5Wl9Agq3qmSYpOOcsgTkOJTqIW2WG
         m2GzhyM2mzOJ6iOH/JBZsyqbn1/9J00szZ96v20xW/lQDY7pYBgvW8rGpvFwQBNqEehn
         zXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790716863; x=1791321663;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lDp8WWU/0UlLYBNjAv5MLJXqSdTj0yxp/bLRhzLI/Qc=;
        b=SGI/bsjz64C095Q01xkQhFNLW2gsDY7luswsxSIJ3k6ipIE7jVgObFY1J2n+7glI84
         Ids7G66rpWh/FzvZDW+qNJZv33QhjQzbVhrV4xCtqqN9wk23KXzPcdAPHQfnHARH2GWz
         xlO9VYE7rRES6xuFjMgzOAflJdp3w++mF0Kz2iU/qYclDjf3HhBDzpBuH/ABzZuk1Jad
         ZBkd0AIPqpVBuIqnJEDJA4tSwlJuCoPE3pM/qgDUTrSpozMVNKyjtIRe+HiAfteQHM7x
         ruHoXnLyJsd7A525WAKjMQ3VNnCz+zP8jv5SGGrHh5rvWpsG7udhUrb/tZ5xdWxuoCEp
         xkOg==
X-Forwarded-Encrypted: i=1; AKwUvBxX3BY01gqB0p+PAdE7vJ69WvlwX/vEH2I4bQ9Gr1r0n/sFAhskBaNDqL7d232uYAWcmQyxTVs=@lists.linux.dev
X-Gm-Message-State: AFuF++nWeOnR/NA/Bjw1Pn+5Dj22doZXE+RqT1dCou2XGYjK1sgFlvP4
	T0PW6clu0jaJTmYhB+1qAWNuuZsIP1eAwce1oQS9ruHYNNdSe0YLLTp/hRwGBnwWp/SBLCUlgqc
	wd3sM87tXt89NK7bn9KTf2aG/yA==
X-Received: from ioia10.prod.google.com ([2002:a05:6602:888a:b0:9c4:b6b4:bf53])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f21:b0:4bc:336d:7494 with SMTP id 5614622812f47-4f0751c3a87mr763966b6e.30.1790716862759;
 Tue, 29 Sep 2026 14:21:02 -0700 (PDT)
Date: Tue, 29 Sep 2026 21:21:02 +0000
In-Reply-To: <CAFEAcA9Rwrffx8bYiOxrtQGdg31QAz1oBm8okzpfqHZ6yK0Y7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924173051.2117637-1-coltonlewis@google.com> <CAFEAcA9Rwrffx8bYiOxrtQGdg31QAz1oBm8okzpfqHZ6yK0Y7A@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929212102.3659389-1-coltonlewis@google.com>
Subject: Re: [PATCH] target/arm: Enable KVM PMU partitioning and counter limit
From: Colton Lewis <coltonlewis@google.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Colton Lewis <coltonlewis@google.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	James Clark <james.clark@linaro.org>, Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

Thanks for reviewing!

On Mon, Sep 28, 2026 at 03:01:32PM +0100, Peter Maydell wrote:
> FYI for next time around, QEMU patches that depend on not-yet-accepted
> kernel ABI changes should be tagged RFC, please.

Ack, sorry about that. I will tag future versions with RFC until the
kernel uAPI is accepted.

> > ---
> >  target/arm/cpu.c | 20 ++++++++++++++++++++
> >  target/arm/cpu.h |  4 ++++
> >  target/arm/kvm.c | 32 ++++++++++++++++++++++++++++++++
>
> New CPU properties should be documented in docs/system/arm/cpu-features.rst .

Will document them there in the next revision.

> > +static bool arm_get_pmu_partition(Object *obj, Error **errp)
> > +{
> > +    ARMCPU *cpu = ARM_CPU(obj);
> > +
> > +    return cpu->kvm_pmu_partition;
> > +}
> > +
> > +static void arm_set_pmu_partition(Object *obj, bool value, Error **errp)
> > +{
> > +    ARMCPU *cpu = ARM_CPU(obj);
> > +
> > +    cpu->kvm_pmu_partition = value;
> > +}
>
> If your getter/setter are only updating the struct field,
> you can use a DEFINE_PROP_BOOL to avoid having to have them
> (compare arm_cpu_has_el2_property etc.)

Thanks, I will switch to DEFINE_PROP_BOOL.

> >      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
> >          cpu->has_pmu = true;
> >          object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> > +        object_property_add_bool(obj, "pmu-partition",
> > +                                 arm_get_pmu_partition,
> > +                                 arm_set_pmu_partition);
> > +        object_property_add_uint32_ptr(obj, "pmu-num-counters",
> > +                                       &cpu->kvm_pmu_nr_counters,
> > +                                       OBJ_PROP_FLAG_READWRITE);
>
> What should we do with these properties if we're not using KVM
> (i.e. for TCG, hvf, etc) ?

PMU partitioning is specific to KVM, so moving it into
kvm_arm_add_vcpu_properties() (which is only called when kvm_enabled())
and naming it "kvm-pmu-partition" per the KVM VCPU Features convention
in docs/system/arm/cpu-features.rst seems to make the most sense.

For the counter limit property, would you prefer that it also live in
kvm_arm_add_vcpu_properties() as "kvm-pmu-num-counters" (KVM-only), or
keep "pmu-num-counters" general so TCG can also use it to override
PMCR_EL0.N in reset_pmcr_el0?

Thanks,
Colton
