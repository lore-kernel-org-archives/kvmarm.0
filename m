Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B282426B2C8
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 10:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819772; cv=none; b=kbB11UvSw8Qcxx0ue0wFCd5k02Cdva3AhB0eqeWUBfjqQwUMqjszAEqvmB2KCex88ZMfORAlZ0VrKnfU9uI9lUX+JeuCfXeTuvTu2EkAwH1NkWf9FdlMMoPNBxVAeOHZpuyqe3Ze389LNBVIOBRKoTbRRy/H+/lKgVKTRYsatkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819772; c=relaxed/simple;
	bh=cSMRPy2Ejt7AcgWwS4Xg6W8YSTMAtS2YoEnEg5OvBbM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=B/szoVmkUjsVFZFcOsai/yV9PyXcW2wlCbAa+EqUYaPXRqPVpQIW/iYHGyf5e+2LCelyHbn5qKmMHnuqEt/FP4yhNLTMcLP1nKwhaAZuFcTUyjIBt7v8NAp5Ph2agzvz27eAyxN79PjOh4N8t+4mPy4BZWzWHs15btZWHJ/RROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AA5B2C42;
	Thu, 30 Oct 2025 03:22:42 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D679F3F66E;
	Thu, 30 Oct 2025 03:22:47 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	perlarsen@google.com,
	ayrton@google.com,
	ben.horgan@arm.com,
	sudeep.holla@arm.com,
	stuart.yoder@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/2] use TPM device with CRB over FF-A when kernel boot with pkvm
Date: Thu, 30 Oct 2025 10:22:43 +0000
Message-Id: <20251030102245.2313898-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

To use TPM device iwth CRB over FF-A, it would be good to be compiled:
  - CONFIG_ARM_FFA_TRANSPORT as bulit-in
  - CONFIG_TCG_ARM_CRB_FFA as built-in

to integrate with IMA subsystem otherwise, it couldn't generate the
boot_aggreate log with the PCR value.

Unfortuately, kernel fails to probe the TPM device
when it boots with kvm-arm.mode=protected since the FF-A calls
(FFA_SEND_DIRECT_MSG/MSG2) are failed when CONFIG_ARM_FFA_TRANSPORT=y.

This patch series resolves failure of the TPM device when
kernel boots with kvm-arm.mode=protected and based on v6.18-rc3.

Patch History
==============

from v1 to v2:
  - remove unnecessary ffa_feature smc-call in ffa_call_supported()
    (Ben Horgan's comment).
  - https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/


Yeoreum Yun (2):
  KVM: arm64: fix FF-A call failure when ff-a driver is built-in
  KVM: arm64: support some optional calls of FF-A v1.2

 arch/arm64/kvm/hyp/nvhe/ffa.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

