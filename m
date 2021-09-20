Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EEEC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 09:45:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7243660F9B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 09:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7243660F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9D4F4B0DE;
	Mon, 20 Sep 2021 05:45:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t4lwX4kMsofG; Mon, 20 Sep 2021 05:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA124B0DD;
	Mon, 20 Sep 2021 05:45:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364B24B0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 05:45:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id akLIfCAxv-nI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 05:45:32 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD8B54B089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 05:45:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6WKcFj8KH5zmE3aTXCP6zwGUN8VgQpUtcVDHRQZ/pkI=; b=noZDo68Icsx4e76vM0o8uY9xWS
 tYFfDr0W4AgOEUQqoEChkEhZ7JiQ4i3H9lsLYGA310nQdTlsUeLroa11nZV+a9gy6QGVe2kW51e7x
 iDL3X97EpnhI4k4S/lpPy/yvOwEj3dz8539te0Pcr0T7pleb+XOL9mZAVZVZId9Bs34ggUzdN30uX
 g6sut84PQ6HGiI9yu867yks+CTNFrfydDOFzf5/TNsn2wkQWJ/74hCunVRQ1rlM1JqCtcDn2POQYB
 oqHwwxp9BoNDKO9i83dSzQmh8Ep/7tD2Y9C34oqZNSmv73VYuj+Hs9TmN4j9z0xGkXGNa0haAfkNO
 PArPtLWg==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54662)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1mSFrb-0001T7-S1; Mon, 20 Sep 2021 10:45:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1mSFra-0002Bu-8S; Mon, 20 Sep 2021 10:45:26 +0100
Date: Mon, 20 Sep 2021 10:45:26 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
References: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
 <877dfcwutt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877dfcwutt.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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

On Sun, Sep 19, 2021 at 02:36:46PM +0100, Marc Zyngier wrote:
> Urgh. That's a bummer. T1he PMU driver only comes up once it has found
> its interrupt controller, which on the Armada 8040 is not the GIC, but
> some weird thing on the side that doesn't actually serve any real
> purpose. On HW where the PMU is directly wired into the GIC, it all
> works fine, though by luck rather than by design.
> 
> Anyway, rant over. This is a bug that needs addressing so that KVM can
> initialise correctly irrespective of the probing order. This probably
> means that the static key controlling KVM's behaviour wrt the PMU must
> be controlled by the PMU infrastructure itself, rather than KVM trying
> to probe for it.
> 
> Can you please give the following hack a go (on top of 5.15-rc1)? I've
> briefly tested it on my McBin, and it did the trick. I've also tested
> it on the M1 (which really doesn't have an architectural PMU) to
> verify that it was correctly failing.

My test program that derives the number of registers qemu uses now
reports 236 registers again and I see:

kvm [7]: PMU detected and enabled

in the kernel boot log.

Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
