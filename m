Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F77C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 18:32:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A646921D92
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 18:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEuH0DiJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A646921D92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA504B358;
	Fri, 11 Sep 2020 14:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JtVspBNqggro; Fri, 11 Sep 2020 14:32:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D304B31F;
	Fri, 11 Sep 2020 14:32:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16E214B31F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 14:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GfjV5iW+3sX6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 14:32:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 116F34B2FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 14:32:42 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5B29421D92;
 Fri, 11 Sep 2020 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599849161;
 bh=nnLh5PDA50PBANZGznYbikGGD8qINrJ/18+17ey7VJo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VEuH0DiJpBqGNEt7WfWFUghkpFZqMPYZz9XwXnbI1pL9sLYCR+Ax2Ksr5OgIhqQM9
 IU2WGfChGdFBbaS2WKRMOyicVLzInTg3VKGaFL7jqPIMLP6QNpfO5UFWwF+uRfR1JJ
 yWy7FdM37dclb+I8FmeNDGZSbqg3fFQpAdk2Z+P4=
From: Will Deacon <will@kernel.org>
To: Pingfan Liu <kernelfans@gmail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/2] Documentation/kvm/arm: improve description of
 HVC_SOFT_RESTART
Date: Fri, 11 Sep 2020 19:32:37 +0100
Message-Id: <159984895041.2629375.6685480407417202629.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1598621998-20563-2-git-send-email-kernelfans@gmail.com>
References: <1598621998-20563-1-git-send-email-kernelfans@gmail.com>
 <1598621998-20563-2-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org,
 Geoff Levand <geoff@infradead.org>, catalin.marinas@arm.com,
 Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, 28 Aug 2020 21:39:58 +0800, Pingfan Liu wrote:
> Besides disabling MMU, HVC_SOFT_RESTART also clears I+D bits. These behaviors
> are what kexec-reboot expects, so describe it more precisely.

Applied to arm64 (for-next/boot), thanks!

[1/1] Documentation/kvm/arm: improve description of HVC_SOFT_RESTART
      https://git.kernel.org/arm64/c/3a1793066fdf

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
