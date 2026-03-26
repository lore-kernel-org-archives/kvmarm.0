Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5491361DB8
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534342; cv=none; b=lZqEzljoW2G+mKYwssuASlmlEhqwHNCwwQ9bMMYC/Ei2gPzN7heWcIlEJwENUHjjle0lV8HZ4ku/xVm3dVtmZ0lKy+Oimw8+raHAW8zZXaO7vhBr9iQr7LFAxudR9O9kAG5U52EVVbGOkXHIlF2F6WU8RrSqeoXmGutf616cjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534342; c=relaxed/simple;
	bh=VtAN8m1onSTBcLOzCI47xsDgjal03lRFmBJx3s07OL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T+4PDksE018BqT3K+78RlNXti99e2T040JH7cEr4AJHVc0ynEDD1670r1i1HpHlhwetylblMnfMVZyc5segvLjUnhuLuGQcYjUvKA64D3DPk6Pr7MHfPY71NGbKqWfcequLxLeZ2TghEeQxOaxAQ2KF2Lw+HFLho+gzkuYlavKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbRbaVHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbRbaVHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33508C19423;
	Thu, 26 Mar 2026 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534341;
	bh=VtAN8m1onSTBcLOzCI47xsDgjal03lRFmBJx3s07OL0=;
	h=From:To:Cc:Subject:Date:From;
	b=hbRbaVHnroVnSPV1vbTumNRF3iFriuolYE6pFkmoLlSGEFNZLF9HQfvJTBCtEiav7
	 T8jzVbh+pCw17TZ0YWec7/CE0qiJViV2TXIv9R9XdpZ/6baORUpwxQoLZoniwuBu30
	 cP7OCwijTJJYhV78gtnOWbSZxTSWeclwe0o6oflSko03G9zXBX5GtI2fZ9svYr995H
	 mOfpaQuNZMotV+WKE2bC5fuJVIYCHXfBrRSjhs39sWQeSsL5twzbmHWKGwAxHg1lxb
	 y1lsn0hXMi8jjXk8W/xXoIB6IMhBWVPzt0aq/cnaieZAzmsUgz3IsBgm3vscHT20Ec
	 B32lvMrlL6B1g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: [PATCH v3 0/3] KVM: arm64: Fix SPE and TRBE nVHE world switch
Date: Thu, 26 Mar 2026 14:12:10 +0000
Message-ID: <20260326141214.18990-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Here is version three of the SPE/TRBE fixes I previously posted here:

  v1: https://lore.kernel.org/r/20260216130959.19317-1-will@kernel.org
  v2: https://lore.kernel.org/r/20260227212136.7660-1-will@kernel.org

Changes since v2 include:

  * Simplified the TRBE drain check logic
  * Added R-b / T-b tags
  * Rebased onto -rc4

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Yabin Cui <yabinc@google.com>

--->8

Will Deacon (3):
  KVM: arm64: Disable TRBE Trace Buffer Unit when running in guest
    context
  KVM: arm64: Disable SPE Profiling Buffer when running in guest context
  KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines

 arch/arm64/include/asm/kvm_host.h  |   2 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 116 ++++++++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/switch.c   |   2 +-
 3 files changed, 94 insertions(+), 26 deletions(-)

-- 
2.53.0.1018.g2bb0e51243-goog

