Return-Path: <SRS0=6MoU=NW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10419C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 31 Aug 2021 15:06:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 857B26103A
	for <kvmarm@archiver.kernel.org>; Tue, 31 Aug 2021 15:06:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 857B26103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 146224B21F;
	Tue, 31 Aug 2021 11:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qu1qy+FKX6sB; Tue, 31 Aug 2021 11:06:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E70ED4B1E3;
	Tue, 31 Aug 2021 11:06:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28FF34B190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Aug 2021 11:06:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P76OuSr9wBHr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Aug 2021 11:06:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 081564A126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Aug 2021 11:06:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC51860F9E;
 Tue, 31 Aug 2021 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1630422365;
 bh=ViEcZriqNGftF6CD6GvE421AsLC+XWVHOYgf9s6bi40=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ucV/l2krKJt53NOLNvrINOu+/Vf0KBjb+f7K+Yg9yirJro99zhofmSGOkgMkGuU9M
 HANpEBMBspd9KoD1rFuzb2rV4cUy2hGFuGRGEOKwkVGXUFI06eC/y2NAUxz+pnA793
 B3LFHqG0VGfB8R0dTjllr9lVv0lylGd0Cy175lRXA9VN74GQzq6SYySYJzTc7yZCie
 Ex8Or2SMqEq3V0SexX605y06M3BVe+ykaf0BGx+Wid/Mpt+za3tArccRz3DQdSS3tW
 7O4IBNlZy45gZ0yIMLKUJISoL5ECmbawIljG/R+p9eYuH3B7QWR7P5CJfOrw1E9UtV
 Dgl2UjBhjhpcA==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: Re: [PATCH][kvmtool] virtio/pci: Size the MSI-X bar according to the
 number of MSI-X
Date: Tue, 31 Aug 2021 16:05:56 +0100
Message-Id: <163042127389.1911500.12320690511273820628.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210827115405.1981529-1-maz@kernel.org>
References: <20210827115405.1981529-1-maz@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, Andre Przywara <andre.przywara@arm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>
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

On Fri, 27 Aug 2021 12:54:05 +0100, Marc Zyngier wrote:
> Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
> per PCI device"), the number of MSI-S has gone from 4 to 33.
> 
> However, the corresponding storage hasn't been upgraded, and writing
> to the MSI-X table is a pretty risky business. Now that the Linux
> kernel writes to *all* MSI-X entries before doing anything else
> with the device, kvmtool dies a horrible death.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio/pci: Size the MSI-X bar according to the number of MSI-X
      https://git.kernel.org/will/kvmtool/c/2e7380db438d

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
