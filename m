Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A056A3158A
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="lRkle9xw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uryGSx2r+KBBKtYnZwparRWHnho2ggpLtpZaQHsRXRw=; b=lRkle9xweJK7FFbW1FFvqC/n43
	7bis5aAZ9xrI18O/ptwXmM155hy8w6KCcZlmPl2xwbuccPv5/IvODiAKZYv5Gcgiy/8r/+RZ1uqEr
	N0FSM9XGAlwCoi/qZDSpYUexsnBNCCvp0S0/Bq1iQvgjs3zeiTx2ffzNhelowyjCE5bEN4t0+9uum
	mm7li3txI51DvM5jF2I6L1DCPFqTCp7XceR4ua/NuYMhLH8ntDv5WsrX1oveXvEW/2sT/2IOlnYiU
	DaEX8CIQmzIgmnBc0/yBqILrTutofk5t/PfD3YbD/NVaZCrC4LWrj8FwQBxz6TgMSoQmHAyVOb/Yr
	uQE3YJHQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39226)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1r3hgx-0002Bb-1i;
	Thu, 16 Nov 2023 19:06:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1r3hgx-0007nw-0G; Thu, 16 Nov 2023 19:06:19 +0000
Date: Thu, 16 Nov 2023 19:06:18 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jianyong Wu <jianyong.wu@arm.com>
Cc: maz@kernel.org, james.morse@arm.com, will@kernel.org,
	salil.mehta@huawei.com, suzuki.poulose@arm.com,
	oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	justin.he@arm.com
Subject: Re: [PATCH] arm64/kvm: Introduce feature extension for SMCCC filter
Message-ID: <ZVZoKlWrjV1L3CBo@shell.armlinux.org.uk>
References: <20231116114152.912344-1-jianyong.wu@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116114152.912344-1-jianyong.wu@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Thu, Nov 16, 2023 at 11:41:52AM +0000, Jianyong Wu wrote:
> 821d935c87b introduces support for userspace SMCCC filtering, but lack
> of a way to tell userspace if we have this feature. Add a corresponding
> feature extension can resolve this issue.
> 
> For example, the incoming feature Vcpu Hotplug needs the SMCCC filter.
> As there is no way to check this feature, VMM will run into error when
> it calls this feature on an old kernel. It's bad for backward compatible.

Can't you just attempt to use the SMCCC filtering, and if it errors out
with the appropriate error code, decide that SMCCC filtering is not
available?

That's how most things like kernel syscalls work - if they're not
implemented they return -ENOSYS. glibc can detect that and use a
fallback.

Imagine what it would be like if the kernel provided userspace with
a large bitmap of what syscalls were implemented...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
