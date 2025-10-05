Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA16258EEF
	for <kvmarm@lists.linux.dev>; Sun,  5 Oct 2025 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759676208; cv=none; b=Tlx48itleoh+/6V640T1AZelNgtItcZ2ynjiz7izUhx6EFFcg7k6LCc0xOt3znJTADzhjudB8SIrQD6FvIpSdz0gQtFH3Ru7j9CdADdjl30myFsXscmoHG7nKoC242DYNhfRxFdNifB9smH8CXWye+anGGl0CU3JTJQXmsdngX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759676208; c=relaxed/simple;
	bh=Yj4tiE4dTWU4yfDRcYohrrunQ86WlGRjquzJPgYlLoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qRD/iOzGskEOxy0vZL8HT6syHVnzsZZpje18HoqdO3krYAG6E9X7QboLYGywULg5PDAk2u5SH4vKBC4tzyWwnnd+mnzWvV/M+adDBteHWtxIQcM7PYQR/hwukEkdO0jKzTkwPO5TQVPkiLItXbsWXfIsJyLYqLbsIQX8o0ybjWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bM39Lkrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bM39Lkrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73EC4AF0B
	for <kvmarm@lists.linux.dev>; Sun,  5 Oct 2025 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759676208;
	bh=Yj4tiE4dTWU4yfDRcYohrrunQ86WlGRjquzJPgYlLoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bM39LkrnNqlprILFdRvaDox5bzxzS2ZLyd4b/WpKjBb7l/K7x+qXirkK+cOJTdNTC
	 3fe+/9CUlhP5Wm73T82uUg5mR0NIGY62ZMS34qPzzXrS1TyFEv4HcORRU4CtVpfRlv
	 E6NqAAjYn1TgPm2f8AKt4WMYL1cpimRHR0gr54ht/BGx0acP0ERt6WgTWITF5Gi3pg
	 SrPnRk8n/TeffzlvYlutXyG5lbRdoZ3dNoB0ot+X4617yvliFCApWnsa615NShxZmH
	 oaQQsVtG3wEId6xmZUXKoYyXKOYpR1PGF7959cR9nIXmU4FjBy/WMbrPncy2YYIkZs
	 EUX238+/UCznw==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-373a1ab2081so32674011fa.3
        for <kvmarm@lists.linux.dev>; Sun, 05 Oct 2025 07:56:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW18RnXEKgWJWVO7R96M/nNRhDzLvhuTjha3NOkKBk9nw6e0piky+uIx/uVtzuCOCarrwtY3U4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWlY2lCj+AcciNcX/xjpw+4gRowa8QO6ITxQEz/eYT6mogQRpl
	hxET7dEtrojVWFmJlW8ibzHQ0M6ztdzSMs75viDKZZq21FZ4/LlKGaCqvJR4uwXLXqqaOep8Q8F
	FH+1jIOmVs+f2sWg1HQzEMM5SNTJSISg=
X-Google-Smtp-Source: AGHT+IHTBpde/4YqplVs3DvfJcUY45IE5HyynZLYjJZCEhLnl34hecKm47NpIOXlv+NwHQkGQNpDfmKYcWNAPQWIcTw=
X-Received: by 2002:a2e:bd13:0:b0:372:a12c:45a5 with SMTP id
 38308e7fff4ca-374c3841062mr34212861fa.33.1759676206685; Sun, 05 Oct 2025
 07:56:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003183917.4209-1-will@kernel.org> <aOAZR0-4ZCq78DZ8@willie-the-truck>
In-Reply-To: <aOAZR0-4ZCq78DZ8@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 5 Oct 2025 16:56:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE0v7mtDbOLMmXkmSJVQFcjTPvib1D+MnHSHCfximyixA@mail.gmail.com>
X-Gm-Features: AS18NWCWnxptvHIz8dittp-mT7s9UTTlScpg8LcZAgmaKGO2Z1S4zTcYNuKocPU
Message-ID: <CAMj1kXE0v7mtDbOLMmXkmSJVQFcjTPvib1D+MnHSHCfximyixA@mail.gmail.com>
Subject: Re: [STABLE 5.15.y] [PATCH] KVM: arm64: Fix softirq masking in FPSIMD
 register saving sequence
To: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>, 
	Kenneth Van Alstyne <kvanals@kvanals.org>, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Oct 2025 at 20:43, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Oct 03, 2025 at 07:39:17PM +0100, Will Deacon wrote:
> > Stable commit 23249dade24e ("KVM: arm64: Fix kernel BUG() due to bad
> > backport of FPSIMD/SVE/SME fix") fixed a kernel BUG() caused by a bad
> > backport of upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally
> > save+flush host FPSIMD/SVE/SME state") by ensuring that softirqs are
> > disabled/enabled across the fpsimd register save operation.
> >
> > Unfortunately, although this fixes the original issue, it can now lead
> > to deadlock when re-enabling softirqs causes pending softirqs to be
> > handled with locks already held:
> >
> >  | BUG: spinlock recursion on CPU#7, CPU 3/KVM/57616
> >  |  lock: 0xffff3045ef850240, .magic: dead4ead, .owner: CPU 3/KVM/57616, .owner_cpu: 7
> >  | CPU: 7 PID: 57616 Comm: CPU 3/KVM Tainted: G           O       6.1.152 #1
> >  | Hardware name: SoftIron SoftIron Platform Mainboard/SoftIron Platform Mainboard, BIOS 1.31 May 11 2023
> >  | Call trace:
> >  |  dump_backtrace+0xe4/0x110
> >  |  show_stack+0x20/0x30
> >  |  dump_stack_lvl+0x6c/0x88
> >  |  dump_stack+0x18/0x34
> >  |  spin_dump+0x98/0xac
> >  |  do_raw_spin_lock+0x70/0x128
> >  |  _raw_spin_lock+0x18/0x28
> >  |  raw_spin_rq_lock_nested+0x18/0x28
> >  |  update_blocked_averages+0x70/0x550
> >  |  run_rebalance_domains+0x50/0x70
> >  |  handle_softirqs+0x198/0x328
> >  |  __do_softirq+0x1c/0x28
> >  |  ____do_softirq+0x18/0x28
> >  |  call_on_irq_stack+0x30/0x48
> >  |  do_softirq_own_stack+0x24/0x30
> >  |  do_softirq+0x74/0x90
> >  |  __local_bh_enable_ip+0x64/0x80
> >  |  fpsimd_save_and_flush_cpu_state+0x5c/0x68
> >  |  kvm_arch_vcpu_put_fp+0x4c/0x88
> >  |  kvm_arch_vcpu_put+0x28/0x88
> >  |  kvm_sched_out+0x38/0x58
> >  |  __schedule+0x55c/0x6c8
> >  |  schedule+0x60/0xa8
> >
> > Take a tiny step towards the upstream fix in 9b19700e623f ("arm64:
> > fpsimd: Drop unneeded 'busy' flag") by additionally disabling hardirqs
> > while saving the fpsimd registers.
> >
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Lee Jones <lee@kernel.org>
> > Cc: Sasha Levin <sashal@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org
>
> Sorry, Greg, I lost a stray '>' here ^^^  and so you didn't end up on CC
> for this one.
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
