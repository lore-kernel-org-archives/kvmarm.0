Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FC3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 20:51:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61EB4B389;
	Fri, 20 May 2022 16:51:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y1z7nzhd4ONE; Fri, 20 May 2022 16:51:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA1E04B38B;
	Fri, 20 May 2022 16:51:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F40A94B385
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 16:51:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eb4PCw0yPRda for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 16:51:20 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E25124B383
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 16:51:19 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 980DBB82DC6;
 Fri, 20 May 2022 20:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8EAC385AA;
 Fri, 20 May 2022 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653079877;
 bh=snexT8cXup3ZljqY2ys1oA5OyV81LN0nqpxkls/EhZI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=o87d7orRtwAiJOvmSj/SEpLUfTBaqXuBn6EC0gWr58FASkdO6IwZDM84UBcYT46gQ
 0uPAXTgOYf+l5cM0Eukt9rnc2UA54XMBgYCSbeQTAVrlGOa11ubK+5xgkJMwfax1TR
 pcPAtcLxKz3g9kF5AV5Jgna50mzMfB9iVSyNbKwjE7mQ6ebd5dkZk3De4O/UvDir7d
 mqD9PC8v1mv54/fcj9un7+xYfT3M6b8uLlPl6LHqjNCFJWwaE5QtHvLsiUz4L822jP
 GXVL/xsWipnluEEyloYC8M9N+A5OHirDwtwV0uysgndR7vayYqVY/hhDSwsSTSoPY+
 yiYvWeiVmBnWw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH kvmtool] aarch64: Give up with MTE for AArch32 guest
Date: Fri, 20 May 2022 21:51:09 +0100
Message-Id: <165307788987.1659921.14418020994896633810.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220520123844.127733-1-vladimir.murzin@arm.com>
References: <20220520123844.127733-1-vladimir.murzin@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>, maz@kernel.org
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

On Fri, 20 May 2022 13:38:44 +0100, Vladimir Murzin wrote:
> KVM doesn't support combination of MTE and AArch32 guest, so do not
> even try.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] aarch64: Give up with MTE for AArch32 guest
      https://git.kernel.org/will/kvmtool/c/324cc0969b7c

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
