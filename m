Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B70D1D9334
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728319394; cv=none; b=C1CAkOJfO9fBCOdh+3JmmfoDA4PtvEWZ2//DLoSocfqeYKAU6VqIN3LPIGK7XX+q152EyDr/vXNxd4cYzgQc8p7EwCeWzHmFMI9zj6yOTF88ISc2IqfnPxsDm7CFRdeeLDn/0f16Zn/oOwyc6Ohcg7XG4AFEvSAHcFVoKHrZ1Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728319394; c=relaxed/simple;
	bh=1Y/5Z0X56AEsJ8VrOkI/zqV5sQVqUpqb4hRp6aZQO7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kVF8J2q8GxhMIDQgFcBZQ8VP7FYy2Qqq+u5E961UeSXrWZ5ZKNHXsusuLNnQv5FH9Uv6fAtxLVbEd7DX2Oq3pkGXWgJcG8PM5wLpOB61xVH14EXcmsXJQ8AIZBdyBHvh78dis+xOL05cc44vhOLJm4geTC4/5igyYSABaNmU3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dbO/0krW; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dbO/0krW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728319388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DZc3zI8soche5Po0aNFXC4P8XLdXqFm/0ykm3FjNJwY=;
	b=dbO/0krWbrJEM0ltXanSnQzYQEBDHeP6a7Cn3UNzYmuu8cGYVGOPMR6vWoP/tilV7v9XRD
	J3OBL+4SJ9XzfkEDxPFxzINAtdho5NZYkWC2zN5mOXKiDAEel3Txxwr53yY5hxO17RHGJL
	mlKa+ONe19kbh6Aajipf7napjj/nfOs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/4] KVM: arm64: nv: Fixes for stage-2 MMU recycling
Date: Mon,  7 Oct 2024 16:42:51 +0000
Message-ID: <20241007164256.1795250-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v1 -> v2:
  - Keep a reference on the MMU so long as the vCPU appears runnable
    (i.e. not in WFI) (Sean)
  - Add comment clarifying why TLBI unmaps are allowed to reschedule

[*]: https://lore.kernel.org/kvmarm/20241001001709.1303668-1-oliver.upton@linux.dev/#t

Oliver Upton (4):
  KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
  KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
  KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
  KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule

 arch/arm64/include/asm/kvm_host.h   |  3 ++
 arch/arm64/include/asm/kvm_mmu.h    |  3 +-
 arch/arm64/include/asm/kvm_nested.h |  4 ++-
 arch/arm64/kvm/arm.c                |  2 ++
 arch/arm64/kvm/mmu.c                | 15 +++++-----
 arch/arm64/kvm/nested.c             | 46 ++++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c           | 33 +++++++++++++++++++--
 7 files changed, 87 insertions(+), 19 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.47.0.rc0.187.ge670bccf7e-goog

