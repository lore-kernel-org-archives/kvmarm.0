Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F02C33CA1
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 08:20:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94AD22077C
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 08:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vwhphxIl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94AD22077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16C154AEC9;
	Mon, 20 Jan 2020 03:20:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZUesKoFpVEvL; Mon, 20 Jan 2020 03:20:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E5D4AEB4;
	Mon, 20 Jan 2020 03:20:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A714A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 03:20:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5NUU-6N7lIGa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 03:20:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 496DA4A54B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 03:20:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 014D12077C;
 Mon, 20 Jan 2020 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579508440;
 bh=uTRV3naHZ7SuwBCAU/nj+43MXDJ0Er9eYJ3n0a5uSAw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=vwhphxIl+rZV5Voty1CQHVbRAylVOwk9FnX7nlJDQvius/K5FOX4POAZx/4O7bL70
 kjOQJrkAdt8AJ8j761YyDDyBysquN9PjiePOedGMy+rfZQz7vgaQhUlW35KB6JAFrp
 G9jpZ4gNdMLfhuVmMwlkxtpGWHZvbXDJE38Qh2LU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itSIY-000Cwb-64; Mon, 20 Jan 2020 08:20:38 +0000
Date: Mon, 20 Jan 2020 08:20:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH v2] arm64: kvm: fix IDMAP overlap with HYP VA
Message-ID: <20200120082036.5bea3a89@why>
In-Reply-To: <20200119194340.GW25745@shell.armlinux.org.uk>
References: <E1ilAiY-0000MA-RG@rmk-PC.armlinux.org.uk>
 <20200119174327.4b2c514e@why>
 <20200119194340.GW25745@shell.armlinux.org.uk>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux@armlinux.org.uk, james.morse@arm.com,
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

On Sun, 19 Jan 2020 19:43:40 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Sun, Jan 19, 2020 at 05:43:27PM +0000, Marc Zyngier wrote:
> > On Sat, 28 Dec 2019 11:57:14 +0000
> > Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >   
> > > Booting 5.4 on LX2160A reveals that KVM is non-functional:
> > > 
> > > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > > kvm [1]: IPA Size Limit: 43bits
> > > kvm [1]: IDMAP intersecting with HYP VA, unable to continue
> > > kvm [1]: error initializing Hyp mode: -22
> > > 
> > > Debugging shows:
> > > 
> > > kvm [1]: IDMAP page: 81a26000
> > > kvm [1]: HYP VA range: 0:22ffffffff
> > > 
> > > as RAM is located at:
> > > 
> > > 80000000-fbdfffff : System RAM
> > > 2080000000-237fffffff : System RAM
> > > 
> > > Comparing this with the same kernel on Armada 8040 shows:
> > > 
> > > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > > kvm [1]: IPA Size Limit: 43bits
> > > kvm [1]: IDMAP page: 2a26000
> > > kvm [1]: HYP VA range: 4800000000:493fffffff
> > > ...
> > > kvm [1]: Hyp mode initialized successfully
> > > 
> > > which indicates that hyp_va_msb is set, and is always set to the
> > > opposite value of the idmap page to avoid the overlap. This does not
> > > happen with the LX2160A.
> > > 
> > > Further debugging shows vabits_actual = 39, kva_msb = 38 on LX2160A and
> > > kva_msb = 33 on Armada 8040. Looking at the bit layout of the HYP VA,
> > > there is still one bit available for hyp_va_msb. Set this bit
> > > appropriately. This allows kvm to be functional on the LX2160A, but
> > > without any HYP VA randomisation:
> > > 
> > > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > > kvm [1]: IPA Size Limit: 43bits
> > > kvm [1]: IDMAP page: 81a24000
> > > kvm [1]: HYP VA range: 4000000000:62ffffffff
> > > ...
> > > kvm [1]: Hyp mode initialized successfully
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> > 
> > I've applied this to kvmarm-next with a couple of cleanups, and
> > preserving the fallback when the tag is zero (only the mask gets
> > applied, without any ROR or ADD).  
> 
> If only the mask is applied, then it will overlap with the IDMAP
> region, and KVM will fail 

If the tag (which includes the V-1 bit) is *zero*, what else would you
add?

> - so I think it would be a good idea in
> that case to print something a little more useful, rather than
> attributing the KVM failure to an overlap of IDMAP and the KVM
> range.

What other failure mode do you anticipate?

> The real problem is there aren't enough VA bits to allow the KVM
> range to be adequately placed, rather than the overlap itself.

I don't get your point. By construction, there *are* enough VA bits,
since EL2 is only concerned with the linear mapping which only occupies
(at most) half of that VA space. If we can't do that at EL2, then we
can't do it at EL1 either.

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
