Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E54D44E653
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455865; cv=none; b=GTsggDIbPtEY7+8hnBs3vqZijwk61ijYxsLx32fsXYQMLxVfN3+DtBUqEK9fXyYypNRgwBZ83lixsIHvpTY4TyBKi1+/xCRsSZKkIToDDrJ4+wJs5Z+FyjPx3uZguvIs6bE+gclm5WyKjdQjB+9cpnM1K78SILuBM1CUDZbXSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455865; c=relaxed/simple;
	bh=1dBVgqiX9CYqykZIpW6hii98L+GZiNAYn8/L36aDd8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ceEShNgodFrwPtgGNkj6yNc39uaz/0QA2BDO0VZZZq8QVsDnoKVl7L89E40hMBdOowH7tCiBwiUwyPs+inOPQzPZzs92qoHtUFwn9SbuFwn1d93UN0iYA2AbjnucYzTp99/X4+cHa3aA01ACyXs/5Ad3mEB4C3R0bvgmNeOsoZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lE5u71m4; arc=none smtp.client-ip=91.218.175.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lE5u71m4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1dBVgqiX9CYqykZIpW6hii98L+GZiNAYn8/L36aDd8E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455861; v=1; x=1790060661;
 b=lE5u71m4qBpqsm7gKiCJGpT7ewzRfTZ/ym3fsjDEM0Se3gqXjC24eAmgsbCEpYuV1sqC8/nd
 1EyTUB9Iw9jx3m82eqsv79UIwQsVYnmvOEs7Q7LjVgGPkr76fJwr1/D3PYbWHo11g6MBkCsp+N4
 LR8YlUXm4vDYr5/5lNgL1ZsM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 22be79310fb6ffaa;
	Tue, 15 Sep 2026 07:04:21 +0000
X-Mizu-Trace-ID: 22be79310fb6ffaa
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v2 0/2] KVM: arm64: Validate host pointers in __kvm_adjust_pc() under pKVM
Date: Tue, 15 Sep 2026 08:04:16 +0100
Message-Id: <20260915070418.3209779-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - New patch 1: enter_exception64() reads the VM's MTE flag through a
    host-writable vcpu->kvm that nothing validates. It goes first,
    since pinning the vCPU alone leaves that read on an unmapped VM.
    (sashiko)
  - Dropped the VM pin the fix carried in v1, patch 1 validating that
    read at its site.

Two host pointers reach EL2 unvalidated on the __kvm_adjust_pc() path
under pKVM, and this series fixes both. The host vCPU isn't mapped at
EL2 until its first KVM_RUN pins it, and KVM_SET_VCPU_EVENTS with
ext_dabt_pending reaches the hypercall before that. The vcpu->kvm the
exception entry reads the MTE flag from is host-writable, and nothing
checks it. Either one panics the hypervisor, and on MTE-capable
hardware the flag read leaks one bit of hyp memory the host chose,
through PSR_TCO.

These are patches 2 and 3 of the pKVM core series [2], which carries
them so that it applies as is. They're respun here so they can be
applied on their own.

Based on v7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914065136.3418404-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260914113338.159227-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
  KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM

 arch/arm64/kvm/hyp/exception.c             |  5 ++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 19 ++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 39 ++++++++++++++++++++++
 4 files changed, 79 insertions(+), 2 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

