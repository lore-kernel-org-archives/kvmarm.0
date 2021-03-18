Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107AEC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 10:05:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EF1C64F3B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 10:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EF1C64F3B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BEB4B678;
	Thu, 18 Mar 2021 06:05:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ZzLydTlZ-Rx; Thu, 18 Mar 2021 06:05:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B133B4B67F;
	Thu, 18 Mar 2021 06:05:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF134B678
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 06:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8BR4i0YgFSt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 06:05:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3F374B479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 06:05:04 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE6464F38;
 Thu, 18 Mar 2021 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616061903;
 bh=KddoL2XE4uBf99evSPlBM3odoKUqV8uiIdkiEMeuARg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YwxOfGYU2tGsaOJ4g3FJ8E2dmNIGYdQiKcKsPfiwIeTC6Akd6uuzqZDMBpTXYBB8C
 wPaxvzP0yq1Vb3qFQoqyLMJS8Gi3b1oLhYw96Ir5KL91s1b8FT4LTQ9ZSOV3DLyru8
 uMRu/5KLQnx+jSW5UazRXg4hPcGVZ0j+pKxU8FAJ391aT1AjdCbgdJebQFGFsU7QjU
 1TSDU/T3sLV7GiDb16dvnjpb5lpJ0VQF+4mBFldm8m5kVBb+9089v4/iE2nT9rZkiZ
 T0z3vUwUI6gksslbP92OCnvL7/lqYzpscNm70Jeu4kN5FXBVFkxfQvWNx7VprqWH0+
 zAjfub8bIx6HQ==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v3 00/22] Unify I/O port and MMIO trap handling
Date: Thu, 18 Mar 2021 10:04:55 +0000
Message-Id: <161606068634.550587.17439092982108275200.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
 Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, 15 Mar 2021 15:33:28 +0000, Andre Przywara wrote:
> this version is addressing Alexandru's comments, fixing mostly minor
> issues in the naming scheme. The biggest change is to keep the
> ioport__read/ioport_write wrappers for the serial device.
> For more details see the changelog below.
> ==============
> 
> At the moment we use two separate code paths to handle exits for
> KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
> are semantically very similar. Because the trap handler callback routine
> is different, devices need to decide on one conduit or need to provide
> different handler functions for both of them.
> 
> [...]

Applied to kvmtool (master), thanks!

[01/22] ioport: Remove ioport__setup_arch()
        https://git.kernel.org/will/kvmtool/c/97531eb2ca70
[02/22] hw/serial: Use device abstraction for FDT generator function
        https://git.kernel.org/will/kvmtool/c/a81be31eee6e
[03/22] ioport: Retire .generate_fdt_node functionality
        https://git.kernel.org/will/kvmtool/c/9bc7e2ce343e
[04/22] mmio: Extend handling to include ioport emulation
        https://git.kernel.org/will/kvmtool/c/96f0c86ce221
[05/22] hw/i8042: Clean up data types
        https://git.kernel.org/will/kvmtool/c/fc7696277b29
[06/22] hw/i8042: Refactor trap handler
        https://git.kernel.org/will/kvmtool/c/f7ef3dc0cd28
[07/22] hw/i8042: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/d24bedb1cc9a
[08/22] x86/ioport: Refactor trap handlers
        https://git.kernel.org/will/kvmtool/c/82304999f936
[09/22] x86/ioport: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/3adbcb235020
[10/22] hw/rtc: Refactor trap handlers
        https://git.kernel.org/will/kvmtool/c/8c45f36430bd
[11/22] hw/rtc: Switch to new trap handler
        https://git.kernel.org/will/kvmtool/c/123ee474b97b
[12/22] hw/vesa: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/38ae332ffcec
[13/22] hw/serial: Refactor trap handler
        https://git.kernel.org/will/kvmtool/c/47a510600e08
[14/22] hw/serial: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/59866df60b4b
[15/22] vfio: Refactor ioport trap handler
        https://git.kernel.org/will/kvmtool/c/a4a0dac75469
[16/22] vfio: Switch to new ioport trap handlers
        https://git.kernel.org/will/kvmtool/c/579bc61f8798
[17/22] virtio: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/205eaa794be7
[18/22] pci: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/1f56b9d10a28
[19/22] Remove ioport specific routines
        https://git.kernel.org/will/kvmtool/c/7e19cb54a7cc
[20/22] arm: Reorganise and document memory map
        https://git.kernel.org/will/kvmtool/c/f01cc778bd65
[21/22] hw/serial: ARM/arm64: Use MMIO at higher addresses
        https://git.kernel.org/will/kvmtool/c/45b4968e0de1
[22/22] hw/rtc: ARM/arm64: Use MMIO at higher addresses
        https://git.kernel.org/will/kvmtool/c/382eaad7b695

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
