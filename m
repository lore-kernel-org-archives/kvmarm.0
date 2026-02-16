Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A78021019C
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248664; cv=pass; b=Hb/pDxDBipK3upd4jGJQO1H4Fs8IYxbwXxrPOUR9nfXWOxBW0pMiqQwFmKGz+qfObtko8MsUibWPEMZhbnfcHbqjevYoDj0nEI/RvIR6A285a7Kd+opjGD9sNlnRmnv8CwjiER/N1m9TwMyo6J4iCYJAZH5XokgIf1shZzFshmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248664; c=relaxed/simple;
	bh=KYwDyE5sgL5bnvQDKuNcqwkPWVqjsboFUT0Et0w39IE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haetiJEAMLzanQ0+2c3B4jbMJqKuaMSw8E5sQ7IXn3qj4UzlxGD7Wag31syvJv/E0W/lVrjWBhrCmSHyndlJxNi+eHE5MWU7I2rX6heLd6HReIhW8IjIOwXFaqunI9WzICmf6LDv0BUsPWdPL1CgVNk2yPAAo8LhNMLKB2xjk8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qJLr4xYW; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qJLr4xYW"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ad8435f46so2738750d50.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 05:31:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771248662; cv=none;
        d=google.com; s=arc-20240605;
        b=ctwlD+n88p7jgyVZiwIx/F6S3v7XeXVPuDAjhqyq4dvO9BuCyltGopqDKmc37RNPgS
         RLbMjJsgHqql2WTO1MmcGfdzRyzb3tGSpXV4rHOnAu8rig4tz6pGTlYCgh9owkWvJnH0
         F0ByXg+3835taNxdnsWvY23hQOLNnwMIKdebalondPl54VTs8PqsnnKngQGSInys/T0A
         lamsKV2/YoVpQU0BltntzySunuyqSABb6KMgKutABYu16kWwksZ27adyLJNKS+Y3KO1c
         eGoEQyC7Z5NnitPrbGTsBu0ekz8Wdr8lGLo1xkV3evWsmUTXbZq2FVHFfw2AB6ItFk+N
         lV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        fh=nR9peNaufbd5g/N7GWDvKOWCiJ0rB6aNFlctZHDikzc=;
        b=cDV0SrAlSY66D9ZoiDPc56JRnazvgzgXiJc24CTHSWTmw7TkUQ7+yghxdxPBQJgeZK
         0KFBiyLg0N3i/yuWPzvVGTBCDFUJdQkC9UfoC6h9B2sKNXUqrCzdDu1mfeqmYu9Iq91j
         KShsZ8eujcZWil8q7BzHQtQbus11iWN/qt77H/UjqVauDA+gf5yhV/4lKbbslZeKyscG
         MOCMpl5LLPd3mP5ighTBJgrpSg0ehIkw9/2zjgdUjpJbEuaukSM/mxVd+toWK2awet0d
         RONzjpItljg8t9hmyeqKgKjucD91cHqlobUfCG8UxitKEfIoCY2jQrQvYkn8lHlkRZbH
         PmBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771248662; x=1771853462; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        b=qJLr4xYWIlHwRDyxKGxVSbmah6rgRjsUBGhsbbyT1EbnNCpldujAoqNv0cvqU5q7w+
         N1cWSdo7lX++eudSLotpIxaBTwdvit/E9IGVpczL0VDZaRwMzzPhoZpvX/Npml1dZtTW
         rUrXOVWTDIzp1TUdz3lJXs7krrTH1+BOes6Dg5MMUDf019UcznesLzUyuG7yT5/obl/m
         bNQNx9gqxjyw1Pa7PEhztEE/YQuquaHvlxdnbEtaraOt1v0nj8RhLC2FGaCEbA/6zl8S
         SaCGuL3sRKuGoL56fNmJ0km2tUzBUuhGw3nuTEyI2MyMswyiopMQ9P3lmGSh7DjXDwP8
         u4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771248662; x=1771853462;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        b=j6bY5baBg0z059acAXzH3AMzREvnNR3wKl4qzsDO2STEiUxQZPpd89rO38SQobiYhI
         d+RsN1fNXelfYL0wSld45uxiXPCDuwLqvZSa84BvWgDUvdttKH6PhgdjCjH+QNDj2w7K
         s48OPbzp0iMhgzmlKAR0a1Rz5yAHKFiRRdhZGIAR5MQyy8qETrjC7GbAKwOOY3ADc1YJ
         eX0uG5IS9zDK8Sb3Xu3lXv8GFic9DCqjp1wDViRDrvYZpHTrpc8k7YuBo4YXKD4DZyg6
         Z5ZmW5qSrGMWueQt3uIPvS4u5OcQ+8e+utqCgeGkyn+QYqaX1BRySBTs3AyupI+zirpD
         MShg==
