Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DB1C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jan 2022 15:36:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B2249F24;
	Mon, 17 Jan 2022 10:36:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GnDenAhvNLVn; Mon, 17 Jan 2022 10:36:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96F2E49F03;
	Mon, 17 Jan 2022 10:36:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0B049DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:36:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyRcp+XayH7T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 10:36:15 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDD7343C96
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:36:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6wdb+RSfOYtXVx2QzAjSPlhmXyeOp04Xz18+mlcDwiY=; b=MAi5evp5V1emr8iC5rBW99L0Kd
 aYrxpLT61TZn/0Hc2idjx6aGbcXjB3PM12uzncY/pc2UqCWXrlWPD54bsBLZUpu2v/9gL7VuTQOVk
 DKOcWU5DSOuqVfODoMdkJxx7aX8+O6ZZ8Q87Y0vJ9wu4N0c6VTEnXnw2g95Ild0pmFU/4WBMW9le7
 1WQyUuxf9N0hHDc5cp6RlfdkjIQf8piKdoz4bXZK3yX4jr9JAaKgMbxupaPq7mAE1zvrF4+tXAc7x
 RIxs5IhegTeFvFFnF6nVQzvlE+m7PpElvBZhBZrSAPcOY3yk1u4wQFlAM/hojf67GDw0PHlNrWwPj
 7RZkDfKg==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56726)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1n9U3J-0002ma-F8; Mon, 17 Jan 2022 15:36:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1n9U3F-0003Q2-4W; Mon, 17 Jan 2022 15:36:09 +0000
Date: Mon, 17 Jan 2022 15:36:09 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 01/69] KVM: arm64: Save PSTATE early on exit
Message-ID: <YeWM6YtDpmy3BL2j@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-2-maz@kernel.org>
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

On Mon, Nov 29, 2021 at 08:00:42PM +0000, Marc Zyngier wrote:
> In order to be able to use primitives such as vcpu_mode_is_32bit(),
> we need to synchronize the guest PSTATE. However, this is currently
> done deep into the bowels of the world-switch code, and we do have
> helpers evaluating this much earlier (__vgic_v3_perform_cpuif_access
> and handle_aarch32_guest, for example).
> 
> Move the saving of the guest pstate into the early fixups, which
> cures the first issue. The second one will be addressed separately.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
