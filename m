Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BD1C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 16:43:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C625349EE6;
	Tue,  1 Feb 2022 11:43:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3FHqvv1ZsyLu; Tue,  1 Feb 2022 11:43:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1C8C49EBB;
	Tue,  1 Feb 2022 11:43:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2756749EBB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:43:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rEqA3FHpPP5V for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 11:43:11 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E21B40FAC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:43:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=MVe/2dgTXbUfj0/u/HAqWp9cqwu+WGAL6D0gWo7O6Dg=; b=KY00SYrK3RWXYJeG1jBng1R4AS
 TLvUpMHmCeajHE6g/ewYpYnIEr+kRn3GyW6ReAEjCpSyPeeUCCa/fhL2LfMh7D+rJ1lPZBCprTKCf
 bl5Q2fRzQ/Laqf2N7tsqtn8KjuJvBJhU74hhf3AnQVdcIaNbjL98SlDKjNKNMtSZ0Tz9eAVG8sb3f
 SDrg2QVvnFz5FHOHqBLOQMMc3P6RiPk+8ymIfD6jkSJpJFBBL8OfGyIOKEmZHH+s/hBrEQv55JGYt
 6FXsgwkazpKften8yKud8Z6E+XSEI4K2i5zDKSCMEk52XRuvhzPzKfk91m7QTkSReGMXG5JX5OxSl
 oD5HsE6A==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56972)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1nEwFD-0000pN-MB; Tue, 01 Feb 2022 16:43:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1nEwFB-0002E7-Aq; Tue, 01 Feb 2022 16:43:01 +0000
Date: Tue, 1 Feb 2022 16:43:01 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 14/64] KVM: arm64: nv: Handle SPSR_EL2 specially
Message-ID: <YfljFZk9JyywTvz2@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-15-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-15-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
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

On Fri, Jan 28, 2022 at 12:18:22PM +0000, Marc Zyngier wrote:
> SPSR_EL2 needs special attention when running nested on ARMv8.3:
> 
> If taking an exception while running at vEL2 (actually EL1), the
> HW will update the SPSR_EL1 register with the EL1 mode. We need
> to track this in order to make sure that accesses to the virtual
> view of SPSR_EL2 is correct.
> 
> To do so, we place an illegal value in SPSR_EL1.M, and patch it
> accordingly if required when accessing it.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
