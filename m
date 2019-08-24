Return-Path: <SRS0=WQoh=WV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED92C3A5A1
	for <kvmarm@archiver.kernel.org>; Sun, 25 Aug 2019 09:29:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C110217D7
	for <kvmarm@archiver.kernel.org>; Sun, 25 Aug 2019 09:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIAB4BxM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C110217D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9624A646;
	Sun, 25 Aug 2019 05:29:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mSpFSdMRbVz1; Sun, 25 Aug 2019 05:29:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 810C84A64B;
	Sun, 25 Aug 2019 05:29:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23924A5C6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Aug 2019 14:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDXVzHBu193V for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Aug 2019 14:45:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F4654A5B9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Aug 2019 14:45:09 -0400 (EDT)
Subject: Re: [GIT PULL] arm64: Fixes for -rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1566672308;
 bh=7Qs4bkWflVG2mFrf3I3eozRzQTQ5YMm/Ki/3Id1X/AI=;
 h=From:In-Reply-To:References:Date:To:Cc:From;
 b=nIAB4BxMmxWEosyKv10E7oJVldQ05MeERhSeCglIKLgjWljr2Wy5JQY1UX+ndUgn3
 85W+dw4yr9dwMkmlTWdwamz5jUpmnBygOpzNglxppFzcLo+q912QCdTpN1keUHwAiy
 1qqAgCYxQsCP+OOZr+dEFbmf7yhi9qeIoQBh2hQQ=
From: pr-tracker-bot@kernel.org
In-Reply-To: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
References: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
 tags/arm64-fixes
X-PR-Tracked-Commit-Id: 087eeea9adcbaef55ae8d68335dcd3820c5b344b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a022eccf7c468efcb8aa5192b8d13e20127bbac
Message-Id: <156667230824.2337.2969578272613309440.pr-tracker-bot@kernel.org>
Date: Sat, 24 Aug 2019 18:45:08 +0000
To: Will Deacon <will@kernel.org>
X-Mailman-Approved-At: Sun, 25 Aug 2019 05:29:25 -0400
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The pull request you sent on Sat, 24 Aug 2019 13:12:55 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a022eccf7c468efcb8aa5192b8d13e20127bbac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
