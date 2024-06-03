Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00413C9C8
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717454799; cv=none; b=L7yjFuCLwhOJYhIxNalQO66vYpmH35mENyHmWYi/WFD29SS3rr5UwhFFzEE2qFMt4TgbZkOiDkhDPoaSWQlx9G0Q8YZld1jcQo4Lqq5Vqpwn9x3pcZWyJE5MnIzsRckAolqH48RjgWCqykHJ/xdMkrCHTdfcnUDxU/aFImSIb0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717454799; c=relaxed/simple;
	bh=0SDC8BkbIu6webNUXhyFkkBsSVcdj+Sq6u/l89WhDUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JrKeRcdDK/tX7jHWU2MS250TyZuaWDDGjXEsTe9xK7RgROJgEJIOtNR7qLgBlQr0Ft2XsSWS24K8pqOdWGTITPNFdQJeYSQrvU5AXLFUNnpz4Pjxdl3O967lu8k4X542axF288cH0o7WL9PfnlB8Tg6Dy3u9FEayJozTacovsjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qVhVdeRC; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qVhVdeRC"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-43dfe020675so119741cf.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717454796; x=1718059596; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwApvMmCxi6kRvhFpeZNrHVjs/fSYi202Vq8O0y7Pvc=;
        b=qVhVdeRCulbSABKl8NrD/egxQbXDyqGNlv3hafxYyMgNdv6C4H+Awu49g5I1izDfXS
         ThzyexBd7To/iFp2ZJVac8j1VzE9eJpdygjg1NaBnk+4WnMhHLk/0vZLztKXCtAAINlc
         iycEEsqPXwyAARB31UMCbccOTvGAIuTbhdE4OMNz3faAFRKpofoSd1F0/yk1XmLCBpUC
         z+GDIig5PF+wi7T6jf+rEKOAS0LqMU2/60PeW6iZYvcg+xovPPWiTXpuSMu24SNreyyr
         te6vl7BJowTyP2pUuBjISVm2mtZmonBhHOvJMZMiNpJQL0/h4oQygPc2XyhO+LuxctCx
         L06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717454796; x=1718059596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zwApvMmCxi6kRvhFpeZNrHVjs/fSYi202Vq8O0y7Pvc=;
        b=d8woSnMZCzX56BAtVBHCvR1qTDPyLL2Dgt5EbltgfM7lNdZr0RIxnSTJnnk7TsjnEi
         PNyWEQ7lnkpIuwrW34/2EmwEAeR+NFI32xRdolamtY+nhVC1eB1/NrM8SXDXVBd3wJ9x
         unSINsKTiTuyDHbgT5tW8O/vqedMsqIlrDgGdZYhxmtEBmvZGD7gsPbqWaka76K3U87S
         gNQno5ChizjLNlG6yAe/K/mTSWgX8CumJl1w65ISs94ODoOZDwGBcnOyAI3DdF+7/yQU
         AaHjJUhpfLOsTN0EkakMqRsrhrKc6cqj7loNUd7fBBuL+VecF1bCFTBSm7KlGvpB1NEn
         Wb9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWikrPcfCSik2swLC4q88+0x0Rsz0hOJKdJkBsyyQ9IbbwKti9O8SlUdNAc5lC7g+uSK/imgVpO3CIHXG9kR2+mdD9wBN46
X-Gm-Message-State: AOJu0Yygg2U1FNteQf8Xl43Z1GFZA9c1kYNcP0gyXqLZRxwf5cuQaKRP
	TDUbZttk10xCr/2WDzhb0W0LJaTZFTE/fh9AfGQl18JU+syyjaYEggpQJktnrkq9XgB1fkBDQc4
	DROhPrQTS5XyUsdY5JTYLI7DQvesgFlzlFIT6
X-Google-Smtp-Source: AGHT+IFNqO3Eeca3fb/gjbGejzk9epZFQKuRMTX94UERp2ub7SAJHzg0ElHPjQ2U8grOlDfvsiNhgYwFk5rOK4wQGMU=
X-Received: by 2002:a05:622a:59ce:b0:43f:ff89:dfb9 with SMTP id
 d75a77b69052e-4401bd281f4mr1732131cf.6.1717454795966; Mon, 03 Jun 2024
 15:46:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
 <Zley-u_dOlZ-S-a6@google.com> <CADrL8HXHWg_MkApYQTngzmN21NEGNWC6KzJDw_Lm63JHJkR=5A@mail.gmail.com>
 <CAOUHufZq6DwpStzHtjG+TOiHaQ6FFbkTfHMCe8Yy0n_M9MKdqw@mail.gmail.com>
In-Reply-To: <CAOUHufZq6DwpStzHtjG+TOiHaQ6FFbkTfHMCe8Yy0n_M9MKdqw@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 3 Jun 2024 15:45:59 -0700
Message-ID: <CADrL8HW44Hx_Ejx_6+FVKt1V17PdgT6rw+sNtKzumqc9UCVDfA@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Yu Zhao <yuzhao@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:06=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> On Wed, May 29, 2024 at 7:08=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Hi Yu, Sean,
> >
> > Perhaps I "simplified" this bit of the series a little bit too much.
> > Being able to opportunistically do aging with KVM (even without
> > setting the Kconfig) is valuable.
> >
> > IIUC, we have the following possibilities:
> > - v4: aging with KVM is done if the new Kconfig is set.
> > - v3: aging with KVM is always done.
>
> This is not true -- in v3, MGLRU only scans secondary MMUs if it can
> be done locklessly on x86. It uses a bitmap to imply this requirement.
>
> > - v2: aging with KVM is done when the architecture reports that it can
> > probably be done locklessly, set at KVM MMU init time.
>
> Not really -- it's only done if it can be done locklessly on both x86 and=
 arm64.
