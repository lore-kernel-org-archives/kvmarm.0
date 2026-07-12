Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B73033F8
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783873217; cv=none; b=AI9bqieK/51LKbW4aCWx9ujWWravBloDPYHwfw8b6o7jv8Q9pDe2Y245uVIIY14/JGtf/lY+s58QIYbb1rRqmO4ampQe7pf+gMh3adN4I83Mw7whWjUr2hPSxostKtiPBncUBXy4m6hz/+W1a6KuN4ORyIHbHZ8C/urFmLhNoLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783873217; c=relaxed/simple;
	bh=TfN4R7MqLyKIjmZTr3oZQoogoaNxuVYWyndAJVZQTYQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxYjPGWQLPL4oqbi7CNy3PlyDEJdLgrUTq9wDxy3+TH/CS7uPCkbPYTJ9PQWzRiiOy95/osQuoj2ZbqBQ8yCPjHXNDrptX0lVOKX24aeKHjA/799tvl0/2oyJ3lHgrP0iUbpenketi4fVQn4+XtGr1lFWOoi/fcGHJwL/HjThP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JQOunDuc; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JQOunDuc"
X-Forwarded-Encrypted: i=1; AHgh+Rqez4VyNQD4FGA6lsqWJeeiyygTktP8LAfX3/umJpCiZyjrHSPX/9hHDQgq/G5Gy5+GWDG8nN8=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783873214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=janMU5MXezvmZmqnJkQjOF/ir5w8di28OoznHFU8LA0=;
	b=JQOunDuciGCpZNsZXTI+ojfg4GsIBPFAta1XpUXixlseTzRYfPr1vhmfAuT85m3/E7tza8
	vylGBz9exv9LM8Sb3LClR0hqAxHuJHfHkBQEU9/xZVzyM7c874H7S4MskLhaDtVvWJLphR
	vqOwCeq0r7aJMSsXr6LRl5Mmc1xQ6d8=
X-Gm-Message-State: AOJu0YxaDq+mt0q12huhkqte7zTzyKNtZGTimUUR51snZT/aRmhT3LWf
	eywB8z83K5n55/ZD6bRorsbEGfJpzCsGUhT3DhjIQ1d8pG4aq1jy/fY94maBLGIeeaCjatZaFgp
	OItF9jApyCzQDtYbDPdrjzPMFoQmA+5X4o4dcKhCC
X-Received: by 2002:a05:622a:5805:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-51cc08385e1mr10853171cf.11.1783873199708; Sun, 12 Jul 2026
 09:19:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260712153835.2264905-1-smostafa@google.com>
In-Reply-To: <20260712153835.2264905-1-smostafa@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 12 Jul 2026 17:19:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
X-Gm-Features: AUfX_mw9S0OZ_DagkNOYZ4ShM2Ytghc_E4HL25aTJrhUWph1A1thQJPgeFVqwv0
Message-ID: <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Mostafa,

On Sun, 12 Jul 2026 at 16:38, Mostafa Saleh <smostafa@google.com> wrote:
>
> When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> defines a static inline stub for trace_clock().
>
> However, trace_clock() is already declared as an extern function in
> linux/trace_clock.h which is pulled in EL2 compilation.

The rename itself looks correct and complete: all three sites (the
declarations and stubs in nvhe/clock.h, the definitions in clock.c,
and the two callers in trace.c) are updated, and no other reference to
the old names remains under arch/arm64/kvm.

Two small things...

>
> If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> is disabled (by including it manually in setup.c) it will cause:
> In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
>
> ./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declaratio=
n of =E2=80=98trace_clock=E2=80=99 follows non-static declaration
>
>    14 | static inline u64 trace_clock(void) { return 0; }
>
>       |                   ^~~~~~~~~~~
>
> on GCC and a linker error on LLVM (it seems to change the linkage to
> global)
>
> Although that is not a problem at the moment, as no other files
> include <nvhe/clock.h>. That does not seem to be the intent of
> this code and that will cause issues with more users as the SMMUv3
> driver.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
>
> --

git am only treats a three-dash "---" line as the scissors; the "--"
here is two dashes, so mailinfo keeps everything above the diffstat.
Worth a "---" on the repost so the note stays out of the log.

> I did not add Fixes tag as this is currently dormant and not breaking
> anything.
> ---
>  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
>  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp=
/include/nvhe/clock.h
> index 9f429f5c0664..c2ccd0e8bf22 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> @@ -6,11 +6,11 @@
>  #include <asm/kvm_hyp.h>
>
>  #ifdef CONFIG_NVHE_EL2_TRACING
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc=
);
> -u64 trace_clock(void);
> +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch=
_cyc);
> +u64 hyp_trace_clock(void);

hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
already has a struct hyp_trace_clock and static helpers
hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
of the same clock. No actual collision, so this is only a readability
point, but a reader grepping hyp_trace_clock now gets two unrelated
things. Maybe you'd want to consider a different name, but naming is
hard :)

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Test: builds fine with the different config enables.

Cheers,
/fuad


>  #else
>  static inline void
> -trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> -static inline u64 trace_clock(void) { return 0; }
> +hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)=
 { }
> +static inline u64 hyp_trace_clock(void) { return 0; }
>  #endif
>  #endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/cl=
ock.c
> index a7fc61976fd0..8adefb0b696c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -30,7 +30,7 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 =
shift)
>  }
>
>  /* Does not guarantee no reader on the modified bank. */
> -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc=
)
> +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch=
_cyc)
>  {
>         struct clock_data *clock =3D &trace_clock_data;
>         u64 bank =3D clock->cur ^ 1;
> @@ -48,7 +48,7 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_=
ns, u64 epoch_cyc)
>  }
>
>  /* Use untrusted host data */
> -u64 trace_clock(void)
> +u64 hyp_trace_clock(void)
>  {
>         struct clock_data *clock =3D &trace_clock_data;
>         u64 bank =3D smp_load_acquire(&clock->cur);
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/tr=
ace.c
> index e7e150ab265f..f2a32463c6c2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_bu=
ffer *trace_buffer)
>  void *tracing_reserve_entry(unsigned long length)
>  {
>         return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simpl=
e_rbs), length,
> -                                         trace_clock());
> +                                         hyp_trace_clock());
>  }
>
>  void tracing_commit_entry(void)
> @@ -290,7 +290,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 =
epoch_ns, u64 epoch_cyc)
>         }
>
>         /* ...we can now override the old one and swap. */
> -       trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
> +       hyp_trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
>  }
>
>  int __tracing_reset(unsigned int cpu)
> --
> 2.55.0.795.g602f6c329a-goog
>
