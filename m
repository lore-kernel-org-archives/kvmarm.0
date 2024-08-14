Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CDA15C9
	for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 12:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638875; cv=none; b=s/kBNg6TlrUWez+F/qqTaHAE19kE94BGkdoE8JMsc9NzuDyKSt+V827rA8JZH8nWxnYtLuuhOtAhCWnWeNCcB/ryxI2omMFyvEsA4U5r9UXv3A0QyB/Kj1QI9wSgIT+Qr+1IE8ly8ueTTzwIPlDgtcGn4iXP2oZWJN5ot0CNXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638875; c=relaxed/simple;
	bh=Ro9obe4GzgZcpGLQoFXEVVhiEoxNfb65EYTdSVyz9GY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ey446hOVQtaXF8dWQE75VVcBeItFpld/texhn6MtdJovr1rIRkkG1vs/8Q1jhIV9kRZmgRvx3PRIvodsWjiwGao+jnWRZDarsasAEoPP9VZyZt8gm0e/Hz668Za2PvpUeKhRci4Xdl2hLuzkGO9Mc0AQ8ITKGTipoQ2iIMfdZgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpMWxe8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpMWxe8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD4EC32786;
	Wed, 14 Aug 2024 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723638874;
	bh=Ro9obe4GzgZcpGLQoFXEVVhiEoxNfb65EYTdSVyz9GY=;
	h=From:To:Cc:Subject:Date:From;
	b=PpMWxe8XdI4tFK9XH8NujOiuE5a6TJuOYX+1AKoJ38YOnXxQ66OZZmlPUiSVtZ2qs
	 A25HkmZ5Z9X90C53+zG9KOKCnDJvIMDuVkNVE5e09BdHXU6+TatwTvqm/L0hdmXzyb
	 HFfZvWeuRyu5bGM2/r/rdAaXXR9dGpneKkPXNNOVIe7krmYCqfUKmZcGMnL3tD1jhb
	 NhaOyNenZ/NNTiDCsFa7OrB6uyi3iPMN8pHnodpgruP5vW4yLhhv0oRRixh92MhLoj
	 JbJo29oAry7Cjnm8Sirw1a7zu5LkDagLzI3FzbWERbtfJXMK3ZqI0Oo4ehSozqIM3/
	 TkxSrk3Za3OIw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/2] KVM: arm64: Fix a couple of pKVM/nVHE TLB invalidation bugs
Date: Wed, 14 Aug 2024 13:34:27 +0100
Message-Id: <20240814123429.20457-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

These two patches fix a couple of TLB invalidation bugs in pKVM. The
first one was spotted by inspection while I was debugging a crash which
turned out to be caused by the second problem.

Feedback welcome.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev

--->8

Will Deacon (2):
  KVM: arm64: Invalidate EL1&0 TLB entries for all VMIDs in nvhe hyp
    init
  KVM: arm64: Ensure TLBI uses correct VMID after changing context

 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.46.0.76.ge559c4bf1a-goog

