Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530F4CA4E
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 10:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065550; cv=none; b=dJJvFjpmB2pZLLV2Kz1o90O5FZs/uu0skrWUfFxwKeZtyxtxtDA6UVWQT03FQXqo9tZI07SruFM0j/gDGEYL8xPaGTEgHcATAQsMHqWnIWj9VZxmmlyk7LKePJPgfcJHmqhAburlQ3LoL+/wlLPaGyWNjJq+6WbuQ12A/22qyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065550; c=relaxed/simple;
	bh=oQq93jAlvg1u01N83VZi/yOa9DweNoHv8//xSLQvn4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCwiLKoUC4FGDYwQ9tGo3Ft/0I790zoXu6AK+EJTy+9wnJpgQJbGkHt98JE1jEAFeqejf1w5/JXhvWtO9EJgJNet+hGI6TWtEIowbEdx/4Rty9T12THifPRQ0g3BiKMZ3Gs7Uvvy2AGn0I4fw7jQw7IQGKMa4cQAyWPnCOf4LS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D3741655;
	Tue, 25 Nov 2025 02:12:21 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 133973F86F;
	Tue, 25 Nov 2025 02:12:26 -0800 (PST)
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
Subject: [PATCH v2 2/2] KVM: arm64: selftests: Consider all 7 possible levels of cache
Date: Tue, 25 Nov 2025 10:12:07 +0000
Message-ID: <20251125101207.1492580-3-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251125101207.1492580-1-ben.horgan@arm.com>
References: <20251125101207.1492580-1-ben.horgan@arm.com>
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
index 5fbcf5d1f168..c4815d365816 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -676,7 +676,7 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	clidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1));
 
 	/* find the first empty level in the cache hierarchy */
-	for (level = 1; level < 7; level++) {
+	for (level = 1; level <= 7; level++) {
 		if (!CLIDR_CTYPE(clidr, level))
 			break;
 	}
-- 
2.43.0

