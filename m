Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E42E630
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BHDU/uL8LxSg62Q/u4osBO6lMbutGaWzvUBNKWgWQLM=; b=pLvrwD4msGWTwxI8101DXka/78
	DZEMxr08Dp8UAFTjZbVfC9lF+XzkCI4X73WOV7xA6bvQQrmxHHgrwHTsGvzqcv7QjmXFtuvJZPXrr
	e80aORF125Xth3z/Nr4XDOaFG+q7HzMK8hA9mFOhJ2ewEwudulmxbBQgiyQ9tA2CARLvEr8slMmQT
	YUuQGIbaP48KiRH0+Utzxhqxt65swdcVCy5eD+L+bwYLGmobeQZGiGQv/jhOEh64rD4JlvW02y4ae
	sOrAwSmaJ5sap4IFpnXyYAFAFVYzvkv73YnhzlE77IZrS/t1HHduvLPnImGQPMFj0YPU5O4QmE7ha
	489v0a7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33864)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qiXS4-0001em-11;
	Tue, 19 Sep 2023 10:55:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qiXS3-0001P0-3I; Tue, 19 Sep 2023 10:55:27 +0100
Date: Tue, 19 Sep 2023 10:55:27 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Gavin Shan <gshan@redhat.com>
Cc: James Morse <james.morse@arm.com>, linux-pm@vger.kernel.org,
	loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
	x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	jianyong.wu@arm.com, justin.he@arm.com
Subject: Re: [RFC PATCH v2 32/35] ACPI: add support to register CPUs based on
 the _STA enabled bit
Message-ID: <ZQlwD50FEZeeAMBQ@shell.armlinux.org.uk>
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-33-james.morse@arm.com>
 <ad068df5-d5b1-030a-af25-723cd5c3b854@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad068df5-d5b1-030a-af25-723cd5c3b854@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Tue, Sep 19, 2023 at 02:46:22PM +1000, Gavin Shan wrote:
> The message needs to be split up into multiple lines to make ./scripts/checkpatch.pl
> happy:
> 
> 	pr_err_once(FW_BUG "CPU %u is online, but described "
> 			   "as not present or disabled!\n", pr->id);

No. checkpatch is wrong on this point. Splitting the message like this
hurts debuggability, because the message can no longer be grepped for.

What James has done is perfectly fine.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
