Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DF9C43334
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 15:41:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 356A54B60E;
	Fri,  1 Jul 2022 11:41:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sW8ntBuYopED; Fri,  1 Jul 2022 11:41:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E52464B604;
	Fri,  1 Jul 2022 11:41:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D0C4B604
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xzwVuiweJdq0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 11:41:40 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F73E4B5FF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:41:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A270962489;
 Fri,  1 Jul 2022 15:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF0EC3411E;
 Fri,  1 Jul 2022 15:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656690098;
 bh=7lItzP8zk4+BxeCmQ67G5wnVeuTEXK2Jibl4RLB/M9U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CORsKudJ2UCn0GzOal85kXMilqwwZocTO1kA/3IgpreJk24wOuI2HEvI6g6SGsT9P
 Mlv5owJe9uo1Jm8+6+M9zDmjCOyqUZbf97svGObhQGGnTpq5zidjkjgaRk/qazHoGj
 u2OOW5REoQ40ejM4mTUNVAhTgHrLVUKDL06RmlFRCqnakQH9w+XQ4BzNAm99fKeGlj
 vU5qNNp9sPuh6dOcJQMLSmRVBhC/V3Tm4SqxYB5q+lJMdVmzB3X5Jt3YbCbFrWcBvK
 SbeYTqOpLHtK99/Pyyl6U9a8jI7yIjrpYJQsGV15iQJbDxYLI9FFS++lYO9quqV6NU
 3mwJrLBW//WFw==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com, andre.przywara@arm.com, maz@kernel.org,
 Alexandru Elisei <alexandru.elisei@arm.com>, sebastianene@google.com,
 pierre.gondois@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH kvmtool] arm64: pvtime: Use correct region size
Date: Fri,  1 Jul 2022 16:41:23 +0100
Message-Id: <165668952034.421187.14859187831399456002.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220629103905.24480-1-alexandru.elisei@arm.com>
References: <20220629103905.24480-1-alexandru.elisei@arm.com>
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

On Wed, 29 Jun 2022 11:39:05 +0100, Alexandru Elisei wrote:
> pvtime uses ARM_PVTIME_BASE instead of ARM_PVTIME_SIZE for the size of the
> memory region given to the guest, which causes to the following error when
> creating a flash device (via the -F/--flash command line argument):
> 
>   Error: RAM (read-only) region [2000000-27fffff] would overlap RAM region [1020000-203ffff]
> 
> The read-only region represents the guest memory where the flash image is
> copied by kvmtool. The region starting at 0x102_0000 (ARM_PVTIME_BASE) is
> the pvtime region, which should be 64K in size. kvmtool erroneously creates
> the region to be ARM_PVTIME_BASE in size instead, and the last address
> becomes:
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm64: pvtime: Use correct region size
      https://git.kernel.org/will/kvmtool/c/6a1f699108e5

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
