Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90148489A
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990155; cv=none; b=lP96R1JajQKZ47+gI87har0kgbuscb4elGJZyV4Dy34sbMfmaL8VrM7rqFpN9jjgPt1BbWfpD/uaP6rLLKhiF/bMYtL1AOvAl6dmsPBgrs8DVUlmZiLPJxsndnS+V9uGMGEVKdMwzUxPOtRIx/MWyCD0FxYr7PXfiYxVL6AqWGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990155; c=relaxed/simple;
	bh=xqLu/nC/RBdWWfJCzlL9gBVxPMgI4ZF+fkIfdQ+WJCY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lh+dEDJcQTQm0/06RuX48YFn4rwcy2hS1l+NLhRCNr6TRv3ZCsebfCfJUQlzy/l5TIdnvqV0f5Kf0ACXNeVP2eM8pxQuTyb3Fosw+7pmwRbKvSDvsvBFCcD+Cd6rUgFVDfctL9hemtWVCKZMcXeLBX7CNx/QTOXd7b7ZmfLJ3Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from canpmsgout11.his.huawei.com (unknown [172.19.92.148])
	by szxga04-in.huawei.com (SkyGuard) with ESMTPS id 4hpLZf2pRLz126LsP
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 19:28:26 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hpLLL07YQzKm5t;
	Mon, 21 Sep 2026 19:17:46 +0800 (CST)
Received: from kwepemk100011.china.huawei.com (unknown [7.202.194.59])
	by mail.maildlp.com (Postfix) with ESMTPS id 819504057A;
	Mon, 21 Sep 2026 19:28:51 +0800 (CST)
Received: from huawei.com (10.90.31.46) by kwepemk100011.china.huawei.com
 (7.202.194.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 19:28:50 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad
 Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: <kvmarm@lists.linux.dev>, Zhou Wang <wangzhou1@hisilicon.com>, Nianyao
 Tang <tangnianyao@huawei.com>
Subject: [RFC PATCH] KVM: arm64: Restrict CNTP_CVAL/CNTHP_CVAL save/reload when ptimer is used
Date: Mon, 21 Sep 2026 19:18:40 +0800
Message-ID: <20260921111840.3000905-1-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk100011.china.huawei.com (7.202.194.59)

A guest's physical timer may be used in nested guest or directly used in
VHE mode. We can check above cases to avoid useless CNTP_CVAL/CNTHP_CVAL save
and reload.

Use lazy detection to determine whether a non-nested VHE guest actually uses
the physical timer.

timer_set_traps() initially traps CNTP_CTL_EL0 writes for non-nested guests.
On the first write that sets CNTP_CTL.ENABLE=1, the trap handler records
ptimer_used and clears the trap in CNTHCTL_EL2, allowing the guest direct
access thereafter.

A test result from KUT in HiSilicon HIP12 is:

                    nopatch        patch
 hvc                758            624
 mmio_read_user     3647           3479
 mmio_read_vgic     949            817
 eoi                29             29
 ipi                2534           2302
 lpi                2684           2442
 timer_10ms         2393           2168

Reported-by: Nianyao Tang <tangnianyao@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/kvm/arch_timer.c     | 15 +++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c |  6 ++++--
 include/kvm/arm_arch_timer.h    |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6ac3321f4c57..fcbd1e133ad0 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -832,6 +832,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
 		tpt = tpc = true;
 
+	/* Lazy ptimer detection: trap CTL until guest first enables it */
+	if (has_cntpoff() && !vcpu_has_nv(vcpu) && !vcpu_timer(vcpu)->ptimer_used)
+		tpt = true;
+
 	/*
 	 * For the poor sods that could not correctly subtract one value
 	 * from another, trap the full virtual timer and counter.
@@ -1054,6 +1058,7 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		offs->vm_offset = &vcpu->kvm->arch.timer_data.poffset;
 	}
 
+	timer->ptimer_used = false;
 	if (timer->enabled) {
 		for (int i = 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
@@ -1270,6 +1275,16 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 		preempt_disable();
 		timer_save_state(timer);
 		kvm_arm_timer_write(vcpu, timer, treg, val);
+
+		/* Lazy ptimer detection: catch first CNTP_CTL enable */
+		if (has_cntpoff() && !vcpu_has_nv(vcpu) &&
+		    tmr == TIMER_PTIMER && treg == TIMER_REG_CTL &&
+		    (val & ARCH_TIMER_CTRL_ENABLE) &&
+		    !vcpu_timer(vcpu)->ptimer_used) {
+			vcpu_timer(vcpu)->ptimer_used = true;
+			sysreg_clear_set(cnthctl_el2, 0,
+					 CNTHCTL_EL1PCEN << 10);
+		}
 		timer_restore_state(timer);
 		preempt_enable();
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7875911c0506..0cd73093878a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -122,7 +122,8 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	___activate_traps(vcpu, __compute_hcr(vcpu));
 
-	if (has_cntpoff()) {
+	if (has_cntpoff() &&
+	    (vcpu_has_nv(vcpu) || vcpu_timer(vcpu)->ptimer_used)) {
 		struct timer_map map;
 
 		get_timer_map(vcpu, &map);
@@ -156,7 +157,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
-	if (has_cntpoff()) {
+	if (has_cntpoff() &&
+	    (vcpu_has_nv(vcpu) || vcpu_timer(vcpu)->ptimer_used)) {
 		struct timer_map map;
 		u64 val, offset;
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index bc6f2fdd7ad3..f427246a7726 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -90,6 +90,7 @@ struct arch_timer_cpu {
 
 	/* Is the timer enabled */
 	bool			enabled;
+	bool			ptimer_used;
 };
 
 int __init kvm_timer_hyp_init(bool has_gic);
-- 
2.33.0

