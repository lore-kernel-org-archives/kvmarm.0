Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C9426687
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 07:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838674; cv=none; b=NtZ6Mjj/wmSEjOFBc5NILsjQ44F7t+nZFEmdOE0yYWdjQsj1F6wsNSaYRp+4Uu3yKVTZ4U2386P5Ob8CsGuJcJEMlZN3j7mEKJrdaXId7uNWwhjtmHdBWjT85bvUh/T3TWrBFEfFVQp7DXDc+51EPr/X2GYvpvJ0ZwR9vHBYuCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838674; c=relaxed/simple;
	bh=DhIR0bzDit/54mRZ18aEIOAZmEoER6aoaw9jLPnsPjo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jqg+GUPnEBFf8ed/vdnaGTrN17heTaPFin3NhF9CmoWIXaVdnMQJ5myMt2Go56YQlD3YEr/dVnggFpMd45KTetxZAC4Q0lJ5eDbkcPuH+FTj6NXC5nxa1YD0wAixZFiMD/NvVttEunjlc8+4/Vvhs7DjNQ0QBjIzfOSZOMrg96c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ctqS2PQ5; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ctqS2PQ5"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DhIR0bzDit/54mRZ18aEIOAZmEoER6aoaw9jLPnsPjo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790838665; v=1; x=1791443465;
 b=ctqS2PQ5TuzqsOkOQZDVPfBJ3GgMmT10ZS0Wse6z0+FYaP0bGZhxZgCbf9RkdH4HBxnbNTRc
 VKOAG0GOuOJFATGGPXyVr6uRaGEKmNo7YTNeV8f1Re0yWWOLcwARKEHaIgfFcdaTktKs+RAlkO8
 HlW8Pd6lvgQxBBS6mUCvGaNk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b1243c585b78d71b;
	Thu, 01 Oct 2026 07:11:05 +0000
X-Mizu-Trace-ID: b1243c585b78d71b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 0/3] KVM: arm64: selftests: Cover the ITS MOVALL command
Date: Thu,  1 Oct 2026 08:10:57 +0100
Message-Id: <20261001071100.190013-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Make the LPIs pending before they're moved, since pending state is
    what MOVALL moves. (Marc)
  - Put the test in vgic_lpi_stress, which now builds a VM per test.
    (Marc)
  - Test MOVI as well.
  - Rebased on kvmarm/next.

This series tests MOVI and MOVALL on pending LPIs, in vgic_lpi_stress.
The MOVALL case passes only with "KVM: arm64: vgic-its: Fix MOVALL
handling of source redistributor", which is in kvmarm/fixes. Under QEMU
with pKVM, VHE and nVHE hosts, it failed all 21 runs without the fix,
and the test passed all 21 with it and all 5 on top of Oliver's series
[2]. MOVI is there because it's what Linux uses to change an LPI's
affinity.

The test can also catch the stale LR that Oliver's "KVM: arm64: vgic:
Move IRQ migrations out of vgic_prune_ap_list()" fixes, since the vCPU
the LPI is moved from can keep it in its list registers during the
move. I've only seen that in the MOVALL case without the MOVALL fix,
where 13 of the 21 runs took the LPI on that vCPU. I couldn't reproduce
it with MOVI, with the fix, or in 70 runs in a Linux VM on an M4 with
Ubuntu's 6.8 kernel, which predates the MOVALL bug. Oliver, this may be
the pending-LPI migration test you mentioned.

Turns out the test does run on an M4, unlike what I said in v1, since
KVM emulates the ITS whether or not the host has one.

Based on kvmarm/next (8c00199d322b9).

Cheers,
/fuad

[1] https://lore.kernel.org/all/cover.1790708299.git.fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260929212925.31775-1-oupton@kernel.org/

Fuad Tabba (3):
  KVM: arm64: selftests: Add MOVI and MOVALL commands to the ITS library
  KVM: arm64: selftests: Build a VM per test in vgic_lpi_stress
  KVM: arm64: selftests: Test MOVI and MOVALL on a pending LPI

 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 258 ++++++++++++++++--
 .../selftests/kvm/include/arm64/gic_v3_its.h  |   2 +
 .../selftests/kvm/lib/arm64/gic_v3_its.c      |  28 ++
 3 files changed, 265 insertions(+), 23 deletions(-)


base-commit: 8c00199d322b9e5e936bb0ff624ac95b01c740fe
-- 
2.39.5

