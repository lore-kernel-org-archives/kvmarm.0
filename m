Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE656FD9
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 21:06:25 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id b16so15344165yba.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 13:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=as6M7rF8vu2B1VLzLGLnujoNEHxjqSZF2ixbKuvGXxE=;
        b=jIhGaXVnl3YvAnDSTeWQFwWR+xDHpsjs16kACsfVA5aKtf91JC05OJjmUmKeP0nkpM
         SnDACAK7EvYaQ0k+/SaN1mEHgyH0DYgRRStukX7P77NP1FuYigKrflB4Ki4chVKDLckx
         PcbOzgjjYKRLK44+Pe1nn5owF1kec2HNqSnIpRfr7QP2EE/vpPFzlWfDvSdDUaVVenod
         N2kzbeLjIoQucXZh1kYPlKrgL+ICtIDFTpL/2QNV3RfTDJQxiKbZ0U4k49qhwdvrXZew
         rCl3bxQP1QGlSh1wnz8qOTaqIvdkcp0n2w91WmgfaTkcQxK4hFcijjPmc+qIiQbMg51Q
         ysyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as6M7rF8vu2B1VLzLGLnujoNEHxjqSZF2ixbKuvGXxE=;
        b=CGVyviV722Cz4zOs6/m3MhZcxlsvW81Bjh+y1sGwuegvMgMixRpw5LDAdZogcyPWem
         qDFsFqdSbKphbPY8ZLykgRwzQ4MUDP7fcXzsDJFuSrDjQ56iPKUK5vaQTBzxE+ArVxNX
         rp+wbV3bVbGwQEk0HQ2537IdjCnt0xVNDpmR8Mc6gScSUk8peOkhFMOyGaRfS7namnGC
         TXMTfIPxMDdQ3TXoW90+tCS9oLiuuqXH2Xc1tGDPyz7oklRcfl8Hf9NV0FONxjhANH+i
         1OShWDEJMGq4HqshZTro3Ec91SrcEbGiv8FymycuB/TNU1bQ1iaNOBZa8NNhDl5CugFd
         wOwg==
X-Gm-Message-State: ANoB5pljYnO5430KOfgtroERJxRJaITSnUUMiecRPIFtF3iSPf/70i4M
	AyD7aYKOp35oXaIJqlBtBuPC1cH+6br+d+awdfTpNQ==
X-Google-Smtp-Source: AA0mqf6t0tL+M5odHwBkmEtWZ3JrhY8ZOtTx4LY0nKQZE8xDjE9jvCGoO42nxIdR/mBoqjExkkZ8XXCco0Q3+sfbdfg=
X-Received: by 2002:a25:742:0:b0:6fd:6aa4:82a5 with SMTP id
 63-20020a250742000000b006fd6aa482a5mr26123897ybh.305.1670879183958; Mon, 12
 Dec 2022 13:06:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-21-dmatlack@google.com>
 <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
In-Reply-To: <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 13:05:57 -0800
Message-ID: <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
To: Ben Gardon <bgardon@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Krish Sadhukhan <krish.sadhukhan@oracle.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221212210557.BTOFqwTIBpyaK0ylkk4pF5UDmwXHJFp51kvrBUTdq_w@z>

On Mon, Dec 12, 2022 at 11:32 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
> > function for computing the max level that a given GFN can be mapped in
> > KVM's page tables. This will be used in a future commit to enable moving
> > the TDP MMU to common code.
> >
> > Provide a default implementation for non-x86 architectures that just
> > returns the max level. This will result in more zapping than necessary
> > when disabling dirty logging (i.e. less than optimal performance) but no
> > correctness issues.
>
> Apologies if you already implemented it in a later patch in this
> series, but would it not at least be possible to port
> host_pfn_mapping_level to common code and check that?
> I'm assuming, though I could be wrong, that all archs map GFNs with at
> most a host page table granularity mapping.
> I suppose that doesn't strictly need to be included in this series,
> but it would be worth addressing in the commit description.

It's not implemented later in this series, but I agree it's something
we should do. In fact, it's worth doing regardless of this series as a
way to share more code across architectures (e.g. KVM/ARM has it's own
version in arch/arm64/kvm/mmu.c:get_user_mapping_size()).
