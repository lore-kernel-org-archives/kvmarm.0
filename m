Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548C1C9EC9
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717019999; cv=none; b=iq9nbgYT22o5vaIJTvAl43KgfiIaNlPFO/5JnSyklWgFzlarjkqDA0LHhvkXJpXEI2llocQTEAmu2uwa6bfhpPhMkpLSZ2Aqf3lFc47Tzs77rEMCHqqygh1ROaRbaQ7m+IfQHl3Z9Lu24y1IpgTtsx6ChLyKMMWvzubf0mGqmzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717019999; c=relaxed/simple;
	bh=VygQSYtgJkxGCNbSiB1TmlrjiVcPo9FASZn5iwrGyKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XmulC1OppKJsjE7neqWbiKGLT8K1zgFSG6gQHmuLUtbZ6rxHRVozUcNurLXyM8MeQIY1ELoPkCNg/VXJwnFcUGMoI8asCXj4t7OdS1ev7lsLsQzoqRN4s6KjyWvfZy7BQFFzJS2PX2EIoLbM0/uZwDNkwW5Z9jo0eFKlLbyOD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3xnmuBZP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3xnmuBZP"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6fb22ecd976so146535b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 14:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717019997; x=1717624797; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VygQSYtgJkxGCNbSiB1TmlrjiVcPo9FASZn5iwrGyKo=;
        b=3xnmuBZPFeI72U9jWxxcxMQZqVIKpEitZ55vqCY1J/ZDt+dsMtB+Xa6WTLGELMchIf
         ZZieYYcRTEq23hYFb9om9W54Y4rXkfH/UwR6xDO/Z9txuLnUIzFx3kk0llgcEcg5j5kc
         9ONvExkr4CqTkS2qBZWxedmbbOGtICSXu710Z8Ib42bZa+VTqdxDMoGJ36tEDysSQ5t3
         SN0/AFRuldIB+cEyn4qWfNJOrw4QM8/gRZLgd4sOPaDkYmqYK+7SoMS5+FRMMgIzlYSs
         BsL2OUQFCE4B4HxBoZS1mT2a66STivXs4UKyg9lyqysJo4Phdptyz0tsXGQaTw3OSKoI
         +NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717019997; x=1717624797;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VygQSYtgJkxGCNbSiB1TmlrjiVcPo9FASZn5iwrGyKo=;
        b=YqCTNCeomIe02ZS7U9PsVkLXsnhY04tYO0ESAxqLIu49h/Gb8+RAJuBuf3oSp6ztk7
         MhHWiMUmyHFg8FWuAO8Mo2yYtNHQZPifIiEh5nt5xYRyucTtvBiibf71csJ0Z/R5QAYe
         ye26siIMvRVgm36hE92r0hy9R7PXGg/1UsaqtWahfdBkBhnbj1+XGvILrVkMmHbT/2yq
         Gog/jVsVQDI57jFlQT2yuLGOULhgHduA/lsEOqejS7Mshm50pNVWFLBeEC15EKa/rDnJ
         DJGaHfOveqPD4O6Zn7HtysmUl3cBz4TLRZfsUZeBtibCk6fDjaK19NPc3X8aV/tBmR55
         XE8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUvOVRcTUu/CfaQeHVPv8UhF9xzvwk5lFeZcUp7xRjKHJAsP8sdliqYEsXoZ6OKDEc0MXkzh8Sek7be6z08gz2GxPAO+kEt
X-Gm-Message-State: AOJu0Yy1tDliS1FsrzzmlZ2kQTrNwtCTQ8PV+1D2Y9TkIvFKYRWNzvlF
	8wq5B7xrhNR5mkXyCM6hHZ8NQL/AIXJwUaMDMyWZggoN4BzYGi8OfeU6YgHFfUoGJYxh106Y37i
	hZA==
X-Google-Smtp-Source: AGHT+IErfD3/6U7Yg0vFWmN+JznLDOE9vgR2lO1JhTGk52Ll6iOJE5uAx2O1dqENYjCcQTLMPcB8oRdC9wY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8607:b0:702:1e25:a47c with SMTP id
 d2e1a72fcca58-70231a8676amr343b3a.1.1717019996755; Wed, 29 May 2024 14:59:56
 -0700 (PDT)
Date: Wed, 29 May 2024 14:59:55 -0700
In-Reply-To: <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
Message-ID: <ZlelW93_T6P-ZuSZ@google.com>
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
> On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@googl=
e.com> wrote:
> >
> > Secondary MMUs are currently consulted for access/age information at
> > eviction time, but before then, we don't get accurate age information.
> > That is, pages that are mostly accessed through a secondary MMU (like
> > guest memory, used by KVM) will always just proceed down to the oldest
> > generation, and then at eviction time, if KVM reports the page to be
> > young, the page will be activated/promoted back to the youngest
> > generation.
>=20
> Correct, and as I explained offline, this is the only reasonable
> behavior if we can't locklessly walk secondary MMUs.
>=20
> Just for the record, the (crude) analogy I used was:
> Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
> but you are only allowed to pick up 10 of them (and put them in your
> pocket). A smart move would be to survey the room *first and then*
> pick up the largest ones. But if you are carrying a 500 lbs backpack,
> you would just want to pick up whichever that's in front of you rather
> than walk the entire room.
>=20
> MGLRU should only scan (or lookaround) secondary MMUs if it can be
> done lockless. Otherwise, it should just fall back to the existing
> approach, which existed in previous versions but is removed in this
> version.

IIUC, by "existing approach" you mean completely ignore secondary MMUs that=
 don't
implement a lockless walk?
