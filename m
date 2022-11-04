Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DBBC43217
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 17:42:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 004FF413E2;
	Fri,  4 Nov 2022 13:42:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PbVZRk0lauwQ; Fri,  4 Nov 2022 13:42:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE0B40E25;
	Fri,  4 Nov 2022 13:42:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8773340BFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 13:42:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cIasvVe+54W8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 13:42:40 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C10640B41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 13:42:39 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id a14so8048003wru.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 10:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=gZRaWO/V1xiqx1eDC7r3VOOHIFPvaFpSyP31c7Jcw6s=;
 b=moVmMmYBwK6xOn+awu4Z2/Q+mLOImqr4cXxGAy1//sAXvXmk+uwiPJ1KnAFv/5MJdx
 WKxFXzVqwdlx5SH8sQFjR9m9CemQd5+udzUFNvRd3Duvl4mjdkzhwN4SfCmPCd5bBNZL
 M+XbukpM6pFEup0kX94kJUjYR8wzIVuzxtYCSWzOmxRcpykfgbMZ69effEZvbi0o7Qce
 qfMq9cLcShSfWjlyjW2f4Es9+mlJ48cQsRneRwUj7IvcgsoyV+nC0RY/Y2XIX64ZsN/7
 Yo4WRHqM2sfKt7yzKGgr5+DrH0R0IrBCRpz3dahyUL1Enwik8EfkA2IwMLrcAXvE0q4l
 FKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=gZRaWO/V1xiqx1eDC7r3VOOHIFPvaFpSyP31c7Jcw6s=;
 b=YC04CZ4ZXljy5239+WI6N/Rzk+U0gNxiTnkoK+CBLup/Z6sjtVdFY70JgJ/JPUd7bp
 8YyOuZJp3TblMZG/cLUSXa2C2Mmi+EXaQUEzcGjMSGfs6/jFYKO1GUFiMwYPNThS1Qr0
 z5Hebonufhh4G2+eRhEczKepT4FC2LSY0X7OgswyF/B55ElVdLXEsNv7o3h0TyfgtiWd
 1qBZiXefa6q+H/ta95FljoMsY57qbYOyOttl8KmXQ11aKYtNTHTvvJGI8D45O2jV+L4j
 m5tBZmNRMbGto3F1xZUCFQ2XVin5TR9Vmi3mTWX4tM/cON4SA2WTpB+MbgggG8C6IUvY
 3j/w==
X-Gm-Message-State: ACrzQf3i3n86Ar7lfKK0rXPDFmA2a1r+jS21g9aVlOqAk7Lh3rY/govC
 mt2q99rC3ECLgUeLmDZymO2cvX/Gw1SII1xr4GwBsQ==
X-Google-Smtp-Source: AMsMyM6oeAl9VU7IukG+ufk/d0220k0kvPLgAWMaVWWu9lfDLGiKZIeuyB2sA3qpRQ42h5Db8GK0C/zT7dQz5Xt2uI8=
X-Received: by 2002:a5d:53cf:0:b0:236:bbc0:236 with SMTP id
 a15-20020a5d53cf000000b00236bbc00236mr21494089wrw.572.1667583758732; Fri, 04
 Nov 2022 10:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
 <86a656r8nh.wl-maz@kernel.org>
In-Reply-To: <86a656r8nh.wl-maz@kernel.org>
From: Peter Collingbourne <pcc@google.com>
Date: Fri, 4 Nov 2022 10:42:27 -0700
Message-ID: <CAMn1gO62ugtyL9-0hE=DCn=EJ6JY+=Li3QTKPeNULdUhZdnM7w@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE
 enabled
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-mm <linux-mm@kvack.org>, linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Fri, Nov 4, 2022 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 04 Nov 2022 01:10:33 +0000,
> Peter Collingbourne <pcc@google.com> wrote:
> >
> > Hi,
> >
> > This patch series allows VMMs to use shared mappings in MTE enabled
> > guests. The first five patches were taken from Catalin's tree [1] which
> > addressed some review feedback from when they were previously sent out
> > as v3 of this series. The first patch from Catalin's tree makes room
> > for an additional PG_arch_3 flag by making the newer PG_arch_* flags
> > arch-dependent. The next four patches are based on a series that
> > Catalin sent out prior to v3, whose cover letter [2] I quote from below:
> >
> > > This series aims to fix the races between initialising the tags on a
> > > page and setting the PG_mte_tagged flag. Currently the flag is set
> > > either before or after that tag initialisation and this can lead to CoW
> > > copying stale tags. The first patch moves the flag setting after the
> > > tags have been initialised, solving the CoW issue. However, concurrent
> > > mprotect() on a shared mapping may (very rarely) lead to valid tags
> > > being zeroed.
> > >
> > > The second skips the sanitise_mte_tags() call in kvm_set_spte_gfn(),
> > > deferring it to user_mem_abort(). The outcome is that no
> > > sanitise_mte_tags() can be simplified to skip the pfn_to_online_page()
> > > check and only rely on VM_MTE_ALLOWED vma flag that can be checked in
> > > user_mem_abort().
> > >
> > > The third and fourth patches use PG_arch_3 as a lock for page tagging,
> > > based on Peter Collingbourne's idea of a two-bit lock.
> > >
> > > I think the first patch can be queued but the rest needs some in depth
> > > review and test. With this series (if correct) we could allos MAP_SHARED
> > > on KVM guest memory but this is to be discussed separately as there are
> > > some KVM ABI implications.
> >
> > In this v5 I rebased Catalin's tree onto -next again. Please double check
>
> Please don't do use -next as a base. In-flight series should be based
> on a *stable* tag, either 6.0 or one of the early -RCs. If there is a
> known conflict with -next, do mention it in the cover letter and
> provide a resolution.

Okay, I will keep that in mind.

> > my rebase, which resolved the conflict with commit a8e5e5146ad0 ("arm64:
> > mte: Avoid setting PG_mte_tagged if no tags cleared or restored").
>
> This commit seems part of -rc1, so I guess the patches directly apply
> on top of that tag?

Yes, sorry, this also applies cleanly to -rc1.

> > I now have Reviewed-by for all patches except for the last one, which adds
> > the documentation. Thanks for the reviews so far, and please take a look!
>
> I'd really like the MM folks (list now cc'd) to look at the relevant
> patches (1 and 5) and ack them before I take this.

Okay, here are the lore links for the convenience of the MM folks:
https://lore.kernel.org/all/20221104011041.290951-2-pcc@google.com/
https://lore.kernel.org/all/20221104011041.290951-6-pcc@google.com/

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
