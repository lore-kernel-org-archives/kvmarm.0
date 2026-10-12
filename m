Received: from mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D054A49A3
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821730; cv=none; b=HomvlnYvgmTdeopTEEALaxqr300Tg/iqYQmZdRiIbmvmc23zBsL8TFNJl5g6gwSJqmCGZ96qmy0Qziy4n1ADoetcMEuCKOFYXrO1PBabucTul1t+AlpyDWIBL6diPQwBeO8+2jvl52GdTKzwPLwJu+h3njmEcx+HEaHD39P7akM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821730; c=relaxed/simple;
	bh=g6cSCDmIiMeFVv+t4Y6Wg9H08beduiIxXPLZlypaYk8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SRUjHg43r+aM2vTJmXM5A8VHeNneosg9E6E4hr8kRoU9oUpOkvJHLt/SPreNwU2GJjh/SIPsAtNmH2AYc3h4cYYKFWR2kJ+CTNltiUfxqfJda7f/SlE48DDvQdiABO42mHgAFMOMnMwKmwzuPbOdSNuoMmvNpD3LJuwpKChNr6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EcnNG0yS; arc=none smtp.client-ip=95.215.58.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EcnNG0yS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=g6cSCDmIiMeFVv+t4Y6Wg9H08beduiIxXPLZlypaYk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791821725; v=1; x=1792426525;
 b=EcnNG0ySDPJM6Yhx3IcShUu7OXspr8PWmxfYi0iRmo0KAzvgxh7ERUNbvcWuShtJjBNr0bad
 vWWKz3D22RpAfdTVKose/1UPb+1vGDZ1T6hV47XO546sHvY9xevN6/bjzUDJpHyr8EzD8GjN1pF
 I7c/5mXBiliszHvHh5LX+YQA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7c027d74522afa10;
	Mon, 12 Oct 2026 16:15:24 +0000
X-Mizu-Trace-ID: 7c027d74522afa10
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH v3 0/5] KVM: arm64: pKVM host hypercall and GICv5 CPU interface fixes
Date: Mon, 12 Oct 2026 17:15:19 +0100
Message-Id: <20261012161524.4016464-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v2 [1]:
  - Patch 4 now allows only GICv2 from EL1 and requires VHE for every
    other CPU interface, instead of adding GICv5 to the VHE list. Same
    behaviour; I kept Sascha's Reviewed-by. (Marc)
  - Added Suzuki's Reviewed-by on patches 1-3.

Thanks Suzuki for the reviews.

Patches 1 and 2 move the GICv5 CPU interface save/restore and the
stage-2 flushes into the band the dispatcher rejects once pKVM has
finalised, since the host has no use for them in protected mode.
Patch 3 validates the vgic model EL2 copies from the host. Patch 4
stops nVHE from accessing the GICv5 CPU interface from EL1, and patch
5 fixes two stale comments.

The GICv5 residency and VDPEND hypercalls in kvmarm/next still check
for pKVM in each handler. I'll move them into the same band once this
lands.

Based on Linux 7.3-rc3 (fd73f4a665989). On kvmarm/next, patches 1 and
2 have a minor conflict: new hypercall IDs sit next to the ones they
move.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261011143648.211337-1-fuad.tabba@linux.dev/

Fuad Tabba (5):
  KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
  KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
  KVM: arm64: Validate the host-provided vgic model in pKVM
  KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
  KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch

 arch/arm64/include/asm/kvm_asm.h   | 16 ++++++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 ++++++++-------
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 10 ++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c   |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         |  7 +++----
 5 files changed, 29 insertions(+), 23 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

