Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705833EE1E3
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922734; cv=none; b=kNuKf0Ov38QqUoE5kKNsKLlXGIGjnRFpo3sjo1w/Wy1jxj4dUtcQ50qFO1bJzJhF+lCNg24TprCk8wtx5MNoZnQJl2KBPxesZ+Hud/VMJ4oh58W8fgO7pHHAquP3PMVbIyqxeSBDXHYg90uX8/vzIoRm+w409gM6+gq6tceqwtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922734; c=relaxed/simple;
	bh=w5am5ByVaHiJqioMFlR2jniAuFfv2vXAEGIyG/UIheg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ieyH83m7pLQe4w/nls+6vDN0l74vbrSjHbuVX3Zx6WnYeTLdK1r//UUcM3bg/UmC5UT0hxir5tzVrLl66qLm9ZiECKJUTOPzIzkzSwwZ1KqK9z3yPenXFSFrpVJXT6wvcA1GDdpRFhsxwNFaQ4KOQOpXxtTuyoJWyvJm4knDBzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfOMAQdc; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfOMAQdc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785922725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XA6uf0vdp8ORAw6TXnT7k194lRleDVJK9cishIOZQWw=;
	b=tfOMAQdcMAp+kwN52T099XsJCEIwqGyaubYGQJI3nJug/ZIvnEdlj9Ew39ZD8Min4I1Y2x
	P/iccTt1D69eUcYPcDyhwKa4cwDC9wakk9dMpXYzGF4aRNFc2IEhshkG5uD6AMZrd+RYGN
	DJT/p+XuuDeus5tnAmHA8xT3DRfEJr0=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: vgic: Fixes for ITS table save and init retry
Date: Wed,  5 Aug 2026 10:38:25 +0100
Message-Id: <20260805093828.3626610-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Three unrelated vgic fixes.

These came out of reviewing the GIC-related postings on the list lately,
from Sebastian's ITS hardening series [1] to Sascha's GICv5 IRS series
[2]. These three are from the ITS table save paths and vgic init. Stare
into the GIC long enough and it stares back!

The first is the one that matters the most. A guest that issues MAPD,
MAPTI and then MAPC(V=0) leaves an ITE mapped with no collection, and
the next KVM_DEV_ARM_ITS_SAVE_TABLES from the VMM oopses the host. That
is three ITS commands and an ordinary migration save, with no race and
no allocation failure.

The other two are weaker and come after it. The init fix stops the SPI
array leaking when userspace retries KVM_DEV_ARM_VGIC_CTRL_INIT after a
failure. The collection table fix bounds a walk that a guest can drive
past the end of the table KVM computed, which stays inside guest
memory, so the guest only corrupts itself. Its error code is a
judgement call, and the commit message says which one and why.

The first and the last are reproduced, each with a selftest that fails
on an unfixed kernel and passes on a fixed one. Those are not part of
this series, happy to post them separately if they are worth having.
The init leak needs an observed allocation failure rather than a crash,
so there is no reproducer for it.

Based on Linux 7.2-rc6 (075b74841bd00).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260310124933.830025-1-sebastianene@google.com/
[2] https://lore.kernel.org/all/20260724104819.1296803-1-sascha.bischoff@arm.com/

Fuad Tabba (3):
  KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save
  KVM: arm64: vgic: Don't leak the SPI array when init is retried
  KVM: arm64: vgic-its: Don't write past the end of the collection table

 arch/arm64/kvm/vgic/vgic-init.c |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c  | 11 +++++++++++
 2 files changed, 14 insertions(+)


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.39.5

