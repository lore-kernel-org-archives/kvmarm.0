Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D300342DA59
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099286; cv=none; b=JpCoJgS3Ev8xjvVGg1hj2zeC5OALpplRqv3+rk2Bv7XgvpKpOJYW993WwdysNO49g530hMSc6cGlIir4Snzp6Yg4/J0Q/8lXWqtna4qkYh2q66nQKGl7Mv4V1UOsg9hi6dkDVyGArdUJk1D5V+XOoZb8TM6sLqyQ4CNzXHeZl2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099286; c=relaxed/simple;
	bh=hpcT4mmWrsVBtuIsNOiEqSW7KDRvW75gMbMetYl4Cjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kaBljKSkl18yyQWW0C8msd2HwDZuIpd9wggwhOVnUPeB6NMLu8+YVc8ws2TkY/whX0NLobyju3/4LwQR7d4f1bqIBS2jne9TDCDkiF+G1TvJt0bTGpEm7riGpcQSiaKb3jOHYy1Ph3juFo5ELGv52+6hMHX9xbUM3JSfAJlXEQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wtq+/WRR; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wtq+/WRR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQKyNwSgEBS1FdQPCr0BFf1gJZ2ngUj/l5kLW14oFV0=;
	b=Wtq+/WRRi/zWxjokWMWgph4XGTpP8G+/C6SbMsAxCylqKbM1bC3IA/Eeqsia7zfqs2owWV
	wNilawhsI6w/KNzH57TCNK6r0UjGjMehcMgDmNaFgvx7zFuX/Lz4+KKePzwJ7YkkXn7j6J
	YoK1Lk+t4XnPRIz6KWtAbely2w+dXhs=
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
Subject: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array when init is retried
Date: Fri,  7 Aug 2026 11:41:00 +0100
Message-Id: <20260807104102.2410744-3-fuad.tabba@linux.dev>
In-Reply-To: <20260807104102.2410744-1-fuad.tabba@linux.dev>
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nothing latches a failed vgic_init(), so userspace can retry
KVM_DEV_ARM_VGIC_CTRL_INIT after a failure past kvm_vgic_dist_init().
kvm_vgic_setup_default_irq_routing() is the reachable case, running on
every configuration. Each retry overwrites dist->spis and only the last
allocation is freed at teardown, leaking up to 960 struct vgic_irq,
about 90KB, per attempt.

Return early when the array is already allocated, as
vgic_allocate_private_irqs_locked() and vgic_v4_init() do.

Fixes: ad275b8bb1e65 ("KVM: arm/arm64: vgic-new: vgic_init: implement vgic_init")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 907057881b26a..d4cf143f3ae6b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -210,6 +210,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
+	if (dist->spis)
+		return 0;
+
 	dist->active_spis = (atomic_t)ATOMIC_INIT(0);
 	dist->spis = kzalloc_objs(struct vgic_irq, nr_spis, GFP_KERNEL_ACCOUNT);
 	if (!dist->spis)
-- 
2.39.5

