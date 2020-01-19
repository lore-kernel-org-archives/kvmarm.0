Return-Path: <SRS0=D0fm=3I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0CBC3F68F
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 17:43:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09EF6206D7
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 17:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmLd1ry7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09EF6206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54EE24AE96;
	Sun, 19 Jan 2020 12:43:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4M9YvKLuOK4W; Sun, 19 Jan 2020 12:43:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D5314A959;
	Sun, 19 Jan 2020 12:43:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE82B4A946
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 12:43:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9sXc6x7h1QME for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 12:43:32 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62D254A7FD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 12:43:32 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01D4320674;
 Sun, 19 Jan 2020 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579455811;
 bh=R0N0qdRvwA0CSQsT/alDM97aT/J/0dgnyJzGEbfyDhM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=RmLd1ry7lvMf/1dyH4I/wdco57Za4aj+As791DgPUn2DNnmdDV+6tnrt+HS+AWocT
 uTjnpfDYIuUpZ8yHToVG8n4Aa32cyZe/DIZAYjNfuJKmSQ91ADCQBXVcWJ04j5UBQd
 wDW5WgEHkPIau9KIyF3uJY1j3D3QKFsI4h0oKyeo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itEbg-0004D7-P4; Sun, 19 Jan 2020 17:43:28 +0000
Date: Sun, 19 Jan 2020 17:43:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v2] arm64: kvm: fix IDMAP overlap with HYP VA
Message-ID: <20200119174327.4b2c514e@why>
In-Reply-To: <E1ilAiY-0000MA-RG@rmk-PC.armlinux.org.uk>
References: <E1ilAiY-0000MA-RG@rmk-PC.armlinux.org.uk>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: rmk+kernel@armlinux.org.uk, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Sat, 28 Dec 2019 11:57:14 +0000
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Booting 5.4 on LX2160A reveals that KVM is non-functional:
> 
> kvm: Limiting the IPA size due to kernel Virtual Address limit
> kvm [1]: IPA Size Limit: 43bits
> kvm [1]: IDMAP intersecting with HYP VA, unable to continue
> kvm [1]: error initializing Hyp mode: -22
> 
> Debugging shows:
> 
> kvm [1]: IDMAP page: 81a26000
> kvm [1]: HYP VA range: 0:22ffffffff
> 
> as RAM is located at:
> 
> 80000000-fbdfffff : System RAM
> 2080000000-237fffffff : System RAM
> 
> Comparing this with the same kernel on Armada 8040 shows:
> 
> kvm: Limiting the IPA size due to kernel Virtual Address limit
> kvm [1]: IPA Size Limit: 43bits
> kvm [1]: IDMAP page: 2a26000
> kvm [1]: HYP VA range: 4800000000:493fffffff
> ...
> kvm [1]: Hyp mode initialized successfully
> 
> which indicates that hyp_va_msb is set, and is always set to the
> opposite value of the idmap page to avoid the overlap. This does not
> happen with the LX2160A.
> 
> Further debugging shows vabits_actual = 39, kva_msb = 38 on LX2160A and
> kva_msb = 33 on Armada 8040. Looking at the bit layout of the HYP VA,
> there is still one bit available for hyp_va_msb. Set this bit
> appropriately. This allows kvm to be functional on the LX2160A, but
> without any HYP VA randomisation:
> 
> kvm: Limiting the IPA size due to kernel Virtual Address limit
> kvm [1]: IPA Size Limit: 43bits
> kvm [1]: IDMAP page: 81a24000
> kvm [1]: HYP VA range: 4000000000:62ffffffff
> ...
> kvm [1]: Hyp mode initialized successfully
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

I've applied this to kvmarm-next with a couple of cleanups, and
preserving the fallback when the tag is zero (only the mask gets
applied, without any ROR or ADD).

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
