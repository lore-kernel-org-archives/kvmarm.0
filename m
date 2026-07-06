Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C96395AFA
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333904; cv=none; b=u1UFD3sZEsm/G4VxCQGqpKeM2iiPmO1V+t9bMTi+BxOQI+JAKJ0dWSTHsq1AWjKABUfbB4P4gyVyJTJ2qQyZuOqfVzxb4NISE7tIO1lvkrF2JAtDlDt/v3DCU3MAjuTpzar9fR0IeDsZKywJEZoH26QymUiO8rTQtbw6+bV9NfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333904; c=relaxed/simple;
	bh=LTX3qS9MJW2HW2SAsF4CbrSVk/s27g2Zg/IShaeqkOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOC49ZmkBpcNlUq4YVmRA7BVqSMx42W185qTOZEcLIbV2fxYl07mZxBISq1bb3nTNg8LM8O/j3BWyI+igd0VdlXk2aA5HMayn+NfA5WRzUIe1DW41qGhkovf1k8+52W9Bl5o3aNLrOrfKSw066xhvmzYzOYrTOpDkF6gON5vtAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HyBiiCAs; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HyBiiCAs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783333897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sf3aVvVWV5y32+hWgZQOR7Ij0Kq541DNImzJ0Vu0T7Y=;
	b=HyBiiCAsxm62at1/d1SoF3e4BUauw5uVShsxvFGFJumWpcj/EaO3A0Lb1NUDa3A2jyJyR2
	4JyoG9Codo2PEfpRDG1+yeV17tFmKInZUaddCU5PV8csfFuNzxeWgg9oWS//lhwPvtJ1e1
	3b7lYo1Mf2AZpfQPuNchABPHMysyjiU=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
Date: Mon,  6 Jul 2026 11:31:28 +0100
Message-Id: <20260706103129.706974-3-fuad.tabba@linux.dev>
In-Reply-To: <20260706103129.706974-1-fuad.tabba@linux.dev>
References: <20260706103129.706974-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

pkvm_init_host_vm() runs once from kvm_arch_init_vm(), while the VM is
still being allocated and is not yet reachable by another thread. Both
early checks therefore test impossible state: is_created is still false
(it is only set on first vCPU run) and the handle is still zero (this
function is what reserves it). Neither branch can be taken.

Remove them.

Reviewed-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4be..67b90a58fbea2 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -230,13 +230,6 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
 	int ret;
 	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
 
-	if (pkvm_hyp_vm_is_created(kvm))
-		return -EINVAL;
-
-	/* VM is already reserved, no need to proceed. */
-	if (kvm->arch.pkvm.handle)
-		return 0;
-
 	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
 	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
 	if (ret < 0)
-- 
2.39.5

