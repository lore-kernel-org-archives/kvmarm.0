Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C290C2BB85
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D11BA20784
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yychbi2M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D11BA20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76D0F4B155;
	Wed, 15 Apr 2020 13:06:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AWzhbc9uBPnh; Wed, 15 Apr 2020 13:06:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 893524B21F;
	Wed, 15 Apr 2020 13:06:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 245C24B15D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 11:56:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0nTz39wtbMoW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 11:56:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4E254B12B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 11:56:04 -0400 (EDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D8F5820857
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586966163;
 bh=n4WL1T858zal6SWux0kcghyeb03YcdCK83LPyQqpmOU=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=yychbi2M7PdL4U/sur0ERyt44GK4CFegqPUkaZ1u5iy/BuUdzfAp14ANUWaR8RxPY
 bwqjQ64EQpRgDtmlgXu9BiUK0xgrFqQTt18ZLPPLIvp0DI+7bea4NZZSwk2qL2/iIK
 8cJC/FT8JDPZpcoYDkmf2w2RhK7MSepi/7zMldDI=
Received: by mail-il1-f169.google.com with SMTP id i75so3745698ild.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 08:56:03 -0700 (PDT)
X-Gm-Message-State: AGi0PubbL6Bcs9DwGwTUaoMX78CiOaYkW2KanPk9yGCKfmf/Lj3XLrYv
 JJU7RQY/ImNan4p0aoMIcX4aqBm+3YKOZjMNsT4=
X-Google-Smtp-Source: APiQypJO2rcsOAPOZwNgYyBGwSD18Rro24rIIN5xJo2IrgJIuBFWlXuwcbqq2VlhdS3Pf3dN91LZUXXkZ6WIB4fz4EM=
X-Received: by 2002:a92:5a4c:: with SMTP id o73mr5693957ilb.218.1586966163228; 
 Wed, 15 Apr 2020 08:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
 <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
In-Reply-To: <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 15 Apr 2020 17:55:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
Message-ID: <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To: Alexandru Elisei <alexandru.elisei@arm.com>, sami.mujawar@arm.com
X-Mailman-Approved-At: Wed, 15 Apr 2020 13:06:31 -0400
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Raphael Gault <raphael.gault@arm.com>, Will Deacon <will@kernel.org>,
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

On Wed, 15 Apr 2020 at 17:43, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 7 Apr 2020 at 17:15, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > I've tested this patch by running badblocks and fio on a flash device inside a
> > guest, everything worked as expected.
> >
> > I've also looked at the flowcharts for device operation from Intel Application
> > Note 646, pages 12-21, and they seem implemented correctly.
> >
> > A few minor issues below.
> >
> > On 2/21/20 4:55 PM, Andre Przywara wrote:
> > > From: Raphael Gault <raphael.gault@arm.com>
> > >
> > > The EDK II UEFI firmware implementation requires some storage for the EFI
> > > variables, which is typically some flash storage.
> > > Since this is already supported on the EDK II side, we add a CFI flash
> > > emulation to kvmtool.
> > > This is backed by a file, specified via the --flash or -F command line
> > > option. Any flash writes done by the guest will immediately be reflected
> > > into this file (kvmtool mmap's the file).
> > > The flash will be limited to the nearest power-of-2 size, so only the
> > > first 2 MB of a 3 MB file will be used.
> > >
> > > This implements a CFI flash using the "Intel/Sharp extended command
> > > set", as specified in:
> > > - JEDEC JESD68.01
> > > - JEDEC JEP137B
> > > - Intel Application Note 646
> > > Some gaps in those specs have been filled by looking at real devices and
> > > other implementations (QEMU, Linux kernel driver).
> > >
> > > At the moment this relies on DT to advertise the base address of the
> > > flash memory (mapped into the MMIO address space) and is only enabled
> > > for ARM/ARM64. The emulation itself is architecture agnostic, though.
> > >
> > > This is one missing piece toward a working UEFI boot with kvmtool on
> > > ARM guests, the other is to provide writable PCI BARs, which is WIP.
> > >
>
> I have given this a spin with UEFI built for kvmtool, and it appears
> to be working correctly. However, I noticed that it is intolerably
> slow, which seems to be caused by the fact that both array mode and
> command mode (or whatever it is called in the CFI spec) are fully
> emulated, whereas in the QEMU implementation (for instance), the
> region is actually exposed to the guest using a read-only KVM memslot
> in array mode, and so the read accesses are made natively.
>
> It is also causing problems in the UEFI implementation, as we can no
> longer use unaligned accesses to read from the region, which is
> something the code currently relies on (and which works fine on actual
> hardware as long as you use normal non-cacheable mappings)
>

Actually, the issue is not alignment. The issue is with instructions
with multiple outputs, which means you cannot do an ordinary memcpy()
from the NOR region using ldp instructions, aligned or not.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
