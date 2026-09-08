Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD7556E07B;
	Tue,  8 Sep 2026 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884614; cv=none; b=u8H59vCPsowOJOIVDOQCqmCEVjyOWkMcMwcvp4xpRUBGFJQMiLNdz+AN4gIGkPx78n7LXjgykls4/xbyNkCTkloloJLMF4yww7SQgBm5QVEtKZQXWQlPIN3KdAgWtiIlzZgYIGqRX6lVDYzzqUZxZqKcuncIuS9WWa3lhN+XR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884614; c=relaxed/simple;
	bh=cQ58Yv70roVo81q8YhrC7/X6t1/ZhRn2w2WWnNS8nhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtxDtO6F9ewJthXsF1ZCnWOSnYj1GAQgbkpWsMxbVHil62aFI0OeqBQjc/PA+X7j2ZR/05RhvLZKRXtKdOfZeYWU1TXBskaouAprIFk/PmX5SYMu7tuqZbLIBenc2BYXNYVsFSEHGqch3gAWABK/TfGEqL+7sncrCkubnjFRRhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kClYRytW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kClYRytW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 779011477;
	Tue,  8 Sep 2026 09:23:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D775D3F7B4;
	Tue,  8 Sep 2026 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884612; bh=cQ58Yv70roVo81q8YhrC7/X6t1/ZhRn2w2WWnNS8nhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kClYRytWqQQBGNNWIWxVmskQVHDgFyIpVPJJUOmWcU0B+eJcM90R/uSvItvNW5ufv
	 37Ffp+qeitSORtr+HhQuh4ELTvScMnd6b7Lm0elsysioOlx/w0VCzZGeYMcRiyDI63
	 ScAk2LSkj5PGLVJRp3pAWyoRIOX5ikoQAAyB/oxM=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 12/20] KVM: arm64: CCA: Support timers in realm RECs
Date: Tue,  8 Sep 2026 17:22:15 +0100
Message-ID: <20260908162223.1683432-13-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

The RMM keeps track of the timer while the realm REC is running, but on
exit to the normal world KVM is responsible for handling the timers.

A later patch adds the support for propagating the timer values from the
exit data structure and makeing sure the values are in sync for KVM.

Also, RMM doesn't support injecting virtual interrupts backed by Physical
interrupts. So, use the existing software resampling mechanims for Realm
timer interrupts.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arch_timer.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index eba84cab95d01..3eddf44f7b1dd 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,11 +56,25 @@ static unsigned long kvm_arch_timer_get_irq_flags(void)
 	return kvm_vgic_global_state.no_hw_deactivation ? VGIC_IRQ_SW_RESAMPLE : 0;
 }
 
+static unsigned long kvm_realm_timer_get_irq_flags(void)
+{
+	/*
+	 * RMI_REC_ENTER rejects LRs with the HW bit set, so use the existing
+	 * software resampling mechanism for Realm timer interrupts.
+	 */
+	return VGIC_IRQ_SW_RESAMPLE;
+}
+
 static const struct irq_ops arch_timer_irq_ops = {
 	.get_flags	 = kvm_arch_timer_get_irq_flags,
 	.get_input_level = kvm_arch_timer_get_input_level,
 };
 
+static const struct irq_ops realm_timer_irq_ops = {
+	.get_flags	 = kvm_realm_timer_get_irq_flags,
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
+
 static const struct irq_ops arch_timer_irq_ops_vgic_v5 = {
 	.get_input_level = kvm_arch_timer_get_input_level,
 	.queue_irq_unlock = vgic_v5_ppi_queue_irq_unlock,
@@ -1609,8 +1623,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 
 	get_timer_map(vcpu, &map);
 
-	ops = vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
-				      &arch_timer_irq_ops;
+	if (vcpu_is_rec(vcpu))
+		ops = &realm_timer_irq_ops;
+	else if (vgic_is_v5(vcpu->kvm))
+		ops = &arch_timer_irq_ops_vgic_v5;
+	else
+		ops = &arch_timer_irq_ops;
 
 	for (int i = 0; i < nr_timers(vcpu); i++)
 		kvm_vgic_set_irq_ops(vcpu, timer_irq(vcpu_get_timer(vcpu, i)), ops);
-- 
2.43.0

