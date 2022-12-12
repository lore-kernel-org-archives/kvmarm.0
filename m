Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E82C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:42:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69ACB4B918;
	Mon, 12 Dec 2022 17:42:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kNNrDP4Nco+Q; Mon, 12 Dec 2022 17:42:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 410E64B91C;
	Mon, 12 Dec 2022 17:42:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D28C4B91C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:42:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IvJMNyjCaTC8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:42:54 -0500 (EST)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C22D4B918
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:42:53 -0500 (EST)
Received: by mail-yw1-f178.google.com with SMTP id
 00721157ae682-3e78d07ab4fso168305977b3.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=xlakFXRE5WR+eI81tSHGT8mBX3C2kTQwJgOLsFBL4OY=;
 b=ndwFSRoXLSuq0mtL5gu3GohHZTtCmsXoG5LnB+4W5ntMQyw7hg7yWmVnEVKI/CMMjq
 KrRV2sbCGqD+H+xzIvKYj1uByps5sG637+06KzojhBb8JdEZSaKaduwj2AG/udwtUpyt
 ek+ZoO9A0+tsd50WkNyDpm1NuAuM3Y5dUIJvdzOEDIi6I+KRA7WOdHGwAFMZnvKcKJm8
 sMmoQVLveW58rH19lDfr14dd1014L5iT8SfRCYVc1nc0+/mzoEy8/Q6/90V5+D11cSnV
 VR0IEIuzVXTRNeTb22H3kEKuvjJHEQSBOYF1lXueeHZG7VZeReMvOUQqeeOQrxzxcfeM
 2TJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=xlakFXRE5WR+eI81tSHGT8mBX3C2kTQwJgOLsFBL4OY=;
 b=5OKmFLx6UqivqtbTD3h3y2Arl6yts8LUl9q1zxIubrKyF6BvyQtG+x8Z+g8WfF5x8Q
 4zdp9zQaz3CrglLzN1rQh0nHo7u0s43ck+mBvasJvW173BjveqMZmkNcb3xxPA0NbvQJ
 hRZJydX3hueUJ5jL5ca8SGE/eQGMKe7LfI0US5B5i+jkEibHrfs3mBoKBcOjncV9+8t5
 ave7xv+AEbZOmm6mlUXTe+Iqu/sOOVngkyd9T/+9ioHVANfwIm4sjsZsVE88SCgMx7oI
 WU5xc8ARfaizHpySwgkHCLGgzMlew/ik8OIjfNbWq5WGS9cfJwiWDptIBK9HuNoQJZTT
 QoTQ==
X-Gm-Message-State: ANoB5plHvL66vZ95gMNAcc4AV6wFyxJ4uHsAsem0gyDHSzPIg/p+FqcU
 pZOwJCsuFpRnWRntMtPrPYcv3wSUboPqqEUa5xqTgA==
X-Google-Smtp-Source: AA0mqf44l006Q6QVS5WsjpiBIi3T4SW6bvJpPAfR1juAzLaGPOaG7kqLyOnkKrJsuk2Vx7E4bBJKqTB5CVZjDntvdQc=
X-Received: by 2002:a0d:df0a:0:b0:35f:9c14:144a with SMTP id
 i10-20020a0ddf0a000000b0035f9c14144amr26604984ywe.209.1670884973326; Mon, 12
 Dec 2022 14:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-34-dmatlack@google.com>
 <CANgfPd_069QPNby+mR4GuOWDNJtFk_=9EOffb0=2_V5TH-ZCDA@mail.gmail.com>
In-Reply-To: <CANgfPd_069QPNby+mR4GuOWDNJtFk_=9EOffb0=2_V5TH-ZCDA@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 14:42:27 -0800
Message-ID: <CALzav=fMX0g_n9pVFsLShZjEkPLquo2u_QpPMPzUMAGYtjZFOw@mail.gmail.com>
Subject: Re: [RFC PATCH 33/37] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
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

On Mon, Dec 12, 2022 at 2:03 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Thu, Dec 8, 2022 at 11:40 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> > "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> > range-based TLB invalidation where the range is defined by the memslot.
> > Now that kvm_flush_remote_tlbs_range() can be called from common code we
> > can just use that and drop a bunch of duplicate code from the arch
> > directories.
> >
> > Note this adds a lockdep assertion for slot_lock being held when calling
> > kvm_flush_remote_tlbs_memslot(), which was previously only asserted on
> > x86.
>
> Besides the one lockdep assertion, is there any benefit to having this
> wrapper function? Open-coding "kvm_flush_remote_tlbs_range(kvm,
> memslot->base_gfn, memslot->npages);" is only a slightly longer line
> and, IMO, just as readable. I'm happy to see this cleanup, but it
> might be just as easy to drop the function.

The wrapper makes lines shorter, adds a lockdep assertion, and is just
as readable. What's the reason to drop it?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
