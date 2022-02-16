Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03433C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Feb 2022 16:11:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B140408BA;
	Wed, 16 Feb 2022 11:11:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id taNDzIg1vuqH; Wed, 16 Feb 2022 11:11:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFFA549E3F;
	Wed, 16 Feb 2022 11:11:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AD649B0E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:11:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHAKegxgCd7Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 11:11:31 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2461E408BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:11:31 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 72C9CB81F67;
 Wed, 16 Feb 2022 16:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5870EC004E1;
 Wed, 16 Feb 2022 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645027888;
 bh=T55G/11Y1oiYmF+1j/uPL7cCs5GJVxmzOFnwXcSCwxY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=FnR12cvKX97Jqj0O2e87vd18jVujAjsE8oswjwBnnbJsx9nEPusSxE3lLp1ySYp5s
 FPovzwJqGyPsOLxPx3broUxLD48exc3AoBCMjG08p1BateqRIYNAapOGGyv1jwc0a1
 X2T41saN8Sw2kIAaq4y66uNCE3gaLwJndDRWRYlOzLly2Qxon+bjAmFJimJiBWZwJ6
 Kr7Ue+tW/K6dq0UOKVoilw4MOp9KGtGO0KlHn9HM5oFhIbjmU64ujFoy9xVoz9aICR
 AEgM505brdL84b1rdh/i95Kdb1M+iD4ZCyCor6msN560UdBE/ofaxfrMef6bduRQNv
 pgN/og9TTgsrw==
From: Will Deacon <will@kernel.org>
To: andre.przywara@arm.com, Alexandru Elisei <alexandru.elisei@arm.com>,
 pierre.gondois@arm.com, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 0/3] Misc fixes
Date: Wed, 16 Feb 2022 16:11:19 +0000
Message-Id: <164502718020.1969392.9699126746620631658.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
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

On Mon, 14 Feb 2022 16:58:27 +0000, Alexandru Elisei wrote:
> These are a handful of small fixes for random stuff which I found while
> using kvmtool.
> 
> Patch #1 is actually needed to use kvmtool as a test runner for
> kvm-unit-tests (more detailed explanation in the commit message).
> 
> Patch #2 is more like a quality of life improvement for users.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] Remove initrd magic check
      https://git.kernel.org/will/kvmtool/c/9b681b0827d7
[2/3] arm: Use pr_debug() to print memory layout when loading a firmware image
      https://git.kernel.org/will/kvmtool/c/c334a68e202e
[3/3] arm: pci: Generate "msi-parent" property only with a MSI controller
      https://git.kernel.org/will/kvmtool/c/95f47968a1d3

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
