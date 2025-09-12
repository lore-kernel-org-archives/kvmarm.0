Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1475C2DC780
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 08:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757665677; cv=none; b=Lr4+m3roxpFM3iUvK/QNc2MYN1bissdx6R0MZARrTKA6zNQ7mYTZrNGii8ONtw+MMmL7UG1uIHP+G2T+z4vXhoJYWzFk9U+n2WuB69+KZjQL1KYZopgp2ggJX0GHSRjOPx4OaL/PGF1gmC04tGqmOepOU7/cg6UY3tf/tPuHT8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757665677; c=relaxed/simple;
	bh=XPv2E+QqHbQDLO4EmTCQZMManpkJEAmxYKBnXLGB/Q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kqNMWyNJ6NPba1/zpfKyIdEsQtHG37TVGk7peJHerCngTWK9uLD90WxuqpldfZU5GkYBDl+x3EVo0MavCAzmo+Y9OLtBb3NawTFVBJLVIe97Wv+TzHYICLdQhJowG3AyNQzzGccLe1K8FTXl/H2sprUTJJFdWQbhkqhnKYGIpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDlamB2D; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDlamB2D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757665671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iAQrbCqZZ4sOxWZdD0ZcXvxkxM3DekbLizKEk5JXiYI=;
	b=kDlamB2DmhQj2fTmsOmZiyKAroCsKWkXguZcNfTcNVtkG1bOz8NDZcVCf2adk4w6V4LPeR
	j6LjxuUCyJT2gCgG2RXhbV3aBg0/oeSKoo3tl0EB4Srxpgh3mVIWnr/kM8bC2uZsWeHNUj
	gjF97lNGZ34GseD0JoxAiDitli856yE=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Date: Fri, 12 Sep 2025 17:27:40 +0900
Subject: [PATCH] PMCR_EL0.N is RAZ/WI. At least a build failes in Ubuntu
 22.04 LTS. Remove the set function.
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250912-selftest-fix3-v1-1-256710a5ae5b@linux.dev>
X-B4-Tracking: v=1; b=H4sIAHvZw2gC/x2M0QpAQBAAf+XaZ1usdMevyIPYY0vo9pKSf7d5n
 KmZB5STsELnHkh8icqxG1SFg2kd94VRZmOgkpqyrQiVt5hZM0a5ayQfKTTs2zkQWHMmNv//+uF
 9P1b0CzVfAAAA
X-Change-ID: 20250912-selftest-fix3-27f285e79d82
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
---
Seen a build failure with old Ubuntu 22.04 LTS, while the latest release
has no build issue, a write to the bit fields is RAZ/WI, remove the
function.
---
 tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32ed7ca57481f27d689d47783aa0345..56214a4430be90b3e1d840f2719b22dd44f0b49b 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -45,11 +45,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
-{
-	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
-}
-
 static uint64_t get_counters_mask(uint64_t n)
 {
 	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
@@ -490,7 +485,6 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 	 * Setting a larger value of PMCR.N should not modify the field, and
 	 * return a success.
 	 */
-	set_pmcr_n(&pmcr, pmcr_n);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
 	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 

---
base-commit: aae5a9834b388860844b294c70c8770dd26e528c
change-id: 20250912-selftest-fix3-27f285e79d82

Best regards,
-- 
Itaru Kitayama <itaru.kitayama@linux.dev>

