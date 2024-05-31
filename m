Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CFB7D06E
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 20:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187519; cv=none; b=F4BhgF/lwIwlK9XGRV2vyDUdxFlQEAWtLkHFHjhZp8BBa5Bwh2lN0NQNWYWHRTCeG8/8xObLedSaMg8/EIUCjEZG32SNzqvJizx9LLAzL+ooCw8XNT/5F5SPf8psfCCJZx/AvADqiBbfLTYcKI2c6t1oxViqp7hIJBd0S0Odcqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187519; c=relaxed/simple;
	bh=InPM3IgrwlWAIe+nSHKsuhmVDndDnlj7rMcdOWuFi5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FfOhsOJpTX1Nj+HJaFD1ng6e9Yt2jcDlKwtYXZPyo+TYpnVt4jspneuPiJGQN27mEGrlHEHoPKk6ErntmeO27YNNSbd0qUNocZzywg+qxxFsxNnJKoHvX9xMMY01KEOchAXP7IXoDbBw06cv3TUsVQ/9js67su9YJFqbHvL3iZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DYZrq56l; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DYZrq56l"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42133fbe137so4995e9.0
        for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 13:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717187516; x=1717792316; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InPM3IgrwlWAIe+nSHKsuhmVDndDnlj7rMcdOWuFi5w=;
        b=DYZrq56lETkmzRCVxahoYnmhzhtJptsmd22ALh95MWEGmnxC0G6F0Qje4kq7UWZkFh
         id4DUSVd752xr4CG4BAbJ6bVJ4n5KZbRVikmFUVrbZhSEmNRd83SqO44ltukFttHde6m
         w/EovL4h3dRBaA/a2h2XzXkhWLPt6IDKJX9z46iW+7ZzTrIWqCbC3sYVoGGo+Q+DGFIY
         2ihWcGUvYDpFiH92dLHHt5+fOJ9r3TC546k2LAGtOVt8L8r3FXO5rJplxxdSqfhBGKg9
         sK6gAMM5EHjGbADmzrJvP9je+xdLns9OjKNpWNzwBRfstBQG/P/DnfG1HF+RLCGyYMud
         5/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717187516; x=1717792316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=InPM3IgrwlWAIe+nSHKsuhmVDndDnlj7rMcdOWuFi5w=;
        b=rxuQW6fHzEudq60Fv5K2Rzue5t0UW6pxTkB3nfpW3T8xui/9v4P4T7gNqNMdUHdmjt
         mf21fSX06/nonuUW8rsbANCqotbBkl+KXsDQ9vI8oKt3pUXuOXeDLp0YBlwztNNYx0wB
         nylEpRBOVQbhTmcj/d4o73MdmLxwY+oKCwoRz8VuvtOjWNzv07Con72qXqdFUlA7uMzd
         3AuxlSnAO3ToRx9FqXXktihC3Eo5R15p7m6pXl7gAIWF8wsWnRTVrbzx/CfbcHhnrd02
         bwTo85TS9lZmpzID8p0OnHAGHYGAzkuLgn8lvVxu9+/x3Y3XYuZd7PHucI9Iy/macCWj
         vlkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1H0N0OWhS7fBjUZ14jPo/L+1RpF/6arnKY884YfXrFsiN4KsQqP6L0xMehskzaGMWHG6A9L10l2wZxr+vUH2fqlEa25Zg
X-Gm-Message-State: AOJu0YymT1MoOv82kK+tFa3Jf90pOrivkvqdcZM8PNBwUe1An4WzxoFk
	bs6/3mN2Ef3+P6UxeT12J6iOAXKRKaaDodjrBeJ8s4PfvYb3rihAGF1QvcT5QG0lChHHb5Xs9oG
	NniXlVIjDWce9nygH7YV30+C0Q7o6efj9bETg
X-Google-Smtp-Source: AGHT+IECr7zScct/L9KDZG2FMT9+ZV9pueXumB1G4qrj8mkBEYnZr/Z/kM44zsq5c/gUQqURoi9spkN6RMIRJ4Ct+FE=
X-Received: by 2002:a05:600c:299:b0:418:97c6:188d with SMTP id
 5b1f17b1804b1-421358ce41bmr41075e9.7.1717187515962; Fri, 31 May 2024 13:31:55
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <Zll7IuGYGG5uI20W@linux.dev>
In-Reply-To: <Zll7IuGYGG5uI20W@linux.dev>
From: Yu Zhao <yuzhao@google.com>
Date: Fri, 31 May 2024 14:31:17 -0600
Message-ID: <CAOUHufa50Dy8CJ5+D10Khs4NU-3Pv0B8qi-GYkcppctTVUkPcA@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 1:24=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, May 29, 2024 at 03:03:21PM -0600, Yu Zhao wrote:
> > On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@goo=
gle.com> wrote:
> > >
> > > Secondary MMUs are currently consulted for access/age information at
> > > eviction time, but before then, we don't get accurate age information=
.
> > > That is, pages that are mostly accessed through a secondary MMU (like
> > > guest memory, used by KVM) will always just proceed down to the oldes=
t
> > > generation, and then at eviction time, if KVM reports the page to be
> > > young, the page will be activated/promoted back to the youngest
> > > generation.
> >
> > Correct, and as I explained offline, this is the only reasonable
> > behavior if we can't locklessly walk secondary MMUs.
> >
> > Just for the record, the (crude) analogy I used was:
> > Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
> > but you are only allowed to pick up 10 of them (and put them in your
> > pocket). A smart move would be to survey the room *first and then*
> > pick up the largest ones. But if you are carrying a 500 lbs backpack,
> > you would just want to pick up whichever that's in front of you rather
> > than walk the entire room.
> >
> > MGLRU should only scan (or lookaround) secondary MMUs if it can be
> > done lockless. Otherwise, it should just fall back to the existing
> > approach, which existed in previous versions but is removed in this
> > version.
>
> Grabbing the MMU lock for write to scan sucks, no argument there. But
> can you please be specific about the impact of read lock v. RCU in the
> case of arm64? I had asked about this before and you never replied.
>
> My concern remains that adding support for software table walkers
> outside of the MMU lock entirely requires more work than just deferring
> the deallocation to an RCU callback. Walkers that previously assumed
> 'exclusive' access while holding the MMU lock for write must now cope
> with volatile PTEs.
>
> Yes, this problem already exists when hardware sets the AF, but the
> lock-free walker implementation needs to be generic so it can be applied
> for other PTE bits.

Direct reclaim is multi-threaded and each reclaimer can take the mmu
lock for read (testing the A-bit) or write (unmapping before paging
out) on arm64. The fundamental problem of using the readers-writer
lock in this case is priority inversion: the readers have lower
priority than the writers, so ideally, we don't want the readers to
block the writers at all.

Using my previous (crude) analogy: puting the bill right in front of
you (the writers) profits immediately whereas searching for the
largest bill (the readers) can be futile.

As I said earlier, I prefer we drop the arm64 support for now, but I
will not object to taking the mmu lock for read when clearing the
A-bit, as long as we fully understand the problem here and document it
clearly.
