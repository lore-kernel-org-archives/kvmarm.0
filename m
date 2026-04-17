Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8543D3603DB
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776429979; cv=none; b=dRpIDDW2JC82AAO5Q6PC2mHAs8j46zhyvEFPBX8jy1coCYA/hDZQ8gtKigpFZDR9cPMftDGNK8jddIS/6iWWYy+x4gYgMGAQeexW3nKnbqk5ZQZNXoh6m+ek1fnf68CZk9NgdrjfAfIiWla1nN/UN+b0suif2WMMnpKqkRVEMGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776429979; c=relaxed/simple;
	bh=ydJDYUjgybLlO9ISnWIIvpjgy9hzClj2miPHNIqLbo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljEGi7w7cW0RvIEwX9I5o0FE2TZSwEtvxZBkg83tmPt7oXlntNgdY/NTVSFIIKSpuiaWaLK+aXAYOFo1qGUTi/b5h4WCQmmChljyybpLw5uCo5oEhKl2t4Ny6KrMv1QBbih/ORj19v0ZuLwKTMZr7QbsmN1Wpsu6KHdzRA2FNdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VcEN800/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcEN800/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599D5C19425;
	Fri, 17 Apr 2026 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429979;
	bh=ydJDYUjgybLlO9ISnWIIvpjgy9hzClj2miPHNIqLbo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcEN800/Y+pym/j0vQtweSLITtYEYNtGwcA7AQYcQ+cviUOlNOsjQFtGfUV8fs4Bf
	 y34BkdlUWrFFKEx2aJQ50Q+pu8MiLibP9RBoWnzlwQyCVy9hUMvCR28zsE1a0Veh+T
	 8pvl1dVW1LN2SFrdtZIq+ZKevrh8xa2KJbHM/lE6hQX94XVwXAok6BAJPcltpV9y5Q
	 vFyIP5+n5ztsDw7wc5d2cHI2kCNjXbq5Dz1zO0Y2gEO9hnw0iFCmHNKiWOVh20m+TY
	 sb9c5gbNANDXtsgZImI+L7gxRtTQCnZbZs+67PY7sQRSkDbcczKOfsSHSdArjBHfyZ
	 o7q5ZxdSfBbrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wDiaP-0000000CRo5-1V07;
	Fri, 17 Apr 2026 12:46:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/4] KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt injection
Date: Fri, 17 Apr 2026 13:46:12 +0100
Message-ID: <20260417124612.2770268-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417124612.2770268-1-maz@kernel.org>
References: <20260417124612.2770268-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We how have the lazy init on three paths:

- on first run of a vcpu
- on first injection of an interrupt from userspace
- on first injection of an interrupt from kernel space

Given that we recompute the state of each in-kernel interrupt
every time we are about to enter the guest, we can drop the lazy
init from the kernel injection path.

This solves a bunch of issues related to vgic_lazy_init() being called
in non-preemptible context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1e9fe8764584d..9e29f03d3463c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -534,11 +534,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 {
 	struct vgic_irq *irq;
 	unsigned long flags;
-	int ret;
 
-	ret = vgic_lazy_init(kvm);
-	if (ret)
-		return ret;
+	if (unlikely(!vgic_initialized(kvm)))
+		return 0;
 
 	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
-- 
2.47.3

