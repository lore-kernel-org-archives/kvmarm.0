Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31184C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 09:17:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934734B2F9;
	Thu, 26 May 2022 05:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XXm3yk1R229j; Thu, 26 May 2022 05:17:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C024B29C;
	Thu, 26 May 2022 05:17:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18AEB4B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 05:17:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dRvddddWmW6g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 05:17:47 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E90DD4B28B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 05:17:46 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 44A03B81F74;
 Thu, 26 May 2022 09:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49242C34118;
 Thu, 26 May 2022 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653556664;
 bh=x+lBBuqopDOuNZyM+ku5PFUpxXP459/dEt1EtMFdA/o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GmWpkyOqlaT3AOeKT57ufXOMyRRsfLnjauXQ6qDTW6Yc9HbMhwJf9Uwrzhzpxr8kC
 7dnc1B7uClVr8zofQMi+C0W73UuTrtSAM0LYMMAZ1oObG6Prbb3x78F2HfzJxZsUov
 btaU0/Ju/Tw/0ADV+mbKdb5KX3DIZRwJ2DebpsVsffeU3ewZSZhOBDqTqxtZ4K/w/X
 P1Y/Y6NKipu3lOWdamrRCmO4cdRakB+Au/6EwLf6SpKlt7cANy6R5CRbTa2N+DW1Kr
 LIxK6pvoEyg2esBcE9AXGmiV7jJWgT5H/CJNMiYXjX1XUh2W2pLtsPy0OuDD2eOuC1
 6GNOGbd+L9oqw==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 0/4] Update virtio headers (to fix build)
Date: Thu, 26 May 2022 10:17:34 +0100
Message-Id: <165355576397.3703094.17299737137964542053.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
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

On Tue, 24 May 2022 16:06:07 +0100, Andre Przywara wrote:
> Since we implement some virtio devices in kvmtool, we were including
> older copies of some virtio UAPI header files in our tree, but were
> relying on some other headers to be provided by the distribution.
> This leads to problems when we need to use newer virtio features (like
> the recent virtio_balloon stat update), which breaks compilation on some
> (older) distros.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] update virtio_mmio.h
      https://git.kernel.org/will/kvmtool/c/7e2209945bb5
[2/4] util: include virtio UAPI headers in sync
      https://git.kernel.org/will/kvmtool/c/393e2187cf68
[3/4] include: update virtio UAPI headers
      https://git.kernel.org/will/kvmtool/c/e5390783db61
[4/4] include: add new virtio uapi header files
      https://git.kernel.org/will/kvmtool/c/1a992bbaab08

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
