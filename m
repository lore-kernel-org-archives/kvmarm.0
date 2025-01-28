Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625BA1D6DBC
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079711; cv=none; b=ovor81r8inDTzrD5AvmLfeMpw257ADgOoS4C5Y5/P6W9eCHxFOX40VThkjl8P5SeYd9JTqe6NACRcs467ALhCXeJDLUamuGzEyB8apPD6Bjwu2N1/0+L+BSfaY5/eOnLjaIFi+rw7mIY7vud9zy9q2qf+VoJDiBY2Ryh8F5CZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079711; c=relaxed/simple;
	bh=jCKt0gUT5g/Y2mG2zUFu1Yf0NlQ9tnRq+zh+vqYXFls=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Eyrq8cteW5rURnoJoLvNYn+qiKsPui5cgs5aZ0x/won+zyI80kEGjAXAhno8wzwm91fAP1m9+llE2necwm8QX65N1pNkSCj5sX/DX08EckQUpz+g7u9alRPREvFkCKRf2Sx2gTAAmASvhtom67zDa0hZ8geO/NhjJ7MPLPijiJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00D6D1007;
	Tue, 28 Jan 2025 07:55:35 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C6FF33F694;
	Tue, 28 Jan 2025 07:55:06 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of firmware mitigation
Date: Tue, 28 Jan 2025 15:54:24 +0000
Message-Id: <20250128155428.210645-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
a hardware prefetcher to form an address using the contents of a memory
location which is accessible by privileged accesses in the active
translation regime, potentially leaking the contents of this memory
location via a side channel. This has been assigned CVE-2024-7881:

  https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881

Arm's recommended mitigation is that firmware configures an
IMPLEMENTATION DEFINED control bit (CPUACTLR6_EL1[41]) to disable the
affected prefetcher, and updates to Trusted Firmware-A are available to
do this. For systems which have not yet recevied a firmware update, KPTI
can help to mitigate the issue.

These patches enable KPTI for affected parts when the firmware
mitigation is not present. The presence of the mitigation is identified
by the presence of the SMCCC_ARCH_WORKAROUND_4 SMCCC call, which was
deployed with the mitigation. This is documented in the SMCCC 1.6 G BET0
specification:

  https://developer.arm.com/documentation/den0028/gbet0/?lang=en

I have tested this on a few configurations of virtual platforms. I'd
appreciate any feedback, especially on the KVM changes.

Mark.

Mark Rutland (4):
  arm64: cpufeature: rename unmap_kernel_at_el0() -> needs_kpti()
  arm64: cpufeature: factor out cpu_is_meltdown_safe()
  arm64: cpufeature: mitigate CVE-2024-7881
  KVM: arm64: expose SMCCC_ARCH_WORKAROUND_4 to guests

 arch/arm64/include/asm/spectre.h  |  2 +
 arch/arm64/include/uapi/asm/kvm.h |  4 ++
 arch/arm64/kernel/cpufeature.c    | 95 ++++++++++++++++++++++++-------
 arch/arm64/kvm/hypercalls.c       | 21 +++++++
 include/linux/arm-smccc.h         |  5 ++
 5 files changed, 107 insertions(+), 20 deletions(-)

-- 
2.30.2

