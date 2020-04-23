Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2393C54FD0
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C35820736
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXc1zu2T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C35820736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A86A14B23B;
	Fri, 24 Apr 2020 09:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RET98YJeIXmT; Fri, 24 Apr 2020 09:40:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711604B23C;
	Fri, 24 Apr 2020 09:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB404B1E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 16:43:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lm-+o9vwfCNt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 16:43:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18324B1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 16:43:25 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B83BD2073A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587674604;
 bh=oBeoK4Ts3IjHpqjL3Ti09H4JuJ5fGBnvc+ezg8vGLNc=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=sXc1zu2TDsoqGPTCxhtIfoNhzQHTCy7bryxDNjg1HyYofvm9WLE7Qus38k6TowZSe
 hkYSDqEYPQVeaRAxVBWNdmFPhEAMgHnX95sf3ZZDSaSoTkhNrDicBmVFoeZzXXLeMh
 YpAac62GrTdBGUawenLqox6DR3H5PwHyUWE4vr2U=
Received: by mail-il1-f170.google.com with SMTP id e8so7164748ilm.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:43:24 -0700 (PDT)
X-Gm-Message-State: AGi0PuYM/Eb7Cz0MJpX2SHG2ubO0dFnkRRsAe39RA7rFpf1VAEV1ZcGT
 vH7kwesQakY/e1yfdwZZi0o3oE5HNRCvMnw/T3E=
X-Google-Smtp-Source: APiQypJLC2CAavFDx79KAiO8cUtXdB0gEzPkwZwLp7ZAajg4puIj8+tl3c9epWApmzwlYc1NSji9g7BPXZPG4SJNh9E=
X-Received: by 2002:a92:405:: with SMTP id 5mr5113914ile.279.1587674604087;
 Thu, 23 Apr 2020 13:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
In-Reply-To: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 23 Apr 2020 22:43:13 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
Message-ID: <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: Andre Przywara <andre.przywara@arm.com>
X-Mailman-Approved-At: Fri, 24 Apr 2020 09:40:38 -0400
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 23 Apr 2020 at 19:55, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 23 Apr 2020 at 19:39, Andre Przywara <andre.przywara@arm.com> wrote:
> >
> > Hi,
> >
> > an update for the CFI flash emulation, addressing Alex' comments and
> > adding direct mapping support.
> > The actual code changes to the flash emulation are minimal, mostly this
> > is about renaming and cleanups.
> > This versions now adds some patches. 1/5 is a required fix, the last
> > three patches add mapping support as an extension. See below.
> >
> > In addition to a branch with this series[1], I also put a git branch with
> > all the changes compared to v3[2] as separate patches on the server, please
> > have a look if you want to verify against a previous review.
> >
> > ===============
> > The EDK II UEFI firmware implementation requires some storage for the EFI
> > variables, which is typically some flash storage.
> > Since this is already supported on the EDK II side, and looks like a
> > generic standard, this series adds a CFI flash emulation to kvmtool.
> >
> > Patch 2/5 is the actual emulation code, patch 1/5 is a bug-fix for
> > registering MMIO devices, which is needed for this device.
> > Patches 3-5 add support for mapping the flash memory into guest, should
> > it be in read-array mode. For this to work, patch 3/5 is cherry-picked
> > from Alex' PCIe reassignable BAR series, to support removing a memslot
> > mapping. Patch 4/5 adds support for read-only mappings, while patch 5/5
> > adds or removes the mapping based on the current state.
> > I am happy to squash 5/5 into 2/5, if we agree that patch 3/5 should be
> > merged either separately or the PCIe series is actually merged before
> > this one.
> >
> > This is one missing piece towards a working UEFI boot with kvmtool on
> > ARM guests, the other is to provide writable PCI BARs, which is WIP.
> > This series alone already enables UEFI boot, but only with virtio-mmio.
> >
>
> Excellent! Thanks for taking the time to implement the r/o memslot for
> the flash, it really makes the UEFI firmware much more usable.
>
> I will test this as soon as I get a chance, probably tomorrow.
>

I tested this on a SynQuacer box as a host, using EFI firmware [0]
built from patches provided by Sami.

I booted the Debian buster installer, completed the installation, and
could boot into the system. The only glitch was the fact that the
reboot didn't work, but I suppose we are not preserving the memory the
contains the firmware image, so there is nothing to reboot into. But
just restarting kvmtool with the flash image containing the EFI
variables got me straight into GRUB and the installed OS.

Tested-by: Ard Biesheuvel <ardb@kernel.org>

Thanks again for getting this sorted.


[0] https://people.linaro.org/~ard.biesheuvel/KVMTOOL_EFI.fd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
