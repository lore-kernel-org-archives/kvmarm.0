Return-Path: <SRS0=D0fm=3I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFC0C33CAF
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 19:44:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 228AC20679
	for <kvmarm@archiver.kernel.org>; Sun, 19 Jan 2020 19:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="lnGZsRNo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 228AC20679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3AE4A7FD;
	Sun, 19 Jan 2020 14:44:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CFqakTuq5tmd; Sun, 19 Jan 2020 14:44:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 258034A95B;
	Sun, 19 Jan 2020 14:44:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EAA34A528
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 14:44:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GM4Sqss9h4rd for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 14:43:57 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4424D4A524
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 14:43:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=3z7zbcC6+n0ijVHwdWGh6TJYkP0ZMZNW/76LdpCfz2M=; b=lnGZsRNopbJxj2FTf8JDa48y7
 B1t1nQaMIi9rDCTtt3Hsz8CzHM+mudBxXR5dgMaU7tFbqU3BkIORoSTa1gR+xjukxXR6ijxKCxwEL
 L2pjo0pMQsVD5JGYaJRCvZhSALLq9Xhj2YBQjpFVPHR8sIP1ExLNwyvd0Kze4FRz9WD+4xUyRM0Bb
 soGTxz1ERuZtAmDWnHTVLls9gT+lwIVNVohPYBZBn8S6nh6gNI+f5/2ItaYrdX7Pxs/6MIIXWuFnJ
 lGWb2kVMVYSzD+rj0MovK/ZBYuzr6PIMMZljI73ZUvIgzPYN6PLJ8/JcDfsE1EiRvzOOW16QFRd/V
 pL9hFXS1g==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40530)
 by pandora.armlinux.org.uk with esmtpsa
 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.90_1)
 (envelope-from <linux@armlinux.org.uk>)
 id 1itGU4-0001ez-Cy; Sun, 19 Jan 2020 19:43:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1itGU0-00025u-NL; Sun, 19 Jan 2020 19:43:40 +0000
Date: Sun, 19 Jan 2020 19:43:40 +0000
From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] arm64: kvm: fix IDMAP overlap with HYP VA
Message-ID: <20200119194340.GW25745@shell.armlinux.org.uk>
References: <E1ilAiY-0000MA-RG@rmk-PC.armlinux.org.uk>
 <20200119174327.4b2c514e@why>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200119174327.4b2c514e@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Sun, Jan 19, 2020 at 05:43:27PM +0000, Marc Zyngier wrote:
> On Sat, 28 Dec 2019 11:57:14 +0000
> Russell King <rmk+kernel@armlinux.org.uk> wrote:
> 
> > Booting 5.4 on LX2160A reveals that KVM is non-functional:
> > 
> > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > kvm [1]: IPA Size Limit: 43bits
> > kvm [1]: IDMAP intersecting with HYP VA, unable to continue
> > kvm [1]: error initializing Hyp mode: -22
> > 
> > Debugging shows:
> > 
> > kvm [1]: IDMAP page: 81a26000
> > kvm [1]: HYP VA range: 0:22ffffffff
> > 
> > as RAM is located at:
> > 
> > 80000000-fbdfffff : System RAM
> > 2080000000-237fffffff : System RAM
> > 
> > Comparing this with the same kernel on Armada 8040 shows:
> > 
> > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > kvm [1]: IPA Size Limit: 43bits
> > kvm [1]: IDMAP page: 2a26000
> > kvm [1]: HYP VA range: 4800000000:493fffffff
> > ...
> > kvm [1]: Hyp mode initialized successfully
> > 
> > which indicates that hyp_va_msb is set, and is always set to the
> > opposite value of the idmap page to avoid the overlap. This does not
> > happen with the LX2160A.
> > 
> > Further debugging shows vabits_actual = 39, kva_msb = 38 on LX2160A and
> > kva_msb = 33 on Armada 8040. Looking at the bit layout of the HYP VA,
> > there is still one bit available for hyp_va_msb. Set this bit
> > appropriately. This allows kvm to be functional on the LX2160A, but
> > without any HYP VA randomisation:
> > 
> > kvm: Limiting the IPA size due to kernel Virtual Address limit
> > kvm [1]: IPA Size Limit: 43bits
> > kvm [1]: IDMAP page: 81a24000
> > kvm [1]: HYP VA range: 4000000000:62ffffffff
> > ...
> > kvm [1]: Hyp mode initialized successfully
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> I've applied this to kvmarm-next with a couple of cleanups, and
> preserving the fallback when the tag is zero (only the mask gets
> applied, without any ROR or ADD).

If only the mask is applied, then it will overlap with the IDMAP
region, and KVM will fail - so I think it would be a good idea in
that case to print something a little more useful, rather than
attributing the KVM failure to an overlap of IDMAP and the KVM
range.

The real problem is there aren't enough VA bits to allow the KVM
range to be adequately placed, rather than the overlap itself.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
