Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66F2575F
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723108556; cv=none; b=gOZgGR2U/hZ+SWtSZwUrgv+jMKdc449DsNiOiLE2xY6mqNDlpwQVmUIrydqMo9pAjXb7Xm2ZG97Vu6jj1qWopEm6xx9Gw+xzPYbiS+QlRnrofbLCwRCC9jkRGLSCKdCKpDu1iKGCbb/LjxNqTza1h2k6cagviFeaatLDNM8lNQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723108556; c=relaxed/simple;
	bh=GqGoXZf5ZNkijfTLRcElpTz8MeTHeBFjY1iwA1halrI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ajCIzHf4VOSBVkPfVAhyU/9M2ysmSOVZO1lZ/aw3MftJaf2cFdpXox2I4uujNxx5xRdEvtucsN4tjc9WKwR1dqf4etFwuxYfjyc6AoWFPSJeKbsho8p8xl8eLHzSLqDuS+XsFhSflyyFuDzyEeC660ovZ9K3wyH09tra0Xb8sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMlwhq1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMlwhq1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1897C32782;
	Thu,  8 Aug 2024 09:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723108555;
	bh=GqGoXZf5ZNkijfTLRcElpTz8MeTHeBFjY1iwA1halrI=;
	h=From:To:Cc:Subject:Date:From;
	b=dMlwhq1SkfgqR3g0/69MG9IZp6AdCOEvYQbWQ4SbF7SPv0cMmb2FE7QM7emAYdyLO
	 mPx/3VQQAiZKIyDsGkUdXrNvrgKDfYoW7iWYd1gxUkb3HZ2ZGEnf3IGaznxaQXb7d7
	 gy9BSUK1HN+SnHuNopDb6SU0OnLuT0KrnZzBkhSBfdR6z61y/UnJZulnOx0hT6tx7P
	 Ws0R3bHP/VK+J0ac5Now/yMT1Rtg05DkCMtOBj7EfbNM9C5M7hwXI8XfPKstaVNYux
	 NOnuXM3a4RvL4UzBgGRmM+5n29eYULCtrPROIQ5b7f4gO/fRBwbVuGf7qRLGpQVPMH
	 wG/nElj7W9lgA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sbzFR-001yCx-Gh;
	Thu, 08 Aug 2024 10:15:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH] KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface
Date: Thu,  8 Aug 2024 10:15:46 +0100
Message-Id: <20240808091546.3262111-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Tearing down a vcpu CPU interface involves freeing the private interrupt
array. If we don't hold the lock, we may race against another thread
trying to configure it. Yeah, fuzzers do wonderful things...

Taking the lock early solves this particular problem.

Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on demand")
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 7f68cf58b978..41feb858ff9a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -438,14 +438,13 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	unsigned long i;
 
 	mutex_lock(&kvm->slots_lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		__kvm_vgic_vcpu_destroy(vcpu);
 
-	mutex_lock(&kvm->arch.config_lock);
-
 	kvm_vgic_dist_destroy(kvm);
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

