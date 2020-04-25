Return-Path: <SRS0=8W4i=6K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228A7C5519A
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 10:57:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FCD62070A
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 10:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHljdFkC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FCD62070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5574B1E9;
	Sun, 26 Apr 2020 06:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKI7N+5NnNkH; Sun, 26 Apr 2020 06:57:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D94C44B1F0;
	Sun, 26 Apr 2020 06:57:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274634B0EB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 11:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0IrD+-r2BhBV for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 11:16:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21D694B0E7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 11:16:21 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0A19520748
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587827780;
 bh=o0YvFXB0fOhkpMsOYQtyfaC/gbqb1WTOlDnFNBy5vYg=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=WHljdFkCPrGvMauQcqkQpX5IqC4DgJqxiZXcR9v6QBtR0AoMMqa4UWNnKxqyh39eN
 qMM3xtTEI2bUVsU2OhunkCpogsZJ/JrhiTxAQpLUHxXwPmk9IZQJz/00PDeEZb45+q
 +6LR8xOM4eK+UIoxokqO5i2kvDt2vzHj1NJBBN0s=
Received: by mail-io1-f50.google.com with SMTP id f3so13895251ioj.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 08:16:20 -0700 (PDT)
X-Gm-Message-State: AGi0Pub0qafPCrHzW0FP230GVlJv2152alZXsAjB6m8WMINj4cF1ivRl
 FhU7YHoCMQQmkG9SDO77UWnhfY1Svc59f5CiBN4=
X-Google-Smtp-Source: APiQypKpQLTIEmPBlkNb/mJvpnVtQmj0oSSXVLfzbPQIzljzrUXXxbbXS8vMsiZMRXnwnNWajim3I0mgUTHSAVuXVPs=
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr13684897iot.161.1587827779426; 
 Sat, 25 Apr 2020 08:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200424084051.GA20801@willie-the-truck>
 <20200424170315.GH21141@willie-the-truck>
In-Reply-To: <20200424170315.GH21141@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 25 Apr 2020 17:16:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFGzBvrCr_-+_Gse8kpoPx49iCrLnVpb3JLT=GqaQA5+A@mail.gmail.com>
Message-ID: <CAMj1kXFGzBvrCr_-+_Gse8kpoPx49iCrLnVpb3JLT=GqaQA5+A@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: Will Deacon <will@kernel.org>
X-Mailman-Approved-At: Sun, 26 Apr 2020 06:57:24 -0400
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Raphael Gault <raphael.gault@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
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

On Fri, 24 Apr 2020 at 19:03, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Apr 24, 2020 at 09:40:51AM +0100, Will Deacon wrote:
> > On Thu, Apr 23, 2020 at 06:38:39PM +0100, Andre Przywara wrote:
> > > an update for the CFI flash emulation, addressing Alex' comments and
> > > adding direct mapping support.
> > > The actual code changes to the flash emulation are minimal, mostly this
> > > is about renaming and cleanups.
> > > This versions now adds some patches. 1/5 is a required fix, the last
> > > three patches add mapping support as an extension. See below.
> >
> > Cheers, this mostly looks good to me. I've left a couple of minor comments,
> > and I'll give Alexandru a chance to have another look, but hopefully we can
> > merge it soon.
>
> Ok, I pushed this out along with the follow-up patch.
>

Cheers for that, this is useful stuff.

For the record, I did a quick benchmark on RPi4 booting Debian in a
VM, and I get the following delays (with GRUB and EFI timeouts both
set to 0)

17:04:58.487065
17:04:58.563700 UEFI firmware (version  built at 22:13:20 on Apr 23 2020)
17:04:58.853653 Welcome to GRUB!
17:04:58.924606 Booting `Debian GNU/Linux'
17:04:58.927835 Loading Linux 5.5.0-2-arm64 ...
17:04:59.063490 Loading initial ramdisk ...
17:05:01.303560 /dev/vda2: recovering journal
17:05:01.408861 /dev/vda2: clean, 37882/500960 files, 457154/2001920 blocks
17:05:09.646023 Debian GNU/Linux bullseye/sid rpi4vm64 ttyS0

So it takes less than 400 ms from starting kvmtool to entering GRUB
when the boot path is set normally. Any other delays you are observing
may be due to the fact that no boot path has been configured yet,
which is why it attempts PXE boot or other things.

Also, note that you can pass the --rng option to kvmtool to get the
EFI_RNG_PROTOCOL to be exposed to the EFI stub, for KASLR and for
seeding the kernel's RNG.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
