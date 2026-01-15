Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DDC2C159E
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514110; cv=none; b=HDtbMCVcZOa0tBBSnGMcjgSJWjaPwwsvFjLWjXsMokoqtnNddYx/Swx+RNOhmd+SEW+iiUMXpc+wxLNofYFVHxvQsHszu8GRi/yqotur15CbQ9d6vQmmJXOGcITxIeZSqYt3EPSn6gruLWsRL8AaIq9ieGH+Ug58lMBm7QbP++E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514110; c=relaxed/simple;
	bh=D5j/yqPjhph8B93YQzXdAs0lu1UQCpzf0y3U/X7Puxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpQmAc8uakNNoN9kvSb1FqcGx6ZJNSCUn4TzoXCgowF97xbPGeD5GtWx3MOeFngi6BsJdmwi4kqNZyeLZ1gcunU47/jNulMxfwEXad67lLne8va+A4CQnmeEt8oyKo+qsmNHgX4Pr22il6Ltmz+EnJt581Zxl1FVmwvauVGjwy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Izp+lAFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Izp+lAFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB0DC116D0;
	Thu, 15 Jan 2026 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768514109;
	bh=D5j/yqPjhph8B93YQzXdAs0lu1UQCpzf0y3U/X7Puxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izp+lAFeDGzYiEIXcaJVMMZ2MANpVQ7niZwE348SvFy14TUsbCIcuavBwwnohgylw
	 E2UBXmR+52NuTOzxnvjtISkZNEQ8GP2J5lSAklL2ILgnV5lZvJb/W6iTA6OQro80+q
	 rRpWwlK87TgwYXTxtG1Y0yTfMKGzm0vuw78g2l0o7jQU/Ier8gqk8P/nK+xOS09H9Z
	 iPl2eK1iSP4KI4CziVSj3AeAlxzvE71vG4dxLoj5C/BH6eqWkgukVd7kbKCBldVZ4A
	 yzTlS2PJjTMPYeI4DFwetUIGgIwLmvBxpQIdlvIuIRncWJxDNbVE7JIdeUzdFilP1O
	 keTGesWNNOc8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vgVJ5-00000002gXB-1FkR;
	Thu, 15 Jan 2026 21:55:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: will@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	vladimir.murzin@arm.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v6 0/9] KVM: arm64: Fixes for guest CPU feature trapping and enabling
Date: Thu, 15 Jan 2026 21:55:04 +0000
Message-ID: <176851408508.3822586.5772710860545860120.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
References: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, vladimir.murzin@arm.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 11 Dec 2025 10:47:00 +0000, Fuad Tabba wrote:
> This series contains several fixes for guest feature trapping and
> enabling in pKVM, as well as a bit of tidying up.
> 
> Changes from v6 [1]:
> - Fixes to the patch that tracks KVM IOCTLs and their associated KVM
>   caps. Move static header data and function definitions to arm.c.
> - Introduce a capability KVM_CAP_ARM_BASIC instead of KVM_CAP_CORE,
>   since it is ARM-specific and that it only checks basic ARM ioctls.
> - Tidying up code and commit messages.
> - Based on Linux 6.18
> 
> [...]

Applied to next, thanks!

[1/9] KVM: arm64: Fix Trace Buffer trapping for protected VMs
      commit: 288eb55483c05bc37379a781d0d18b8e6c280f92
[2/9] KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
      commit: e913c7ce9e6f62038a486218f43f699fc443e3e1
[3/9] KVM: arm64: Fix MTE flag initialization for protected VMs
      commit: ebbcaece84738f71b35f32339bdeb8776004e641
[4/9] KVM: arm64: Introduce helper to calculate fault IPA offset
      commit: c273feee70bd3d8c6c4d5efaf6b3ae945c839378
[5/9] KVM: arm64: Include VM type when checking VM capabilities in pKVM
      commit: 43a21a0f0c4ab7de755f2cee2ff4700f26fe0bba
[6/9] KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
      commit: f4eee308c8f4013a52bd7d7735e64b5127c1b4a8
[7/9] KVM: arm64: Track KVM IOCTLs and their associated KVM caps
      commit: 8823485a697de5c280a7a2632620338722f16663
[8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
      commit: b12b3b04f6ba072ca5a618a75e546c996be94bd1
[9/9] KVM: arm64: Prevent host from managing timer offsets for protected VMs
      commit: f7d05ee84a6a8d3775e0f0c3070d9380bed844a9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


