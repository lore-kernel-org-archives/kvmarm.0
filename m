Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C379C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 17:04:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8904240E06;
	Wed,  9 Mar 2022 12:04:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id js1yidymXL0X; Wed,  9 Mar 2022 12:04:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B99984120D;
	Wed,  9 Mar 2022 12:04:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 743054120D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 12:04:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sF8KB9ua1OdM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 12:04:14 -0500 (EST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88D4840D0B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 12:04:14 -0500 (EST)
Received: by mail-wm1-f45.google.com with SMTP id
 q7-20020a7bce87000000b00382255f4ca9so3840885wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 09:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ndx32WBmfBxuvJH6NgXVPP6Qai1KeFznS/MWmU68F2k=;
 b=YQjVRwGsmDyttSMWRArNfLF0dqeQKY8E/07xyYcuzGr0kpyfDmH8G4dbdGdwdlBwnP
 zX1OtOneZOfWA5I7yR+egmuSJ2jHhH7Ut7NmOVk1XPYZi0TADjvFf5B5DFIvdUkNY62P
 +cvUl3a7OfQRD0oBDWHHEUNpZ7y2RxB1g2F8aRdKdvN5tt4jdIZjz2wzUoM1Xdj+uEwz
 4YWWV1fNTpxtUqI9nbSpNzW55JCP6aUHS8hIbhGRLCdSUpYypgBjKrYzBB4AnrJV5Wj8
 Cxpn/g7Z6EZckp3ywXFFKd8kS5wEwjqPOsYOOYEeBNo2wik/g+SdAai+Er3kQuhh/VAp
 xKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ndx32WBmfBxuvJH6NgXVPP6Qai1KeFznS/MWmU68F2k=;
 b=focbI5iFxT7KTd8M1SMmUlCTanBtSFLBXEC5u03dAaBJtx1VB8G9vUM2zYsikM1MEt
 LwQiMrTYPpzp9Qfafkb7pWE+1bcfK0MTRRGGpKCKfA66jRu2UDGDvhS8JEBHxWkgxZz4
 FuGhfbGmxLAk577ZDRz6QGyXb8N9yqHLF45f/Mra3i/L/xgln3Pi0y3v3DuEpc9Y2r+v
 kRuE/+0+fLBhPtOZT+1/xc3OkRW1NY7/UXw70l/Qt9TSu4nHcQnhkYHPmNP3tIbBI+vW
 hyANFzE6c9Czcv7AiFFDKr9sFWtPQhNBPkQ4QFmFkSfkkpfrj3LLOqrTrjHInkNwVaEJ
 xvag==
X-Gm-Message-State: AOAM531BLrJkCuyQy48dm1FjRdbfyOWpZL6U6qSPskq2bhY7kHjvoUyM
 bIoQcTQSo3e5tW02bsw5Jg2EQ3qzKlym+sodw4y77Q==
X-Google-Smtp-Source: ABdhPJy5alfRTJ16ow1R2qoghwtdNe1YLO1P7U2E+EplB8YB4Kg4kWeP+53DYGC1dkaYhZktOY9T6zkHogbJiFNWhcI=
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id
 u23-20020a7bc057000000b0037bebadc9c8mr8419395wmc.61.1646845453376; Wed, 09
 Mar 2022 09:04:13 -0800 (PST)
MIME-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
 <20220307184935.1704614-2-kaleshsingh@google.com>
 <CAE-0n52LmVRkrSNN=eJf+TYYnmesVjFv99nnetYvRWshm82rOg@mail.gmail.com>
 <CAC_TJvc6LYp95BXQc0DSBBBAZpYpixa+NyHKMLFWsBADD5Ubhg@mail.gmail.com>
 <Yija5cY6j/B25Psw@google.com>
In-Reply-To: <Yija5cY6j/B25Psw@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 9 Mar 2022 09:04:01 -0800
Message-ID: <CAC_TJvc9o5OJ-aSLkDOu8h3jnuHvBQZnh8pRFbHxunVWUyhHzA@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Quentin Perret <qperret@google.com>
Cc: "Cc: Android Kernel" <kernel-team@android.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Wed, Mar 9, 2022 at 8:50 AM Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 08 Mar 2022 at 15:09:18 (-0800), Kalesh Singh wrote:
> > On Tue, Mar 8, 2022 at 12:21 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > > It looks odd to use an error pointer casted to unsigned long to return
> > > from an address allocation function. Why not pass a pointer for base
> > > like the function was written before and return an int from this
> > > function with 0 for success and negative error value?Otherwise some
> > > sort of define should made like DMA_MAPPING_ERROR and that can be used
> > > to indicate to the caller that the allocation failed, or a simple zero
> > > may work?
> >
> > I wanted to keep consistent between the pkvm and traditional nvhe
> > code. I will refactor both *alloc_private_va_range() functions to take
> > a pointer and return an int error if that's preferred. There would
> > still be a case of this kind of cast in
> > __pkvm_create_private_mapping() which does return an unsigned long
> > address or ERR_PTR(...). It looks like it was made to return the
> > address to facilitate use as a hypercall (@Quentin CMIW).
>
> Yep, passing everything by value was much easier to cross the EL1/EL2
> boundary as that avoids having the hypervisor map kernel memory and all
> that fun. But Stephen's point is fair, so no objection from to keep this
> little dance confined to the hypercall wrapper and make the function
> signature nicer and easier to use for the rest of the code.

Thanks for clarifying Quentin. That sounds good to me.

- Kalesh

>
> Cheers,
> Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
