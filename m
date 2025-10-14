Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09162F5A17
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 10:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760437283; cv=none; b=ZeA8shcv62LGzweFLHmlXLjdSMNtP/dn1IgEudkw58FLUelcqvRD2USzTwZ7RrPNJtFjFbKfZGqkoYR6F7TY3ibF9LVcEON0PoA7xgwPmllwhJYM02FzigNzZAybJVvyXZmfNebk//T/0i8pdBMvMim2z7xxx/oiNmSQ28a3s1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760437283; c=relaxed/simple;
	bh=coVtKSwRQrbySSkPHYLuKKcEgJPLwn7tA74OhNVSbuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkUfdm22K4+5Wv0r6HPG953lGFYLJxJQHofLKB37o18qfiIbbaa2jjdkNBrovLQZlmw6MImo+72LKdpRhVzdCpMEDF/GiTjG1ljbmyYR4KZdY1eb0L4Qasf1hTvAn4qnMkTBLW3Ot/cE0JpOZ/+3/xAIOmugAprTPKRP0epLHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BAF81A9A;
	Tue, 14 Oct 2025 03:21:13 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6D7F83F6A8;
	Tue, 14 Oct 2025 03:21:19 -0700 (PDT)
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
Subject: [PATCH 1/3] KVM: arm64: selftests: Count test_guest_reg_read() as a test
Date: Tue, 14 Oct 2025 11:21:06 +0100
Message-ID: <20251014102108.2442391-2-ben.horgan@arm.com>
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

The test test_guest_reg_read() is run without announcing its presence or
contributing to the test count. Rectify this.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 5e24f77868b5..6878ee23310e 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -655,6 +655,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 		}
 	}
+
+	ksft_test_result_pass("%s\n", __func__);
 }
 
 /* Politely lifted from arch/arm64/include/asm/cache.h */
@@ -786,7 +788,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;
-- 
2.43.0

