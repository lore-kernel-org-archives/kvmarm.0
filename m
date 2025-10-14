Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4937E2F5A29
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 10:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760437291; cv=none; b=RO53lTjIaAoKtgW4d8Ap9Az7FLGgIpme34AHcLO25/y85Fa3qodxddqxeTqpb1Rq49YUvu+FL5Ow8HEzM2XFnSwczsDSR8W0BnrQrqkFGO77dQfAH0idM2T4tH8mLOIMqstNM4dDyvCItp2DznpV4uEc3a03zquAMCZKOR04DNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760437291; c=relaxed/simple;
	bh=xZ8NihRRe6UX64Xsvr0tqSmjUiw6PZyIdR5rcivGBq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwhiK56PGq38ZKb/y7Qty6GaamA2wzzQggXiE3e7qfyYdX0YVTtjGq6a0W/zKHqsUAm5Utbs8kM5Zq4pt3m5PzGLOv3kxOwkHWjnQyHITjeuQLMHZZHjkKJZgHDC1xUDKlBDEUX4QGK5K2+TPcC9/JhA/1FCriBwl6klu5+MUqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9FCA1A9A;
	Tue, 14 Oct 2025 03:21:21 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EC6C93F6A8;
	Tue, 14 Oct 2025 03:21:27 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	shuah@kernel.org
Cc: Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH 3/3] KVM: arm64: selftests: Consider all 7 possible levels of cache
Date: Tue, 14 Oct 2025 11:21:08 +0100
Message-ID: <20251014102108.2442391-4-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014102108.2442391-1-ben.horgan@arm.com>
References: <20251014102108.2442391-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In test_clidr() if an empty cache level is not found then the TEST_ASSERT
will not fire. Fix this by considering all 7 possible levels when iterating
through the hierarchy. Found by inspection.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index a0b81b627037..731f8b23b1c5 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -678,7 +678,7 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	clidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1));
 
 	/* find the first empty level in the cache hierarchy */
-	for (level = 1; level < 7; level++) {
+	for (level = 1; level <= 7; level++) {
 		if (!CLIDR_CTYPE(clidr, level))
 			break;
 	}
-- 
2.43.0

