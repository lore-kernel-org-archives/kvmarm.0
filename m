Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B6DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 16 Feb 2022 16:11:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3734649EF8;
	Wed, 16 Feb 2022 11:11:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nvQjimwdCgEA; Wed, 16 Feb 2022 11:11:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F390549EF3;
	Wed, 16 Feb 2022 11:11:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03D1949DED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:11:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jBSCQD3ll-7r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 11:11:32 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7584A411C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 11:11:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 99557B81F1E;
 Wed, 16 Feb 2022 16:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96049C340F0;
 Wed, 16 Feb 2022 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645027890;
 bh=Gv9fQIJr29i8l+LAmPL8ngrxHr5o6Nworu2jiocP76o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=X0P65ijpUNEwUX3uOsiOyiaWZ/ttKXefxaw/HCwKZQl5Xm58E1Q7EZQ6LdZS5Y2Wi
 P1l2R9S6R5OoGFvr1RL40/0HytzXVJOJApXNt03Oqb9ThN23v21ujzh85Pr/BQlWuT
 PsuM/8s6/Uj3MpVWlTWxOPr5nA0p4AmAeMGr+Dx2XgwWQEwHjS+8Zk5pV4YvI31O/y
 UKL1GnFgqcvBmzCb6LsNEoTTRD7EXlNBBoTBvsdYpb5/x1tZPT/CrURCSt3N4fVcbn
 swznY7Is6pL6Penp81mTvdPZjOirJjHZGaEatDPOwY5Fq+xJcN44p+5WPFU13WhWL+
 iTsyv6tcd81Tg==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH][kvmtool] virtio/pci: Signal INTx interrupts as level
 instead of edge
Date: Wed, 16 Feb 2022 16:11:20 +0000
Message-Id: <164502693231.1968323.7402472324417525816.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220131160242.2665191-1-maz@kernel.org>
References: <20220131160242.2665191-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Pierre Gondois <pierre.gondois@arm.com>, Will Deacon <will@kernel.org>,
 catalin.marinas@arm.com, Andre Przywara <andre.przywara@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>, kernel-team@android.com
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

On Mon, 31 Jan 2022 16:02:42 +0000, Marc Zyngier wrote:
> It appears that the way INTx is emulated is "slightly" out of spec
> in kvmtool. We happily inject an edge interrupt, even if the spec
> mandates a level.
> 
> This doesn't change much for either the guest or userspace (only
> KVM will have a bit more work tracking the EOI), but at least
> this is correct.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio/pci: Signal INTx interrupts as level instead of edge
      https://git.kernel.org/will/kvmtool/c/2108c86d0623

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
