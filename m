Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29792D0614
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776448700; cv=none; b=pumm5ikdIyPrcOeS4xBvdvLC9tSGg8qTb2RMyLQaj0avpFcZiylHQsL/qnuvfJCRxaqhOyRXw6dVXFxjTqcIz2Zsmdh194anZPbkrC/DNy35YzY5B3Ap8qRwTmplMw/hrTIgBNKzdwC56IBuwNUM5dQcVPLJkhKDbozus97xOmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776448700; c=relaxed/simple;
	bh=e3o4nX2FYzFLs1uAJiYhcCfAbWsy9IaHHY4Cf/NSGlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NmvnItbM++KSIsmCpSYqKoSmKfKBDs6vcpBmieh1ldLqTMG/7dj5J+Zd7jQ7DXTWZJy4TdibId+j/HQCki6O4dbGOahDZw4UhoA1ItM2IcVdgaeASpLsOI4bQVxyrVi236vOn3AOHj99+8O/pQXoDPlYK+Mu0zkwaOIkE1IqyxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PAQgiHJf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PAQgiHJf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B1CE1D70;
	Fri, 17 Apr 2026 10:58:13 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CAEDA3F7D8;
	Fri, 17 Apr 2026 10:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776448699; bh=e3o4nX2FYzFLs1uAJiYhcCfAbWsy9IaHHY4Cf/NSGlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAQgiHJflKchkVTf/kQxxIrjzTHGvFJkuV2kwY6XVZZlvHYUbI3Avkufy0FHECdDg
	 0P+g9FWmwfm3CDwAafNIVAFd5MRZvLs98syRr3ZCobKtO8PfJc1iP/boxHqZ8imHPw
	 eybNPYc6+cBCnjNgTj1nJ8zU6CpETaF8idHpaOrA=
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
Subject: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when initailise ffa driver
Date: Fri, 17 Apr 2026 18:57:59 +0100
Message-Id: <20260417175759.3191279-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417175759.3191279-1-yeoreum.yun@arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pKVM is enabled, the FF-A driver must be initialized after pKVM.
Otherwise, pKVM cannot negotiate the FF-A version or
obtain RX/TX buffer information, leading to failures in FF-A calls.

During FF-A driver initialization, check whether pKVM has been initialized.
If not, defer probing of the FF-A driver.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/arm.c              |  1 +
 drivers/firmware/arm_ffa/driver.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..0f517b1c05cd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -119,6 +119,7 @@ bool is_kvm_arm_initialised(void)
 {
 	return kvm_arm_initialised;
 }
+EXPORT_SYMBOL(is_kvm_arm_initialised);

 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 02c76ac1570b..2647d6554afd 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -42,6 +42,8 @@
 #include <linux/uuid.h>
 #include <linux/xarray.h>

+#include <asm/virt.h>
+
 #include "common.h"

 #define FFA_DRIVER_VERSION	FFA_VERSION_1_2
@@ -2035,6 +2037,16 @@ static int __init ffa_init(void)
 	u32 buf_sz;
 	size_t rxtx_bufsz = SZ_4K;

+	/*
+	 * When pKVM is enabled, the FF-A driver must be initialized
+	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
+	 * the FF-A version or obtain RX/TX buffer information,
+	 * which leads to failures in FF-A calls.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
+	    !is_kvm_arm_initialised())
+		return -EPROBE_DEFER;
+
 	ret = ffa_transport_init(&invoke_ffa_fn);
 	if (ret)
 		return ret;
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

