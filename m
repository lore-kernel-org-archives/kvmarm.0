Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5337C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 15:41:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 568234B3C5;
	Fri,  1 Jul 2022 11:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JHT2grXOWfeF; Fri,  1 Jul 2022 11:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 137A54B3B6;
	Fri,  1 Jul 2022 11:41:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A79D4B3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G-sp14km0FyG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 11:41:44 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B52D04B605
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 27115B830A0;
 Fri,  1 Jul 2022 15:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8701BC341CA;
 Fri,  1 Jul 2022 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656690100;
 bh=3T9BR9wQoQq/4l/cuzDtrWY3lzmwZg8afajWV734Dec=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Lug4DmtrmpSw5neujBjnRi7fGP89gVgZ24QOAJOyACkezuGNUVLaJ45hbqfbgRfsD
 +Y2RfNiYBnmkZQBbKfUseS5mdedNWJDdkLAWnbTlfXT5zzw/yx96SrWb8olyojH4Jy
 hLwZW4qLtv0lWSDl/I0E9K03jsspravTdz0lUIh1Z65DxSKckcegX+12wPX1HDAufS
 6DLaNXEmK+6SUYnJSCid6X/e/or0HUJ0k3AtiyBYw5uI9mGn/JcS4tImhjh4kciJNH
 X/Wf+NZMWaw0Zgs+WhyjE7LIwhX63wb3G55gQ4Ojami2HU4r7mcvderuLVncCAjVbL
 asBcBC2NDJc9g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 maz@kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com,
 julien@xen.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v4 kvmtool 00/12] arm64: Allow the user to set RAM base
 address
Date: Fri,  1 Jul 2022 16:41:24 +0100
Message-Id: <165668808723.3745248.3708834385367183136.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220616134828.129006-1-alexandru.elisei@arm.com>
References: <20220616134828.129006-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

On Thu, 16 Jun 2022 14:48:16 +0100, Alexandru Elisei wrote:
> The series can be found at [1]. It is loosely based on the patches that
> allow the user to define the VM memory layout (RAM + MMIO) [2]. I've
> cherry-picked a handful of patches from that series, the rest I wrote from
> scratch since there have been several changes to the way guest memory is
> handled. I've chosen to focus on specifying the RAM layout with only one
> RAM bank and leave the rest for a later series because this was relatively
> easy to accomplish, while still being very useful.
> 
> [...]

Applied to kvmtool (master), thanks!

[01/12] Use MB for megabytes consistently
        https://git.kernel.org/will/kvmtool/c/024c331b8483
[02/12] builtin-run: Always use RAM size in bytes
        https://git.kernel.org/will/kvmtool/c/9d655190e466
[03/12] builtin-run: Rework RAM size validation
        https://git.kernel.org/will/kvmtool/c/28b96259fbdf
[04/12] builtin-run: Add arch hook to validate VM configuration
        https://git.kernel.org/will/kvmtool/c/abe3f28a9c07
[05/12] arm/arm64: Fail if RAM size is too large for 32-bit guests
        https://git.kernel.org/will/kvmtool/c/cce5a4f6ae9b
[06/12] arm/arm64: Kill the ARM_MAX_MEMORY() macro
        https://git.kernel.org/will/kvmtool/c/1af57dcdce51
[07/12] arm/arm64: Kill the ARM_HIMAP_MAX_MEMORY() macro
        https://git.kernel.org/will/kvmtool/c/d6d4220133b7
[08/12] builtin_run: Allow standard size specifiers for memory
        https://git.kernel.org/will/kvmtool/c/a9c24ec78b4f
[09/12] kvm__arch_init: Remove hugetlbfs_path and ram_size as parameters
        https://git.kernel.org/will/kvmtool/c/5e9c654e60e8
[10/12] arm/arm64: Consolidate RAM initialization in kvm__init_ram()
        https://git.kernel.org/will/kvmtool/c/a37dad0ea9c7
[11/12] Introduce kvm__arch_default_ram_address()
        https://git.kernel.org/will/kvmtool/c/3f7e48f621bb
[12/12] arm64: Allow the user to specify the RAM base address
        https://git.kernel.org/will/kvmtool/c/8b91a1828ee9

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
