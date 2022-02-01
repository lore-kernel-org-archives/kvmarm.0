Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B685C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 16:52:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 907AC49F13;
	Tue,  1 Feb 2022 11:52:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gym914q3Ty+m; Tue,  1 Feb 2022 11:51:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF97D49F1B;
	Tue,  1 Feb 2022 11:51:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D641F49F18
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:51:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Xzan0t2sVLB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 11:51:57 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38C2749F13
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:51:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=4RYLbPYhwvz3vodCfFsOAXqcVYhkJQJgonJ0Dgy6/18=; b=qOKwGJKjRULYfRSB8qLlAl6/Sw
 hp8JAMx372ifqhLcNsJaRart9AJw8OM1b2dVTSjxOHh6fPlYNrDoipHQDvlHLr5fIgj8yLl7FCWWw
 8vJyEdFvTqF6T+7mrDhvJxkwiGLXDvGTG9G2l8cjdcxmN+DFFQ/bsKdtDHKNYZMuCcAftv5ZGYl6b
 IPA1LQf+Crr2qlgz1UkHsqjK6Dr57BOoeeoZV5cUbAW2SXvwv5jvB/0ufj03HkwZ+9RsVOKMC6u/I
 HSIkTTuQmhNPt16ZDWyD6XNV/qC2LbzlMmCVT/bUlPXuB5iwR5WjGgIA5GYbUtqz9jrPSTc8JvPhG
 CXdahTxw==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56974)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1nEwNm-0000ps-43; Tue, 01 Feb 2022 16:51:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1nEwNj-0002EH-LT; Tue, 01 Feb 2022 16:51:51 +0000
Date: Tue, 1 Feb 2022 16:51:51 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 15/64] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Message-ID: <YfllJ9WPx45nzeCZ@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-16-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-16-maz@kernel.org>
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

On Fri, Jan 28, 2022 at 12:18:23PM +0000, Marc Zyngier wrote:
> HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
> we deal with a lot of the state. So when the guest flips this bit
> (sysregs are live), do the put/load dance so that we have a consistent
> state.
> 
> Yes, this is slow. Don't do it.

I'd hope this is very unlikely!

> 
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
