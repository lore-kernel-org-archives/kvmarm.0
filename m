Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E7F1CB32C
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717023487; cv=none; b=Np0AFgGFczinoBy3/iTUidU2pq+3HbetSreOQeoojJMRD6xXGYqBJoS41YGcNGwRloQn8QQ3H/iq2x7PXzZYuC1baIV1oG6FVgcMm2DxuzJssqReSDPdmolvv7GBrn8QmR9OsmIix9/rsYDzqyS0ktzWSizSpmK9OOumERFEjqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717023487; c=relaxed/simple;
	bh=ILTrqYj7gGL+uJmOCLBAjzct0EhWj0aN1ME6oQovXBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gaaZEoZLWfSbzT1OOcEEQ3gmfH0GmxnPbOZIRhSHFlWW7yQulLAYGaHWXjMvYIhFZyhnK2NwGj4vxbilCbNUBACqkj+j7NkfFFa3xX5BksY8djiKwbzmlnRRV8u6NU/ByypGkqHqvT/IiJ9AwEUW2OAKYsRmfRiT12+3rJ5ClGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kku/jNJJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kku/jNJJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df4dc93d0d3so386221276.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 15:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717023484; x=1717628284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXQ4aAmXpFR+Rnn+LVSp/P9w+zocv3IAjl6jcVlXHAQ=;
        b=kku/jNJJ3MJ/wgXHujjn9udBjgTokp8ar0bLJgXGLwcVSxoo5nLFZGuxufsFlAjsxa
         kscfOs3eMZR8Zf7qOavtr/o2/N84yESsptPFu1W3JE4JzggoAY+6lIAhvPQJmGoAlN9x
         vlrZTZLGUydgpgVAQJHLpmbsNRu5yTLe3m+cT5gm1SZ/1ZLnlV53ZqnRoo9G9VNDlDaq
         VgobUi8B8Wwz2LDOyoXImXt65BOQeBFV6eeTlFHO3c3mYf97t3oQ3dtWwKK8kXnKtt+H
         inDak7dQHWCVxhiiOyaDPUBe/JeYFgIZrW/GB9Jup5/ZhexcYxj3PyfkqY4pUwHntbMT
         2w7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717023484; x=1717628284;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lXQ4aAmXpFR+Rnn+LVSp/P9w+zocv3IAjl6jcVlXHAQ=;
        b=m2o8j2N57J90TKEQFxN2UGRA7DwJGj+IPYh1Tvv2DzYvxYQ2sb+Z+6ANveRVk9M1Ix
         +f1KcX4Z5vTpQSpHir3Ez0jo3ZjHi7Gyx7A7LqDal5o+upq5Z9/xIN59y4Q6c9WGoED3
         BFuYCCF8gwR7Ky4bpUQfMXbFTM49mrUB4i6XBTVlZMfO4e8hufk50JUfvmpgEFlEI+8Z
         oIfVRykA3qDET7CTIYOrcqYiijrldHOGtJFo+9/vaP3L12sHKy/lWvNJGvSPj/ewGvyo
         /6ShczsLsvuV0Gcak0rr8E4SOdt/xBjZaHVN12VHX4BdHmlgo95/Q7ZmmARWsONVhGfu
         72Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXpk5U6GgV8tKzpi1JpfnTqQ7A/JrRNAWr8JcADYbozF+MXV1Nir2jQ7YkDsyAqoxsDtj/WJiA7W091xmYkvA7Dhr2aOdd2
X-Gm-Message-State: AOJu0YxcF7xIjIXL//YpOYOzR7TVuXpr+6iZevWL9F5quf9EBqZJXpOH
	RS4Q1K3X8072l0h1WCUOD2zlhpWhfzO9pPILy2RR2Td0P55zZ4+ZQBWgH+dJ7yUkK+Qww5G86Eh
	+jg==
X-Google-Smtp-Source: AGHT+IEcoxWAWGQljmQC1ObvPASoASZSWeSUzQr2Szq7dgxCnuAYyloQCwOCyj3B7twEp9K1BnNOHbqA4OU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dfa:5838:b919 with SMTP id
 3f1490d57ef6-dfa5a68828dmr142777276.10.1717023484293; Wed, 29 May 2024
 15:58:04 -0700 (PDT)
Date: Wed, 29 May 2024 15:58:02 -0700
In-Reply-To: <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
Message-ID: <Zley-u_dOlZ-S-a6@google.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024, Yu Zhao wrote:
> On Wed, May 29, 2024 at 3:59=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, May 29, 2024, Yu Zhao wrote:
> > > On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@g=
oogle.com> wrote:
> > > >
> > > > Secondary MMUs are currently consulted for access/age information a=
t
> > > > eviction time, but before then, we don't get accurate age informati=
on.
> > > > That is, pages that are mostly accessed through a secondary MMU (li=
ke
> > > > guest memory, used by KVM) will always just proceed down to the old=
est
> > > > generation, and then at eviction time, if KVM reports the page to b=
e
> > > > young, the page will be activated/promoted back to the youngest
> > > > generation.
> > >
> > > Correct, and as I explained offline, this is the only reasonable
> > > behavior if we can't locklessly walk secondary MMUs.
> > >
> > > Just for the record, the (crude) analogy I used was:
> > > Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
> > > but you are only allowed to pick up 10 of them (and put them in your
> > > pocket). A smart move would be to survey the room *first and then*
> > > pick up the largest ones. But if you are carrying a 500 lbs backpack,
> > > you would just want to pick up whichever that's in front of you rathe=
r
> > > than walk the entire room.
> > >
> > > MGLRU should only scan (or lookaround) secondary MMUs if it can be
> > > done lockless. Otherwise, it should just fall back to the existing
> > > approach, which existed in previous versions but is removed in this
> > > version.
> >
> > IIUC, by "existing approach" you mean completely ignore secondary MMUs =
that
> > don't implement a lockless walk?
>=20
> No, the existing approach only checks secondary MMUs for LRU folios,
> i.e., those at the end of the LRU list. It might not find the best
> candidates (the coldest ones) on the entire list, but it doesn't pay
> as much for the locking. MGLRU can *optionally* scan MMUs (secondary
> included) to find the best candidates, but it can only be a win if the
> scanning incurs a relatively low overhead, e.g., done locklessly for
> the secondary MMU. IOW, this is a balance between the cost of
> reclaiming not-so-cold (warm) folios and that of finding the coldest
> folios.

Gotcha.

I tend to agree with Yu, driving the behavior via a Kconfig may generate si=
mpler
_code_, but I think it increases the overall system complexity.  E.g. distr=
os
will likely enable the Kconfig, and in my experience people using KVM with =
a
distro kernel usually aren't kernel experts, i.e. likely won't know that th=
ere's
even a decision to be made, let alone be able to make an informed decision.

Having an mmu_notifier hook that is conditionally implemented doesn't seem =
overly
complex, e.g. even if there's a runtime aspect at play, it'd be easy enough=
 for
KVM to nullify its mmu_notifier hook during initialization.  The hardest pa=
rt is
likely going to be figuring out the threshold for how much overhead is too =
much.
