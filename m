Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3980BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A96149F4E;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GbqmiXTXf9nl; Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A3B49F58;
	Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F18DE49E37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:17:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqye5F7PHXlZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:17:27 -0400 (EDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC29A411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:17:27 -0400 (EDT)
Received: by mail-lf1-f44.google.com with SMTP id 5so13021507lfp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rjXWwDt+piFjEizKBPLIwkQ3oNcecYs/t2+aRfZKR2Q=;
 b=e0SsUFEnYUMCyRAkGyLVow0+R4bFdfmash3hSguwzYMReIozuymckocyM5BR/BZLJg
 F/po3/TlVjopsmXJ41juFAnRzPe45KNaRNkzN0MtvjZ9mBPCEsZrjkO6ujDAemvwda96
 rl80jZRhNG2l/NMfwbStZ6I+jDlhs/HdozQzWkjJ80csfkdMlVM4vYTOYFFyjfHkCzzd
 9/mg9mIusJIiJ41q4kWg6sKjFXIQgUQguTqgxHiq8PkCHtwIR6pYWShWbrYo5MzF8yp5
 bQ749BhKFyRlGHbieptNt6y4VPTEPjdhkDnJ0TPl0KSwq8Nl847v1G4lQzpS2egtD3Nu
 R/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rjXWwDt+piFjEizKBPLIwkQ3oNcecYs/t2+aRfZKR2Q=;
 b=7609Ix/CaejJxG/hZlFK6z+717Rwe/860XxIm0SKk+GnpEGd+ll2xOCAP2OR6boxIA
 XoIIwVrmgpkDx0E1+bD1C7ZInvJZGtAN8petqTJloiphAmHGTwtBytMHX80x6ktZhvDD
 NjNcuEDGqdHxgVbxZbv9/cBcSs0HJmhMJSqX6iuuzcuzgUtxP0VgZ5x6QhV4OfF3o79M
 W3F5KJPwcVAfVcZbRKTKrOppt0d7sfHfIgG32YF76fhQrSURIdjBaUsf7rCZoT8BCdxr
 ik2J9208eIAYeIpWI0isTO5L0GoysFltVxUNA5ooR3g9824jwLjbDw0DefW/2KtqJe2L
 bvCw==
X-Gm-Message-State: AOAM531SNL7YYF4+QkDV5ezv2dy/14ocAdMLOjt/pdv3LcFvezpaVW0g
 7EBlwaUvSx1H++rEfxjEOuSQgcyvqGGIuL/kNd18Dw==
X-Google-Smtp-Source: ABdhPJxTpXDCogH6wFEbXP5cV7bKAnz+C/vzgCxatvwG3tgn9N4H9nX6rT0RugIgjr0sQJpMf/ysU29QMVGOZ9XlHbA=
X-Received: by 2002:ac2:57db:0:b0:44a:23ce:b7f5 with SMTP id
 k27-20020ac257db000000b0044a23ceb7f5mr9953556lfo.235.1647973045570; Tue, 22
 Mar 2022 11:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-2-dmatlack@google.com>
 <YjBC1ZLio2iPkZ0V@xz-m1.local>
In-Reply-To: <YjBC1ZLio2iPkZ0V@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 11:16:59 -0700
Message-ID: <CALzav=dx2rm7xm07x0iEMiS1jzNoU2cOT-mtA9=P6C1riOe2AQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/26] KVM: x86/mmu: Optimize MMU page cache lookup for
 all direct SPs
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Mar 15, 2022 at 12:40 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:03AM +0000, David Matlack wrote:
> > Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> > fully direct MMUs") skipped the unsync checks and write flood clearing
> > for full direct MMUs. We can extend this further and skip the checks for
> > all direct shadow pages. Direct shadow pages are never marked unsynced
> > or have a non-zero write-flooding count.
>
> Nit: IMHO it's better to spell out the exact functional change, IIUC those
> are the direct mapped SPs where guest uses huge pages but host uses only
> small pages for the shadowing?

Yes that's correct. I'll include that in the commit message in the next version.

>
> >
> > Checking sp->role.direct alos generates better code than checking
> > direct_map because, due to register pressure, direct_map has to get
> > shoved onto the stack and then pulled back off.
> >
> > No functional change intended.
> >
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
