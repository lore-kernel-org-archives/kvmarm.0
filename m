Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17A6C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 21:06:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D48D4B960;
	Mon, 12 Dec 2022 16:06:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wc2AzKWpcRq5; Mon, 12 Dec 2022 16:06:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4EA4B93C;
	Mon, 12 Dec 2022 16:06:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF44C4B93C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:06:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4E7MtozwnVBo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 16:06:24 -0500 (EST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B34924B8F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:06:24 -0500 (EST)
Received: by mail-yb1-f182.google.com with SMTP id e141so15273905ybh.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=laikB1VLAeGRWOf0AMzEFlNYL3CqEDRBB2MgG+//i8MFppAe8tylU6rcal5YrAtw7H
 XCJo3lLjCBeC3ysslA7q1sC4CUAh9a7snASOkPT2yniRs7TIfGL3Vavca5Fzb1HUXkrB
 yfsheVLkRaUUJilstET0dylup1JZxI+/srHSoIiDbuBIAMAjM3O7MlDJyksNNnp5f625
 ht+JLb2VdKMPkkAelgaBr3pqIkI1gV86pOgryR1YgAHQiOm3BlZLgFSX6HBMMLIeX9Iy
 48hOu5l39e7uRY/rLtRzBKc9MtnbKwTaWcj95pY1REuq6LzFZHVpZODRT/OKRQRskf7p
 LP7Q==
X-Gm-Message-State: ANoB5pnur7xrhFuHrn63MHRxZZfKwEel21+K+bgMz/GY6Ou/ZTqKInTD
 xOq2m1c9uI3djNebRK3C8Ux05a6ujOsYf+e3oq78rA==
X-Google-Smtp-Source: AA0mqf6t0tL+M5odHwBkmEtWZ3JrhY8ZOtTx4LY0nKQZE8xDjE9jvCGoO42nxIdR/mBoqjExkkZ8XXCco0Q3+sfbdfg=
X-Received: by 2002:a25:742:0:b0:6fd:6aa4:82a5 with SMTP id
 63-20020a250742000000b006fd6aa482a5mr26123897ybh.305.1670879183958; Mon, 12
 Dec 2022 13:06:23 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-21-dmatlack@google.com>
 <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
In-Reply-To: <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 13:05:57 -0800
Message-ID: <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
To: Ben Gardon <bgardon@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
