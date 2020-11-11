Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C6BC388F9
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 22:01:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EBCB20797
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 22:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jldkB27k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EBCB20797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0224B8CE;
	Wed, 11 Nov 2020 17:01:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FyU8Je56VWsm; Wed, 11 Nov 2020 17:01:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E43D4B8C1;
	Wed, 11 Nov 2020 17:01:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E976A4B8BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 17:01:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CT+KTjDWfFPI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 17:01:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD2144B8BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 17:01:12 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4BED20709;
 Wed, 11 Nov 2020 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605132071;
 bh=yfmnLKnD360CSGBWVhdrKZ/Sup7sBNsW6MAI3Nfho2k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jldkB27kxTY+vA/vzf03GgekORhjmJNW639J6cu9somkjx6HWjYcF8OJiQ+JOZyDe
 J40iTJ/dweKJYW5WKzVpWdSZN3qjSDRKYdcvOgim6L3+ObB/PIyVJ2//I/+WFWJmxA
 h3dl5YO5W+jPMlChG6KmNmqrkRnIJVIBbKLpnva4=
Date: Wed, 11 Nov 2020 22:01:06 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2
 from userspace
Message-ID: <20201111220105.GA18414@willie-the-truck>
References: <20201110141308.451654-1-maz@kernel.org>
 <20201110141308.451654-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201110141308.451654-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 10, 2020 at 02:13:06PM +0000, Marc Zyngier wrote:
> We now expose ID_AA64PFR0_EL1.CSV2=1 to guests running on hosts
> that are immune to Spectre-v2, but that don't have this field set,
> most likely because they predate the specification.
> 
> However, this prevents the migration of guests that have started on
> a host the doesn't fake this CSV2 setting to one that does, as KVM
> rejects the write to ID_AA64PFR0_EL2 on the grounds that it isn't
> what is already there.
> 
> In order to fix this, allow userspace to set this field as long as
> this doesn't result in a promising more than what is already there
> (setting CSV2 to 0 is acceptable, but setting it to 1 when it is
> already set to 0 isn't).
> 
> Fixes: e1026237f9067 ("KVM: arm64: Set CSV2 for guests on hardware unaffected by Spectre-v2")
> Reported-by: Peng Liang <liangpeng10@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              | 16 ++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 42 ++++++++++++++++++++++++++++---
>  3 files changed, 56 insertions(+), 4 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
