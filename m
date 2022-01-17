Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357C7C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jan 2022 15:40:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D8B549E1E;
	Mon, 17 Jan 2022 10:40:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2-zEjb4Qy+cd; Mon, 17 Jan 2022 10:40:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4506C49E36;
	Mon, 17 Jan 2022 10:40:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59FA649E1E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:40:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2dVgnoMEVt+b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 10:40:23 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5FBE41175
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:40:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=lzdw6Nwn/vFRWz9WPmMH5XAh3P+TxRDaZo1uvpfE2q0=; b=Lqxv7+kxwBdy26Iyw1jNLC3CKA
 2GHch2IuPp9L0uGBKnf5CnKD1T9t4qLvUHxB0iFZrOQjzOEOki5POQ7jakgBvFphqfGgvW4/R2Swk
 jUrp+WsL48NSDb6Xu/48XBqITKBCqhThTcwF4eEb3bMwDgQBD1G9bR6Stad2eJbGhGyacMqBPohiK
 2MMWj9Fq1gh8J4ZTU5PRJfeaX/NhwpC+09ZnrgHJcaUg+vN+KVbffD7ixUuopggIl/o/Y+SL2cIaf
 aB1EqpZCUwwECnAB/wnIGz0T+4LDsUUxIvaXq/J72f/4n6kT7p3LraIc2fgMy5fguhi2bFohZh3P3
 G0im24LA==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56728)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1n9U7H-0002nI-KW; Mon, 17 Jan 2022 15:40:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1n9U7E-0003RF-Qr; Mon, 17 Jan 2022 15:40:16 +0000
Date: Mon, 17 Jan 2022 15:40:16 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 03/69] KVM: arm64: Add minimal handling for the
 ARMv8.7 PMU
Message-ID: <YeWN4JoAB5UqN2/0@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-4-maz@kernel.org>
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

On Mon, Nov 29, 2021 at 08:00:44PM +0000, Marc Zyngier wrote:
> When running a KVM guest hosted on an ARMv8.7 machine, the host
> kernel complains that it doesn't know about the architected number
> of events.
> 
> Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20211126115533.217903-1-maz@kernel.org

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
