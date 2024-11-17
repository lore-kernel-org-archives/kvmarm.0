Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D577DA68
	for <kvmarm@lists.linux.dev>; Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731862683; cv=none; b=hHUE2pz1n5pyh4yqOAERItHifSp+vtnRHBK5+ke0bYEXU1VwToFdZlO6MV8xhYtIyiUtjw+hqz4o6cXIKI/H7Ni3VgNeLCGX1IlmWMJDjkrsadysVJzOMIZdYBOtNNBJNtwc/OVjfYqTWzNZN6NfeRIvz3QAPHvS/C8Anv+Rhsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731862683; c=relaxed/simple;
	bh=NpH4jY+JCjKP6r6zSnex/nzywYVAlfjvb617sL0GkLw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CPyb0sY/vlUY5JYMeFuXOK4lZmwqX/to06XJkwmli5Zw54Y4EaAzzNjS6AGV0MDDmPHEWTdICKTNRQBK2CdAWMuCUJY9K8GhY2g99f4GYK5LXQqGcuHtl7FrfVd0noA2T901zyT1seJ1mo6WIQuNNWfXP43FUKsnbKDk6c+oZOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBxv/TOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBxv/TOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE88C4CED0;
	Sun, 17 Nov 2024 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731862683;
	bh=NpH4jY+JCjKP6r6zSnex/nzywYVAlfjvb617sL0GkLw=;
	h=From:To:Cc:Subject:Date:From;
	b=EBxv/TOZ8w81qYwE+diW+f9Y6u0WGIiXFdsVP1oLEBc82WtRLuiclHWAZQDIkugEz
	 2xJhKxhAXhWWyUeHErd3vdaHY2vwNZIdoV4G7g4hRx9N4bygnWwG0dptFO1fopnKKB
	 IuN2PbdjMC2wAak/zwU1zclKvuVjgesAt+yX38xasOm5wW2i002CWWmt1I1ap+RwKM
	 FumdE9rJVc2BXfTv1HmGSdc9rHTYMGZiKdMHQuOGREe86eeYPWRhpRZ6ykun8E1HOA
	 YEnBr3dBHE5P7xjsC9OAIu6sER39SvP+ri+m90/ra+zgzCBRmbMhAGRxut952avkWK
	 WT40++aBR6JNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tCib3-00DYt6-1q;
	Sun, 17 Nov 2024 16:58:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/4] KVM: arm64: vgic: Collection of fixes for 6.13
Date: Sun, 17 Nov 2024 16:57:53 +0000
Message-Id: <20241117165757.247686-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is a more or less random collection of vgic fixes, addressing
issues ranging from "purely cosmetic" all the way to "pretty annoying"
(of which patch #1 is an example).

The general theme is around the tightening of the internal API in
order to make it a bit more difficult to get things wrong, something
that I'm particularly good at. There is a bit more I'd like to do on
the ITS, but I'm testing the waters here.

Patches on top of kvmarm-6.13, tested on the funky x1e box.

Marc Zyngier (4):
  KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
  KVM: arm64: vgic: Make vgic_get_irq() more robust
  KVM: arm64: vgic: Kill VGIC_MAX_PRIVATE definition
  KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry
    sizes

 arch/arm64/kvm/vgic/vgic-debug.c   |  5 +-
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c     | 77 +++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 12 ++---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 +++--
 arch/arm64/kvm/vgic/vgic-mmio.c    | 38 +++++++--------
 arch/arm64/kvm/vgic/vgic-v2.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 +-
 arch/arm64/kvm/vgic/vgic.c         | 43 ++++++++++-------
 arch/arm64/kvm/vgic/vgic.h         | 27 +----------
 include/kvm/arm_vgic.h             |  1 -
 12 files changed, 126 insertions(+), 100 deletions(-)

-- 
2.39.2

