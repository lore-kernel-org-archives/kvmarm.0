Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CC1420898;
	Tue, 15 Sep 2026 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488172; cv=none; b=EEVAPO4puQqxAiwJZterg8Vpee62lwJdVtXZYjU1gR8jytD+g/ubh/jvls4wor/oiE2sa+c/K7qUrPQtBRDlpL0sqQ8mE3BBSwhQ418ZL2RYb29fIFKq+O2JDuPMUqVouWhI9123AuoMLcXalyGkeWKgY0yvZQl607XDQNH2dS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488172; c=relaxed/simple;
	bh=KNGyqBTTUJTWOTVKLgAvuyYtc0wespVw2YOMovUz8Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK0s6x9oKb3otr6qj42/wEs94AztK0XuG1S+sEf8xVmVtSA3uFxixIoX6u0fRXHQ99t8Bup72MmOY0VE8XicQDJpUtHqxw2/5cOxoZKU28C2cw9jz/r0BLxjxHlRHbSZpEhPkHQ0Gwnqa35vAvnPLcqKVtab4M+FR2t8FLcT7zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M9v6rzUZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M9v6rzUZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78D8C1D70;
	Tue, 15 Sep 2026 09:02:46 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 637F63F882;
	Tue, 15 Sep 2026 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488170; bh=KNGyqBTTUJTWOTVKLgAvuyYtc0wespVw2YOMovUz8Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9v6rzUZFHfz43wxKkRx3e2xakx1kna3LEd7bJX+wrLxtfmO6WJmoxsNI1XfDZkn+
	 qU6Re6idPVttaiaoWNuc3tRaFFgNXBmgVAFecgXl6jNMX3opYre6JnfKMBvjOaQzhM
	 p4Ji0zuj//M+hKQvMrlJxscR9jiJ9H57ilvizYIA=
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
Subject: [PATCH v18 19/23] KVM: arm64: CCA: Support timers in realm RECs
Date: Tue, 15 Sep 2026 17:01:37 +0100
Message-ID: <20260915160141.3543048-20-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
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
index dda020da4c9c7..ef5690956ee64 100644
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
@@ -1604,8 +1618,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 
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

