Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF12B2C9D;
	Fri, 12 Apr 2024 10:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918122; cv=none; b=W8PJn3O829JU/OC91Xs9WnYoMny3US+A6pga+zYB9yAniYA4rV0H1pjPWyph4zp2J8CDEEZVgnoZoNg5fJ2PAvebg/zaBrYqFEdoPC7NF2Cu6R1U5wFk3cCjHzMsVHoyCvGVWfenwws9MaPdRDHwlWJzApjJxccHmFvpU/TwX+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918122; c=relaxed/simple;
	bh=EyAx/IvdbvfnTpXesXnHym7TSjG4+UZwu5cLl6Rm89I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jOUNKN9aHK5FOLVo3Zzk76zGhT/2RBOK72da+QiR9L/ODEJXxptkClWHNj7+a22Sc4L7mAFhv3rLCsMMyINtwrn23UrXYfuQAVj0fsuqoWN8XgUZXFzziIX5skP+mP/EMcnCGaDOKtqyyYRYrhClCAoeNmNDq4BYRIMyHSj5rzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9DD715DB;
	Fri, 12 Apr 2024 03:35:48 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A97313F64C;
	Fri, 12 Apr 2024 03:35:17 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: [kvm-unit-tests PATCH 30/33] arm: realm: Add Realm attestation tests
Date: Fri, 12 Apr 2024 11:34:05 +0100
Message-Id: <20240412103408.2706058-31-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests for Attestation and measurement related RSI calls.

Signed-off-by: Mate Toth-Pal <mate.toth-pal@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[ Rewrote the test cases, keeping the core testing data/logic
  Added more test scenarios to test the ABI
]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/realm-attest.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arm/realm-attest.c b/arm/realm-attest.c
index 082d4964..6e407bae 100644
--- a/arm/realm-attest.c
+++ b/arm/realm-attest.c
@@ -108,7 +108,7 @@ static int attest_token_complete(phys_addr_t base, size_t buf_size,
 		if ((buf_size - len) < size)
 			size = buf_size - len;
 
-		ret = rsi_attest_token_continue(ipa, offset, size, &bytes);
+		ret = attest_token_continue(ipa, offset, size, &bytes);
 		len += bytes;
 		ipa += bytes;
 		offset += bytes;
@@ -116,7 +116,6 @@ static int attest_token_complete(phys_addr_t base, size_t buf_size,
 
 	if (plen)
 		*plen = len;
-	report_info("Found %ldbytes\n", len);
 	return ret;
 }
 
@@ -130,14 +129,14 @@ static int get_attest_token(phys_addr_t ipa,
 
 	rc = attest_token_init(ch, &max_size);
 	if (max_size > size)
-		report_info("Attestation token size (%ld bytes) is greater than the buffer size\n",
+		report_info("Attestation token size (%ld bytes) is greater than the buffer size",
 			    max_size);
 	if (rc)
 		return rc;
 
 	rc = attest_token_complete(ipa, size, len);
 	if (len && *len > max_size)
-		report_info("RMM BUG: Token size is greater than the max token size from RSI_ATTEST_TOKEN_INIT\n");
+		report_info("RMM BUG: Token size is greater than the max token size from RSI_ATTEST_TOKEN_INIT");
 
 	return rc;
 }
@@ -293,7 +292,7 @@ static void test_get_attest_token_abi_misuse(void)
 		report_prefix_pop(); /* miss token init */
 		return;
 	}
-	report_info("Received a token of size %ld\n", len);
+	report_info("Received a token of size %ld", len);
 
 	/*
 	 * step2. Execute RSI_ATTEST_TOKEN_CONTINUE without an RSI_ATTEST_TOKEN_INIT.
@@ -333,7 +332,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_ERROR_INPUT, len);
 	} else {
-		report(true, "Attestation token continue failed for invalid IPA\n");
+		report(true, "Attestation token continue failed for invalid IPA");
 	}
 	report_prefix_pop();
 
@@ -350,7 +349,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_ERROR_INPUT, len);
 	} else {
-		report(true, "Attestation token continue failed for invalid offset\n");
+		report(true, "Attestation token continue failed for invalid offset");
 	}
 	report_prefix_pop();
 
@@ -367,7 +366,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d)",
 			      rc.status, RSI_ERROR_INPUT);
 	} else {
-		report(true, "Attestation token continue failed for invalid size\n");
+		report(true, "Attestation token continue failed for invalid size");
 	}
 	report_prefix_pop();
 
@@ -383,7 +382,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_ERROR_INPUT, len);
 	} else {
-		report(true, "Attestation token continue failed for overflow size\n");
+		report(true, "Attestation token continue failed for overflow size");
 	}
 	report_prefix_pop();
 
@@ -399,7 +398,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_ERROR_INPUT, len);
 	} else {
-		report(true, "Attestation token continue failed for overflow offset\n");
+		report(true, "Attestation token continue failed for overflow offset");
 	}
 	report_prefix_pop();
 
@@ -415,7 +414,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_ERROR_INPUT, len);
 	} else {
-		report(true, "Attestation token continue failed for unaligned ipa\n");
+		report(true, "Attestation token continue failed for unaligned ipa");
 	}
 	report_prefix_pop();
 
@@ -431,7 +430,7 @@ static void test_get_attest_token_abi_misuse(void)
 			       " (%d) vs expected (%d), len: %ld vs 0",
 			      rc.status, RSI_INCOMPLETE, len);
 	} else {
-		report(true, "Attestation token continue returned 0bytes\n");
+		report(true, "Attestation token continue returned 0bytes");
 	}
 	report_prefix_pop(); /* invalid input */
 
@@ -472,7 +471,7 @@ static void test_get_attest_token_abi_abort_req(void)
 	}
 
 	/* Execute one cycles, but not let it complete */
-	report_info("Attest token continue with %lx, 0, 4K\n", addr);
+	report_info("Attest token continue with %lx, 0, 4K", addr);
 	ret = attest_token_continue(addr, 0, RSI_GRANULE_SIZE, &size);
 	if (ret != RSI_INCOMPLETE) {
 		if (ret) {
-- 
2.34.1

