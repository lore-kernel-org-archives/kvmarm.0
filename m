Return-Path: <SRS0=U5fj=VO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2201C76192
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 11:44:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D351205ED
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 11:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sF4zAqvm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D351205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88284A537;
	Wed, 17 Jul 2019 07:43:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hVrwrcSEUV9s; Wed, 17 Jul 2019 07:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14A24A563;
	Wed, 17 Jul 2019 07:43:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 705BF4A541
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 07:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UCP5fH5hTgf6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jul 2019 07:43:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D6244A537
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 07:43:55 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A238C205ED;
 Wed, 17 Jul 2019 11:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1563363834;
 bh=Ujtx3Yha188ZjWZa6A3epObXGpp/EmAPbG0aCvh0hUw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sF4zAqvmS1GOoCXb71KZmXkfYymheU+qLMsE9UIanxBBCZOX3qAu1IIxAwyaNTPrE
 Awwwh5k1BVH9siPw9Vnf45AniBX4Sc25DuCQLCEKcTEcMxsHkfM58nep+vvM0LdEaw
 qNmgpVcNV2rbWgTXOHq3ozGAiVrH0/vigfSGLxwI=
Date: Wed, 17 Jul 2019 12:43:49 +0100
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH] MAINTAINERS: Update my email address
Message-ID: <20190717114349.vegt6yyu577kynd4@willie-the-truck>
References: <1563359535-2762-1-git-send-email-julien.thierry@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1563359535-2762-1-git-send-email-julien.thierry@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Jul 17, 2019 at 11:32:15AM +0100, Julien Thierry wrote:
> My @arm.com address will stop working in a couple of weeks. Update
> MAINTAINERS and .mailmap files with an address I'll have access to.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

I'll pick this up at -rc1.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
