Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0BD301471
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776448689; cv=none; b=l05LgK4IlNVi1T4/lU5lTNgnoLDrMixB6JRJ+s/zbod7neF10SGNs2YlRhAeccfFlL9UZLg2HAWhQhHcf0rxc8EkLZShUVEgqwXgWomDpHwp7gr6ZxsrXfpIfNxzxJugiLfdkT6Xn7YUooc6gGiw80h9Auy9sfZirpo7OwOTXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776448689; c=relaxed/simple;
	bh=tsQy6qMxsa5wjMUuqspAU/D38Z+x2rhzlE1+ZI76oYs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ILpgHSWLqUNUZ7YQKtBd2T2FyuO3v1GSyI41iivHWU1Tiq3TpeKbXS1cIJ46q0d+Tgwg0sy9RiaKHJMwtgkG7ECIKxME4tBcyLvIzMn1KagKD9IY2e4L7qkmPrKa0Q4GrNongbJdcJPwIJ6pGssKyfo/ga2mgYpRfXe9kdrVdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sU2B9iWd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sU2B9iWd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19B381D70;
	Fri, 17 Apr 2026 10:57:59 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 673183F7D8;
	Fri, 17 Apr 2026 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776448684; bh=tsQy6qMxsa5wjMUuqspAU/D38Z+x2rhzlE1+ZI76oYs=;
	h=From:To:Cc:Subject:Date:From;
	b=sU2B9iWdqNy2qZpmdMvrPLtnrYEgCQBpmBdwpnWijSItJl8tytKgc0Jql+QiSx43R
	 zaEjGkUxmpc4kFClz0FjWLjiaBsf06MeWnkNvOGcDCypTryA+GZ5bx9w8Ys/Oexc8C
	 C3l5LnRs2B6aw1babPLRKbfONNLltApGHEBC5a5Q=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	zohar@linux.ibm.com,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	sudeep.holla@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 0/4] fix FF-A call failed with pKVM when ff-a driver is built-in
Date: Fri, 17 Apr 2026 18:57:55 +0100
Message-Id: <20260417175759.3191279-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 0e0546eabcd6 ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall")
changed the initcall level of ffa_init() to rootfs_initcall to address
an issue where IMA could not properly recognize the TPM device
when FF-A driver is built as built-in.

However, this introduces another problem: pKVM fails to handle FF-A calls
because it cannot trap the FFA_VERSION call invoked by ffa_init().

To ensure the TPM device is recognized when present in the system,
it is preferable to invoke ima_init() at a later stage.
Deferred probing is resolved by deferred_probe_initcall(),
which runs at the late_initcall level.
Therefore, introduce an LSM initcall at late_initcall_sync and
move ima_init() to this level.

With this change, revert the initcall level of ffa_init() back to
device_initcall. Additionally, to handle the case where ffa_init() runs
before kvm_init(), check whether pKVM has been initialized during ffa_init().
If not, defer initialization to prevent failures of FF-A calls
due to the inability to trap FFA_VERSION and FFA_RXTX_MAP in pKVM.

This patch is based on v7.0

Yeoreum Yun (4):
  security: ima: move ima_init into late_initcall_sync
  tpm: tpm_crb_ffa: revert defered_probed when tpm_crb_ffa is built-in
  firmware: arm_ffa: revert ffa_init() initcall level to device_initcall
  firmware: arm_ffa: check pkvm initailised when initailise ffa driver

 arch/arm64/kvm/arm.c              |  1 +
 drivers/char/tpm/tpm_crb_ffa.c    | 18 +++---------------
 drivers/firmware/arm_ffa/driver.c | 14 +++++++++++++-
 include/linux/lsm_hooks.h         |  2 ++
 security/integrity/ima/ima_main.c |  2 +-
 security/lsm_init.c               | 13 +++++++++++--
 6 files changed, 31 insertions(+), 19 deletions(-)


base-commit: 028ef9c96e96197026887c0f092424679298aae8
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

