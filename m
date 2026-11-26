Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708429;
	b=atI9Z7b8vZF5cTGO0gM0rOlzzBytwrpa8YyteqAXTlZqI+pszAV1uC5rG8pZ4hoNFV38
	 fx3j0Q0wgLgMx6CbxUYF4KSLyqgFXiv1wnjVOCelyvsN0584QM735tFmXmqS0lB0QHnMK
	 dL2xyJZ3pISOb+e7roYGwESg3fj30PLVZDwTslDkqjUiT1CydUXD8CvLpawCAx5IRqcZO
	 6AdpI/go0Tfah8A9b3WBxEApmnKDLy03MmUzH54mTjUkpmFhteoRJwrd23auJ7xK4kwxz
	 uwCFnKnsBNfd9y0kC6VG/2IEQINraWLmZq4qXvn8ni3W+AHK6mILhKB0NL/08ccXNtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PAqADx6BCDJW/l9oyP65JCbSK+i8IXF6jV/NhPgDrvU=;
	b=qxqIPl1xWg0usFnLXoQmPCbSjKhtUxdn02lTetowW0K1+S0cmwDsvaN0R++aVt9/Asfm
	 zfBDxFX4ULA8bcyd3NIevZvL/zyWQtKpPmQpYYdna7Iepo2KsHvQudAH2PS5rzBq0dk4H
	 bOw7dtIBcqU5WCG9IZDZGUpr1BkioYa1QV27NhZtlb1WA/SPmJ0oSuPO1xZPKrlzx/z2U
	 TrN32+pqcF8FVHrCUWEERmRpu5C826Su1qEOrkpRVItw4gQ8apvkZBmsOKi+ZaLDawiZf
	 FcWU3Bykc+Z85iO5HzwICUG1vUCVucPiE6oATQhv0+kSLMFVkUMBRDRbzhy1TSZGRIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCW3kp4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44B606A31C;
	Thu, 26 Nov 2026 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCW3kp4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04D01F000C4;
	Thu, 26 Nov 2026 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795708429;
	bh=PAqADx6BCDJW/l9oyP65JCbSK+i8IXF6jV/NhPgDrvU=;
	h=From:To:Cc:Subject:Date;
	b=DCW3kp4bO4zkrtAStC232kE2c10swC9+NjsauNb1VICxzYnBnC6Js0Z7klYUz3qBs
	 xNb09tUvy+3jSA5vNRRsyZs6N405zHR4Zb8eBnYa1MPmXXiDOsWIScby8hIIbkNSOj
	 dPqo4IaDRiRWo+3dGuFQg/SMUlqX9udE+0JE3/uZTpy7EksLLYDexqgC1fbOGCRajV
	 v63CFcispC9ldwvdNol8EJ/5AT+RAJUrotsMS7d0pp3OVGGW/wvmK0dVeO1JUXbKwd
	 fviFjAB8o5HcmcZfBjavIBP3TkE8UlEjNjYW0RoSzHHKJSrdB8MjryAYKSkACAdo3Y
	 eNUvF7upBFtWA==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	apais@microsoft.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	hargar@linux.microsoft.com,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Navneet Singh <navneetsingh@microsoft.com>,
	Oliver Upton <oupton@kernel.org>,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sven Schnelle <sven@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] st64bv0 support in iommu-sva
Date: Thu, 26 Nov 2026 16:53:36 +0100
Message-ID: <20261126155339.1349218-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

This is an updated set of patches to enable ls64_accdata with the
st64bv0 instruction in Linux.

I have included feeback from Siddharth and Sven here, in
particular:

 - fix SCTLR_USER_MASK and reset feature on fork/exec
 - add a testcase for the HWCAP
 - fix compilation with old assembler version
 - enable HCRX_EL2_EnAS0 when booting in EL2
 - restore ACCDATA_EL1 in cpu_resume
 - context-switch host ACCDATA when entering KVM guest

     Arnd

Arnd Bergmann (3):
  arm64: dynamically enable st64bv0 for SVA
  arm64: add HWCAP3_LS64_ACCDATA
  kselftest/arm64: Add HWCAP test for FEAT_LS64_ACCDATA

 Documentation/arch/arm64/elf_hwcaps.rst    |  7 +++
 arch/arm64/include/asm/cpufeature.h        |  6 +++
 arch/arm64/include/asm/el2_setup.h         |  3 ++
 arch/arm64/include/asm/exception.h         |  1 +
 arch/arm64/include/asm/mmu_context.h       | 17 +++++++
 arch/arm64/include/asm/processor.h         |  2 +-
 arch/arm64/include/uapi/asm/hwcap.h        |  1 +
 arch/arm64/kernel/cpufeature.c             |  1 +
 arch/arm64/kernel/cpuinfo.c                |  1 +
 arch/arm64/kernel/entry-common.c           | 11 ++++
 arch/arm64/kernel/process.c                | 25 +++++++++
 arch/arm64/kernel/suspend.c                | 17 +++++++
 arch/arm64/kernel/traps.c                  | 59 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  8 ++-
 arch/arm64/tools/sysreg                    |  5 ++
 tools/testing/selftests/arm64/abi/hwcap.c  | 50 ++++++++++++++++++
 16 files changed, 211 insertions(+), 3 deletions(-)

-- 
2.53.0
Cc: apais@microsoft.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>
Cc: hargar@linux.microsoft.com
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Navneet Singh <navneetsingh@microsoft.com>
Cc: Oliver Upton <oupton@kernel.org>
Cc: rlmenge@gmail.com
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Sven Schnelle <sven@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

