Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5475D285CB4
	for <kvmarm@lists.linux.dev>; Sun, 12 Oct 2025 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760283854; cv=none; b=p7cqoiSSKcHw0CW7mL2rXuFUEKwlEIiGeOn/aK6nNlTfmzXKUNZc8nF2ps/87Ev97IsxcMTumdKRKM2gyfEONi+yxy3vE8KJ9lNTpXIAHTD/ohDfSDbh4/4uz/t+bx0c20k9wS2JKJt2+3y4EdGRwBLne9PhpUjxZaOW2yul448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760283854; c=relaxed/simple;
	bh=b6hDAD8c81FN+jynGvjXEey6OQ4Pw37W+Khp/jCjT9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ixNQWbm4k9uWyYo0a2AgU5B4ZsbEToU01iZXqoOxxGRYLKhqPubs4I2VPh1OrFUs7tlYv2uqaC5tVcKctqcCl5BRInjiZYPxVWYyzPBecHtH+zp1EyqvD38wphAxDmjdRo7OSSa965a6rkIbnnyl19oEHD2H8tbCppl2zSU6Eu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bHOHnH3e; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bHOHnH3e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760283847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=etGXtXgYukUwOM3oh9xUMwzEF3+F73hM03oAFvr8aAo=;
	b=bHOHnH3eJTHwsi1Fj7c3KNiiKjZdFYo821vrKDIiZbQUB7028AdAa9tb9hzMHq3CLNqc24
	Evbf740RK9A5zEr67dFFqOmIaHfmAg46qdmtwP5f42FRoh7nVLrg1vBhfWawL6D+I6THUL
	4zsnjBGWnWDUKRfXHJWggrh5FN1e2SU=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in guest
Date: Sun, 12 Oct 2025 23:43:52 +0800
Message-Id: <20251012154352.61133-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We forgot to sync several registers (ID_AA64PFR1, MPIDR, CLIDR) in guest to
make sure that the guest had seen the written value.

Add them to the list.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 8ff1e853f7f8..5e24f77868b5 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -249,11 +249,14 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64ISAR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ISAR3_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64PFR0_EL1);
+	GUEST_REG_SYNC(SYS_ID_AA64PFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR0_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+	GUEST_REG_SYNC(SYS_MPIDR_EL1);
+	GUEST_REG_SYNC(SYS_CLIDR_EL1);
 	GUEST_REG_SYNC(SYS_CTR_EL0);
 	GUEST_REG_SYNC(SYS_MIDR_EL1);
 	GUEST_REG_SYNC(SYS_REVIDR_EL1);
-- 
2.34.1

