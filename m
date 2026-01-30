Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8EA367F28;
	Fri, 30 Jan 2026 11:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769771942; cv=none; b=D38yLvYkVFGju7KgSrQJcOuitK/uQjfSz5JY3x9PQsgoTixxtuozhs2PQ9Ag4HyViv4y8mJBi53eMFgNeDj/rJIcWcBeTObOSw+IP24gYAtFOyr5U2il40+3J8GeevbVh1uyL+4wVeQYPikPPXE2Zhjwq//S+nfVm2gb0pMxklQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769771942; c=relaxed/simple;
	bh=PQ+p73R80ETqkVCGJZy86pYL5c9ExyceZZ1ihJeBk6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kliYtK1VqVIICTqko6toYLjrrzcXW5MYUEIpvXuoTLMcUAtKDXlJNQPafuiRD1Vs2gQk2NFgizrJjGZjZx3TkfC5nrykYRs3u8uCpXQlgs+Ef0N7ui0N5MhZYsB6rsJQc3H4Ja2q5It2sDQsL5IbVCWDVHr6yanSInM/ThijaRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyMsJfQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyMsJfQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BA9C4CEF7;
	Fri, 30 Jan 2026 11:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769771942;
	bh=PQ+p73R80ETqkVCGJZy86pYL5c9ExyceZZ1ihJeBk6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyMsJfQzjbkS4YBP1Z4DaBLKbyhqrJBvxRwvXEQOg/WwbLCPnvY8FtC1F8+zB92xj
	 TCvbeDXUNQlAPMr5pdUcGFIZ/xsyR7Lp/hccOYRvryUUB7EUYJAdOi5f3n+YGZfDux
	 HCWyT7KzcsGvHrOQfTtcMPCFxnHIZFaysYjmtN8eXykvVcpqg3X7NHg+A2DPEKEORw
	 AwD1xG1u+HjXXSXIZMXGvvCLP4GDYh4G4txPB/tNzMD5mm7ekZcrk9tNoX+sFoHyR1
	 X7Z3COTKCTQBqfx57wJ21fm3G5WmdMfz+ghp0JEPOlv1u7RKHuIfhr5Ek22o88Sd3Z
	 1bRF6eQelSlYg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vlmWi-000000072qr-0Xg1;
	Fri, 30 Jan 2026 11:19:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	jonathan.cameron@huawei.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: (subset) [PATCH v4 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Date: Fri, 30 Jan 2026 11:18:57 +0000
Message-ID: <176977191232.2312774.6420835979447644993.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128175919.3828384-1-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, lpieralisi@kernel.org, Timothy.Hayes@arm.com, jonathan.cameron@huawei.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 28 Jan 2026 17:59:19 +0000, Sascha Bischoff wrote:
> This is the v4 of the patch series to add the virtual GICv5 [1] device
> (vgic_v5). Only PPIs are supported by this initial series, and the
> vgic_v5 implementation is restricted to the CPU interface,
> only. Further patch series are to follow in due course, and will add
> support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.
> 
> v1, v2, and v3 of this series can be found at [2], [3], [4], respectively.
> 
> [...]

Applied to next, thanks!

[02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
        commit: 4a03431b742b4edc24fe1a14d355de1df6d80f86
[03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
        commit: b583177aafe3ca753ddd3624c8731a93d0cd0b37
[06/36] KVM: arm64: gic: Set vgic_model before initing private IRQs
        commit: 9435c1e1431003e23aa34ef8e46c30d09c3dbcb5
[32/36] irqchip/gic-v5: Check if impl is virt capable
        commit: 3227c3a89d65fe7482312b7b27038d9ebd86f210

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


