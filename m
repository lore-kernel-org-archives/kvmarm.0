Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E959F266C1
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 12:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AA4F13D5;
	Thu, 12 Oct 2023 05:35:49 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DB033F5A1;
	Thu, 12 Oct 2023 05:35:07 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 0/2] KVM: fix issues with Permission Indirection Extension
Date: Thu, 12 Oct 2023 13:34:57 +0100
Message-Id: <20231012123459.2820835-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is a fix (and a cleanup) to KVM when using PIE.

The handling around HFG registers was changed and that missed off adding the
PIE traps to the HFG*_nMASK values.

Thanks,
Joey

Joey Gouly (2):
  KVM: arm64: add nPIR{E0}_EL1 to HFG traps
  KVM: arm64: POR{E0}_EL1 do not need trap handlers

 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 arch/arm64/kvm/sys_regs.c        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

