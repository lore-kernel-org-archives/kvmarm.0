Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2201A0728
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 19:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915681; cv=none; b=Q6wh9atVzGrbnpZBZwRAiBU4BVbtc4icmp+PhwFLBilxguv4jMSwTot0eMxXDQTAHyK1exErxSJ+7XAJK1Irz9cqGetzPZmOwyuSvQ9OTwvMJqmwlP+fSkzndlTGnRpcaCw6XrVWHyA8jztcn8jH4pGjUQEed5i+JvfwMXmbmh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915681; c=relaxed/simple;
	bh=u/lEjkaWX2017lMx7tGwQPvBK+FBGVmqJv2uSIgjwhg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YNBnZdio5DaU35fBzMWgJ0eaNUzMCuqC7hIy9DXH51tEGet7q6kEP/TIGQlesXnW1FE6bP0a6EzV593pSJ5GzxW8OKG6LINbORyW7P0FZveiZbbHwtUjzAWdGQyrNhDrZoVrANZtZFyUsdulvRRd2xIrLVk+G6AsSObX03Ohxp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nuC+kQYk; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nuC+kQYk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758915676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bPm94xwFV+fo/YgUBByLg/UMkjZbS7H6SUPTmXZduyo=;
	b=nuC+kQYk5D+i6s2VKdM98AGpZJSYtLsu4qnkUTHke++GhKxvIxdMXeWn949mKObaIoTepF
	v/Xwm5RvmVHnupObAchS+VuVODahCryIJfbRUhemvMq6a5Pl6wCIN/A1MDrpzPZXP/ncDY
	wQujHLNeOLJCnvL1AKpW2lAhfBCXZZY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jan Kotas <jank@cadence.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fixes for NV+SVE
Date: Fri, 26 Sep 2025 12:41:06 -0700
Message-Id: <20250926194108.84093-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

After staring at the ZCR_EL2 handling for the issue Jan reported I
also spotted an ugly preemption bug because ZCR_EL2 residence is *very*
different from the other sysregs.

We could definitely get away with loading ZCR_ELx on the CPU at
vcpu_load() but I'd rather not given the amount of special treatment
that we need to do for it already.

In addition to that, I've taken the liberty of forging Marc's authorship
and SOB on the SVE exception fix, figured he wont mind :-)

Applies to kvmarm-6.18, tested with QEMU-TCG (only implementation >128
bit) with L0: VL=512, L1: VL=256, and L2: VL=128.

Marc Zyngier (1):
  KVM: arm64: nv: Don't advance PC when pending an SVE exception

Oliver Upton (1):
  KVM: arm64: nv: Don't treat ZCR_EL2 as a 'mapped' register

 arch/arm64/kvm/sys_regs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5