>
> > - Another possibility?: aging with KVM is only done exactly when it
> > can be done locklessly (i.e., mmu_notifier_test/clear_young() called
> > such that it will not grab any locks).
>
> This is exactly the case for v2.

Thanks for clarifying; sorry for getting this wrong.

>
> > I like the v4 approach because:
> > 1. We can choose whether or not to do aging with KVM no matter what
> > architecture we're using (without requiring userspace be aware to
> > disable the feature at runtime with sysfs to avoid regressing
> > performance if they don't care about proactive reclaim).
> > 2. If we check the new feature bit (0x8) in sysfs, we can know for
> > sure if aging is meant to be working or not. The selftest changes I
> > made won't work properly unless there is a way to be sure that aging
> > is working with KVM.
>
> I'm not convinced, but it doesn't mean your point of view is invalid.
> If you fully understand the implications of your design choice and
> document them, I will not object.
>
> All optimizations in v2 were measured step by step. Even that bitmap,
> which might be considered overengineered, brought a readily
> measuarable 4% improvement in memcached throughput on Altra Max
> swapping to Optane:
>
> Using the bitmap (64 KVM PTEs for each call)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50
> Latency     p99 Latency   p99.9 Latency       KB/sec
> -------------------------------------------------------------------------=
---------------------------------------------------
> Sets            0.00          ---          ---             ---
>     ---             ---             ---         0.00
> Gets      1012801.92    431436.92     14965.11         0.06246
> 0.04700         0.16700         4.31900     39635.83
> Waits           0.00          ---          ---             ---
>     ---             ---             ---          ---
> Totals    1012801.92    431436.92     14965.11         0.06246
> 0.04700         0.16700         4.31900     39635.83
>
>
> Not using the bitmap (1 KVM PTEs for each call)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50
> Latency     p99 Latency   p99.9 Latency       KB/sec
> -------------------------------------------------------------------------=
---------------------------------------------------
> Sets            0.00          ---          ---             ---
>     ---             ---             ---         0.00
> Gets       968210.02    412443.85     14303.89         0.06517
> 0.04700         0.15900         7.42300     37890.74
> Waits           0.00          ---          ---             ---
>     ---             ---             ---          ---
> Totals     968210.02    412443.85     14303.89         0.06517
> 0.04700         0.15900         7.42300     37890.74
>
>
> FlameGraphs with bitmap (1.svg) and without bitmap (2.svg) attached.
>
> What I don't think is acceptable is simplifying those optimizations
> out without documenting your justifications (I would even call it a
> design change, rather than simplification, from v3 to v4).

I'll put back something similar to what you had before (like a
test_clear_young() with a "fast" parameter instead of "bitmap"). I
like the idea of having a new mmu notifier, like
fast_test_clear_young(), while leaving test_young() and clear_young()
unchanged (where "fast" means "prioritize speed over accuracy"). It
seems a little more straightforward that way.

>
> > For look-around at eviction time:
> > - v4: done if the main mm PTE was young and no MMU notifiers are subscr=
ibed.
> > - v2/v3: done if the main mm PTE was young or (the SPTE was young and
> > the MMU notifier was lockless/fast).
>
> The host and secondary MMUs are two *independent* cases, IMO:
> 1. lookaround the host MMU if the PTE mapping the folio under reclaim is =
young.
> 2. lookaround the secondary MMU if it can be done locklessly.
>
> So the v2/v3 behavior sounds a lot more reasonable to me.

I'll restore the v2/v3 behavior. I initially removed it because,
without batching, we (mostly) lose the spatial locality that, IIUC,
look-around is designed to exploit.

>
> Also a nit -- don't use 'else' in the following case (should_look_around(=
)):
>
>   if (foo)
>     return bar;
>   else
>     do_something();

Oh, yes, sorry. I wrote and rewrote should_look_around() quite a few
times while trying to figure out what made sense in a no-batching
series. I'll fix this.

>
> > I made this logic change as part of removing batching.
> >
> > I'd really appreciate guidance on what the correct thing to do is.
> >
> > In my mind, what would work great is: by default, do aging exactly
> > when KVM can do it locklessly, and then have a Kconfig to always have
> > MGLRU to do aging with KVM if a user really cares about proactive
> > reclaim (when the feature bit is set). The selftest can check the
> > Kconfig + feature bit to know for sure if aging will be done.
>
> I still don't see how that Kconfig helps. Or why the new static branch
> isn't enough?

Without a special Kconfig, the feature bit just tells us that aging
with KVM is possible, not that it will necessarily be done. For the
self-test, it'd be good to know exactly when aging is being done or
not, so having a Kconfig like LRU_GEN_ALWAYS_WALK_SECONDARY_MMU would
help make the self-test set the right expectations for aging.

The Kconfig would also allow a user to know that, no matter what,
we're going to get correct age data for VMs, even if, say, we're using
the shadow MMU. This is somewhat important for me/Google Cloud. Is
that reasonable? Maybe there's a better solution.
