Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100751C3BEE
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 23:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738624563; cv=none; b=k59oSQNxz8J5nm3rPXuhq11vmg2uyLUsViV3yXcLBCus9jFOqqpoEH6v5ERMEn0zbnH4HkORRSuAC6kPrs3+c850phb0xHjJ5HjmaZAX76L+pPwWM2AImBlzXerugeT91NZEynFgyKYx4iY8zw478OXuv+p9kRJSWGqjvfFYrM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738624563; c=relaxed/simple;
	bh=AbxADVLWu160PmlBKhk2VoMibabqm887VrdNek/0RfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=by5pCvzl53NHDyUzeNnkSdDrR3zDzEpyZfSBxSlQdno68vYZtXvdw0ssCZdKS5DgHjNTJeX1V1wRgifMli12s6u6nrnHX3UbdSpRHL1gERJDeSboW4kR+jgbu9GKLgkxUwwvH7AFspknJIpb9VI+o0kG/W7rxS22wPzt7H/DtJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmajkjwV; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmajkjwV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738624558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eFbczyyYTedhfn6mOy/+OafquWEd745U97lYb5Rllxg=;
	b=JmajkjwVXZkpUoGKtqiq9+5TdAcggd1UoqLwXNfsgg8J3pNpxIO2AtxsDWXnoFe1qqPFvi
	Ou9H+zAbqBztJCZ1804RalOFweJFyCkZ2s8csBQ5k44U7/eTExG6yN7vUtFNZeEiPmQywK
	LmDFpJxAyPgwOW7bbLJEE7aqo/1nvkg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: Fail protected mode init if no vgic hardware is present
Date: Mon,  3 Feb 2025 15:15:43 -0800
Message-Id: <20250203231543.233511-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Protected mode assumes that at minimum vgic-v3 is present, however KVM
fails to actually enforce this at the time of initialization. As such,
when running protected mode in a half-baked state on GICv2 hardware we
see the hyp go belly up at vcpu_load() when it tries to restore the
vgic-v3 cpuif:

  $ ./arch_timer_edge_cases
  [  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kvm_nvhe___vgic_v3_restore_vmcr_aprs+0x8/0x84!
  [  130.603685] kvm [4518]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
  [  130.611962] kvm [4518]: Hyp Offset: 0xfffeca95ed000000
  [  130.617053] Kernel panic - not syncing: HYP panic:
  [  130.617053] PS:800003c9 PC:0000b56a94102b58 ESR:0000000002000000
  [  130.617053] FAR:ffff00007b98d4d0 HPFAR:00000000007b98d0 PAR:0000000000000000
  [  130.617053] VCPU:0000000000000000
  [  130.638013] CPU: 0 UID: 0 PID: 4518 Comm: arch_timer_edge Tainted: G         C         6.13.0-rc3-00009-gf7d03fcbf1f4 #1
  [  130.648790] Tainted: [C]=CRAP
  [  130.651721] Hardware name: Libre Computer AML-S905X-CC (DT)
  [  130.657242] Call trace:
  [  130.659656]  show_stack+0x18/0x24 (C)
  [  130.663279]  dump_stack_lvl+0x38/0x90
  [  130.666900]  dump_stack+0x18/0x24
  [  130.670178]  panic+0x388/0x3e8
  [  130.673196]  nvhe_hyp_panic_handler+0x104/0x208
  [  130.677681]  kvm_arch_vcpu_load+0x290/0x548
  [  130.681821]  vcpu_load+0x50/0x80
  [  130.685013]  kvm_arch_vcpu_ioctl_run+0x30/0x868
  [  130.689498]  kvm_vcpu_ioctl+0x2e0/0x974
  [  130.693293]  __arm64_sys_ioctl+0xb4/0xec
  [  130.697174]  invoke_syscall+0x48/0x110
  [  130.700883]  el0_svc_common.constprop.0+0x40/0xe0
  [  130.705540]  do_el0_svc+0x1c/0x28
  [  130.708818]  el0_svc+0x30/0xd0
  [  130.711837]  el0t_64_sync_handler+0x10c/0x138
  [  130.716149]  el0t_64_sync+0x198/0x19c
  [  130.719774] SMP: stopping secondary CPUs
  [  130.723660] Kernel Offset: disabled
  [  130.727103] CPU features: 0x000,00000800,02800000,0200421b
  [  130.732537] Memory Limit: none
  [  130.735561] ---[ end Kernel panic - not syncing: HYP panic:
  [  130.735561] PS:800003c9 PC:0000b56a94102b58 ESR:0000000002000000
  [  130.735561] FAR:ffff00007b98d4d0 HPFAR:00000000007b98d0 PAR:0000000000000000
  [  130.735561] VCPU:0000000000000000 ]---

Fix it by failing KVM initialization if the system doesn't implement
vgic-v3, as protected mode will never do anything useful on such
hardware.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/kvmarm/5ca7588c-7bf2-4352-8661-e4a56a9cd9aa@sirena.org.uk/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 646e806c6ca6..3b3cdcda7a2e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2290,6 +2290,19 @@ static int __init init_subsystems(void)
 		break;
 	case -ENODEV:
 	case -ENXIO:
+		/*
+		 * No VGIC? No pKVM for you.
+		 *
+		 * Protected mode assumes that VGICv3 is present, so no point
+		 * in trying to hobble along if vgic initialization fails.
+		 */
+		if (is_protected_kvm_enabled())
+			goto out;
+
+		/*
+		 * Otherwise, userspace could choose to implement a GIC for its
+		 * guest on non-cooperative hardware.
+		 */
 		vgic_present = false;
 		err = 0;
 		break;

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.39.5

