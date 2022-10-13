Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CFFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 19:03:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D874B1C6;
	Thu, 13 Oct 2022 15:03:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 99x2UUAf13Nx; Thu, 13 Oct 2022 15:03:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B62AD49DE3;
	Thu, 13 Oct 2022 15:03:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E437401AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 15:02:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uTc7PEXsyoBu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 15:02:57 -0400 (EDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBB8540159
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 15:02:57 -0400 (EDT)
Received: by mail-io1-f42.google.com with SMTP id r142so2143395iod.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 12:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=MP3T/XHtvB7T2dvq2BFDW4i0+SNmM+iMnWNu4Hti2BA=;
 b=ZMTofWbJPh9OXpNDn+89bEexPttxGkSAoMgTKgcO7a58oNNx9ffMYPcw0jPVik8bNf
 /OdbkHy01qlffZiisapq3bbG4+XMS09MNjZl1h/9ALwM8RGjlmHPsvgrdPX9IVmEJ2JB
 EKKjB5RiaxA9mNnPMfFShHlMbHQOtBYCMrVMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=MP3T/XHtvB7T2dvq2BFDW4i0+SNmM+iMnWNu4Hti2BA=;
 b=MyIXRZSqEXDess86bvXrIh/z028WerFlvySMJP7G5jdNdf+ACPGN/4ovYZzJ9IWrdz
 z+y2ZbfTXiIZaYJZsR5Oy9tAaPAXEmqCkfhGS6PhgLIT7hG189HF1BRn9hULI5x13403
 /6sEuD/hd5rAVFxYZAr33QEDuINCrakMqOX29z0v1+VICGooY17BHDKFelROEOurviCb
 BrauVR3XnoXxvsntniAbx9XeV7lPVVayYYSrdu0xbPKqvj1l5UFLv4wQ9fYBAxsVb65v
 /F0fi6DpTW0REoo5FiNxkt8w88z+QgPN9kZ+jvYKaWuNIMsvh1iEZL4SgCcOofEcDaED
 wHNA==
X-Gm-Message-State: ACrzQf1pg2s3pLow4bsIgJLVdCY82i0AQLvnlMwGWrX3nMCqbNGeWbwZ
 gIk7FHVsCS+hJ70a8xsSw1nePeq7xIeskgoDIU+Hhw==
X-Google-Smtp-Source: AMsMyM4RzYGiidFH0NDYt44AzYf9H4jcVkGDqcI3RF9uszlKftMcbPM4u6lpy8mLxwLYCdzS763ghbAVi0/zMgolec8=
X-Received: by 2002:a02:290e:0:b0:35a:d680:7aad with SMTP id
 p14-20020a02290e000000b0035ad6807aadmr807425jap.62.1665687777109; Thu, 13 Oct
 2022 12:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220920082005.2459826-1-denik@chromium.org>
 <20220922053145.944786-1-denik@chromium.org>
 <87h70zk83g.wl-maz@kernel.org>
 <CADDJ8CW0QgHtp1rwk=ZqrcuWZ4_L8KQh26VaEfcBQS0Tx9+ZYg@mail.gmail.com>
 <CAH=Qcsi3aQ51AsAE0WmAH9VmpqjOaQQt=ru5Nav4+d8F3fMPwQ@mail.gmail.com>
 <CADDJ8CXObkhMvOx+L29awjtt7tiaTWxFrRxOmhUqvzku1wswHw@mail.gmail.com>
 <CADDJ8CV83d4tYeLnQH-hHjzBfED6EBo4Z70q5A=9cwO+Lp1sNQ@mail.gmail.com>
 <87sfjxhh4k.wl-maz@kernel.org>
 <CADDJ8CVX5tZU9jL4FvTnvQxxVohhS76TVOoZAyy3k_Uit1efmA@mail.gmail.com>
 <86fsfsf0ab.wl-maz@kernel.org>
In-Reply-To: <86fsfsf0ab.wl-maz@kernel.org>
From: Denis Nikitin <denik@chromium.org>
Date: Thu, 13 Oct 2022 12:02:46 -0700
Message-ID: <CADDJ8CVP0f99e6v0F==5Qo6LePb0DCkF1KatTEHx24W8aWcXWw@mail.gmail.com>
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

Thank you Marc for figuring out the filtering-out solution!
It fixed the build on ChromeOS.

I will update the patch and also filter out `-fprofile-use` which will avoid
a similar problem with the instrumented PGO in the future.

Thanks,
Denis

On Thu, Oct 13, 2022 at 4:09 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 11 Oct 2022 03:15:36 +0100,
> Denis Nikitin <denik@chromium.org> wrote:
> >
> > On Sat, Oct 8, 2022 at 7:22 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 06 Oct 2022 17:28:17 +0100,
> > > Denis Nikitin <denik@chromium.org> wrote:
> > > >
> > > > Hi Mark,
> > >
> > > s/k/c/
> > >
> > > >
> > > > This problem currently blocks the PGO roll on the ChromeOS kernel and
> > > > we need some kind of a solution.
> > >
> > > I'm sorry, but I don't feel constrained by your internal deadlines. I
> > > have my own...
> > >
> > > > Could you please take a look?
> > >
> > > I have asked for a reproducer. All I got for an answer is "this is
> > > hard". Providing a profiling file would help, for example.
> >
> > Could you please try the following profile on the 5.15 branch?
> >
> > $ cat <<EOF > prof.txt
> > kvm_pgtable_walk:100:10
> >  2: 5
> >  3: 5
> >  5: 5
> >  6: 5
> >  10: 5
> >  10: _kvm_pgtable_walk:50
> >   5: 5
> >   7: 5
> >   10: 5
> >   13.2: 5
> >   14: 5
> >   16: 5 __kvm_pgtable_walk:5
> >   13: kvm_pgd_page_idx:30
> >    2: __kvm_pgd_page_idx:30
> >     2: 5
> >     3: 5
> >     5: 5
> >     2: kvm_granule_shift:5
> >      3: 5
> > EOF
> >
> > $ make LLVM=1 ARCH=arm64 KCFLAGS=-fprofile-sample-use=prof.txt -j8 vmlinux
>
> Thanks, this was helpful, as I was able to reproduce the build failure.
>
> FWIW, it seems pretty easy to work around by filtering out the
> offending option, making it consistent with the mechanism we already
> use for tracing and the like.
>
> I came up with the hack below, which does the trick and is IMHO better
> than dropping the section (extra work) or adding the negation of this
> option (which depends on the compiler option evaluation order).
>
>         M.
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 48f6ae7cc6e6..7df1b6afca7f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -91,7 +91,7 @@ quiet_cmd_hypcopy = HYPCOPY $@
>
>  # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
>  # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
> -KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI) -fprofile-sample-use=%, $(KBUILD_CFLAGS))
>
>  # KVM nVHE code is run at a different exception code with a different map, so
>  # compiler instrumentation that inserts callbacks or checks into the code may
>
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
