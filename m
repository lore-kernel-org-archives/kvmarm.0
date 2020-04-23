Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300D2C54FD0
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 18:07:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A96F820736
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 18:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cu4I9nHQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A96F820736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 261024B09F;
	Thu, 23 Apr 2020 14:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UzE2W85cAksX; Thu, 23 Apr 2020 14:07:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF84E4B1AE;
	Thu, 23 Apr 2020 14:07:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA994B172
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:55:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rSZ0le+e3qIb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 13:55:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E72CE4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:55:33 -0400 (EDT)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D71EC20784
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587664532;
 bh=HzfdttVM9BgXQr/ijSQNIg+ZauLcJdE62a/irg9HQUA=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=cu4I9nHQfaAgy0rxfE2IlSOes6GxtHhb1TM6KzJAfSoXk3LQVsGKljDgd4Kf2e0Du
 cgTDqQF09l20AZz5QEkMAXbyseU5q3jalMsiN/Hvx3mfkYLe/u9uBIWtbfuu8QqiYD
 SEJ5CeenY+ILfm9KNSCcO8L/iPPsdWYEoz4fb+Bc=
Received: by mail-il1-f180.google.com with SMTP id s10so6413662iln.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 10:55:32 -0700 (PDT)
X-Gm-Message-State: AGi0Puaesbw+MKH/coHt/b2pt/UEhlXbcdyhkSPQgGW9t0IdRFVEV54Z
 QOxvUzkri4BhGQN3Elph9kUNp96sMOP/ce4praI=
X-Google-Smtp-Source: APiQypL/Z2RoaxQTfyMU8HG6ck8a1KcKtB0U7jGPtMPkv1hfvGb/DzU/DYKwhO+zoay4gzXDiXn1MefQvMTM2uI93Yw=
X-Received: by 2002:a92:405:: with SMTP id 5mr4426510ile.279.1587664532201;
 Thu, 23 Apr 2020 10:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 23 Apr 2020 19:55:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
Message-ID: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: Andre Przywara <andre.przywara@arm.com>
X-Mailman-Approved-At: Thu, 23 Apr 2020 14:07:53 -0400
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

On Thu, 23 Apr 2020 at 19:39, Andre Przywara <andre.przywara@arm.com> wrote:
>
> Hi,
>
> an update for the CFI flash emulation, addressing Alex' comments and
> adding direct mapping support.
> The actual code changes to the flash emulation are minimal, mostly this
> is about renaming and cleanups.
> This versions now adds some patches. 1/5 is a required fix, the last
> three patches add mapping support as an extension. See below.
>
> In addition to a branch with this series[1], I also put a git branch with
> all the changes compared to v3[2] as separate patches on the server, please
> have a look if you want to verify against a previous review.
>
> ===============
> The EDK II UEFI firmware implementation requires some storage for the EFI
> variables, which is typically some flash storage.
> Since this is already supported on the EDK II side, and looks like a
> generic standard, this series adds a CFI flash emulation to kvmtool.
>
> Patch 2/5 is the actual emulation code, patch 1/5 is a bug-fix for
> registering MMIO devices, which is needed for this device.
> Patches 3-5 add support for mapping the flash memory into guest, should
> it be in read-array mode. For this to work, patch 3/5 is cherry-picked
> from Alex' PCIe reassignable BAR series, to support removing a memslot
> mapping. Patch 4/5 adds support for read-only mappings, while patch 5/5
> adds or removes the mapping based on the current state.
> I am happy to squash 5/5 into 2/5, if we agree that patch 3/5 should be
> merged either separately or the PCIe series is actually merged before
> this one.
>
> This is one missing piece towards a working UEFI boot with kvmtool on
> ARM guests, the other is to provide writable PCI BARs, which is WIP.
> This series alone already enables UEFI boot, but only with virtio-mmio.
>

Excellent! Thanks for taking the time to implement the r/o memslot for
the flash, it really makes the UEFI firmware much more usable.

I will test this as soon as I get a chance, probably tomorrow.


>
> [1] http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/cfi-flash/v4
> [2] http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/cfi-flash/v3
> git://linux-arm.org/kvmtool.git (branches cfi-flash/v3 and cfi-flash/v4)
>
> Changelog v3 .. v4:
> - Rename file to cfi-flash.c (dash instead of underscore).
> - Unify macro names for states, modes and commands.
> - Enforce one or two chips only.
> - Comment on pow2_size() function.
> - Use more consistent identifier spellings.
> - Assign symbols to status register values.
> - Drop RCR register emulation.
> - Use numerical offsets instead of names for query offsets to match spec.
> - Cleanup error path and reword info message in create_flash_device_file().
> - Add fix to allow non-virtio MMIO device emulations.
> - Support tearing down and adding read-only memslots.
> - Add read-only memslot mapping when in read mode.
>
> Changelog v2 .. v3:
> - Breaking MMIO handling into three separate functions.
> - Assing the flash base address in the memory map, but stay at 32 MB for now.
>   The MMIO area has been moved up to 48 MB, to never overlap with the
>   flash.
> - Impose a limit of 16 MB for the flash size, mostly to fit into the
>   (for now) fixed memory map.
> - Trim flash size down to nearest power-of-2, to match hardware.
> - Announce forced flash size trimming.
> - Rework the CFI query table slightly, to add the addresses as array
>   indicies.
> - Fix error handling when creating the flash device.
> - Fix pow2_size implementation for 0 and 1 as input values.
> - Fix write buffer size handling.
> - Improve some comments.
>
> Changelog v1 .. v2:
> - Add locking for MMIO handling.
> - Fold flash read into handler.
> - Move pow2_size() into generic header.
> - Spell out flash base address.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
