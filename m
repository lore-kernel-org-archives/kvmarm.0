Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22F11185
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757924; cv=none; b=jDbCByoWcRyVID0+BIOJoA1N9P0m24eGt8Dsb8v9cxReA7/vYLnnn3TkdtzDMIixlGkCX0XVDGNKQTdSbe1TTI3jmEWAeNpw278/1SpwjLYyXzJoqrk3li0M6uhAWJkwggDAskYGoyUe1MrM03MybaCDyNPjmTZYCRIf0HKuDDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757924; c=relaxed/simple;
	bh=94sCr449sePpes869rvPtAYX6knrqxBBqVulQFnAUrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HC9LXOcBg3yTRzoEAHq+z0Hv3BBzRch1YhbKBdkhY8YUvonH0Mo1PK9iXAQ9tf/gvIG+0FaDSyopwT1ilVA8M2NM6fu5R2+7/keElw5vKS1hK2Of9z67frpwGK2kt1DXpvR4SATWJR/t+XffsV7KdqK4szRutj/kJ1HMB2Oo9yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C1RCZPU/; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C1RCZPU/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758757919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=la1K5BSa6TOGyehQd4ZcfPmE1aMsyu7kskQjzKvwGiI=;
	b=C1RCZPU/h/I227obSbtVqRthD0qke7KiXs83iGMWEzDLzI2Ossxu7xkTrUAgASFZCxcizR
	MwMeFQhT4C61QdszL+vzZHL8Q1Fjoh/pPBJvb6jHwHmEvYD5EmqC0HRV9/vPx+PXB1EQZN
	Q43lU5cGgve/bVyR0pY4pjfRmWXK9Zg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: nv: FGT traps of MDSCR_EL1
Date: Wed, 24 Sep 2025 16:51:48 -0700
Message-ID: <20250924235150.617451-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM now traps MDSCR_EL1 (and a hell of a lot of other things) because of
bad architecture redirecting the register to the VNCR. Marc reports that
this hurts (surprised?) meaning it is probably time to send in the FGTs.

As part of this the FGT configuration becomes contextual to the vCPU. FGT
computation is now hoisted up into vcpu_load() which avoids doing a
bunch of bit twiddling on every entry into the guest.

The last thing we can do to speed this up is add an early exit handleer,
but it's EOD for me over here and would rather push out what appears to
work right now.

Based directly on kvmarm/next given the fact that the dependency is
there also.

Oliver Upton (2):
  KVM: arm64: Compute per-vCPU FGTs at vcpu_load()
  KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when available

 arch/arm64/include/asm/kvm_host.h       |  50 ++++++++
 arch/arm64/kvm/arm.c                    |   1 +
 arch/arm64/kvm/config.c                 |  90 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 148 +++---------------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |   1 +
 arch/arm64/kvm/nested.c                 |   9 +-
 6 files changed, 165 insertions(+), 134 deletions(-)


base-commit: 181ce6b01ad52aeb791545edbae0b92648c6428d
-- 
2.47.3

