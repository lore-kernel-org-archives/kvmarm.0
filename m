Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDF1204940
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280892; cv=none; b=j8RPGziDsCKgzpDQDg0rpbBkJ0FMRahDoep7sVigNeQQxlkMGseR6nwd1/W2qLxDNQbos5lY7k2n+JNSKAR8YFLYxMJgqPO1x0g2nlA7O7f/w51/SgcMVWMKjEFIIZR+a2wCDPjGkKZk980Jl5/wFZ2NPBBz8OBlGvpaHq9TptI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280892; c=relaxed/simple;
	bh=6bqzXiU8BEBrlYf62K3lafSdSRF2nimCPvohLXaoVos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJl4D1IcjnU0rFwYcc4LtQKzhOXQu1vLhM6JIvQCPVQJmYnwTn5QFQrCW5wsbEvNcQ4VziokHSB0zoaNxnABzAaXMF7xXGcRTKAzCArxK8loUkoVBKHKd0RXyY8E2zarApy5vc82aHKuc1xMzj1k7eTT5x8ISLgYSAsG2Yq/pLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WxLTDzSf; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WxLTDzSf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729280886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6PD/QkeMRMhzyIcgUxv4Oc6z2j3ZeYn8/m+PUFWmQuQ=;
	b=WxLTDzSfdlspCc1MTUnBcw4X8MgMRFswU2HQZBRxvRWasazxyhDN1mgbPoYyBZrXKWEygk
	BbrkvWQVC/MWjFWYrZzjuiQPxugl4df7aV/+Nsj2Kxf69xgSQMuosW9b/W6L9rE0HcNO12
	hBtMEJMtd1W79eaKmjPnm2LQQVCdLxY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fix splat/misbehavior for MMIO SEA injection
Date: Fri, 18 Oct 2024 19:47:55 +0000
Message-ID: <20241018194757.3685856-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzkaller continues to find more interesting bugs, this time due to a
decently-sized hole in our UAPI.

Turns out we still go through the motions of completing MMIO emulation
even if userspace has pended a *synchronous* external abort in response
to an unexpected access. Oops!

In addition to the fix, I felt this warranted a selftest because a
documented UAPI flow has been broken for a while.

Marc, I'll probably take this in 6.13 since we've still got quite a bit
outstanding for 6.12 and this isn't *terribly* urgent.

Oliver Upton (2):
  KVM: arm64: Don't retire aborted MMIO instruction
  KVM: arm64: selftests: Add tests for MMIO external abort injection

 arch/arm64/include/asm/kvm_emulate.h          |  25 +++
 arch/arm64/kvm/mmio.c                         |   7 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/mmio_abort.c        | 158 ++++++++++++++++++
 4 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/mmio_abort.c


base-commit: 78a00555550042ed77b33ace7423aced228b3b4e
-- 
2.47.0.rc1.288.g06298d1525-goog

