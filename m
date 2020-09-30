Return-Path: <SRS0=CuDs=DH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DDFC4727E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 10:30:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B3FA2075F
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 10:30:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSzAjcbE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B3FA2075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8014B3FB;
	Wed, 30 Sep 2020 06:30:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id znpZEGzsK2fy; Wed, 30 Sep 2020 06:30:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 879BF4B41E;
	Wed, 30 Sep 2020 06:30:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A5B4B414
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 06:30:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id np1Mx-bVKNPw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 06:30:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB2084B3FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 06:30:06 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 23AE12074A;
 Wed, 30 Sep 2020 10:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601461805;
 bh=KcOK93l5fC2kmWQcf22L6pyG3jezJMbpRjoKe+SCDvM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=KSzAjcbEhRH74NDi+zlAXPeoN1Ay9pchFE6xmNJPAfj5GSuzgTyY6626GILD7Sr71
 mEoJpjun4TjL7+JlI5AgIgu9PpEIFA8A4KtI2cKFU5ys5WDddF1Y52H0Y2lHxw9lQO
 drGWgRPLEgPrBjtCgeXlmYmPd1vMKyCSOnhrTIpQ=
Date: Wed, 30 Sep 2020 11:30:00 +0100
From: Will Deacon <will@kernel.org>
To: maz@kernel.org
Subject: Re: [PATCH] KVM: arm64: Ensure user_mem_abort() return value is
 initialised
Message-ID: <20200930103000.GA15957@willie-the-truck>
References: <20200930102442.16142-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200930102442.16142-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel test robot <lkp@intel.com>, Will Deacon <willdeacon@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Dan Carpenter <dan.carpenter@oracle.com>
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

On Wed, Sep 30, 2020 at 11:24:42AM +0100, Will Deacon wrote:
> From: Will Deacon <willdeacon@google.com>

Bugger, sorry, committed this in the wrong tree and got the wrong address on
it. Patch is still fine, but the author should be my kernel.org address, to
match the SoB.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
