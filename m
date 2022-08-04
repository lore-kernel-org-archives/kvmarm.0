Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE61C19F2A
	for <kvmarm@archiver.kernel.org>; Thu,  4 Aug 2022 15:02:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8725E5011A;
	Thu,  4 Aug 2022 11:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XY3CrOG6-qR7; Thu,  4 Aug 2022 11:02:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A790D5011D;
	Thu,  4 Aug 2022 11:02:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA9F5011D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 11:02:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wlUDuuSG31af for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 11:02:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA24D5010A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 11:02:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EE95CB825B9;
 Thu,  4 Aug 2022 15:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127BBC433D7;
 Thu,  4 Aug 2022 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1659625356;
 bh=VfHTA1fJNRzuyymLQLhd2Gf5avPwwQWbxAf9Ab2H/QY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PDvh55Vj2wgyRHC/Ue8HoLk0dtlTdABXoZqL93TOsL3taIy5RHgM8WEkOTWCfH3SR
 oZt+k2c/Nv20OiwuUrYrFKPpKrZUy8uNSYLx0/zGd/r7tUNdMFCD5ntqRKFem9WzaA
 R8ntG7wsKGoGowHzc9hmgnAgMXyHrGv+StbmXjkqLyScAog1SaZInGYOok4RF47Jhj
 I10OzDs8f/U8/pu2sznnT3IizxCroyMswyCIAGFwaoDDfAPFIJOdYPUzrC6sx+XP2q
 q2pzW9lhdoBLOyVIpoaOdBfYUDSMeNcewb3pDH8niOVT1519zjAYaelEU9ZfUBWDzI
 zHUDNklIXkJTg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 andre.przywara@arm.com, anup@brainfault.org, kvmarm@lists.cs.columbia.edu,
 Alexandru Elisei <alexandru.elisei@arm.com>, vladimir.murzin@arm.com,
 james.morse@arm.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 0/1] Introduce LIBFDT_DIR
Date: Thu,  4 Aug 2022 16:02:26 +0100
Message-Id: <165962495458.743757.15372017164255102426.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220722141448.168252-1-alexandru.elisei@arm.com>
References: <20220722141448.168252-1-alexandru.elisei@arm.com>
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

On Fri, 22 Jul 2022 15:14:47 +0100, Alexandru Elisei wrote:
> This is based on the series that added the libfdt source files to the
> kvmtool tree [1]. I've reconsidered the feedback I got from Andre and Will,
> and so I came up with a different approach: the user can opt to compile
> libdt without installing it system-wide and use LIBFDT_DIR to point kvmtool
> to the static version of the library.
> 
> For example, to cross-compile for arm64:
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Makefile: Introduce LIBFDT_DIR to specify libfdt location
      https://git.kernel.org/will/kvmtool/c/336751fb10ef

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
