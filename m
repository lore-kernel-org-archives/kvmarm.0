Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD10B4746CC;
	Sun, 20 Sep 2026 21:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939750; cv=none; b=DUbkZR4c2gWaFY0D45M2zwWcfhJE6L29MEh7SZ4NAlRURkm19XazouF2s6460f+qxfWsfPA8GKRulP/rZXOs9jAlkVntRX4UJdugtvIIHBJQPtzeqky2lQFAhSwJ4mu4C+X45kenBWqv01as2JRYhvk10wO7vtrwZEwuNTtenqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939750; c=relaxed/simple;
	bh=hqmO4UXFa4NaBlHK0LJVbTw3LVO/B0mbInSUdRwIiNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sI1SKMcXi4hfMc7cmdBZVPPW0BK8mzz6mfdxbBfy5MDJiyAdNXqr8dg95Q1oprL/3zCN9kLss2gpe9sAWVaEqHaLXfq3sUOq979+CcKONa8/lAZKZwb7e1eeDlg2kVdluEQUUMpBg9j6ZbptdSZtrBOurJ6zJOeKG1x+ChK0DvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H31Bgjl0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H31Bgjl0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B756A15A1;
	Sun, 20 Sep 2026 14:29:01 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 81D3D3F632;
	Sun, 20 Sep 2026 14:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939745; bh=hqmO4UXFa4NaBlHK0LJVbTw3LVO/B0mbInSUdRwIiNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H31Bgjl0ATGrNoIKHGiMj8aBWTwSHxu9K4bi2XqouHfWZWehUW3DVOgQcCeZbAfGi
	 B8MLUbX7u6epok94rEYyk2RAvquu9o2aHDz9OgK1dErtE4u6axRDIhJcC3Hg+dH/Dg
	 v7aO5nv8rAuOHHISg/v4pnSnu/dapx0s173oO46Q=
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
Subject: [PATCH v19 01/20] KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
Date: Sun, 20 Sep 2026 22:28:26 +0100
Message-ID: <20260920212845.707-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected VMs doesn't allow setting offsets for virtual and phyiscal
counters, as the offset is always fixed to 0. The VM ioclt is filtered
out based on the cap. However we don't prevent the userspace from trying
to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.

Fix this by always "fixing" the timer offsets to 0 and marking that the
timer offset is set in the kvm->arch.flags at KVM init time for protected
VMs. A userspace writing to the CNT*CT_EL0 would observe success, without
any real effect. This was chosen over preventing the writes to these
registers and returning -EPERM.

Reported by Sashiko

Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v18:
 - Retain NULL vm_offset for protected VMs to avoid host tampering with the
   offset.
 - Moved the flag setting into kvm_timer_init_vm(), where it should have been
   in the first place
---
 arch/arm64/kvm/arch_timer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6ac3321f4c575..226cd5a495c8b 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1110,8 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!vcpu_is_protected(vcpu) &&
-	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
+	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
@@ -1133,6 +1132,15 @@ void kvm_timer_init_vm(struct kvm *kvm)
 	 */
 	for (int i = 0; i < NR_KVM_TIMERS; i++)
 		kvm->arch.timer_data.ppi[i] = get_vgic_ppi(kvm, default_ppi[i]);
+
+	/*
+	 * Protected VMs don't allow any offset being set from userspace,
+	 * either set via writes to the counters or using the dedicated
+	 * ioctl. Pretend the offset has already been set and rely on the
+	 * default offset being 0.
+	 */
+	if (kvm_vm_is_protected(kvm))
+		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
 }
 
 void kvm_timer_cpu_up(void)
-- 
2.43.0

