Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7D17F7
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 00:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732063966; cv=none; b=tCTvjBDC6Y73xhAsk932AKKUoQfwK9xxXVPmslu9JYpxmMwTSFp8VbwIqbarerupe66/BbHbQZg4MjCays02ebjI02nC6kid4NtH2wu2m21mZ0Ipvt2n2dj1TaDeKXRzaBBTTEsZxIl50/hKSG0rig1mDGlt5QNO8ZEaf9qemnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732063966; c=relaxed/simple;
	bh=PSzcYDQBwTWvyJGIWHTzkLaSP2EJP2ihgb/hSj5dxiA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DivrojKlNmVcOAj1WlpgwusKX7F/iIT3CVeRkFfjFWNbloCuZqST8VEB/Rbo7RXQlZKi+vXZcdMLSKiN2lXvBXx4QmU/hcJDK3Uqd7QbM9KFJ4/fPKii1yJcELLssdEm384ZYSax4yV1v/J46ND5t9jX5Rn6u/SVy4ZB3BnRhdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cVLPeIHr; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cVLPeIHr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732063961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bX6PYJ+F18fbAXWcOe4lqE8HeGREjBlzqR07juAsAPE=;
	b=cVLPeIHrTebGxw12XvXWYBgWAiYzVLYRJyUDkhcIY8y60cZEyoOmoVe5/1vo2ldZpXtGJc
	akn1kEGvV/zD7hFZwFxcdsCBo/dcGlMkdUKqJ7xKe1gU4oZYvwTs1kjN5LLXi0dt3AfFLn
	HjGHDdJHCkXCHA8eES2cijiB0dn3fcw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/2] KVM: arm64: Fixes for PMU overflow state
Date: Tue, 19 Nov 2024 16:52:28 -0800
Message-Id: <20241120005230.2335682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Respin of Raghavendra's fix for evaluating PMU overflow [*], with
another patch stuck on top for my own blatant disregard of the
architecture in the vEL2 bits.

Since I fiddled with this on the M2 these patches are obviously untested
due to the lack of PMUv3. I'll give it a spin on supporting hardware
before actually applying patches, of course.

[*]: https://lore.kernel.org/kvmarm/20241119205841.268247-1-rananta@google.com/

Oliver Upton (1):
  KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters

Raghavendra Rao Ananta (1):
  KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

 arch/arm64/kvm/pmu-emul.c | 59 ++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 16 deletions(-)


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.39.5

