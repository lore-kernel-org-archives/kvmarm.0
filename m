Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5721EC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jan 2022 15:43:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E303C49E34;
	Mon, 17 Jan 2022 10:43:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DtY8FTmTdU30; Mon, 17 Jan 2022 10:43:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A4949E36;
	Mon, 17 Jan 2022 10:43:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D40A49E1E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:43:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id congJV-F0R91 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 10:43:43 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EDC341175
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:43:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ht/XA4o6M7ptrMuQobE80T6P+r3p1d2fY/4emv7Mr6k=; b=gd+XESqH9MGjUcSRFv5QXODHDT
 9/s7SutHqkcuxPN5qijjYFs8D9zkKUxBVYGT9H7PbFND/lmSC9+YgPlp4/wyhZATtgD3Wp2y2c8vI
 lHbIBE9fVA1vQDM7uTPXPWSxo5cO2m+Qd5i/NDziUFyyEmRVmkrJ2VeF6PYMpvQB9iMmTGjLYAZO5
 IMh14SDuLbvQhaC4V79iTt2YaJZxmwtASION1qMdin2GEuAbsqzFuz8/ivF4iLwcWVeQAzD1zlxCn
 yfNisfnN08qjnztVYWYpSOgtEZspfzgWb8QJA51Phk3EBIXviWOz5Alg7y8qXzSfAiGQfUv2fXxn9
 PxJzDqsA==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56730)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1n9UAW-0002nl-NM; Mon, 17 Jan 2022 15:43:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1n9UAQ-0003RO-UA; Mon, 17 Jan 2022 15:43:34 +0000
Date: Mon, 17 Jan 2022 15:43:34 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 04/69] KVM: arm64: Rework kvm_pgtable initialisation
Message-ID: <YeWOpnGxlRC4mCip@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-5-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
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

On Mon, Nov 29, 2021 at 08:00:45PM +0000, Marc Zyngier wrote:
> Ganapatrao reported that the kvm_pgtable->mmu pointer is more or
> less hardcoded to the main S2 mmu structure, while the nested
> code needs it to point to other instances (as we have one instance
> per nested context).
> 
> Rework the initialisation of the kvm_pgtable structure so that
> this assumtion doesn't hold true anymore. This requires some
> minor changes to the order in which things are initialised
> (the mmu->arch pointer being the critical one).
> 
> Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks fairly simple.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
