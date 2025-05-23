Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC7A296D24
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016507; cv=none; b=dVX8xFrWXUpUaSHcW7WQilPX+YXIQbZmSg28QclrNrBNv9njqtOgtzvhShaO54ZUMVlimFE/f8sDmjgToxV0g1LpawPTUUOam1HJo9glbsWXBD8+M8AFT28QPdo/T4LOlsIj/VIHxIV//Nt82IQ6d8QpPGCPRrduC+/RcZhfFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016507; c=relaxed/simple;
	bh=lPyngrcqTkYTzofPwlLcVEjcjsNet17npbieWX0BHuA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tOPnxl81nST5fQuaMt7ufGjnRZ4xQIghmVg9KlRUq/M3zJ1oqByXiuzQWNiGhtCcQiMYUhXF1M9NcNHjPEd2Q0z99/Or2WcNcjmuUKGrFT5j/a7+GRGPxhRS1i1dU0aph9gC467xLPopaJZcOVJPBzcmgOUNVPyFCJVPn9b6c0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=novlI073; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="novlI073"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748016500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xGumbJ9N77LNbRd6Pr0oyWnr5VIDAyYv64xEO5G5HUc=;
	b=novlI073BUBFNyHGhgcEjS9rL11QFqMLDKuQSbuWAXwpNehtSzzIAHwInmgJw0z3GmCXAm
	Aj5yiqUTLFLW4bnoMXC900gYf9T2naaFQr8FGNkP6gmbRc85f2amFdonbIDFBCMxzofZui
	KTerj5hU5MMBt5XyEB2XkO/yOrI5rb8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/5] KVM: arm64: Some VGIC-related fixes
Date: Fri, 23 May 2025 09:08:05 -0700
Message-Id: <20250523160810.4049313-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Flushing out some patches I had sitting around before vacation:

 - The irqbypass hooks are not resilient to changes in the GSI<->MSI
   routing and can sometimes leave behind stale vLPI mappings for the
   VM. The fix is to resolve the VGIC IRQ using the host IRQ (which is
   stable) and nuking the vLPI mapping upon a routing change.

 - Closing another VGIC race where vCPU creation races with VGIC
   creation, leading to in-flight vCPUs entering the kernel w/o private
   IRQs allocated.

Applies to kvmarm-6.16.

Oliver Upton (5):
  KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
  KVM: arm64: Protect vLPI translation with vgic_irq::irq_lock
  KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
  KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
  KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race

 arch/arm64/kvm/arm.c            | 26 +++++++++-
 arch/arm64/kvm/vgic/vgic-init.c | 27 +++++++++-
 arch/arm64/kvm/vgic/vgic-its.c  | 48 ++++++++---------
 arch/arm64/kvm/vgic/vgic-v4.c   | 92 ++++++++++++++++++---------------
 include/kvm/arm_vgic.h          |  3 +-
 5 files changed, 125 insertions(+), 71 deletions(-)


base-commit: 1b85d923ba8c9e6afaf19e26708411adde94fba8
-- 
2.39.5

