Return-Path: <SRS0=K5Hb=K2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165E1C47082
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 11:46:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76C496135C
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 11:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76C496135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EF44029F;
	Mon, 31 May 2021 07:46:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BIefYQly1AnZ; Mon, 31 May 2021 07:46:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E5640762;
	Mon, 31 May 2021 07:46:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8C94029F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 07:46:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 52G-hKh4j+tY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 May 2021 07:46:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86A20400D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 07:46:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AB7610A6;
 Mon, 31 May 2021 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1622461566;
 bh=g5oty2gYfesCWaDdgy+XYzkAsq7/CBguYDeSUuMewns=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=OLnYchXLNVWgmYYNxGjf9iA0AR/VwiC+taYYPCUxlTbnosN9qYOvrLBDX7GdwRev1
 sXS+oBM8FB8m3wgBz13gT/W+sTY8E3RvAOv5faU1GnNB5E3eGybhKc82qXjU/pZCeW
 EZXVYR/3e3cBvYMQlaxyzSwJT0eZikAQXDrcu10o=
Date: Mon, 31 May 2021 13:46:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [stable-rc] 5.12 arch/arm64/kvm/arm.c:722:8: error: use of
 undeclared label 'out'
Message-ID: <YLTMe3O4NDZlsxpD@kroah.com>
References: <CA+G9fYtwjDoDr=hrSGLg4x5pv3Kq-MbCTzohy3=yLLN7P-Czqw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+G9fYtwjDoDr=hrSGLg4x5pv3Kq-MbCTzohy3=yLLN7P-Czqw@mail.gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, May 31, 2021 at 04:43:52PM +0530, Naresh Kamboju wrote:
> The Linux stable-rc 5.12 arm64 builds failed due to these warnings / errors.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> arch/arm64/kvm/arm.c:722:8: error: use of undeclared label 'out'
>                 goto out;
>                      ^
> arch/arm64/kvm/arm.c:918:1: warning: unused label 'out' [-Wunused-label]
> out:
> ^~~~
> 1 warning and 1 error generated.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

This will be fixed in a few minutes, it was reported right before you:
	https://lore.kernel.org/r/0d9f123c-e9f7-7481-143d-efd488873082@huawei.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
