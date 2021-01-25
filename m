Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5668AC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 15:00:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94EEE23108
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 15:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94EEE23108
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1886F4B5DF;
	Mon, 25 Jan 2021 10:00:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iy1GKiB6j0kn; Mon, 25 Jan 2021 10:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE854B5EA;
	Mon, 25 Jan 2021 10:00:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D124B5DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 10:00:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VwQJSa-KbSM0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 10:00:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 662AB4B5E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 10:00:35 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3466123108
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611586834;
 bh=hd/WXSL7nvCB88gXvns199QHmgVVBrlCpN1PP6wvQHw=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=jpPA43bvelk6gF/9cB93LHi7Tly+kXkFx6hG6PHe+9hpQbbKXRCjw499iIjLbeqnz
 AjqmnsIR7Tui3CxngPzhbqCv09a5QdeWAtjObuDMpO+LqJhNRFSxhGOI3B3il2HN98
 8SMTMo41asS0b/1rp4BG5XSI44LSR7AzJe/bh+u5xkk4TPSRVmj8IHhPgU0Y/mMZyD
 yKfIXt54JTHJN6dUxsvM/V/FCAolPrs33scoHlvMVVb+dVdMjXnWCnFPCxTGhnzlH+
 VReByrSeAq6c39B8eS77RfwGjyFPhRP6qBI7/B6nR7II3xm1OfuYKmRET2QcxFTYZF
 N2trskMz/Kwjg==
Received: by mail-ot1-f53.google.com with SMTP id d7so5254084otf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 07:00:34 -0800 (PST)
X-Gm-Message-State: AOAM531W1mXHLYkTRUrhoNzglQeWync64YFwlx8qmu6SHMM1ccltENt9
 aMN0aUpf0dt8lkIOCaNTFXji7pvld10RyR2/31s=
X-Google-Smtp-Source: ABdhPJw1XagAoMkdlEgNaYOLX1Mg3wGRaGlR6h1xBKgBfrY9aj6SMHjzWNtcB8bOfL/jGHT7EzD/r/eZef5aGiCiEgQ=
X-Received: by 2002:a05:6830:1158:: with SMTP id
 x24mr712541otq.108.1611586833510; 
 Mon, 25 Jan 2021 07:00:33 -0800 (PST)
MIME-Version: 1.0
References: <20210125105019.2946057-1-maz@kernel.org>
 <20210125105019.2946057-19-maz@kernel.org>
 <CAMj1kXFcc+0At5+9Keo1MF=TeGE9-eOHtSpK7yVy5jzwXt6KCA@mail.gmail.com>
 <3a98ff1db79c90c96038b924eb534643@kernel.org>
 <CAMj1kXGTu8AtMnm7NxB8M2xFuXHSKzAx2hjjeaAW2v-usvavVQ@mail.gmail.com>
 <32b49beb87b25303d71fd2f7053c7959@kernel.org>
In-Reply-To: <32b49beb87b25303d71fd2f7053c7959@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 25 Jan 2021 16:00:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGW3yWqBMk8E23e4PnYAXWUGUUeg4xFVyhHtq+v3WLF_w@mail.gmail.com>
Message-ID: <CAMj1kXGW3yWqBMk8E23e4PnYAXWUGUUeg4xFVyhHtq+v3WLF_w@mail.gmail.com>
Subject: Re: [PATCH v5 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
To: Marc Zyngier <maz@kernel.org>
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>,
 Android Kernel Team <kernel-team@android.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, 25 Jan 2021 at 15:28, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2021-01-25 14:19, Ard Biesheuvel wrote:
> > On Mon, 25 Jan 2021 at 14:54, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2021-01-25 12:54, Ard Biesheuvel wrote:
>
> [...]
>
> >> > This struct now takes up
> >> > - ~100 bytes for the characters themselves (which btw are not emitted
> >> > into __initdata or __initconst)
> >> > - 6x8 bytes for the char pointers
> >> > - 6x24 bytes for the RELA relocations that annotate these pointers as
> >> > quantities that need to be relocated at boot (on a kernel built with
> >> > KASLR)
> >> >
> >> > I know it's only a drop in the ocean, but in this case, where the
> >> > struct is statically declared and defined only once, and in the same
> >> > place, we could easily turn this into
> >> >
> >> > static const struct {
> >> >    char alias[24];
> >> >    char param[20];
> >> > };
> >> >
> >> > and get rid of all the overhead. The only slightly annoying thing is
> >> > that the array sizes need to be kept in sync with the largest instance
> >> > appearing in the array, but this is easy when the struct type is
> >> > declared in the same place where its only instance is defined.
> >>
> >> Fair enough. I personally find the result butt-ugly, but I agree
> >> that it certainly saves some memory. Does the following work for
> >> you? I can even give symbolic names to the various constants (how
> >> generous of me! ;-).
> >>
> >
> > To be honest, I was anticipating more of a discussion, but this looks
> > reasonable to me.
>
> It looked like a reasonable ask: all the strings are completely useless
> once the kernel has booted, and I'm the first to moan that I can't boot
> an arm64 kernel with less than 60MB of RAM (OK, it's a pretty bloated
> kernel...).
>
> > Does 'char    feature[80];' really need 80 bytes though?
>
> It really needs 75 bytes, because of this:
>
>         { "arm64.nopauth",
>           "id_aa64isar1.gpi=0 id_aa64isar1.gpa=0 "
>           "id_aa64isar1.api=0 id_aa64isar1.apa=0"          },
>
> 80 is a round enough number.
>

Fair enough. This will inflate the struct substantially, but at least
it's all __initconst data now, and it's all NUL bytes so it compresses
much better than the pointers and RELA entries.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
