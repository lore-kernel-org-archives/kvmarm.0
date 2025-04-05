Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C677A625
	for <kvmarm@lists.linux.dev>; Sat,  5 Apr 2025 00:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811297; cv=none; b=jwzvlWSYiyrFVQ0osvaKQZxfWLHV9GB/9MFYl1vcTFO9avjKXBucnkJOa5fj3Kits9rl2fCfOmKxfIpRqJvlbsdM1JuLMA6o41F0bqd9VjsRJTUd529UE1rauzrYulHJ0GiADKH7HYsPzblI/qmfmeCDtJeNC6wcKZz9zQwuGbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811297; c=relaxed/simple;
	bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tbuEvkRX+eBF2XGzs4a2J6logx8nVcGG5jTdeP78SkDBg+J9YrQZ30ofLjUGyVIzMCrDqeUBsgK2pRjIowOyfUwSHMUKXToZ8+Yy0FcF8PmM9FvCwEB2rd+i2Oi/dmJTz9GPM7YHuifnAMrSyTLox5m0z5OdKvuQ5TuWxMVsSck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHcTTCVX; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHcTTCVX"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47666573242so163751cf.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 17:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811294; x=1744416094; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
        b=XHcTTCVXcj2HC2UnQfQcsLXJLM6oe2Jx9LKkAqPKA/Ddaw1FfWj8LPSQeJ8EvN77ai
         akbHRHge1zG7uieLJtKj8MQiiHfo3Mi1Hd8rQM8dvYh6cnaKdio8oKurCqkb2jcpaVXR
         t2a0TZqXoyWHoCtaabSOw0K/dDFHUtR7ALyrNmJJUvymnVSnTEYhIU159iFdPMgXp/CQ
         kvA4rV79sRD9eXktetrrfQp+O+Oi/v9f3i4a5iL3o3O7KVC6Fzl7GkiZlFT9rRKuUWc2
         JczMme0/wE7Hl6cwwf9JhjGltgr8XN9ECCL9rb3VKBZG3emFvZNxWPU1JtTOg3G5uXwg
         BAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811294; x=1744416094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
        b=fvzQOA2Sp/hTo20cA+gdFQo5JWUIOFm7Tk/cLNdD/7azpImqqbljHsiln2bEjs/fX5
         Lw/DpYWaV07ZpGZFaYqkc/x7DnJJmSvufng3obvyvoQqF+G9t3uKUhU/PU0dH5xwhJuG
         qagbuQTuKHgK6vcWoe75e710/syaJIr1s7O+cE+OQG8Xowby6h/EK7cGj0iJdQquulqA
         Z1LnhBwnghUsGzyJ/IW0n6N79t/x/EHN3+PME8ne/fozV2SfSIsdumNmHW/2XlAbtlnq
         Sar4fHqdqtuJZhaeRNmKLs3O3zUIrNob0/dGKxLOr8vmy7MuAG3Y0beFFyH6PxvbNorT
         R+yA==
X-Forwarded-Encrypted: i=1; AJvYcCU73OFiNxTBT6RZfpVx3dtcjfa/4EHSbciTpyjM4aMBURuhucxQObJjeo9FMMdlaol/Un9g1hc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMSSY7Cv2AUhM3wW+1Ai7JUlNqrIjFbHdfosuip3+mlS73WJPV
	aKTzDWPEF0tzdrDrYJbKKelJO5V7T1wPJyvt6YIWLb7/cPL8CWsprvo/GEuA3xit0J0HsBgD4Q9
	fecrbjYfM9Xa3Pni1gVhfHnlVWSTUItUE99+F
X-Gm-Gg: ASbGncu7/BT3b/Bq5dJdfj/n9Xi6RflQPn52MXtu4uBfWySNqekaR8lM3OWAAcEt0Jd
	dWZbzSFPERf0kk5DU/B7UOTmH3Et46JyLahv1Rhq1SSfdnZFj1Yj47LDAazT4iiyzoHBI7+OjaO
	4v2rjtQ04of9uG6m6dZHRAZYTMDRPjXPtDR7TCb+GDMyYybH4obSP1QEEPuCk=
X-Google-Smtp-Source: AGHT+IG31MySeEuDpRESn7yDe70KztZLDYHNiWJTHLqTScxeoaWWTA9NWscHpg9wUOdriSga5X/vaYScrXoyeoYYsl4=
X-Received: by 2002:ac8:7e82:0:b0:467:8416:d99e with SMTP id
 d75a77b69052e-479333a2c5bmr745071cf.21.1743811294445; Fri, 04 Apr 2025
 17:01:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250404220659.1312465-1-rananta@google.com> <20250404220659.1312465-3-rananta@google.com>
 <Z_BksUn4JiPPGc4G@linux.dev>
In-Reply-To: <Z_BksUn4JiPPGc4G@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 4 Apr 2025 17:01:23 -0700
X-Gm-Features: AQ5f1Jq0s70hCQMi54jnhNNYSQm6SIED-nce3BxiWWVuRKa9bdstap1Vc309pC4
Message-ID: <CAJHc60y6pTCS+4qtQmT0ttMK1ZOH36tCXpU+yc2DytgKc=AiPQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver


On Fri, Apr 4, 2025 at 4:01=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Fri, Apr 04, 2025 at 10:06:59PM +0000, Raghavendra Rao Ananta wrote:
> > Atomic instructions such as 'ldset' over (global) variables in the gues=
t
> > is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> > DEFINED fault (Unsupported Exclusive or Atomic access)). The observatio=
n
> > was particularly apparent on Neoverse-N3.
> >
> > According to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte load/store),
> > it is implementation defined that a data abort with the mentioned FSC
> > is reported for the first stage of translation that provides an
> > inappropriate memory type. It's likely that the same rule also applies
> > to memory attribute mismatch. When the guest loads the memory location =
of
> > the variable that was already cached during the host userspace's copyin=
g
> > of the ELF into the memory, the core is likely running into a mismatch
> > of memory attrs that's checked in stage-1 itself, and thus causing the
> > abort in EL1.
>
> Sorry, my index of the ARM ARM was trashed when we were discussing this
> before.
>
> DDI0487L.a B2.2.6 describes the exact situation you encountered, where
> atomics are only guaranteed to work on Inner/Outer Shareable MT_NORMAL
> memory.
>
> What's a bit more explicit for other memory attribute aborts (like the
> one you've cited) is whether or not the implementation can generate the
> abort solely on the stage-1 attributes vs. the combined stage-1/stage-2
> attributes at the end of translation.
>
> Either way, let's correct the citation to point at the right section.
>
Ah yes, DDI0487L.a B2.2.6 seems to be very close. OTOH DDI0487L.a
C3.2.6 explains why we see an abort in EL1. I can cite both to get a
full picture.

Thank you.
Raghavendra

> Thanks,
> Oliver
