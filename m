Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837231CFA3
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 08:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Q/kE71C3YQoVAJcv+tcDCTuOd74zeOrYb7Y83JwQce8=; b=Mcu3CN02ySIiZJ6bCvj/Iptuxw
	BSo6wjkmShOcfztBl0hhhX9Oav1eHic0ijZUBWLstRePTcssLaWnct4Nq9r46KAr72m2Ry8eKktIq
	SkDGTo+ws+c4gvudeNdke21B3+h8kgguvo0NQduA9DWDy1jYrUqwTjFgSoYdeFSqFCii/hoTF+3aH
	TWU/FUE2whnybBaF3IPXsza83M/zgleCCjPRaGPG1nvfa8crT9Jo5PLDU0vo3bk5NWFAiRgqyWUHr
	eHOVg4N6m5KTdbvL4c4zZbW4/7GEIMwFcTktKvIhjLmiDIqkxvpz87B0sOKnoV/fSZ/sNg1eVdso1
	jf+Z531g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44910)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qghmf-0003jH-1O;
	Thu, 14 Sep 2023 09:33:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qghmf-0004ar-Im; Thu, 14 Sep 2023 09:33:09 +0100
Date: Thu, 14 Sep 2023 09:33:09 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: James Morse <james.morse@arm.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
	x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	jianyong.wu@arm.com, justin.he@arm.com
Subject: Re: [RFC PATCH v2 03/35] drivers: base: Allow parts of
 GENERIC_CPU_DEVICES to be overridden
Message-ID: <ZQLFRQActkL7ke+l@shell.armlinux.org.uk>
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-4-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913163823.7880-4-james.morse@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, Sep 13, 2023 at 04:37:51PM +0000, James Morse wrote:
> Architectures often have extra per-cpu work that needs doing
> before a CPU is registered, often to determine if a CPU is
> hotpluggable.
> 
> To allow the ACPI architectures to use GENERIC_CPU_DEVICES, move
> the cpu_register() call into arch_register_cpu(), which is made __weak
> so architectures with extra work can override it.
> This aligns with the way x86, ia64 and loongarch register hotplug CPUs
> when they become present.
> 
> Signed-off-by: James Morse <james.morse@arm.com>

LGTM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
