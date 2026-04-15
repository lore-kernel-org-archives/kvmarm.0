Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF4437D11F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254184; cv=none; b=CZJAehX4ancAYB0K0rnexG+aDmmAbdbyDyAQLivtbHNQAk3nlRPtXDhPOUJqhZi8Ds+Z7lLJVfndJt0QizViAT6F5ljgAxwy0xYuK2kAD/yeHOpHZHg+FAMNPGwMEZVveV1VCHDrCoN/AjwYp2hwwJEEpm2S+WCOYi7ErpJuqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254184; c=relaxed/simple;
	bh=GepxWY2Sbz+aiD9Px/BOeFFVY1vJXpQLuKumF7thz8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tlw+i0a2pP/gzZGCkVcAIY/Pe6Enb3gNWLh90c8FnVb5Lmoa7AkvyZsATZiu9Hf0ZCqN57GW77/mQaSW5mSyWWMsfP8NOh/cWwxQAbJxCWWtf0WVzS0kpT6ggybuoEyLkVRUw9HAekeiYdM2X6r0Nacnv16t40RQWzOsq1quEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYBjmnZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYBjmnZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D1FC2BCB3;
	Wed, 15 Apr 2026 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254183;
	bh=GepxWY2Sbz+aiD9Px/BOeFFVY1vJXpQLuKumF7thz8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYBjmnZhmwAK6duQ+c6y0Y5960nm/fSG1PdX9lcFVBypxea86KrQtRQkuhBedF4AL
	 Lnw69lAKYnK8hNgTWOenv1H4QvLS6sNlGVcAsM1ZKJA9bV7xW3KbWJdxtdpdllAeB+
	 mJ6yDIdB8Pa7rqSS0wCKYBBC9i7u0h3w3EtGnx1xqGcr/X1vl5b04ob3YD51PKQ5pg
	 Iq63LqRb93ND7ZjSVS0YsgD9aMdonFOLtDwreXSmvb+hVEzNMcDIMR19tGfg2aEpwu
	 JZ9dKjaFUIhozq7smEfbCazxi/q40pcXtlYBfIC+udmWpFxUDwvMhX3P0rWPsKgqBm
	 MRdLd8hCvQ5vw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyr0-0000000Bqsi-0d0n;
	Wed, 15 Apr 2026 11:56:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 15/18] Documentation: KVM: Fix typos in VGICv5 documentation
Date: Wed, 15 Apr 2026 12:55:56 +0100
Message-ID: <20260415115559.2227718-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

Fix two typos in the VGICv5 documentation.

Fixes: d51c978b7d3e ("KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI")
Fixes: eb3c4d2c9a4d ("Documentation: KVM: Introduce documentation for VGICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/arm-vgic-v5.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
index 29335ea823fc5..1985b2d880322 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,8 +12,8 @@ Only one VGIC instance may be instantiated through this API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space devices
 to inject interrupts to the VGIC instead of directly to CPUs.
 
-Creating a guest GICv5 device requires a host GICv5 host.  The current VGICv5
-device only supports PPI interrupts.  These can either be injected from emulated
+Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 device
+only supports PPI interrupts.  These can either be injected from emulated
 in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LINE
 ioctl.
 
@@ -25,7 +25,7 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been created.
 
-   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIS
       request the mask of userspace-drivable PPIs. Only a subset of the PPIs can
       be directly driven from userspace with GICv5, and the returned mask
       informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
-- 
2.47.3

