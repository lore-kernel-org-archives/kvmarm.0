Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E0D2853F8
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541330; cv=none; b=YthyS2Fh3sXDqDT8WM+9hy2bv3brkXlOP89QRWJFovL/nT0ttJdwfAcvHDjF1jfS1Q8RHYy7qcWba3zBw0EzNa1KRJOfBBthQM+QyQ6i1PM2Y1NS2sLWJf89pAvne/ttxHCM204YbmRy9xjpFCjnGIxxT/MZNlwKsMvletBnn4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541330; c=relaxed/simple;
	bh=BQOBgTRGRK5CPEDVqbmWZj7Y8fKfMmpTNWxE2BOnaeM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FHpaE4vVLfPi5vW2DLIp7uujIqeA/LHLP0gM5yLaLWQyhQL8z58jNUQUEdE8dOHhZZ9ha8tv6zfdKH4FtCo/ba2WfwdJ3YhGOSAtXetKu8DmAwyStYlWPoxucF/2hwtzkuh2GBgjhODyWr+Btmx7qrqWXj7BVl5mUO02s3HK8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWC5X9ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWC5X9ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690BBC113D0;
	Fri,  7 Nov 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762541329;
	bh=BQOBgTRGRK5CPEDVqbmWZj7Y8fKfMmpTNWxE2BOnaeM=;
	h=From:To:Cc:Subject:Date:From;
	b=CWC5X9ze/7pr5o/6PcZpzdTQLttI+KwdFZxrrkWqhDiug6W/zzbX+sBuxxy0Dvc8/
	 WNFzBT+UCRs2cEnjXInGyiQGa2Nkhj0U6mIl4F6osu/boA0rN3Qq68mHMUFiMiKB+e
	 uJVmVITXEf+MgjKxqxVa42k5WWB9wzISwtqTwm9SeWPmiNWQnnTmji71PXpP2qyK+y
	 oS4IdiJlJ/QBDGXxULwNRJfyHHDbHMcOy82ao61JObud1iFEcNXA+gK5c2VgFX/ykD
	 VwuIIRgXiJ0UaaQI6a3/uQNY+ZiI2dIq3Zcdl38J6R6sQXWPkUP4U8Wj6YLcdR9pOF
	 1J+HqGF+h+ywA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: vgic-v3: Even more locking fun
Date: Fri,  7 Nov 2025 10:48:45 -0800
Message-ID: <20251107184847.1784820-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 => v2:
 - Make iter_(un)mark_lpis() use of the LPI xarray also disable IRQs
   (Zenghui)
 - Fix failure path to drop xa_lock before calling xa_release() in
   vgic_add_lpi() (Zenghui)

Oliver Upton (2):
  KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
  KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock

 arch/arm64/kvm/vgic/vgic-debug.c | 16 ++++++++++++----
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c   | 18 ++++++++----------
 arch/arm64/kvm/vgic/vgic.c       | 23 +++++++++++++++--------
 4 files changed, 36 insertions(+), 23 deletions(-)


base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.47.3

