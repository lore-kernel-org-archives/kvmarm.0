Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C438E199B9
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664535; cv=none; b=NXLqK+1Ezw7jYPQKcON2dGCqyHs000FteAKAtJD/yQWUSED5dWhydqOIqaEA759iaSXpQfJHNtHxmePbouSyuZOxESH3SIgYSN5GDVwP3uJT/ZqiGJj+OuqHI389fxN60TvMTLp2Y3oNwV+sYqOe+Mby0vxV4IoSfYJ0n3XDxDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664535; c=relaxed/simple;
	bh=rm/9w42rRW9GO4zT4u5nCRfbjkL1QdHtbZsP+34jdzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XNZt0XzwZeTVa54uZxpDKilvbbJlKh51FnB0kxJLwzAV+0y/FRWTba4WWOuBog0aEQE/jUvUiWdS7w/jKv+RqfvSDAUHywAlbo25OCXDFT7jqXpQP4ChhWpuK+usnyDhCG7Hq6cmTZv/q/JfIy/T8JN/U+SjmljC+CvAQkUPUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K0APZtGc; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K0APZtGc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709664530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kV8Ptlj+qtC/BUvaFvPQC5SmYfOoKkKBIdz5X70IH7Q=;
	b=K0APZtGcmW6kZvsiImhQgnjX2GbNx5voPUh9y61ATCVpfnlr/MwzXsEgrY/J7fGsM/gB1Q
	w1bAgdGATQnC/w5MEGrhYExDL77hz1poV839iwIOB0KpZcPdcMrPcze66eAq6h08kHBA46
	Djuj3hcHodvPKP/oL/nt5a8w+F1il5I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: PMU fixes for nVHE, protected mode
Date: Tue,  5 Mar 2024 18:48:37 +0000
Message-ID: <20240305184840.636212-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Series to address a couple of issues I've hit using the nVHE / protected
mode configuration:

 - Host-programmed PMU events that run during guest execution do not
   work if the VM doesn't have a vPMU.

 - PMU events do not work at all for non-protected VMs on the
   protected-mode hypervisor

Oliver Upton (3):
  KVM: arm64: pkvm: Actually enable/disable PMU events when running vCPU
  KVM: arm64: Fix host-programmed guest events in nVHE
  KVM: arm64: Do not disable preemption in kvm_vcpu_pmu_restore_guest()

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++++++++++++++++++--
 arch/arm64/kvm/pmu.c               |  2 --
 include/kvm/arm_pmu.h              |  2 +-
 3 files changed, 23 insertions(+), 5 deletions(-)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.44.0.278.ge034bb2e1d-goog

