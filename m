Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E12B428
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 19:04:52 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-4d19b2686a9so41009267b3.6
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 11:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZdECDAg9mmwgMiId+0pdkIRFxWXX0Q/ZbZP48ymAFw=;
        b=Giy1ebz7O7hQyLTIrtkNNdjBv+MOt2a11+O3yrLKdfi0gkb9lOByfeSgTPczfJEGb2
         p8d0RDgaBcgodvbREpLedfJYFzJ6sUh3y+/Kk2nB5wG0XWFvHIIwdRQir2FjfdWdS9Tj
         +rt17AF0fb7qkyCHUXHbr0WuZ+0k+UmlUL3XRsZ35z/NG8KC17aR/t4/C07kqwQtIjYu
         ik9/D70oGXpm9zYVjNL7tCpYbaSSHLrAJ0Kx6LokMM1zSa/Omk45VsI0lkLRYIZHjJ0t
         T4WywLp/HCTt1yfU3CMQr50DAEA47mnPOtX1zH6p6WhCGjVh6+PNei54Lb8VlWVsM6ML
         fO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ZdECDAg9mmwgMiId+0pdkIRFxWXX0Q/ZbZP48ymAFw=;
        b=kY0HEtfeHOz+qcjPp9Jxr/V2bfiC/PJ38mBe+gaKsFo0FK8PuxSsHSwtB9os/Vfr3x
         6G/jCwDtbu9dttZJxO/KXRKTCOTVXzvmGwxNASITNGgLWxWOXMtIwjm/BPpRNstlyS0X
         DzOXgv5DdqGEfdNyzUGXlHFbHOjFPOV5pf4Ry539aTOfR2+qfxjQfaJ2Qw4ccTyymsR5
         4Ja/vF06AH2naQUs51B7gSIr1nHpskEI61qGExEKVQoD9P35bSsofAabnPBFAxrn493K
         7sB7Ri6+5MG+3XUQ6VTtF6e6cWwb9VamuEyWAF/BOI/VX2rmzUHuop6yay9XYNxoNT/z
         xAKg==
X-Gm-Message-State: AFqh2kp7sfWQBDja1+zt+InTIOWGdYQmazd+iQbhkiXC2xenEX1mB47c
	L1i6DrxWT3bfp6FxeYPUEWJiBAcI35TtU87TUBV7PQ==
X-Google-Smtp-Source: AMrXdXtw3ClXGsau5g83hRYHF5bMmdLrbSAwU9zjlK/t8/PMP/LzBLrUT8Sd0TO+7LHePXlgOs+p8s15w/v0I2sj3tQ=
X-Received: by 2002:a81:4bd1:0:b0:478:1c89:6462 with SMTP id
 y200-20020a814bd1000000b004781c896462mr1433601ywa.150.1674155091041; Thu, 19
 Jan 2023 11:04:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <Y8l6egh2wWN7BUlZ@google.com>
 <86tu0mmo8m.wl-maz@kernel.org> <CALzav=dya7GsOD7-dm3649Xe4Xo_p5gJACvjZHtpbk0QwoU-gg@mail.gmail.com>
In-Reply-To: <CALzav=dya7GsOD7-dm3649Xe4Xo_p5gJACvjZHtpbk0QwoU-gg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 19 Jan 2023 11:04:24 -0800
Message-ID: <CALzav=ebYgZu2LfeQkspU_ke6GHbuPcpiST0pMafmAJGziybnA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 19, 2023 at 10:38 AM David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Jan 19, 2023 at 9:24 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 19 Jan 2023 17:14:34 +0000, David Matlack <dmatlack@google.com> wrote:
> > > I'd like to target RISC-V first, since it has significantly lower risk
> > > and complexity than e.g. ARM (which has pKVM, stage-1 walkers, and
> > > [soon] nested virtualization to deal with).
> >
> > And (joy, happiness), the upcoming 128bit page table support[1].
>
> Oh good, I was worried the ARM port was going to be too easy :)

But in all seriousness, I'm not too worried about supporting 128-bit
page tables in the Common MMU, assuming it is a compile-time decision.
The way I'm planning to organize the code, architecture-specific code
will own the PTEs, so each architecture can do whatever they want.
There is a hard-coded assumption that PTEs are u64 in the current
code, but we can abstract that behind a typedef for 128-bit support.

We will need to figure out how to deal with concurrency though. Will
128-bit page table support come with 128-bit atomic support (e.g.
compare-exchange)? If so we should be good to go. If not, we'll need
to emulate them with e.g. spinlocks. But either way, figuring this out
is not specific to the Common MMU. Even if ARM kept its own stage-2
MMU we'd have to solve the same problem there.
