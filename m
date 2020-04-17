Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D43C38A2B
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 15:06:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C59A2223D
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 15:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O49ELBs/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C59A2223D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB044B1B9;
	Fri, 17 Apr 2020 11:06:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wqx0Fo+Zg+7Y; Fri, 17 Apr 2020 11:06:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA95B4B1CC;
	Fri, 17 Apr 2020 11:06:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435F04B18C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 11:06:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bp4GT90U9XiW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 11:06:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15A704B15D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 11:06:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E6BA320857;
 Fri, 17 Apr 2020 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587135966;
 bh=VD3NiQgcjY0DUGZAjRsEC+ytO3vlZSGq4k2zQEHZ9AA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=O49ELBs/WQwrUBMUrrWH4KUCznZ97VVDgy2iJ4DWXor8xO8MHIdT4DU86vRFhhNR6
 N2JtD2m1ZBMRnc4vrajOj2f438b4/hQbXGP+fXuoconP7Ok+MOgGQKWCHg72xCfulK
 kBvzxccuHjPTkz0ZqdO/vA4B7W0w2Grr+LCLnD2w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jPSZA-004DB1-9N; Fri, 17 Apr 2020 16:06:04 +0100
Date: Fri, 17 Apr 2020 16:06:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: "Zengtao (B)" <prime.zeng@hisilicon.com>
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Message-ID: <20200417160602.26706917@why>
In-Reply-To: <3e84aaf8b757bc5a7685a291e54c232b@kernel.org>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
 <3e84aaf8b757bc5a7685a291e54c232b@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: prime.zeng@hisilicon.com, gcherian@marvell.com,
 Dave.Martin@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com,
 christoffer.dall@arm.com, james.morse@arm.com, jintack@cs.columbia.edu,
 julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 suzuki.poulose@arm.com, areddy3@marvell.com, gkulkarni@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, Ganapatrao Kulkarni <gkulkarni@marvell.com>,
 kvm@vger.kernel.org, andre.przywara@arm.com,
 George Cherian <gcherian@marvell.com>, linux-arm-kernel@lists.infradead.org,
 Anil Kumar Reddy H <areddy3@marvell.com>, Dave.Martin@arm.com
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

On Thu, 16 Apr 2020 19:22:21 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Hi Zengtao,
> 
> On 2020-04-16 02:38, Zengtao (B) wrote:
> > Hi Marc:
> > 
> > Got it.
> > Really a bit patch set :)  
> 
> Well, yeah... ;-)
> 
> > 
> > BTW, I have done a basic kvm unit test
> > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> > And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> > The psci test failed for some reason, I can't understand why, this
> > is only the test result.(find the patch by git bisect + kvm test)  
> 
> That it is that mechanical, we should be able to quickly nail that one.
> 
> > My platform: Hisilicon D06 board.
> > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> > Could you help to take a look?  
> 
> I'll have a look tomorrow. I'm in the middle of refactoring the series
> for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
> vs non-VHE issue.

So I've repeatedly tried with the current state of the NV patches[1],
on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid junk
(vim3l). PSCI is pretty happy, although I can only test with at most 8
vcpus (GICv2 gets in the way).

Can you please:

- post the detailed error by running the PSCI unit test on its own
- test with the current state of the patches

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-5.7-rc1-WIP
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
