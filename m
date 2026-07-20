Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225AF3AF676
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553762; cv=none; b=Bdv/r19UvZth8K752BO9cPXigI5+yt8bZN5hiwi0fSWtdpZBGdXS24TTCeJ48WAo84unFVKSdpeYKFk4HKiOvmtHVy//84aORPPxDw5CsmFySL+wS4PmkvUoFbTnwJXWauOeTBEDwY1KAwO8hqsM3D1/tFxVuU3Gyg9PfJCI+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553762; c=relaxed/simple;
	bh=vmgkQ7EmOQWB0dZu70GcQAzgxMya34KamJywgLSqDzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XMrigpFOPabRhzY/AYDUqqa6Y9yqVtzjl+/s8hg0IyukU289b707d8A5x8F5Gd+4DcbWk4iwbLB8+3yi/8iaH/FhMKmYWR8InRkbUlbbR/22ZgcqDhwdH6TWMviXEHkiEw8h7ILY7QaFwwPFLqdWUuB5tsFTB1JKl1WP66JfUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kwqi/3eR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kwqi/3eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DED1F000E9;
	Mon, 20 Jul 2026 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553760;
	bh=YYRiGgf2P+rtL76qHisSx9Ln84RXffHb3Zivhk5R26I=;
	h=From:To:Cc:Subject:Date;
	b=Kwqi/3eRhssMvgchl6+7F/4RBwNzHroWKT+A2hYz3nKMfW5d5YlBOZEnMfMaGQAeV
	 lYzzscniQbeCYJpWumi1HVtBiy78qoTGoDI86qm0mFziOpwFtitvcwAFidjq4WcUvi
	 lkwRSTjiIkecMRYm4LiApkk5kOzpF86ZCW2sbsQVU4xOBPC7Ky1AVhlfwh8GMdw5mN
	 v1NB71LXg4LS5efxOBwH/yUZ6yCCm9oADYDf+HV1vlkRBh5PIU4etufqucWJifAYrv
	 rTVVBc71gQvmIRKOi/W3Y3pO7t0FFo+kjYuJY808KlUHPL9bVHyeY+YsiQgREdvoKO
	 Kd4t5nWdMycIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wlnx8-00000006oKK-1w9t;
	Mon, 20 Jul 2026 13:22:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/5] KVM: arm64: Make ICH_VTR_EL2 accesses an inlined literal
Date: Mon, 20 Jul 2026 14:22:14 +0100
Message-ID: <20260720132220.2143486-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

I did it again.

I was looking at NV traces, and realised that we were trapping a whole
lot of accesses to ICH_VTR_EL2. But ICH_VTR_EL2 really is a constant
from a hypervisor perspective, and we usually cache this in memory, just
like any other ID register.

We do have a variable for this in kvm_vgic_global_state, but we don't
map this one at EL2 since 8aaf3f7dce746 ("KVM: arm64: Don't map
'kvm_vgic_global_state' at EL2 with pKVM").

So what can we do? We can revert back to mapping the global state, but
that's not a very good idea. Or we can be creative and turn the
ICH_VTR_EL2 accesses into a runtime constant patched into the
code. Since we already have a bunch of similar things for the GICv3
traps, that's no big deal.

And for consistency, let's kill kvm_vgic_global_state.ich_vtr_el2
altogether, so that there is only a single efficient way to read
ICH_VTR_EL2.

As usual, this has a significant impact on deeply nested workloads, a
solid 5% reduction in elapsed time for an L3 Linux guest running under
nested KVM instances. I expect this to benefit KVM running under other
hypervisors as well.

Patches on top of -rc3.

Marc Zyngier (5):
  KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field
    symbols
  KVM: arm64: Add a helper providing an inlined literal value for
    ICH_VTR_EL2
  KVM: arm64: Convert most ICH_VTR_EL2 accesses to inlined literal value
  KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
  KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2

 arch/arm64/kernel/image-vars.h   |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 29 ++++++--------
 arch/arm64/kvm/nested.c          |  3 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c    | 69 +++++++++++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-v5.c    |  5 +--
 arch/arm64/kvm/vgic/vgic.h       | 39 +++++++++++++-----
 include/kvm/arm_vgic.h           |  2 -
 8 files changed, 108 insertions(+), 48 deletions(-)

-- 
2.47.3

