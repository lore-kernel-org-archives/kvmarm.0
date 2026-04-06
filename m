Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A103F30E85D
	for <kvmarm@lists.linux.dev>; Mon,  6 Apr 2026 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494048; cv=none; b=r1Es3sRNR0eTMaAU7DqXgpskb/UFqu0IqOxcxtewG7gdmUg8+x7pxU0mjwYBHnf+d3S+Fu+ZX9GP6gMPRL/5/Y5b1bbcaIAxKNcaHEccWUr4/4CCi5z4y4Ibj9I6y01IoV7dQ6xEe4v4iRKJIt5itq8wvevbdqoOklVdAs7CdKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494048; c=relaxed/simple;
	bh=ozT5c4q3To0rGt3iOF4BIad4dP2hdLkN0+ux1is1UlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QJ4sYkzrzGcS4XALZKpKaNlUwPt0PxTiQQLTcLiiNOxcP2x35xfN7j7oik4iH3fnwWWff1S60xai2PdOgavOZ6SFaZB0fUhwKI9V2GmFzKsMgHdfZOCBEAIBRAu2/BvzJkNNussD3gzbXckDqB7S0L49Xo6lZOZswdlYpNDZlog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eHDD8BPx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eHDD8BPx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A93516F3;
	Mon,  6 Apr 2026 09:47:13 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3732F3F7D8;
	Mon,  6 Apr 2026 09:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775494038; bh=ozT5c4q3To0rGt3iOF4BIad4dP2hdLkN0+ux1is1UlI=;
	h=From:To:Cc:Subject:Date:From;
	b=eHDD8BPx6jnFrGRUoEKXnmPzzp8oBJR9NFw+CMewBNOJYyy0Jnp7iXSo5Ghcxr205
	 QLWUfDgSfw4f60J8NH+vVU9uKcX6s5b5neakHoJcGxHFkVKLu+tcFfPg/3O2PYIbdz
	 HfFmOz25tou5tHulTS2Qb+pVpMrNksejuNbZXSO4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Handle unsupported guest translation granules
Date: Mon,  6 Apr 2026 17:46:16 +0100
Message-ID: <20260406164618.3312473-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series fixes the granule size selection for software stage-1
and stage-2 walks. Previously we treat the guest's TCR/VTCR.TGx as-is
and use the encoded granule size for the walks. However this is
incorrect if the granule sizes are not advertised in the guest's
ID_AA64MMFR0_EL1.TGRAN*. The architecture specifies that when an
unsupported size is programed in TGx, it must be treated as an
implemented size. Fix this by choosing an available one while
prioritizing PAGE_SIZE.

The first patch is a refactor to prepare for the fix, and the fix is
implemented in the second patch. I lightly tested for regressions by
booting up nested guests of each page size.

Thanks!

Wei-Lin Chang (2):
  KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
  KVM: arm64: Fallback to a supported value for unsupported guest TGx

 arch/arm64/kvm/at.c     | 121 +++++++++++++++++++++++++--------
 arch/arm64/kvm/nested.c | 145 ++++++++++++++++++++++++++++------------
 2 files changed, 194 insertions(+), 72 deletions(-)

-- 
2.43.0

