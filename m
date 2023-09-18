Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A610F9
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JpmACuKzLEySkiefvR4XEzLq2l/GD0gp2bnZ8kEBIFI=; b=kVzQ7/vwTnpP+CIOcOrHaveVQL
	sLK/dUbflp5AVZCi1NjTN4vGf0n8ODQ7+WX0qtIA+7Sj8W67e4mukT7UakvHTeQdXmkgGSHuD5qlA
	hrSjKimLBut7aaQ14th62KlJ7yiOPuQc4rl7JsKxe0s/9reJwnUuY01QSW/vr6EANjJKVBe++3mpj
	ePhEwkrYE2JyWBt0U0Utguc04Ew3fBOT2gmdqMGE/JseHq70NaEbGE7t+Yc6zjLSOXMHhyz8rkrp3
	qCRkwR9dMkY8mB4getceyrmE3pKMTQIEtRvNZUG1hYZEd24ULHMIsy0/3v3OM9HvXiG2d2pib11lA
	dMSc1aMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34502)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qiBTj-000059-36;
	Mon, 18 Sep 2023 11:27:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qiBTi-0000Oe-EM; Mon, 18 Sep 2023 11:27:42 +0100
Date: Mon, 18 Sep 2023 11:27:42 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: James Morse <james.morse@arm.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
	x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	jianyong.wu@arm.com, justin.he@arm.com
Subject: Re: [RFC PATCH v2 00/35] ACPI/arm64: add support for virtual
 cpuhotplug
Message-ID: <ZQgmHtG10n+XyZYR@shell.armlinux.org.uk>
References: <20230913163823.7880-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913163823.7880-1-james.morse@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, Sep 13, 2023 at 04:37:48PM +0000, James Morse wrote:
> This series is based on v6.6-rc1, and can be retrieved from:
> https://git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git/ virtual_cpu_hotplug/rfc/v2

Hi James,

FYI, this doesn't seem to be based upon v6.6-rc1, but v6.4-rc5.
virtual_cpu_hotplug/rfc/v2 seems to have a hash of 505859b05e15.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
