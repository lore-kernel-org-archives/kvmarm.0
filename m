Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD4042B319;
	Mon,  5 Oct 2026 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191292; cv=none; b=rVmj6VqGCExExGH+Sogj52/0qsFCOrt+Dout1xE8oilSd/2QNievhYZvLcQ5NXcigupTSOOoMnXNwaJgasFhSKjq1p6TBu5eSyENQgmexp8m1PGBmlyqgBlk8F3KFOvm75hMWYdavtZhJBzC06NnWUbW/0E9LBvteyl05G1OYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191292; c=relaxed/simple;
	bh=VEvLdkz1eGObHkr5aPI59l9BjDBAJ/q4k8m4P7yH6kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xuxb0nDMYCCMYObe5RU0sJJyV6EpVF2kLPYElNLeBqly/ehXz5BCeKN2rqtIWDfNBDX8n8nc/4JSvhhwYqx12wKfGastWksrY2tDEfVs8mappF+f2+pJSh6po7MYlb1K8YJZFZ5MXJCdJNwhFzLr/LuKRxfPLt4vYfQ/iP3H1Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VTekPLpm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VTekPLpm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 611831576;
	Mon,  5 Oct 2026 02:08:06 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BEE4A3F66F;
	Mon,  5 Oct 2026 02:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191289; bh=VEvLdkz1eGObHkr5aPI59l9BjDBAJ/q4k8m4P7yH6kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTekPLpml7vv33SnmoRUcJNZV8KWAJ6Jr9TOi847zCOM+o4aL1oI/SgkU2KIXQYGF
	 6fn619PCfEi0acgEGmCmg7/FsXfnwtUDkqqPJtai3oaroPwGoHtWj5+Khzi/VvUGCZ
	 QOAP4i9ET+l5oUkd45PTJwYJj9pC2jJsm2ec/9aM=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 01/23] KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
Date: Mon,  5 Oct 2026 10:07:32 +0100
Message-ID: <20261005090754.2140522-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected VMs doesn't allow setting offsets for virtual and physical
counters, as the offset is always fixed to 0. The VM ioctl is filtered
out based on the cap. However we don't prevent the userspace from trying
to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.

Fix this by always "fixing" the timer offsets to 0 and marking that the
timer offset is set in the kvm->arch.flags at KVM init time for protected
VMs. This prevents the access to the VM specific vm_offset at low cost.
A userspace writing to the CNT*CT_EL0 would observe success, without
any real effect. This is cleaner over spilling "*_is_protected()"
checks and "matches" what we really do in practise. i.e., always run
with "fixed counter offset of 0".

Reported by Sashiko

Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
Suggested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v19:
  - Fix typos in commit description and explain why we choose the approach.
  - Improve comment in the code
 Changes since v18:
  - Retain NULL vm_offset for protected VMs to avoid host tampering with the
    offset.
  - Moved the flag setting into kvm_timer_init_vm(), where it should have been
    in the first place
---
 arch/arm64/kvm/arch_timer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6ac3321f4c575..a45845f4ae4ea 100644
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
+	 * Protected VMs don't allow the userspace to set counter offsets,
+	 * either set via counter register writes or the dedicated ioctls.
+	 * Pretend the offset has already been set and rely on the default
+	 * offset being 0.
+	 */
+	if (kvm_vm_is_protected(kvm))
+		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
 }
 
 void kvm_timer_cpu_up(void)
-- 
2.43.0