X-Forwarded-Encrypted: i=1; AJvYcCV1Zxl0LrONxDebcWjK+f+RhK4n/tum4Vb664uK47XMxyYIEwMnw7vUbzMTYWwqixhJt1CTiNE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya77IXNCDfHHqrUD19mrDr1H9qb+tDcD+lbNkxxMhH8JRhxUqw
	ZHS0znO4fSm7TeMTQFJHx8+RtLQgE+WUeSPu1ZjPKGgoMlG5OXrBbpMmP0ukzWWsndfAtihK5Zx
	9JIleTL9c8WPmkwkXIr6LkFEd5mZX5DRJPM1fWfqANg==
X-Gm-Gg: AZuq6aI6NWW8HJOtA9zUNqu0X9QBFosjI2hJlNNqUqxlvtlEL2T1SYB0QZVoyZtIupM
	sqWWNSyCB1DQiQkBA/WQkvLlpSreKdZnqGQGvXAqjXjgFN70eYAHe7jec8pbv43X3ES+Sp5JjzQ
	f2Gs+kfMvMkvW4NwJ1b5ZcFMoAw6JUR3WjrIE9cPUN61Ilh+Iz3j0sHaYyfM6+77W2S8jXyERjq
	INZ9wwhETQkMH+OIEGXPigEcwqMUWZcFHtSHXQsDaXrCcaetGPisGGvKdmtFEML8hdAg3QgM60l
	fJ2i8m1Adz5ySApPQaNY1cZuJIPU38XEQTjk2PE+VBoT/0+ZHF+eR1gEJj2iOM/htK9t0QliOzE
	YrQ==
X-Received: by 2002:a53:b20c:0:b0:64a:d720:f259 with SMTP id
 956f58d0204a3-64c21b80db0mr4529065d50.85.1771248662214; Mon, 16 Feb 2026
 05:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
 <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
 <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com> <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
 <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
In-Reply-To: <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 16 Feb 2026 13:30:51 +0000
X-Gm-Features: AZwV_QhGoaC3Vnb64FdYsO_8xJx-bd5rBrEQJ8-6M3I7JiVPCm-6tAEOuq08bHQ
Message-ID: <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Feb 2026 at 16:04, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Wed, 11 Feb 2026, Peter Maydell wrote:
> > On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> Hi Peter,
> >>
> >> On Fri, 6 Feb 2026, Peter Maydell wrote:
> >>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
> >
> >>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> >>>> +{
> >>>> +    ARMCPU *cpu = ARM_CPU(obj);
> >>>> +    const struct psci_version *ver;
> >>>> +
> >>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
> >> [...]
> >>>> +        if (ver->number == cpu->psci_version)
> >>>> +            return g_strdup(ver->str);
> >>>> +    }
> >>>> +
> >>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
> >>>
> >>> Is this ever possible?
> >>
> >> Hm, not sure actually - what if there's a new kernel/qemu implementing
> >> psci version 1.4 and then you migrate to a qemu that doesn't know about
> >> 1.4?
> >
> > Oh, I see -- we're reporting back cpu->psci_version here, which
> > indeed could be the value set by KVM. I misread and assumed
> > this was just reading back the field that the setter sets,
> > which is kvm_prop_psci_version (and which I think will only
> > be set via the setter and so isn't ever a value the setter
> > doesn't know about).
> >
> > That does flag up a bug in this patch, though: if I set
> > a QOM property via the setter function and then read its
> > value via the getter function I ought to get back what
> > I just wrote.
> >
>
> Meaning this should be something like below?
>
> static char *kvm_get_psci_version(Object *obj, Error **errp)
> {
>      ARMCPU *cpu = ARM_CPU(obj);
>
>      return g_strdup_printf("%d.%d",
>         (int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
>         (int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));

I guess we need to define what we want. Things we need:

 - user/QMP/etc setting a value and reading it back should
   get back what they set
 - QEMU needs to keep working on a new kernel that defines a
   new PSCI version in the future
 - user reading the default value and then writing it back
   should succeed

Things we might like:
 - ideally the setter would fail if the user picks a version
   KVM can't support, but I don't think we can conveniently
   determine this, so "fail vcpu init" may be as good as we
   can get without unnecessarily large amounts of effort

I think this probably adds up to:
 - setter should accept any a.b value (for a,b fitting in [0,65535])
 - getter can handle any value and turn it into a.b
 - make sure that setting it to an invalid value gives a helpful
   error on vcpu start

Doing it this way, do we need a separate cpu->kvm_prop_psci_version,
or could we directly read and write cpu_>psci_version ?

thanks
-- PMM
