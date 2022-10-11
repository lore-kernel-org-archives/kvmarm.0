Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6482C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 02:15:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4133B4B25A;
	Mon, 10 Oct 2022 22:15:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wkYkEVuxKh5R; Mon, 10 Oct 2022 22:15:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9BC40BED;
	Mon, 10 Oct 2022 22:15:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C07640BED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 22:15:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jz+UCFtiVS2H for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 22:15:48 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B69F404CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 22:15:48 -0400 (EDT)
Received: by mail-il1-f179.google.com with SMTP id 8so6520070ilj.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=H/xYrhJE+jRHh/6xuRZ4OUPEvZUDe865/O/aakyh1Jc=;
 b=cA3mVR/CGxcV72s28yIpSLl8Ry3QNBNtiqfQRJk1LI87DGdgCtvhtL6ju5NrdFgp0v
 jYbavGUnyyFdJJdSvAc+k/dXxseV1w+wYt7qd2Z+qBFjnBIe0LXWbBKllfNKCbfjAlGe
 4S75Ef/hxbmI7DLha0tUVkEeTJmS1s/2ot+vQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=H/xYrhJE+jRHh/6xuRZ4OUPEvZUDe865/O/aakyh1Jc=;
 b=5yIEZRzgTaep+uSQj8RCSge/Q3ZR32aIEhx3lEvwTu4Q7VOpzKe24SjTV2rUUowgqe
 HSr0/a0S4bJ/li143Xt+rbZEqHgnf0SOX9ca3If+rN9fuVQMRk1q+mDYFN0Z3d+OcRGr
 ogd4beGNRJ322kANHPJeto3jZCYthxpZfGx9FB6QjVJt1uObDGmTFzU104n+jx+LtTlY
 RZw/H4yyQakuESoB2dlv96sYLUquUW+wj4yCuPCGGXaPew0wPqHURTHU5c41zTw3OqTo
 +jrf3sSigJepkD1T/8jnMwnd8j+vLkZcsSyHSChuz2BnKfsMffB4rhWUK020iFN1VIN3
 1f8A==
X-Gm-Message-State: ACrzQf3uqYu9q6+bwNweiG4ONE2QOmEA5TUNUy40XDtF796mxbQ9+bHz
 n3dwBj8ibPKh4ib/+REH1fecYzG+qBJ72aEsNNBgTA==
X-Google-Smtp-Source: AMsMyM5JQvbMqETxKQHEq6txeP+r87znPWfN/6DVQDwiA28XRis95uxqOPRsPOisPJqXnkwrVBqASlH34ysfeq3CL9g=
X-Received: by 2002:a05:6e02:1749:b0:2fa:5de2:4cc9 with SMTP id
 y9-20020a056e02174900b002fa5de24cc9mr10531673ill.214.1665454547546; Mon, 10
 Oct 2022 19:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220920082005.2459826-1-denik@chromium.org>
 <20220922053145.944786-1-denik@chromium.org>
 <87h70zk83g.wl-maz@kernel.org>
 <CADDJ8CW0QgHtp1rwk=ZqrcuWZ4_L8KQh26VaEfcBQS0Tx9+ZYg@mail.gmail.com>
 <CAH=Qcsi3aQ51AsAE0WmAH9VmpqjOaQQt=ru5Nav4+d8F3fMPwQ@mail.gmail.com>
 <CADDJ8CXObkhMvOx+L29awjtt7tiaTWxFrRxOmhUqvzku1wswHw@mail.gmail.com>
 <CADDJ8CV83d4tYeLnQH-hHjzBfED6EBo4Z70q5A=9cwO+Lp1sNQ@mail.gmail.com>
 <87sfjxhh4k.wl-maz@kernel.org>
In-Reply-To: <87sfjxhh4k.wl-maz@kernel.org>
From: Denis Nikitin <denik@chromium.org>
Date: Mon, 10 Oct 2022 19:15:36 -0700
Message-ID: <CADDJ8CVX5tZU9jL4FvTnvQxxVohhS76TVOoZAyy3k_Uit1efmA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: nvhe: Fix build with profile optimization
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Manoj Gupta <manojgupta@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, Oct 8, 2022 at 7:22 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 06 Oct 2022 17:28:17 +0100,
> Denis Nikitin <denik@chromium.org> wrote:
> >
> > Hi Mark,
>
> s/k/c/
>
> >
> > This problem currently blocks the PGO roll on the ChromeOS kernel and
> > we need some kind of a solution.
>
> I'm sorry, but I don't feel constrained by your internal deadlines. I
> have my own...
>
> > Could you please take a look?
>
> I have asked for a reproducer. All I got for an answer is "this is
> hard". Providing a profiling file would help, for example.

Could you please try the following profile on the 5.15 branch?

$ cat <<EOF > prof.txt
kvm_pgtable_walk:100:10
 2: 5
 3: 5
 5: 5
 6: 5
 10: 5
 10: _kvm_pgtable_walk:50
  5: 5
  7: 5
  10: 5
  13.2: 5
  14: 5
  16: 5 __kvm_pgtable_walk:5
  13: kvm_pgd_page_idx:30
   2: __kvm_pgd_page_idx:30
    2: 5
    3: 5
    5: 5
    2: kvm_granule_shift:5
     3: 5
EOF

$ make LLVM=1 ARCH=arm64 KCFLAGS=-fprofile-sample-use=prof.txt -j8 vmlinux

Thanks,
Denis

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
